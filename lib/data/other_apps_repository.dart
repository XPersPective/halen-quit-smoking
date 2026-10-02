import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

/// One entry of the family catalogue (napp_apps/apps.json, schema 1).
///
/// The JSON is untrusted input: [tryParse] drops anything malformed and never
/// throws. Promotion only — no reward is ever offered for installing another
/// app (App Store guideline 3.2.2; Google Play policy).
class OtherApp {
  const OtherApp({
    required this.id,
    required this.name,
    required this.description,
    this.androidPackage,
    this.iconUrl,
    this.order = 0,
  });

  final String id;
  final String? androidPackage;
  final String? iconUrl;
  final Map<String, String> name;
  final Map<String, String> description;
  final int order;

  static OtherApp? tryParse(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final id = raw['id'];
    final package = raw['androidPackage'];
    if (id is! String || id.trim().isEmpty) return null;
    if (package is! String || package.trim().isEmpty) return null;
    final icon = raw['icon'];
    final iconUrl = icon is String && Uri.tryParse(icon)?.scheme == 'https'
        ? icon
        : null;
    final name = _texts(raw['name']);
    if (name.isEmpty) return null;
    return OtherApp(
      id: id,
      androidPackage: package,
      iconUrl: iconUrl,
      name: name,
      description: _texts(raw['description']),
      order: raw['order'] is int ? raw['order'] as int : 0,
    );
  }

  static Map<String, String> _texts(Object? raw) {
    if (raw is! Map) return const {};
    return {
      for (final e in raw.entries)
        if (e.key is String && e.value is String && (e.value as String).isNotEmpty)
          e.key as String: e.value as String,
    };
  }

  /// Text in [languageCode], then English, then anything.
  static String pick(Map<String, String> texts, String languageCode) {
    final lang = languageCode == 'iw' ? 'he' : languageCode;
    return texts[lang] ??
        texts['en'] ??
        (texts.isEmpty ? '' : texts.values.first);
  }

  /// Play Store page; the store picks the language and country itself.
  Uri get storeUri => Uri.parse(
        'https://play.google.com/store/apps/details?id=$androidPackage',
      );
}

/// Loads the catalogue: fresh cache → network → stale cache → embedded copy.
/// Never throws. The only network call in the app that is not a store call,
/// and it only happens when the person opens the Discover tab.
class OtherAppsRepository {
  OtherAppsRepository({
    this.url = defaultUrl,
    this.timeout = const Duration(seconds: 5),
    this.cacheTtl = const Duration(hours: 24),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const defaultUrl =
      'https://raw.githubusercontent.com/XPersPective/napp_apps/HEAD/apps.json';
  static const maxBytes = 256 * 1024;
  static const _cacheKey = 'halen.other_apps_cache';
  static const _cacheAtKey = 'halen.other_apps_cache_at';

  final String url;
  final Duration timeout;
  final Duration cacheTtl;
  final DateTime Function() _now;

  /// Used when there is no network and nothing cached yet.
  static const embedded = [
    OtherApp(
      id: 'doctorfilter',
      androidPackage: 'com.crazypenguin.doctorfilter',
      name: {'en': 'DoctorFilter Blue Light Filter'},
      description: {'en': 'A blue light filter that is easy on your eyes.'},
    ),
  ];

  Future<List<OtherApp>> load({required String ownPackage}) async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {}
    final cached = _readCache(prefs);
    final cachedAt = prefs?.getInt(_cacheAtKey);
    final fresh = cached != null &&
        cachedAt != null &&
        _now().difference(DateTime.fromMillisecondsSinceEpoch(cachedAt)) <
            cacheTtl;
    if (fresh) {
      return _prepare(cached, ownPackage);
    }
    final body = await _download();
    if (body != null) {
      final parsed = parse(body);
      if (parsed.isNotEmpty) {
        try {
          await prefs?.setString(_cacheKey, body);
          await prefs?.setInt(_cacheAtKey, _now().millisecondsSinceEpoch);
        } catch (_) {}
        return _prepare(parsed, ownPackage);
      }
    }
    return _prepare(cached ?? embedded, ownPackage);
  }

  /// Valid entries of a catalogue document; malformed records are skipped.
  static List<OtherApp> parse(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic> || json['schema'] != 1) return const [];
      final apps = json['apps'];
      if (apps is! List) return const [];
      return [
        for (final raw in apps) ?OtherApp.tryParse(raw),
      ];
    } catch (_) {
      return const [];
    }
  }

  List<OtherApp>? _readCache(SharedPreferences? prefs) {
    final body = prefs?.getString(_cacheKey);
    if (body == null) return null;
    final parsed = parse(body);
    return parsed.isEmpty ? null : parsed;
  }

  List<OtherApp> _prepare(List<OtherApp> apps, String ownPackage) {
    final list = [
      for (final app in apps)
        if (app.androidPackage != ownPackage) app,
    ]..sort((a, b) {
        final byOrder = a.order.compareTo(b.order);
        return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
      });
    return list;
  }

  Future<String?> _download() async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return null;
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client.getUrl(uri).timeout(timeout);
      request.followRedirects = false;
      final response = await request.close().timeout(timeout);
      if (response.statusCode != 200) return null;
      final bytes = <int>[];
      await for (final chunk in response.timeout(timeout)) {
        bytes.addAll(chunk);
        if (bytes.length > maxBytes) return null;
      }
      return utf8.decode(bytes);
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }
}
