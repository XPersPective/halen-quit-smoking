// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AgeBand, String> ageBand =
      GeneratedColumn<String>(
        'age_band',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AgeBand>($UserProfileTable.$converterageBand);
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, locale, ageBand];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      ageBand: $UserProfileTable.$converterageBand.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}age_band'],
        )!,
      ),
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AgeBand, String, String> $converterageBand =
      const EnumNameConverter<AgeBand>(AgeBand.values);
}

class UserProfileRow extends DataClass implements Insertable<UserProfileRow> {
  final int id;
  final DateTime createdAt;
  final String locale;
  final AgeBand ageBand;
  const UserProfileRow({
    required this.id,
    required this.createdAt,
    required this.locale,
    required this.ageBand,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['locale'] = Variable<String>(locale);
    {
      map['age_band'] = Variable<String>(
        $UserProfileTable.$converterageBand.toSql(ageBand),
      );
    }
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      locale: Value(locale),
      ageBand: Value(ageBand),
    );
  }

  factory UserProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileRow(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      locale: serializer.fromJson<String>(json['locale']),
      ageBand: $UserProfileTable.$converterageBand.fromJson(
        serializer.fromJson<String>(json['ageBand']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'locale': serializer.toJson<String>(locale),
      'ageBand': serializer.toJson<String>(
        $UserProfileTable.$converterageBand.toJson(ageBand),
      ),
    };
  }

  UserProfileRow copyWith({
    int? id,
    DateTime? createdAt,
    String? locale,
    AgeBand? ageBand,
  }) => UserProfileRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    locale: locale ?? this.locale,
    ageBand: ageBand ?? this.ageBand,
  );
  UserProfileRow copyWithCompanion(UserProfileCompanion data) {
    return UserProfileRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      locale: data.locale.present ? data.locale.value : this.locale,
      ageBand: data.ageBand.present ? data.ageBand.value : this.ageBand,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('locale: $locale, ')
          ..write('ageBand: $ageBand')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, locale, ageBand);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.locale == this.locale &&
          other.ageBand == this.ageBand);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileRow> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> locale;
  final Value<AgeBand> ageBand;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.locale = const Value.absent(),
    this.ageBand = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String locale,
    required AgeBand ageBand,
  }) : createdAt = Value(createdAt),
       locale = Value(locale),
       ageBand = Value(ageBand);
  static Insertable<UserProfileRow> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? locale,
    Expression<String>? ageBand,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (locale != null) 'locale': locale,
      if (ageBand != null) 'age_band': ageBand,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String>? locale,
    Value<AgeBand>? ageBand,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      locale: locale ?? this.locale,
      ageBand: ageBand ?? this.ageBand,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (ageBand.present) {
      map['age_band'] = Variable<String>(
        $UserProfileTable.$converterageBand.toSql(ageBand.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('locale: $locale, ')
          ..write('ageBand: $ageBand')
          ..write(')'))
        .toString();
  }
}

class $SmokingProfileTable extends SmokingProfile
    with TableInfo<$SmokingProfileTable, SmokingProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmokingProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _baselineCpdMeta = const VerificationMeta(
    'baselineCpd',
  );
  @override
  late final GeneratedColumn<int> baselineCpd = GeneratedColumn<int>(
    'baseline_cpd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TtfcBand, String> ttfcBand =
      GeneratedColumn<String>(
        'ttfc_band',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TtfcBand>($SmokingProfileTable.$converterttfcBand);
  static const VerificationMeta _pricePerPackMeta = const VerificationMeta(
    'pricePerPack',
  );
  @override
  late final GeneratedColumn<double> pricePerPack = GeneratedColumn<double>(
    'price_per_pack',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packSizeMeta = const VerificationMeta(
    'packSize',
  );
  @override
  late final GeneratedColumn<int> packSize = GeneratedColumn<int>(
    'pack_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandNameMeta = const VerificationMeta(
    'brandName',
  );
  @override
  late final GeneratedColumn<String> brandName = GeneratedColumn<String>(
    'brand_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TargetMode, String> targetMode =
      GeneratedColumn<String>(
        'target_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TargetMode>($SmokingProfileTable.$convertertargetMode);
  @override
  late final GeneratedColumnWithTypeConverter<Pace, String> pace =
      GeneratedColumn<String>(
        'pace',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Pace>($SmokingProfileTable.$converterpace);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baselineCpd,
    ttfcBand,
    pricePerPack,
    packSize,
    brandId,
    brandName,
    targetMode,
    pace,
    startedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smoking_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmokingProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baseline_cpd')) {
      context.handle(
        _baselineCpdMeta,
        baselineCpd.isAcceptableOrUnknown(
          data['baseline_cpd']!,
          _baselineCpdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baselineCpdMeta);
    }
    if (data.containsKey('price_per_pack')) {
      context.handle(
        _pricePerPackMeta,
        pricePerPack.isAcceptableOrUnknown(
          data['price_per_pack']!,
          _pricePerPackMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerPackMeta);
    }
    if (data.containsKey('pack_size')) {
      context.handle(
        _packSizeMeta,
        packSize.isAcceptableOrUnknown(data['pack_size']!, _packSizeMeta),
      );
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('brand_name')) {
      context.handle(
        _brandNameMeta,
        brandName.isAcceptableOrUnknown(data['brand_name']!, _brandNameMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmokingProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmokingProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      baselineCpd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baseline_cpd'],
      )!,
      ttfcBand: $SmokingProfileTable.$converterttfcBand.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ttfc_band'],
        )!,
      ),
      pricePerPack: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_pack'],
      )!,
      packSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_size'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      brandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_name'],
      ),
      targetMode: $SmokingProfileTable.$convertertargetMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_mode'],
        )!,
      ),
      pace: $SmokingProfileTable.$converterpace.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pace'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
    );
  }

  @override
  $SmokingProfileTable createAlias(String alias) {
    return $SmokingProfileTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TtfcBand, String, String> $converterttfcBand =
      const EnumNameConverter<TtfcBand>(TtfcBand.values);
  static JsonTypeConverter2<TargetMode, String, String> $convertertargetMode =
      const EnumNameConverter<TargetMode>(TargetMode.values);
  static JsonTypeConverter2<Pace, String, String> $converterpace =
      const EnumNameConverter<Pace>(Pace.values);
}

class SmokingProfileRow extends DataClass
    implements Insertable<SmokingProfileRow> {
  final int id;
  final int baselineCpd;
  final TtfcBand ttfcBand;
  final double pricePerPack;
  final int packSize;
  final String? brandId;
  final String? brandName;
  final TargetMode targetMode;
  final Pace pace;
  final DateTime startedAt;
  const SmokingProfileRow({
    required this.id,
    required this.baselineCpd,
    required this.ttfcBand,
    required this.pricePerPack,
    required this.packSize,
    this.brandId,
    this.brandName,
    required this.targetMode,
    required this.pace,
    required this.startedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baseline_cpd'] = Variable<int>(baselineCpd);
    {
      map['ttfc_band'] = Variable<String>(
        $SmokingProfileTable.$converterttfcBand.toSql(ttfcBand),
      );
    }
    map['price_per_pack'] = Variable<double>(pricePerPack);
    map['pack_size'] = Variable<int>(packSize);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || brandName != null) {
      map['brand_name'] = Variable<String>(brandName);
    }
    {
      map['target_mode'] = Variable<String>(
        $SmokingProfileTable.$convertertargetMode.toSql(targetMode),
      );
    }
    {
      map['pace'] = Variable<String>(
        $SmokingProfileTable.$converterpace.toSql(pace),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    return map;
  }

  SmokingProfileCompanion toCompanion(bool nullToAbsent) {
    return SmokingProfileCompanion(
      id: Value(id),
      baselineCpd: Value(baselineCpd),
      ttfcBand: Value(ttfcBand),
      pricePerPack: Value(pricePerPack),
      packSize: Value(packSize),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      brandName: brandName == null && nullToAbsent
          ? const Value.absent()
          : Value(brandName),
      targetMode: Value(targetMode),
      pace: Value(pace),
      startedAt: Value(startedAt),
    );
  }

  factory SmokingProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmokingProfileRow(
      id: serializer.fromJson<int>(json['id']),
      baselineCpd: serializer.fromJson<int>(json['baselineCpd']),
      ttfcBand: $SmokingProfileTable.$converterttfcBand.fromJson(
        serializer.fromJson<String>(json['ttfcBand']),
      ),
      pricePerPack: serializer.fromJson<double>(json['pricePerPack']),
      packSize: serializer.fromJson<int>(json['packSize']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      brandName: serializer.fromJson<String?>(json['brandName']),
      targetMode: $SmokingProfileTable.$convertertargetMode.fromJson(
        serializer.fromJson<String>(json['targetMode']),
      ),
      pace: $SmokingProfileTable.$converterpace.fromJson(
        serializer.fromJson<String>(json['pace']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baselineCpd': serializer.toJson<int>(baselineCpd),
      'ttfcBand': serializer.toJson<String>(
        $SmokingProfileTable.$converterttfcBand.toJson(ttfcBand),
      ),
      'pricePerPack': serializer.toJson<double>(pricePerPack),
      'packSize': serializer.toJson<int>(packSize),
      'brandId': serializer.toJson<String?>(brandId),
      'brandName': serializer.toJson<String?>(brandName),
      'targetMode': serializer.toJson<String>(
        $SmokingProfileTable.$convertertargetMode.toJson(targetMode),
      ),
      'pace': serializer.toJson<String>(
        $SmokingProfileTable.$converterpace.toJson(pace),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
    };
  }

  SmokingProfileRow copyWith({
    int? id,
    int? baselineCpd,
    TtfcBand? ttfcBand,
    double? pricePerPack,
    int? packSize,
    Value<String?> brandId = const Value.absent(),
    Value<String?> brandName = const Value.absent(),
    TargetMode? targetMode,
    Pace? pace,
    DateTime? startedAt,
  }) => SmokingProfileRow(
    id: id ?? this.id,
    baselineCpd: baselineCpd ?? this.baselineCpd,
    ttfcBand: ttfcBand ?? this.ttfcBand,
    pricePerPack: pricePerPack ?? this.pricePerPack,
    packSize: packSize ?? this.packSize,
    brandId: brandId.present ? brandId.value : this.brandId,
    brandName: brandName.present ? brandName.value : this.brandName,
    targetMode: targetMode ?? this.targetMode,
    pace: pace ?? this.pace,
    startedAt: startedAt ?? this.startedAt,
  );
  SmokingProfileRow copyWithCompanion(SmokingProfileCompanion data) {
    return SmokingProfileRow(
      id: data.id.present ? data.id.value : this.id,
      baselineCpd: data.baselineCpd.present
          ? data.baselineCpd.value
          : this.baselineCpd,
      ttfcBand: data.ttfcBand.present ? data.ttfcBand.value : this.ttfcBand,
      pricePerPack: data.pricePerPack.present
          ? data.pricePerPack.value
          : this.pricePerPack,
      packSize: data.packSize.present ? data.packSize.value : this.packSize,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      brandName: data.brandName.present ? data.brandName.value : this.brandName,
      targetMode: data.targetMode.present
          ? data.targetMode.value
          : this.targetMode,
      pace: data.pace.present ? data.pace.value : this.pace,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmokingProfileRow(')
          ..write('id: $id, ')
          ..write('baselineCpd: $baselineCpd, ')
          ..write('ttfcBand: $ttfcBand, ')
          ..write('pricePerPack: $pricePerPack, ')
          ..write('packSize: $packSize, ')
          ..write('brandId: $brandId, ')
          ..write('brandName: $brandName, ')
          ..write('targetMode: $targetMode, ')
          ..write('pace: $pace, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baselineCpd,
    ttfcBand,
    pricePerPack,
    packSize,
    brandId,
    brandName,
    targetMode,
    pace,
    startedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmokingProfileRow &&
          other.id == this.id &&
          other.baselineCpd == this.baselineCpd &&
          other.ttfcBand == this.ttfcBand &&
          other.pricePerPack == this.pricePerPack &&
          other.packSize == this.packSize &&
          other.brandId == this.brandId &&
          other.brandName == this.brandName &&
          other.targetMode == this.targetMode &&
          other.pace == this.pace &&
          other.startedAt == this.startedAt);
}

class SmokingProfileCompanion extends UpdateCompanion<SmokingProfileRow> {
  final Value<int> id;
  final Value<int> baselineCpd;
  final Value<TtfcBand> ttfcBand;
  final Value<double> pricePerPack;
  final Value<int> packSize;
  final Value<String?> brandId;
  final Value<String?> brandName;
  final Value<TargetMode> targetMode;
  final Value<Pace> pace;
  final Value<DateTime> startedAt;
  const SmokingProfileCompanion({
    this.id = const Value.absent(),
    this.baselineCpd = const Value.absent(),
    this.ttfcBand = const Value.absent(),
    this.pricePerPack = const Value.absent(),
    this.packSize = const Value.absent(),
    this.brandId = const Value.absent(),
    this.brandName = const Value.absent(),
    this.targetMode = const Value.absent(),
    this.pace = const Value.absent(),
    this.startedAt = const Value.absent(),
  });
  SmokingProfileCompanion.insert({
    this.id = const Value.absent(),
    required int baselineCpd,
    required TtfcBand ttfcBand,
    required double pricePerPack,
    this.packSize = const Value.absent(),
    this.brandId = const Value.absent(),
    this.brandName = const Value.absent(),
    required TargetMode targetMode,
    required Pace pace,
    required DateTime startedAt,
  }) : baselineCpd = Value(baselineCpd),
       ttfcBand = Value(ttfcBand),
       pricePerPack = Value(pricePerPack),
       targetMode = Value(targetMode),
       pace = Value(pace),
       startedAt = Value(startedAt);
  static Insertable<SmokingProfileRow> custom({
    Expression<int>? id,
    Expression<int>? baselineCpd,
    Expression<String>? ttfcBand,
    Expression<double>? pricePerPack,
    Expression<int>? packSize,
    Expression<String>? brandId,
    Expression<String>? brandName,
    Expression<String>? targetMode,
    Expression<String>? pace,
    Expression<DateTime>? startedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baselineCpd != null) 'baseline_cpd': baselineCpd,
      if (ttfcBand != null) 'ttfc_band': ttfcBand,
      if (pricePerPack != null) 'price_per_pack': pricePerPack,
      if (packSize != null) 'pack_size': packSize,
      if (brandId != null) 'brand_id': brandId,
      if (brandName != null) 'brand_name': brandName,
      if (targetMode != null) 'target_mode': targetMode,
      if (pace != null) 'pace': pace,
      if (startedAt != null) 'started_at': startedAt,
    });
  }

  SmokingProfileCompanion copyWith({
    Value<int>? id,
    Value<int>? baselineCpd,
    Value<TtfcBand>? ttfcBand,
    Value<double>? pricePerPack,
    Value<int>? packSize,
    Value<String?>? brandId,
    Value<String?>? brandName,
    Value<TargetMode>? targetMode,
    Value<Pace>? pace,
    Value<DateTime>? startedAt,
  }) {
    return SmokingProfileCompanion(
      id: id ?? this.id,
      baselineCpd: baselineCpd ?? this.baselineCpd,
      ttfcBand: ttfcBand ?? this.ttfcBand,
      pricePerPack: pricePerPack ?? this.pricePerPack,
      packSize: packSize ?? this.packSize,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      targetMode: targetMode ?? this.targetMode,
      pace: pace ?? this.pace,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baselineCpd.present) {
      map['baseline_cpd'] = Variable<int>(baselineCpd.value);
    }
    if (ttfcBand.present) {
      map['ttfc_band'] = Variable<String>(
        $SmokingProfileTable.$converterttfcBand.toSql(ttfcBand.value),
      );
    }
    if (pricePerPack.present) {
      map['price_per_pack'] = Variable<double>(pricePerPack.value);
    }
    if (packSize.present) {
      map['pack_size'] = Variable<int>(packSize.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (brandName.present) {
      map['brand_name'] = Variable<String>(brandName.value);
    }
    if (targetMode.present) {
      map['target_mode'] = Variable<String>(
        $SmokingProfileTable.$convertertargetMode.toSql(targetMode.value),
      );
    }
    if (pace.present) {
      map['pace'] = Variable<String>(
        $SmokingProfileTable.$converterpace.toSql(pace.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmokingProfileCompanion(')
          ..write('id: $id, ')
          ..write('baselineCpd: $baselineCpd, ')
          ..write('ttfcBand: $ttfcBand, ')
          ..write('pricePerPack: $pricePerPack, ')
          ..write('packSize: $packSize, ')
          ..write('brandId: $brandId, ')
          ..write('brandName: $brandName, ')
          ..write('targetMode: $targetMode, ')
          ..write('pace: $pace, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }
}

class $CigaretteEventTable extends CigaretteEvent
    with TableInfo<$CigaretteEventTable, CigaretteEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CigaretteEventTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<DateTime> ts = GeneratedColumn<DateTime>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecordSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecordSource>($CigaretteEventTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<TriggerLabel?, String>
  triggerLabel = GeneratedColumn<String>(
    'trigger_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<TriggerLabel?>($CigaretteEventTable.$convertertriggerLabeln);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextMeta = const VerificationMeta(
    'context',
  );
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planDayMeta = const VerificationMeta(
    'planDay',
  );
  @override
  late final GeneratedColumn<String> planDay = GeneratedColumn<String>(
    'plan_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ts,
    source,
    triggerLabel,
    mood,
    context,
    planDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cigarette_event';
  @override
  VerificationContext validateIntegrity(
    Insertable<CigaretteEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    }
    if (data.containsKey('plan_day')) {
      context.handle(
        _planDayMeta,
        planDay.isAcceptableOrUnknown(data['plan_day']!, _planDayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CigaretteEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CigaretteEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ts'],
      )!,
      source: $CigaretteEventTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      triggerLabel: $CigaretteEventTable.$convertertriggerLabeln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trigger_label'],
        ),
      ),
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      ),
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context'],
      ),
      planDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_day'],
      ),
    );
  }

  @override
  $CigaretteEventTable createAlias(String alias) {
    return $CigaretteEventTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecordSource, String, String> $convertersource =
      const EnumNameConverter<RecordSource>(RecordSource.values);
  static JsonTypeConverter2<TriggerLabel, String, String>
  $convertertriggerLabel = const EnumNameConverter<TriggerLabel>(
    TriggerLabel.values,
  );
  static JsonTypeConverter2<TriggerLabel?, String?, String?>
  $convertertriggerLabeln = JsonTypeConverter2.asNullable(
    $convertertriggerLabel,
  );
}

class CigaretteEventRow extends DataClass
    implements Insertable<CigaretteEventRow> {
  final int id;
  final DateTime ts;
  final RecordSource source;
  final TriggerLabel? triggerLabel;
  final String? mood;
  final String? context;
  final String? planDay;
  const CigaretteEventRow({
    required this.id,
    required this.ts,
    required this.source,
    this.triggerLabel,
    this.mood,
    this.context,
    this.planDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    {
      map['source'] = Variable<String>(
        $CigaretteEventTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || triggerLabel != null) {
      map['trigger_label'] = Variable<String>(
        $CigaretteEventTable.$convertertriggerLabeln.toSql(triggerLabel),
      );
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<String>(context);
    }
    if (!nullToAbsent || planDay != null) {
      map['plan_day'] = Variable<String>(planDay);
    }
    return map;
  }

  CigaretteEventCompanion toCompanion(bool nullToAbsent) {
    return CigaretteEventCompanion(
      id: Value(id),
      ts: Value(ts),
      source: Value(source),
      triggerLabel: triggerLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerLabel),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      context: context == null && nullToAbsent
          ? const Value.absent()
          : Value(context),
      planDay: planDay == null && nullToAbsent
          ? const Value.absent()
          : Value(planDay),
    );
  }

  factory CigaretteEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CigaretteEventRow(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      source: $CigaretteEventTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      triggerLabel: $CigaretteEventTable.$convertertriggerLabeln.fromJson(
        serializer.fromJson<String?>(json['triggerLabel']),
      ),
      mood: serializer.fromJson<String?>(json['mood']),
      context: serializer.fromJson<String?>(json['context']),
      planDay: serializer.fromJson<String?>(json['planDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'source': serializer.toJson<String>(
        $CigaretteEventTable.$convertersource.toJson(source),
      ),
      'triggerLabel': serializer.toJson<String?>(
        $CigaretteEventTable.$convertertriggerLabeln.toJson(triggerLabel),
      ),
      'mood': serializer.toJson<String?>(mood),
      'context': serializer.toJson<String?>(context),
      'planDay': serializer.toJson<String?>(planDay),
    };
  }

  CigaretteEventRow copyWith({
    int? id,
    DateTime? ts,
    RecordSource? source,
    Value<TriggerLabel?> triggerLabel = const Value.absent(),
    Value<String?> mood = const Value.absent(),
    Value<String?> context = const Value.absent(),
    Value<String?> planDay = const Value.absent(),
  }) => CigaretteEventRow(
    id: id ?? this.id,
    ts: ts ?? this.ts,
    source: source ?? this.source,
    triggerLabel: triggerLabel.present ? triggerLabel.value : this.triggerLabel,
    mood: mood.present ? mood.value : this.mood,
    context: context.present ? context.value : this.context,
    planDay: planDay.present ? planDay.value : this.planDay,
  );
  CigaretteEventRow copyWithCompanion(CigaretteEventCompanion data) {
    return CigaretteEventRow(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      source: data.source.present ? data.source.value : this.source,
      triggerLabel: data.triggerLabel.present
          ? data.triggerLabel.value
          : this.triggerLabel,
      mood: data.mood.present ? data.mood.value : this.mood,
      context: data.context.present ? data.context.value : this.context,
      planDay: data.planDay.present ? data.planDay.value : this.planDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CigaretteEventRow(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('source: $source, ')
          ..write('triggerLabel: $triggerLabel, ')
          ..write('mood: $mood, ')
          ..write('context: $context, ')
          ..write('planDay: $planDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ts, source, triggerLabel, mood, context, planDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CigaretteEventRow &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.source == this.source &&
          other.triggerLabel == this.triggerLabel &&
          other.mood == this.mood &&
          other.context == this.context &&
          other.planDay == this.planDay);
}

class CigaretteEventCompanion extends UpdateCompanion<CigaretteEventRow> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<RecordSource> source;
  final Value<TriggerLabel?> triggerLabel;
  final Value<String?> mood;
  final Value<String?> context;
  final Value<String?> planDay;
  const CigaretteEventCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.source = const Value.absent(),
    this.triggerLabel = const Value.absent(),
    this.mood = const Value.absent(),
    this.context = const Value.absent(),
    this.planDay = const Value.absent(),
  });
  CigaretteEventCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required RecordSource source,
    this.triggerLabel = const Value.absent(),
    this.mood = const Value.absent(),
    this.context = const Value.absent(),
    this.planDay = const Value.absent(),
  }) : ts = Value(ts),
       source = Value(source);
  static Insertable<CigaretteEventRow> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<String>? source,
    Expression<String>? triggerLabel,
    Expression<String>? mood,
    Expression<String>? context,
    Expression<String>? planDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (source != null) 'source': source,
      if (triggerLabel != null) 'trigger_label': triggerLabel,
      if (mood != null) 'mood': mood,
      if (context != null) 'context': context,
      if (planDay != null) 'plan_day': planDay,
    });
  }

  CigaretteEventCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? ts,
    Value<RecordSource>? source,
    Value<TriggerLabel?>? triggerLabel,
    Value<String?>? mood,
    Value<String?>? context,
    Value<String?>? planDay,
  }) {
    return CigaretteEventCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      source: source ?? this.source,
      triggerLabel: triggerLabel ?? this.triggerLabel,
      mood: mood ?? this.mood,
      context: context ?? this.context,
      planDay: planDay ?? this.planDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ts.present) {
      map['ts'] = Variable<DateTime>(ts.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $CigaretteEventTable.$convertersource.toSql(source.value),
      );
    }
    if (triggerLabel.present) {
      map['trigger_label'] = Variable<String>(
        $CigaretteEventTable.$convertertriggerLabeln.toSql(triggerLabel.value),
      );
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (planDay.present) {
      map['plan_day'] = Variable<String>(planDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CigaretteEventCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('source: $source, ')
          ..write('triggerLabel: $triggerLabel, ')
          ..write('mood: $mood, ')
          ..write('context: $context, ')
          ..write('planDay: $planDay')
          ..write(')'))
        .toString();
  }
}

class $CigaretteProductTable extends CigaretteProduct
    with TableInfo<$CigaretteProductTable, CigaretteProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CigaretteProductTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _packSizeMeta = const VerificationMeta(
    'packSize',
  );
  @override
  late final GeneratedColumn<int> packSize = GeneratedColumn<int>(
    'pack_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marketMeta = const VerificationMeta('market');
  @override
  late final GeneratedColumn<String> market = GeneratedColumn<String>(
    'market',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verifiedByUserMeta = const VerificationMeta(
    'verifiedByUser',
  );
  @override
  late final GeneratedColumn<bool> verifiedByUser = GeneratedColumn<bool>(
    'verified_by_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified_by_user" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    barcode,
    brand,
    variant,
    packSize,
    market,
    source,
    verifiedByUser,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cigarette_product';
  @override
  VerificationContext validateIntegrity(
    Insertable<CigaretteProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('pack_size')) {
      context.handle(
        _packSizeMeta,
        packSize.isAcceptableOrUnknown(data['pack_size']!, _packSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_packSizeMeta);
    }
    if (data.containsKey('market')) {
      context.handle(
        _marketMeta,
        market.isAcceptableOrUnknown(data['market']!, _marketMeta),
      );
    } else if (isInserting) {
      context.missing(_marketMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('verified_by_user')) {
      context.handle(
        _verifiedByUserMeta,
        verifiedByUser.isAcceptableOrUnknown(
          data['verified_by_user']!,
          _verifiedByUserMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {barcode};
  @override
  CigaretteProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CigaretteProductRow(
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      ),
      packSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_size'],
      )!,
      market: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      verifiedByUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified_by_user'],
      )!,
    );
  }

  @override
  $CigaretteProductTable createAlias(String alias) {
    return $CigaretteProductTable(attachedDatabase, alias);
  }
}

class CigaretteProductRow extends DataClass
    implements Insertable<CigaretteProductRow> {
  final String barcode;
  final String brand;
  final String? variant;
  final int packSize;
  final String market;
  final String source;
  final bool verifiedByUser;
  const CigaretteProductRow({
    required this.barcode,
    required this.brand,
    this.variant,
    required this.packSize,
    required this.market,
    required this.source,
    required this.verifiedByUser,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['barcode'] = Variable<String>(barcode);
    map['brand'] = Variable<String>(brand);
    if (!nullToAbsent || variant != null) {
      map['variant'] = Variable<String>(variant);
    }
    map['pack_size'] = Variable<int>(packSize);
    map['market'] = Variable<String>(market);
    map['source'] = Variable<String>(source);
    map['verified_by_user'] = Variable<bool>(verifiedByUser);
    return map;
  }

  CigaretteProductCompanion toCompanion(bool nullToAbsent) {
    return CigaretteProductCompanion(
      barcode: Value(barcode),
      brand: Value(brand),
      variant: variant == null && nullToAbsent
          ? const Value.absent()
          : Value(variant),
      packSize: Value(packSize),
      market: Value(market),
      source: Value(source),
      verifiedByUser: Value(verifiedByUser),
    );
  }

  factory CigaretteProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CigaretteProductRow(
      barcode: serializer.fromJson<String>(json['barcode']),
      brand: serializer.fromJson<String>(json['brand']),
      variant: serializer.fromJson<String?>(json['variant']),
      packSize: serializer.fromJson<int>(json['packSize']),
      market: serializer.fromJson<String>(json['market']),
      source: serializer.fromJson<String>(json['source']),
      verifiedByUser: serializer.fromJson<bool>(json['verifiedByUser']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'barcode': serializer.toJson<String>(barcode),
      'brand': serializer.toJson<String>(brand),
      'variant': serializer.toJson<String?>(variant),
      'packSize': serializer.toJson<int>(packSize),
      'market': serializer.toJson<String>(market),
      'source': serializer.toJson<String>(source),
      'verifiedByUser': serializer.toJson<bool>(verifiedByUser),
    };
  }

  CigaretteProductRow copyWith({
    String? barcode,
    String? brand,
    Value<String?> variant = const Value.absent(),
    int? packSize,
    String? market,
    String? source,
    bool? verifiedByUser,
  }) => CigaretteProductRow(
    barcode: barcode ?? this.barcode,
    brand: brand ?? this.brand,
    variant: variant.present ? variant.value : this.variant,
    packSize: packSize ?? this.packSize,
    market: market ?? this.market,
    source: source ?? this.source,
    verifiedByUser: verifiedByUser ?? this.verifiedByUser,
  );
  CigaretteProductRow copyWithCompanion(CigaretteProductCompanion data) {
    return CigaretteProductRow(
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      brand: data.brand.present ? data.brand.value : this.brand,
      variant: data.variant.present ? data.variant.value : this.variant,
      packSize: data.packSize.present ? data.packSize.value : this.packSize,
      market: data.market.present ? data.market.value : this.market,
      source: data.source.present ? data.source.value : this.source,
      verifiedByUser: data.verifiedByUser.present
          ? data.verifiedByUser.value
          : this.verifiedByUser,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CigaretteProductRow(')
          ..write('barcode: $barcode, ')
          ..write('brand: $brand, ')
          ..write('variant: $variant, ')
          ..write('packSize: $packSize, ')
          ..write('market: $market, ')
          ..write('source: $source, ')
          ..write('verifiedByUser: $verifiedByUser')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    barcode,
    brand,
    variant,
    packSize,
    market,
    source,
    verifiedByUser,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CigaretteProductRow &&
          other.barcode == this.barcode &&
          other.brand == this.brand &&
          other.variant == this.variant &&
          other.packSize == this.packSize &&
          other.market == this.market &&
          other.source == this.source &&
          other.verifiedByUser == this.verifiedByUser);
}

class CigaretteProductCompanion extends UpdateCompanion<CigaretteProductRow> {
  final Value<String> barcode;
  final Value<String> brand;
  final Value<String?> variant;
  final Value<int> packSize;
  final Value<String> market;
  final Value<String> source;
  final Value<bool> verifiedByUser;
  final Value<int> rowid;
  const CigaretteProductCompanion({
    this.barcode = const Value.absent(),
    this.brand = const Value.absent(),
    this.variant = const Value.absent(),
    this.packSize = const Value.absent(),
    this.market = const Value.absent(),
    this.source = const Value.absent(),
    this.verifiedByUser = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CigaretteProductCompanion.insert({
    required String barcode,
    required String brand,
    this.variant = const Value.absent(),
    required int packSize,
    required String market,
    required String source,
    this.verifiedByUser = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : barcode = Value(barcode),
       brand = Value(brand),
       packSize = Value(packSize),
       market = Value(market),
       source = Value(source);
  static Insertable<CigaretteProductRow> custom({
    Expression<String>? barcode,
    Expression<String>? brand,
    Expression<String>? variant,
    Expression<int>? packSize,
    Expression<String>? market,
    Expression<String>? source,
    Expression<bool>? verifiedByUser,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (barcode != null) 'barcode': barcode,
      if (brand != null) 'brand': brand,
      if (variant != null) 'variant': variant,
      if (packSize != null) 'pack_size': packSize,
      if (market != null) 'market': market,
      if (source != null) 'source': source,
      if (verifiedByUser != null) 'verified_by_user': verifiedByUser,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CigaretteProductCompanion copyWith({
    Value<String>? barcode,
    Value<String>? brand,
    Value<String?>? variant,
    Value<int>? packSize,
    Value<String>? market,
    Value<String>? source,
    Value<bool>? verifiedByUser,
    Value<int>? rowid,
  }) {
    return CigaretteProductCompanion(
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      variant: variant ?? this.variant,
      packSize: packSize ?? this.packSize,
      market: market ?? this.market,
      source: source ?? this.source,
      verifiedByUser: verifiedByUser ?? this.verifiedByUser,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (packSize.present) {
      map['pack_size'] = Variable<int>(packSize.value);
    }
    if (market.present) {
      map['market'] = Variable<String>(market.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (verifiedByUser.present) {
      map['verified_by_user'] = Variable<bool>(verifiedByUser.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CigaretteProductCompanion(')
          ..write('barcode: $barcode, ')
          ..write('brand: $brand, ')
          ..write('variant: $variant, ')
          ..write('packSize: $packSize, ')
          ..write('market: $market, ')
          ..write('source: $source, ')
          ..write('verifiedByUser: $verifiedByUser, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyPlanTable extends DailyPlan
    with TableInfo<$DailyPlanTable, DailyPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyPlanTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCountMeta = const VerificationMeta(
    'targetCount',
  );
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
    'target_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowsJsonMeta = const VerificationMeta(
    'windowsJson',
  );
  @override
  late final GeneratedColumn<String> windowsJson = GeneratedColumn<String>(
    'windows_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlanPhase, String> phase =
      GeneratedColumn<String>(
        'phase',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlanPhase>($DailyPlanTable.$converterphase);
  @override
  late final GeneratedColumnWithTypeConverter<Pace, String> tempo =
      GeneratedColumn<String>(
        'tempo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Pace>($DailyPlanTable.$convertertempo);
  static const VerificationMeta _quitDateMeta = const VerificationMeta(
    'quitDate',
  );
  @override
  late final GeneratedColumn<String> quitDate = GeneratedColumn<String>(
    'quit_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    targetCount,
    windowsJson,
    phase,
    tempo,
    quitDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_plan';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('target_count')) {
      context.handle(
        _targetCountMeta,
        targetCount.isAcceptableOrUnknown(
          data['target_count']!,
          _targetCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCountMeta);
    }
    if (data.containsKey('windows_json')) {
      context.handle(
        _windowsJsonMeta,
        windowsJson.isAcceptableOrUnknown(
          data['windows_json']!,
          _windowsJsonMeta,
        ),
      );
    }
    if (data.containsKey('quit_date')) {
      context.handle(
        _quitDateMeta,
        quitDate.isAcceptableOrUnknown(data['quit_date']!, _quitDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DailyPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyPlanRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      targetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_count'],
      )!,
      windowsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}windows_json'],
      )!,
      phase: $DailyPlanTable.$converterphase.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phase'],
        )!,
      ),
      tempo: $DailyPlanTable.$convertertempo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tempo'],
        )!,
      ),
      quitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quit_date'],
      ),
    );
  }

  @override
  $DailyPlanTable createAlias(String alias) {
    return $DailyPlanTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlanPhase, String, String> $converterphase =
      const EnumNameConverter<PlanPhase>(PlanPhase.values);
  static JsonTypeConverter2<Pace, String, String> $convertertempo =
      const EnumNameConverter<Pace>(Pace.values);
}

class DailyPlanRow extends DataClass implements Insertable<DailyPlanRow> {
  final String date;
  final int targetCount;
  final String windowsJson;
  final PlanPhase phase;
  final Pace tempo;
  final String? quitDate;
  const DailyPlanRow({
    required this.date,
    required this.targetCount,
    required this.windowsJson,
    required this.phase,
    required this.tempo,
    this.quitDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['target_count'] = Variable<int>(targetCount);
    map['windows_json'] = Variable<String>(windowsJson);
    {
      map['phase'] = Variable<String>(
        $DailyPlanTable.$converterphase.toSql(phase),
      );
    }
    {
      map['tempo'] = Variable<String>(
        $DailyPlanTable.$convertertempo.toSql(tempo),
      );
    }
    if (!nullToAbsent || quitDate != null) {
      map['quit_date'] = Variable<String>(quitDate);
    }
    return map;
  }

  DailyPlanCompanion toCompanion(bool nullToAbsent) {
    return DailyPlanCompanion(
      date: Value(date),
      targetCount: Value(targetCount),
      windowsJson: Value(windowsJson),
      phase: Value(phase),
      tempo: Value(tempo),
      quitDate: quitDate == null && nullToAbsent
          ? const Value.absent()
          : Value(quitDate),
    );
  }

  factory DailyPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyPlanRow(
      date: serializer.fromJson<String>(json['date']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      windowsJson: serializer.fromJson<String>(json['windowsJson']),
      phase: $DailyPlanTable.$converterphase.fromJson(
        serializer.fromJson<String>(json['phase']),
      ),
      tempo: $DailyPlanTable.$convertertempo.fromJson(
        serializer.fromJson<String>(json['tempo']),
      ),
      quitDate: serializer.fromJson<String?>(json['quitDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'targetCount': serializer.toJson<int>(targetCount),
      'windowsJson': serializer.toJson<String>(windowsJson),
      'phase': serializer.toJson<String>(
        $DailyPlanTable.$converterphase.toJson(phase),
      ),
      'tempo': serializer.toJson<String>(
        $DailyPlanTable.$convertertempo.toJson(tempo),
      ),
      'quitDate': serializer.toJson<String?>(quitDate),
    };
  }

  DailyPlanRow copyWith({
    String? date,
    int? targetCount,
    String? windowsJson,
    PlanPhase? phase,
    Pace? tempo,
    Value<String?> quitDate = const Value.absent(),
  }) => DailyPlanRow(
    date: date ?? this.date,
    targetCount: targetCount ?? this.targetCount,
    windowsJson: windowsJson ?? this.windowsJson,
    phase: phase ?? this.phase,
    tempo: tempo ?? this.tempo,
    quitDate: quitDate.present ? quitDate.value : this.quitDate,
  );
  DailyPlanRow copyWithCompanion(DailyPlanCompanion data) {
    return DailyPlanRow(
      date: data.date.present ? data.date.value : this.date,
      targetCount: data.targetCount.present
          ? data.targetCount.value
          : this.targetCount,
      windowsJson: data.windowsJson.present
          ? data.windowsJson.value
          : this.windowsJson,
      phase: data.phase.present ? data.phase.value : this.phase,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      quitDate: data.quitDate.present ? data.quitDate.value : this.quitDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyPlanRow(')
          ..write('date: $date, ')
          ..write('targetCount: $targetCount, ')
          ..write('windowsJson: $windowsJson, ')
          ..write('phase: $phase, ')
          ..write('tempo: $tempo, ')
          ..write('quitDate: $quitDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, targetCount, windowsJson, phase, tempo, quitDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyPlanRow &&
          other.date == this.date &&
          other.targetCount == this.targetCount &&
          other.windowsJson == this.windowsJson &&
          other.phase == this.phase &&
          other.tempo == this.tempo &&
          other.quitDate == this.quitDate);
}

class DailyPlanCompanion extends UpdateCompanion<DailyPlanRow> {
  final Value<String> date;
  final Value<int> targetCount;
  final Value<String> windowsJson;
  final Value<PlanPhase> phase;
  final Value<Pace> tempo;
  final Value<String?> quitDate;
  final Value<int> rowid;
  const DailyPlanCompanion({
    this.date = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.windowsJson = const Value.absent(),
    this.phase = const Value.absent(),
    this.tempo = const Value.absent(),
    this.quitDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyPlanCompanion.insert({
    required String date,
    required int targetCount,
    this.windowsJson = const Value.absent(),
    required PlanPhase phase,
    required Pace tempo,
    this.quitDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       targetCount = Value(targetCount),
       phase = Value(phase),
       tempo = Value(tempo);
  static Insertable<DailyPlanRow> custom({
    Expression<String>? date,
    Expression<int>? targetCount,
    Expression<String>? windowsJson,
    Expression<String>? phase,
    Expression<String>? tempo,
    Expression<String>? quitDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (targetCount != null) 'target_count': targetCount,
      if (windowsJson != null) 'windows_json': windowsJson,
      if (phase != null) 'phase': phase,
      if (tempo != null) 'tempo': tempo,
      if (quitDate != null) 'quit_date': quitDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyPlanCompanion copyWith({
    Value<String>? date,
    Value<int>? targetCount,
    Value<String>? windowsJson,
    Value<PlanPhase>? phase,
    Value<Pace>? tempo,
    Value<String?>? quitDate,
    Value<int>? rowid,
  }) {
    return DailyPlanCompanion(
      date: date ?? this.date,
      targetCount: targetCount ?? this.targetCount,
      windowsJson: windowsJson ?? this.windowsJson,
      phase: phase ?? this.phase,
      tempo: tempo ?? this.tempo,
      quitDate: quitDate ?? this.quitDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (windowsJson.present) {
      map['windows_json'] = Variable<String>(windowsJson.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(
        $DailyPlanTable.$converterphase.toSql(phase.value),
      );
    }
    if (tempo.present) {
      map['tempo'] = Variable<String>(
        $DailyPlanTable.$convertertempo.toSql(tempo.value),
      );
    }
    if (quitDate.present) {
      map['quit_date'] = Variable<String>(quitDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyPlanCompanion(')
          ..write('date: $date, ')
          ..write('targetCount: $targetCount, ')
          ..write('windowsJson: $windowsJson, ')
          ..write('phase: $phase, ')
          ..write('tempo: $tempo, ')
          ..write('quitDate: $quitDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanAdjustmentTable extends PlanAdjustment
    with TableInfo<$PlanAdjustmentTable, PlanAdjustmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanAdjustmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AdjustmentReason, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AdjustmentReason>($PlanAdjustmentTable.$converterreason);
  static const VerificationMeta _fromCountMeta = const VerificationMeta(
    'fromCount',
  );
  @override
  late final GeneratedColumn<int> fromCount = GeneratedColumn<int>(
    'from_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCountMeta = const VerificationMeta(
    'toCount',
  );
  @override
  late final GeneratedColumn<int> toCount = GeneratedColumn<int>(
    'to_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageKeyMeta = const VerificationMeta(
    'messageKey',
  );
  @override
  late final GeneratedColumn<String> messageKey = GeneratedColumn<String>(
    'message_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    reason,
    fromCount,
    toCount,
    messageKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_adjustment';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanAdjustmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('from_count')) {
      context.handle(
        _fromCountMeta,
        fromCount.isAcceptableOrUnknown(data['from_count']!, _fromCountMeta),
      );
    } else if (isInserting) {
      context.missing(_fromCountMeta);
    }
    if (data.containsKey('to_count')) {
      context.handle(
        _toCountMeta,
        toCount.isAcceptableOrUnknown(data['to_count']!, _toCountMeta),
      );
    } else if (isInserting) {
      context.missing(_toCountMeta);
    }
    if (data.containsKey('message_key')) {
      context.handle(
        _messageKeyMeta,
        messageKey.isAcceptableOrUnknown(data['message_key']!, _messageKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_messageKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanAdjustmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanAdjustmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      reason: $PlanAdjustmentTable.$converterreason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        )!,
      ),
      fromCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_count'],
      )!,
      toCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_count'],
      )!,
      messageKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_key'],
      )!,
    );
  }

  @override
  $PlanAdjustmentTable createAlias(String alias) {
    return $PlanAdjustmentTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AdjustmentReason, String, String> $converterreason =
      const EnumNameConverter<AdjustmentReason>(AdjustmentReason.values);
}

class PlanAdjustmentRow extends DataClass
    implements Insertable<PlanAdjustmentRow> {
  final int id;
  final String date;
  final AdjustmentReason reason;
  final int fromCount;
  final int toCount;
  final String messageKey;
  const PlanAdjustmentRow({
    required this.id,
    required this.date,
    required this.reason,
    required this.fromCount,
    required this.toCount,
    required this.messageKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    {
      map['reason'] = Variable<String>(
        $PlanAdjustmentTable.$converterreason.toSql(reason),
      );
    }
    map['from_count'] = Variable<int>(fromCount);
    map['to_count'] = Variable<int>(toCount);
    map['message_key'] = Variable<String>(messageKey);
    return map;
  }

  PlanAdjustmentCompanion toCompanion(bool nullToAbsent) {
    return PlanAdjustmentCompanion(
      id: Value(id),
      date: Value(date),
      reason: Value(reason),
      fromCount: Value(fromCount),
      toCount: Value(toCount),
      messageKey: Value(messageKey),
    );
  }

  factory PlanAdjustmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanAdjustmentRow(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      reason: $PlanAdjustmentTable.$converterreason.fromJson(
        serializer.fromJson<String>(json['reason']),
      ),
      fromCount: serializer.fromJson<int>(json['fromCount']),
      toCount: serializer.fromJson<int>(json['toCount']),
      messageKey: serializer.fromJson<String>(json['messageKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'reason': serializer.toJson<String>(
        $PlanAdjustmentTable.$converterreason.toJson(reason),
      ),
      'fromCount': serializer.toJson<int>(fromCount),
      'toCount': serializer.toJson<int>(toCount),
      'messageKey': serializer.toJson<String>(messageKey),
    };
  }

  PlanAdjustmentRow copyWith({
    int? id,
    String? date,
    AdjustmentReason? reason,
    int? fromCount,
    int? toCount,
    String? messageKey,
  }) => PlanAdjustmentRow(
    id: id ?? this.id,
    date: date ?? this.date,
    reason: reason ?? this.reason,
    fromCount: fromCount ?? this.fromCount,
    toCount: toCount ?? this.toCount,
    messageKey: messageKey ?? this.messageKey,
  );
  PlanAdjustmentRow copyWithCompanion(PlanAdjustmentCompanion data) {
    return PlanAdjustmentRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      reason: data.reason.present ? data.reason.value : this.reason,
      fromCount: data.fromCount.present ? data.fromCount.value : this.fromCount,
      toCount: data.toCount.present ? data.toCount.value : this.toCount,
      messageKey: data.messageKey.present
          ? data.messageKey.value
          : this.messageKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanAdjustmentRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('reason: $reason, ')
          ..write('fromCount: $fromCount, ')
          ..write('toCount: $toCount, ')
          ..write('messageKey: $messageKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, reason, fromCount, toCount, messageKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanAdjustmentRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.reason == this.reason &&
          other.fromCount == this.fromCount &&
          other.toCount == this.toCount &&
          other.messageKey == this.messageKey);
}

class PlanAdjustmentCompanion extends UpdateCompanion<PlanAdjustmentRow> {
  final Value<int> id;
  final Value<String> date;
  final Value<AdjustmentReason> reason;
  final Value<int> fromCount;
  final Value<int> toCount;
  final Value<String> messageKey;
  const PlanAdjustmentCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.reason = const Value.absent(),
    this.fromCount = const Value.absent(),
    this.toCount = const Value.absent(),
    this.messageKey = const Value.absent(),
  });
  PlanAdjustmentCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required AdjustmentReason reason,
    required int fromCount,
    required int toCount,
    required String messageKey,
  }) : date = Value(date),
       reason = Value(reason),
       fromCount = Value(fromCount),
       toCount = Value(toCount),
       messageKey = Value(messageKey);
  static Insertable<PlanAdjustmentRow> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? reason,
    Expression<int>? fromCount,
    Expression<int>? toCount,
    Expression<String>? messageKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (reason != null) 'reason': reason,
      if (fromCount != null) 'from_count': fromCount,
      if (toCount != null) 'to_count': toCount,
      if (messageKey != null) 'message_key': messageKey,
    });
  }

  PlanAdjustmentCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<AdjustmentReason>? reason,
    Value<int>? fromCount,
    Value<int>? toCount,
    Value<String>? messageKey,
  }) {
    return PlanAdjustmentCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      reason: reason ?? this.reason,
      fromCount: fromCount ?? this.fromCount,
      toCount: toCount ?? this.toCount,
      messageKey: messageKey ?? this.messageKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $PlanAdjustmentTable.$converterreason.toSql(reason.value),
      );
    }
    if (fromCount.present) {
      map['from_count'] = Variable<int>(fromCount.value);
    }
    if (toCount.present) {
      map['to_count'] = Variable<int>(toCount.value);
    }
    if (messageKey.present) {
      map['message_key'] = Variable<String>(messageKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanAdjustmentCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('reason: $reason, ')
          ..write('fromCount: $fromCount, ')
          ..write('toCount: $toCount, ')
          ..write('messageKey: $messageKey')
          ..write(')'))
        .toString();
  }
}

class $TriggerTable extends Trigger with TableInfo<$TriggerTable, TriggerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriggerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TriggerLabel, String> labelKey =
      GeneratedColumn<String>(
        'label_key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TriggerLabel>($TriggerTable.$converterlabelKey);
  static const VerificationMeta _customMeta = const VerificationMeta('custom');
  @override
  late final GeneratedColumn<String> custom = GeneratedColumn<String>(
    'custom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, labelKey, custom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trigger';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriggerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('custom')) {
      context.handle(
        _customMeta,
        custom.isAcceptableOrUnknown(data['custom']!, _customMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TriggerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriggerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      labelKey: $TriggerTable.$converterlabelKey.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}label_key'],
        )!,
      ),
      custom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom'],
      ),
    );
  }

  @override
  $TriggerTable createAlias(String alias) {
    return $TriggerTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TriggerLabel, String, String> $converterlabelKey =
      const EnumNameConverter<TriggerLabel>(TriggerLabel.values);
}

class TriggerRow extends DataClass implements Insertable<TriggerRow> {
  final int id;
  final TriggerLabel labelKey;
  final String? custom;
  const TriggerRow({required this.id, required this.labelKey, this.custom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['label_key'] = Variable<String>(
        $TriggerTable.$converterlabelKey.toSql(labelKey),
      );
    }
    if (!nullToAbsent || custom != null) {
      map['custom'] = Variable<String>(custom);
    }
    return map;
  }

  TriggerCompanion toCompanion(bool nullToAbsent) {
    return TriggerCompanion(
      id: Value(id),
      labelKey: Value(labelKey),
      custom: custom == null && nullToAbsent
          ? const Value.absent()
          : Value(custom),
    );
  }

  factory TriggerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriggerRow(
      id: serializer.fromJson<int>(json['id']),
      labelKey: $TriggerTable.$converterlabelKey.fromJson(
        serializer.fromJson<String>(json['labelKey']),
      ),
      custom: serializer.fromJson<String?>(json['custom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'labelKey': serializer.toJson<String>(
        $TriggerTable.$converterlabelKey.toJson(labelKey),
      ),
      'custom': serializer.toJson<String?>(custom),
    };
  }

  TriggerRow copyWith({
    int? id,
    TriggerLabel? labelKey,
    Value<String?> custom = const Value.absent(),
  }) => TriggerRow(
    id: id ?? this.id,
    labelKey: labelKey ?? this.labelKey,
    custom: custom.present ? custom.value : this.custom,
  );
  TriggerRow copyWithCompanion(TriggerCompanion data) {
    return TriggerRow(
      id: data.id.present ? data.id.value : this.id,
      labelKey: data.labelKey.present ? data.labelKey.value : this.labelKey,
      custom: data.custom.present ? data.custom.value : this.custom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriggerRow(')
          ..write('id: $id, ')
          ..write('labelKey: $labelKey, ')
          ..write('custom: $custom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, labelKey, custom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriggerRow &&
          other.id == this.id &&
          other.labelKey == this.labelKey &&
          other.custom == this.custom);
}

class TriggerCompanion extends UpdateCompanion<TriggerRow> {
  final Value<int> id;
  final Value<TriggerLabel> labelKey;
  final Value<String?> custom;
  const TriggerCompanion({
    this.id = const Value.absent(),
    this.labelKey = const Value.absent(),
    this.custom = const Value.absent(),
  });
  TriggerCompanion.insert({
    this.id = const Value.absent(),
    required TriggerLabel labelKey,
    this.custom = const Value.absent(),
  }) : labelKey = Value(labelKey);
  static Insertable<TriggerRow> createCustom({
    Expression<int>? id,
    Expression<String>? labelKey,
    Expression<String>? custom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (labelKey != null) 'label_key': labelKey,
      if (custom != null) 'custom': custom,
    });
  }

  TriggerCompanion copyWith({
    Value<int>? id,
    Value<TriggerLabel>? labelKey,
    Value<String?>? custom,
  }) {
    return TriggerCompanion(
      id: id ?? this.id,
      labelKey: labelKey ?? this.labelKey,
      custom: custom ?? this.custom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (labelKey.present) {
      map['label_key'] = Variable<String>(
        $TriggerTable.$converterlabelKey.toSql(labelKey.value),
      );
    }
    if (custom.present) {
      map['custom'] = Variable<String>(custom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TriggerCompanion(')
          ..write('id: $id, ')
          ..write('labelKey: $labelKey, ')
          ..write('custom: $custom')
          ..write(')'))
        .toString();
  }
}

class $CravingEventTable extends CravingEvent
    with TableInfo<$CravingEventTable, CravingEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CravingEventTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<DateTime> ts = GeneratedColumn<DateTime>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CravingIntensity, int> intensity =
      GeneratedColumn<int>(
        'intensity',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CravingIntensity>($CravingEventTable.$converterintensity);
  @override
  late final GeneratedColumnWithTypeConverter<TriggerLabel?, String>
  triggerLabel = GeneratedColumn<String>(
    'trigger_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<TriggerLabel?>($CravingEventTable.$convertertriggerLabeln);
  @override
  late final GeneratedColumnWithTypeConverter<CravingOutcome, String> outcome =
      GeneratedColumn<String>(
        'outcome',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CravingOutcome>($CravingEventTable.$converteroutcome);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ts,
    intensity,
    triggerLabel,
    outcome,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'craving_event';
  @override
  VerificationContext validateIntegrity(
    Insertable<CravingEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CravingEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CravingEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ts'],
      )!,
      intensity: $CravingEventTable.$converterintensity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}intensity'],
        )!,
      ),
      triggerLabel: $CravingEventTable.$convertertriggerLabeln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trigger_label'],
        ),
      ),
      outcome: $CravingEventTable.$converteroutcome.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}outcome'],
        )!,
      ),
    );
  }

  @override
  $CravingEventTable createAlias(String alias) {
    return $CravingEventTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CravingIntensity, int, int> $converterintensity =
      const EnumIndexConverter<CravingIntensity>(CravingIntensity.values);
  static JsonTypeConverter2<TriggerLabel, String, String>
  $convertertriggerLabel = const EnumNameConverter<TriggerLabel>(
    TriggerLabel.values,
  );
  static JsonTypeConverter2<TriggerLabel?, String?, String?>
  $convertertriggerLabeln = JsonTypeConverter2.asNullable(
    $convertertriggerLabel,
  );
  static JsonTypeConverter2<CravingOutcome, String, String> $converteroutcome =
      const EnumNameConverter<CravingOutcome>(CravingOutcome.values);
}

class CravingEventRow extends DataClass implements Insertable<CravingEventRow> {
  final int id;
  final DateTime ts;
  final CravingIntensity intensity;
  final TriggerLabel? triggerLabel;
  final CravingOutcome outcome;
  const CravingEventRow({
    required this.id,
    required this.ts,
    required this.intensity,
    this.triggerLabel,
    required this.outcome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    {
      map['intensity'] = Variable<int>(
        $CravingEventTable.$converterintensity.toSql(intensity),
      );
    }
    if (!nullToAbsent || triggerLabel != null) {
      map['trigger_label'] = Variable<String>(
        $CravingEventTable.$convertertriggerLabeln.toSql(triggerLabel),
      );
    }
    {
      map['outcome'] = Variable<String>(
        $CravingEventTable.$converteroutcome.toSql(outcome),
      );
    }
    return map;
  }

  CravingEventCompanion toCompanion(bool nullToAbsent) {
    return CravingEventCompanion(
      id: Value(id),
      ts: Value(ts),
      intensity: Value(intensity),
      triggerLabel: triggerLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerLabel),
      outcome: Value(outcome),
    );
  }

  factory CravingEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CravingEventRow(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      intensity: $CravingEventTable.$converterintensity.fromJson(
        serializer.fromJson<int>(json['intensity']),
      ),
      triggerLabel: $CravingEventTable.$convertertriggerLabeln.fromJson(
        serializer.fromJson<String?>(json['triggerLabel']),
      ),
      outcome: $CravingEventTable.$converteroutcome.fromJson(
        serializer.fromJson<String>(json['outcome']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'intensity': serializer.toJson<int>(
        $CravingEventTable.$converterintensity.toJson(intensity),
      ),
      'triggerLabel': serializer.toJson<String?>(
        $CravingEventTable.$convertertriggerLabeln.toJson(triggerLabel),
      ),
      'outcome': serializer.toJson<String>(
        $CravingEventTable.$converteroutcome.toJson(outcome),
      ),
    };
  }

  CravingEventRow copyWith({
    int? id,
    DateTime? ts,
    CravingIntensity? intensity,
    Value<TriggerLabel?> triggerLabel = const Value.absent(),
    CravingOutcome? outcome,
  }) => CravingEventRow(
    id: id ?? this.id,
    ts: ts ?? this.ts,
    intensity: intensity ?? this.intensity,
    triggerLabel: triggerLabel.present ? triggerLabel.value : this.triggerLabel,
    outcome: outcome ?? this.outcome,
  );
  CravingEventRow copyWithCompanion(CravingEventCompanion data) {
    return CravingEventRow(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      triggerLabel: data.triggerLabel.present
          ? data.triggerLabel.value
          : this.triggerLabel,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CravingEventRow(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('intensity: $intensity, ')
          ..write('triggerLabel: $triggerLabel, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ts, intensity, triggerLabel, outcome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CravingEventRow &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.intensity == this.intensity &&
          other.triggerLabel == this.triggerLabel &&
          other.outcome == this.outcome);
}

class CravingEventCompanion extends UpdateCompanion<CravingEventRow> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<CravingIntensity> intensity;
  final Value<TriggerLabel?> triggerLabel;
  final Value<CravingOutcome> outcome;
  const CravingEventCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.intensity = const Value.absent(),
    this.triggerLabel = const Value.absent(),
    this.outcome = const Value.absent(),
  });
  CravingEventCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required CravingIntensity intensity,
    this.triggerLabel = const Value.absent(),
    required CravingOutcome outcome,
  }) : ts = Value(ts),
       intensity = Value(intensity),
       outcome = Value(outcome);
  static Insertable<CravingEventRow> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<int>? intensity,
    Expression<String>? triggerLabel,
    Expression<String>? outcome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (intensity != null) 'intensity': intensity,
      if (triggerLabel != null) 'trigger_label': triggerLabel,
      if (outcome != null) 'outcome': outcome,
    });
  }

  CravingEventCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? ts,
    Value<CravingIntensity>? intensity,
    Value<TriggerLabel?>? triggerLabel,
    Value<CravingOutcome>? outcome,
  }) {
    return CravingEventCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      intensity: intensity ?? this.intensity,
      triggerLabel: triggerLabel ?? this.triggerLabel,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ts.present) {
      map['ts'] = Variable<DateTime>(ts.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(
        $CravingEventTable.$converterintensity.toSql(intensity.value),
      );
    }
    if (triggerLabel.present) {
      map['trigger_label'] = Variable<String>(
        $CravingEventTable.$convertertriggerLabeln.toSql(triggerLabel.value),
      );
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(
        $CravingEventTable.$converteroutcome.toSql(outcome.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CravingEventCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('intensity: $intensity, ')
          ..write('triggerLabel: $triggerLabel, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }
}

class $DailySummaryTable extends DailySummary
    with TableInfo<$DailySummaryTable, DailySummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySummaryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTargetMeta = const VerificationMeta(
    'planTarget',
  );
  @override
  late final GeneratedColumn<int> planTarget = GeneratedColumn<int>(
    'plan_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adherenceMeta = const VerificationMeta(
    'adherence',
  );
  @override
  late final GeneratedColumn<double> adherence = GeneratedColumn<double>(
    'adherence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savingsMeta = const VerificationMeta(
    'savings',
  );
  @override
  late final GeneratedColumn<double> savings = GeneratedColumn<double>(
    'savings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avoidedCountMeta = const VerificationMeta(
    'avoidedCount',
  );
  @override
  late final GeneratedColumn<int> avoidedCount = GeneratedColumn<int>(
    'avoided_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _resistedCountMeta = const VerificationMeta(
    'resistedCount',
  );
  @override
  late final GeneratedColumn<int> resistedCount = GeneratedColumn<int>(
    'resisted_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _firstTsMeta = const VerificationMeta(
    'firstTs',
  );
  @override
  late final GeneratedColumn<DateTime> firstTs = GeneratedColumn<DateTime>(
    'first_ts',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastTsMeta = const VerificationMeta('lastTs');
  @override
  late final GeneratedColumn<DateTime> lastTs = GeneratedColumn<DateTime>(
    'last_ts',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minGapMinutesMeta = const VerificationMeta(
    'minGapMinutes',
  );
  @override
  late final GeneratedColumn<int> minGapMinutes = GeneratedColumn<int>(
    'min_gap_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    count,
    planTarget,
    adherence,
    savings,
    avoidedCount,
    resistedCount,
    firstTs,
    lastTs,
    minGapMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_summary';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySummaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('plan_target')) {
      context.handle(
        _planTargetMeta,
        planTarget.isAcceptableOrUnknown(data['plan_target']!, _planTargetMeta),
      );
    }
    if (data.containsKey('adherence')) {
      context.handle(
        _adherenceMeta,
        adherence.isAcceptableOrUnknown(data['adherence']!, _adherenceMeta),
      );
    }
    if (data.containsKey('savings')) {
      context.handle(
        _savingsMeta,
        savings.isAcceptableOrUnknown(data['savings']!, _savingsMeta),
      );
    }
    if (data.containsKey('avoided_count')) {
      context.handle(
        _avoidedCountMeta,
        avoidedCount.isAcceptableOrUnknown(
          data['avoided_count']!,
          _avoidedCountMeta,
        ),
      );
    }
    if (data.containsKey('resisted_count')) {
      context.handle(
        _resistedCountMeta,
        resistedCount.isAcceptableOrUnknown(
          data['resisted_count']!,
          _resistedCountMeta,
        ),
      );
    }
    if (data.containsKey('first_ts')) {
      context.handle(
        _firstTsMeta,
        firstTs.isAcceptableOrUnknown(data['first_ts']!, _firstTsMeta),
      );
    }
    if (data.containsKey('last_ts')) {
      context.handle(
        _lastTsMeta,
        lastTs.isAcceptableOrUnknown(data['last_ts']!, _lastTsMeta),
      );
    }
    if (data.containsKey('min_gap_minutes')) {
      context.handle(
        _minGapMinutesMeta,
        minGapMinutes.isAcceptableOrUnknown(
          data['min_gap_minutes']!,
          _minGapMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DailySummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySummaryRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      planTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_target'],
      ),
      adherence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}adherence'],
      ),
      savings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}savings'],
      )!,
      avoidedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avoided_count'],
      )!,
      resistedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resisted_count'],
      )!,
      firstTs: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_ts'],
      ),
      lastTs: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_ts'],
      ),
      minGapMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_gap_minutes'],
      ),
    );
  }

  @override
  $DailySummaryTable createAlias(String alias) {
    return $DailySummaryTable(attachedDatabase, alias);
  }
}

class DailySummaryRow extends DataClass implements Insertable<DailySummaryRow> {
  final String date;
  final int count;
  final int? planTarget;
  final double? adherence;
  final double savings;
  final int avoidedCount;
  final int resistedCount;
  final DateTime? firstTs;
  final DateTime? lastTs;
  final int? minGapMinutes;
  const DailySummaryRow({
    required this.date,
    required this.count,
    this.planTarget,
    this.adherence,
    required this.savings,
    required this.avoidedCount,
    required this.resistedCount,
    this.firstTs,
    this.lastTs,
    this.minGapMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || planTarget != null) {
      map['plan_target'] = Variable<int>(planTarget);
    }
    if (!nullToAbsent || adherence != null) {
      map['adherence'] = Variable<double>(adherence);
    }
    map['savings'] = Variable<double>(savings);
    map['avoided_count'] = Variable<int>(avoidedCount);
    map['resisted_count'] = Variable<int>(resistedCount);
    if (!nullToAbsent || firstTs != null) {
      map['first_ts'] = Variable<DateTime>(firstTs);
    }
    if (!nullToAbsent || lastTs != null) {
      map['last_ts'] = Variable<DateTime>(lastTs);
    }
    if (!nullToAbsent || minGapMinutes != null) {
      map['min_gap_minutes'] = Variable<int>(minGapMinutes);
    }
    return map;
  }

  DailySummaryCompanion toCompanion(bool nullToAbsent) {
    return DailySummaryCompanion(
      date: Value(date),
      count: Value(count),
      planTarget: planTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(planTarget),
      adherence: adherence == null && nullToAbsent
          ? const Value.absent()
          : Value(adherence),
      savings: Value(savings),
      avoidedCount: Value(avoidedCount),
      resistedCount: Value(resistedCount),
      firstTs: firstTs == null && nullToAbsent
          ? const Value.absent()
          : Value(firstTs),
      lastTs: lastTs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTs),
      minGapMinutes: minGapMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(minGapMinutes),
    );
  }

  factory DailySummaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySummaryRow(
      date: serializer.fromJson<String>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      planTarget: serializer.fromJson<int?>(json['planTarget']),
      adherence: serializer.fromJson<double?>(json['adherence']),
      savings: serializer.fromJson<double>(json['savings']),
      avoidedCount: serializer.fromJson<int>(json['avoidedCount']),
      resistedCount: serializer.fromJson<int>(json['resistedCount']),
      firstTs: serializer.fromJson<DateTime?>(json['firstTs']),
      lastTs: serializer.fromJson<DateTime?>(json['lastTs']),
      minGapMinutes: serializer.fromJson<int?>(json['minGapMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'count': serializer.toJson<int>(count),
      'planTarget': serializer.toJson<int?>(planTarget),
      'adherence': serializer.toJson<double?>(adherence),
      'savings': serializer.toJson<double>(savings),
      'avoidedCount': serializer.toJson<int>(avoidedCount),
      'resistedCount': serializer.toJson<int>(resistedCount),
      'firstTs': serializer.toJson<DateTime?>(firstTs),
      'lastTs': serializer.toJson<DateTime?>(lastTs),
      'minGapMinutes': serializer.toJson<int?>(minGapMinutes),
    };
  }

  DailySummaryRow copyWith({
    String? date,
    int? count,
    Value<int?> planTarget = const Value.absent(),
    Value<double?> adherence = const Value.absent(),
    double? savings,
    int? avoidedCount,
    int? resistedCount,
    Value<DateTime?> firstTs = const Value.absent(),
    Value<DateTime?> lastTs = const Value.absent(),
    Value<int?> minGapMinutes = const Value.absent(),
  }) => DailySummaryRow(
    date: date ?? this.date,
    count: count ?? this.count,
    planTarget: planTarget.present ? planTarget.value : this.planTarget,
    adherence: adherence.present ? adherence.value : this.adherence,
    savings: savings ?? this.savings,
    avoidedCount: avoidedCount ?? this.avoidedCount,
    resistedCount: resistedCount ?? this.resistedCount,
    firstTs: firstTs.present ? firstTs.value : this.firstTs,
    lastTs: lastTs.present ? lastTs.value : this.lastTs,
    minGapMinutes: minGapMinutes.present
        ? minGapMinutes.value
        : this.minGapMinutes,
  );
  DailySummaryRow copyWithCompanion(DailySummaryCompanion data) {
    return DailySummaryRow(
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      planTarget: data.planTarget.present
          ? data.planTarget.value
          : this.planTarget,
      adherence: data.adherence.present ? data.adherence.value : this.adherence,
      savings: data.savings.present ? data.savings.value : this.savings,
      avoidedCount: data.avoidedCount.present
          ? data.avoidedCount.value
          : this.avoidedCount,
      resistedCount: data.resistedCount.present
          ? data.resistedCount.value
          : this.resistedCount,
      firstTs: data.firstTs.present ? data.firstTs.value : this.firstTs,
      lastTs: data.lastTs.present ? data.lastTs.value : this.lastTs,
      minGapMinutes: data.minGapMinutes.present
          ? data.minGapMinutes.value
          : this.minGapMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySummaryRow(')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('planTarget: $planTarget, ')
          ..write('adherence: $adherence, ')
          ..write('savings: $savings, ')
          ..write('avoidedCount: $avoidedCount, ')
          ..write('resistedCount: $resistedCount, ')
          ..write('firstTs: $firstTs, ')
          ..write('lastTs: $lastTs, ')
          ..write('minGapMinutes: $minGapMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    count,
    planTarget,
    adherence,
    savings,
    avoidedCount,
    resistedCount,
    firstTs,
    lastTs,
    minGapMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySummaryRow &&
          other.date == this.date &&
          other.count == this.count &&
          other.planTarget == this.planTarget &&
          other.adherence == this.adherence &&
          other.savings == this.savings &&
          other.avoidedCount == this.avoidedCount &&
          other.resistedCount == this.resistedCount &&
          other.firstTs == this.firstTs &&
          other.lastTs == this.lastTs &&
          other.minGapMinutes == this.minGapMinutes);
}

class DailySummaryCompanion extends UpdateCompanion<DailySummaryRow> {
  final Value<String> date;
  final Value<int> count;
  final Value<int?> planTarget;
  final Value<double?> adherence;
  final Value<double> savings;
  final Value<int> avoidedCount;
  final Value<int> resistedCount;
  final Value<DateTime?> firstTs;
  final Value<DateTime?> lastTs;
  final Value<int?> minGapMinutes;
  final Value<int> rowid;
  const DailySummaryCompanion({
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.planTarget = const Value.absent(),
    this.adherence = const Value.absent(),
    this.savings = const Value.absent(),
    this.avoidedCount = const Value.absent(),
    this.resistedCount = const Value.absent(),
    this.firstTs = const Value.absent(),
    this.lastTs = const Value.absent(),
    this.minGapMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySummaryCompanion.insert({
    required String date,
    required int count,
    this.planTarget = const Value.absent(),
    this.adherence = const Value.absent(),
    this.savings = const Value.absent(),
    this.avoidedCount = const Value.absent(),
    this.resistedCount = const Value.absent(),
    this.firstTs = const Value.absent(),
    this.lastTs = const Value.absent(),
    this.minGapMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       count = Value(count);
  static Insertable<DailySummaryRow> custom({
    Expression<String>? date,
    Expression<int>? count,
    Expression<int>? planTarget,
    Expression<double>? adherence,
    Expression<double>? savings,
    Expression<int>? avoidedCount,
    Expression<int>? resistedCount,
    Expression<DateTime>? firstTs,
    Expression<DateTime>? lastTs,
    Expression<int>? minGapMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (planTarget != null) 'plan_target': planTarget,
      if (adherence != null) 'adherence': adherence,
      if (savings != null) 'savings': savings,
      if (avoidedCount != null) 'avoided_count': avoidedCount,
      if (resistedCount != null) 'resisted_count': resistedCount,
      if (firstTs != null) 'first_ts': firstTs,
      if (lastTs != null) 'last_ts': lastTs,
      if (minGapMinutes != null) 'min_gap_minutes': minGapMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySummaryCompanion copyWith({
    Value<String>? date,
    Value<int>? count,
    Value<int?>? planTarget,
    Value<double?>? adherence,
    Value<double>? savings,
    Value<int>? avoidedCount,
    Value<int>? resistedCount,
    Value<DateTime?>? firstTs,
    Value<DateTime?>? lastTs,
    Value<int?>? minGapMinutes,
    Value<int>? rowid,
  }) {
    return DailySummaryCompanion(
      date: date ?? this.date,
      count: count ?? this.count,
      planTarget: planTarget ?? this.planTarget,
      adherence: adherence ?? this.adherence,
      savings: savings ?? this.savings,
      avoidedCount: avoidedCount ?? this.avoidedCount,
      resistedCount: resistedCount ?? this.resistedCount,
      firstTs: firstTs ?? this.firstTs,
      lastTs: lastTs ?? this.lastTs,
      minGapMinutes: minGapMinutes ?? this.minGapMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (planTarget.present) {
      map['plan_target'] = Variable<int>(planTarget.value);
    }
    if (adherence.present) {
      map['adherence'] = Variable<double>(adherence.value);
    }
    if (savings.present) {
      map['savings'] = Variable<double>(savings.value);
    }
    if (avoidedCount.present) {
      map['avoided_count'] = Variable<int>(avoidedCount.value);
    }
    if (resistedCount.present) {
      map['resisted_count'] = Variable<int>(resistedCount.value);
    }
    if (firstTs.present) {
      map['first_ts'] = Variable<DateTime>(firstTs.value);
    }
    if (lastTs.present) {
      map['last_ts'] = Variable<DateTime>(lastTs.value);
    }
    if (minGapMinutes.present) {
      map['min_gap_minutes'] = Variable<int>(minGapMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySummaryCompanion(')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('planTarget: $planTarget, ')
          ..write('adherence: $adherence, ')
          ..write('savings: $savings, ')
          ..write('avoidedCount: $avoidedCount, ')
          ..write('resistedCount: $resistedCount, ')
          ..write('firstTs: $firstTs, ')
          ..write('lastTs: $lastTs, ')
          ..write('minGapMinutes: $minGapMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthTimelineStateTable extends HealthTimelineState
    with TableInfo<$HealthTimelineStateTable, TimelineStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthTimelineStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quitTsMeta = const VerificationMeta('quitTs');
  @override
  late final GeneratedColumn<DateTime> quitTs = GeneratedColumn<DateTime>(
    'quit_ts',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acknowledgedMilestonesMeta =
      const VerificationMeta('acknowledgedMilestones');
  @override
  late final GeneratedColumn<String> acknowledgedMilestones =
      GeneratedColumn<String>(
        'acknowledged_milestones',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [id, quitTs, acknowledgedMilestones];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_timeline_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimelineStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quit_ts')) {
      context.handle(
        _quitTsMeta,
        quitTs.isAcceptableOrUnknown(data['quit_ts']!, _quitTsMeta),
      );
    }
    if (data.containsKey('acknowledged_milestones')) {
      context.handle(
        _acknowledgedMilestonesMeta,
        acknowledgedMilestones.isAcceptableOrUnknown(
          data['acknowledged_milestones']!,
          _acknowledgedMilestonesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimelineStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quitTs: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}quit_ts'],
      ),
      acknowledgedMilestones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acknowledged_milestones'],
      )!,
    );
  }

  @override
  $HealthTimelineStateTable createAlias(String alias) {
    return $HealthTimelineStateTable(attachedDatabase, alias);
  }
}

class TimelineStateRow extends DataClass
    implements Insertable<TimelineStateRow> {
  final int id;
  final DateTime? quitTs;
  final String acknowledgedMilestones;
  const TimelineStateRow({
    required this.id,
    this.quitTs,
    required this.acknowledgedMilestones,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || quitTs != null) {
      map['quit_ts'] = Variable<DateTime>(quitTs);
    }
    map['acknowledged_milestones'] = Variable<String>(acknowledgedMilestones);
    return map;
  }

  HealthTimelineStateCompanion toCompanion(bool nullToAbsent) {
    return HealthTimelineStateCompanion(
      id: Value(id),
      quitTs: quitTs == null && nullToAbsent
          ? const Value.absent()
          : Value(quitTs),
      acknowledgedMilestones: Value(acknowledgedMilestones),
    );
  }

  factory TimelineStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineStateRow(
      id: serializer.fromJson<int>(json['id']),
      quitTs: serializer.fromJson<DateTime?>(json['quitTs']),
      acknowledgedMilestones: serializer.fromJson<String>(
        json['acknowledgedMilestones'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quitTs': serializer.toJson<DateTime?>(quitTs),
      'acknowledgedMilestones': serializer.toJson<String>(
        acknowledgedMilestones,
      ),
    };
  }

  TimelineStateRow copyWith({
    int? id,
    Value<DateTime?> quitTs = const Value.absent(),
    String? acknowledgedMilestones,
  }) => TimelineStateRow(
    id: id ?? this.id,
    quitTs: quitTs.present ? quitTs.value : this.quitTs,
    acknowledgedMilestones:
        acknowledgedMilestones ?? this.acknowledgedMilestones,
  );
  TimelineStateRow copyWithCompanion(HealthTimelineStateCompanion data) {
    return TimelineStateRow(
      id: data.id.present ? data.id.value : this.id,
      quitTs: data.quitTs.present ? data.quitTs.value : this.quitTs,
      acknowledgedMilestones: data.acknowledgedMilestones.present
          ? data.acknowledgedMilestones.value
          : this.acknowledgedMilestones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineStateRow(')
          ..write('id: $id, ')
          ..write('quitTs: $quitTs, ')
          ..write('acknowledgedMilestones: $acknowledgedMilestones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, quitTs, acknowledgedMilestones);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineStateRow &&
          other.id == this.id &&
          other.quitTs == this.quitTs &&
          other.acknowledgedMilestones == this.acknowledgedMilestones);
}

class HealthTimelineStateCompanion extends UpdateCompanion<TimelineStateRow> {
  final Value<int> id;
  final Value<DateTime?> quitTs;
  final Value<String> acknowledgedMilestones;
  const HealthTimelineStateCompanion({
    this.id = const Value.absent(),
    this.quitTs = const Value.absent(),
    this.acknowledgedMilestones = const Value.absent(),
  });
  HealthTimelineStateCompanion.insert({
    this.id = const Value.absent(),
    this.quitTs = const Value.absent(),
    this.acknowledgedMilestones = const Value.absent(),
  });
  static Insertable<TimelineStateRow> custom({
    Expression<int>? id,
    Expression<DateTime>? quitTs,
    Expression<String>? acknowledgedMilestones,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quitTs != null) 'quit_ts': quitTs,
      if (acknowledgedMilestones != null)
        'acknowledged_milestones': acknowledgedMilestones,
    });
  }

  HealthTimelineStateCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? quitTs,
    Value<String>? acknowledgedMilestones,
  }) {
    return HealthTimelineStateCompanion(
      id: id ?? this.id,
      quitTs: quitTs ?? this.quitTs,
      acknowledgedMilestones:
          acknowledgedMilestones ?? this.acknowledgedMilestones,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (quitTs.present) {
      map['quit_ts'] = Variable<DateTime>(quitTs.value);
    }
    if (acknowledgedMilestones.present) {
      map['acknowledged_milestones'] = Variable<String>(
        acknowledgedMilestones.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthTimelineStateCompanion(')
          ..write('id: $id, ')
          ..write('quitTs: $quitTs, ')
          ..write('acknowledgedMilestones: $acknowledgedMilestones')
          ..write(')'))
        .toString();
  }
}

class $MotivationContentTable extends MotivationContent
    with TableInfo<$MotivationContentTable, MotivationContentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotivationContentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceDateMeta = const VerificationMeta(
    'sourceDate',
  );
  @override
  late final GeneratedColumn<String> sourceDate = GeneratedColumn<String>(
    'source_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionJsonMeta = const VerificationMeta(
    'conditionJson',
  );
  @override
  late final GeneratedColumn<String> conditionJson = GeneratedColumn<String>(
    'condition_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lang,
    category,
    body,
    sourceUrl,
    sourceDate,
    conditionJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motivation_content';
  @override
  VerificationContext validateIntegrity(
    Insertable<MotivationContentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('source_date')) {
      context.handle(
        _sourceDateMeta,
        sourceDate.isAcceptableOrUnknown(data['source_date']!, _sourceDateMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceDateMeta);
    }
    if (data.containsKey('condition_json')) {
      context.handle(
        _conditionJsonMeta,
        conditionJson.isAcceptableOrUnknown(
          data['condition_json']!,
          _conditionJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  MotivationContentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotivationContentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      sourceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_date'],
      )!,
      conditionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_json'],
      ),
    );
  }

  @override
  $MotivationContentTable createAlias(String alias) {
    return $MotivationContentTable(attachedDatabase, alias);
  }
}

class MotivationContentRow extends DataClass
    implements Insertable<MotivationContentRow> {
  final String id;
  final String lang;
  final String category;
  final String body;
  final String sourceUrl;
  final String sourceDate;
  final String? conditionJson;
  const MotivationContentRow({
    required this.id,
    required this.lang,
    required this.category,
    required this.body,
    required this.sourceUrl,
    required this.sourceDate,
    this.conditionJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lang'] = Variable<String>(lang);
    map['category'] = Variable<String>(category);
    map['body'] = Variable<String>(body);
    map['source_url'] = Variable<String>(sourceUrl);
    map['source_date'] = Variable<String>(sourceDate);
    if (!nullToAbsent || conditionJson != null) {
      map['condition_json'] = Variable<String>(conditionJson);
    }
    return map;
  }

  MotivationContentCompanion toCompanion(bool nullToAbsent) {
    return MotivationContentCompanion(
      id: Value(id),
      lang: Value(lang),
      category: Value(category),
      body: Value(body),
      sourceUrl: Value(sourceUrl),
      sourceDate: Value(sourceDate),
      conditionJson: conditionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionJson),
    );
  }

  factory MotivationContentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotivationContentRow(
      id: serializer.fromJson<String>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      category: serializer.fromJson<String>(json['category']),
      body: serializer.fromJson<String>(json['body']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      sourceDate: serializer.fromJson<String>(json['sourceDate']),
      conditionJson: serializer.fromJson<String?>(json['conditionJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lang': serializer.toJson<String>(lang),
      'category': serializer.toJson<String>(category),
      'body': serializer.toJson<String>(body),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'sourceDate': serializer.toJson<String>(sourceDate),
      'conditionJson': serializer.toJson<String?>(conditionJson),
    };
  }

  MotivationContentRow copyWith({
    String? id,
    String? lang,
    String? category,
    String? body,
    String? sourceUrl,
    String? sourceDate,
    Value<String?> conditionJson = const Value.absent(),
  }) => MotivationContentRow(
    id: id ?? this.id,
    lang: lang ?? this.lang,
    category: category ?? this.category,
    body: body ?? this.body,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    sourceDate: sourceDate ?? this.sourceDate,
    conditionJson: conditionJson.present
        ? conditionJson.value
        : this.conditionJson,
  );
  MotivationContentRow copyWithCompanion(MotivationContentCompanion data) {
    return MotivationContentRow(
      id: data.id.present ? data.id.value : this.id,
      lang: data.lang.present ? data.lang.value : this.lang,
      category: data.category.present ? data.category.value : this.category,
      body: data.body.present ? data.body.value : this.body,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      sourceDate: data.sourceDate.present
          ? data.sourceDate.value
          : this.sourceDate,
      conditionJson: data.conditionJson.present
          ? data.conditionJson.value
          : this.conditionJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotivationContentRow(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('category: $category, ')
          ..write('body: $body, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('conditionJson: $conditionJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lang,
    category,
    body,
    sourceUrl,
    sourceDate,
    conditionJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotivationContentRow &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.category == this.category &&
          other.body == this.body &&
          other.sourceUrl == this.sourceUrl &&
          other.sourceDate == this.sourceDate &&
          other.conditionJson == this.conditionJson);
}

class MotivationContentCompanion extends UpdateCompanion<MotivationContentRow> {
  final Value<String> id;
  final Value<String> lang;
  final Value<String> category;
  final Value<String> body;
  final Value<String> sourceUrl;
  final Value<String> sourceDate;
  final Value<String?> conditionJson;
  final Value<int> rowid;
  const MotivationContentCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.category = const Value.absent(),
    this.body = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.sourceDate = const Value.absent(),
    this.conditionJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MotivationContentCompanion.insert({
    required String id,
    required String lang,
    required String category,
    required String body,
    required String sourceUrl,
    required String sourceDate,
    this.conditionJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lang = Value(lang),
       category = Value(category),
       body = Value(body),
       sourceUrl = Value(sourceUrl),
       sourceDate = Value(sourceDate);
  static Insertable<MotivationContentRow> custom({
    Expression<String>? id,
    Expression<String>? lang,
    Expression<String>? category,
    Expression<String>? body,
    Expression<String>? sourceUrl,
    Expression<String>? sourceDate,
    Expression<String>? conditionJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (category != null) 'category': category,
      if (body != null) 'body': body,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (sourceDate != null) 'source_date': sourceDate,
      if (conditionJson != null) 'condition_json': conditionJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MotivationContentCompanion copyWith({
    Value<String>? id,
    Value<String>? lang,
    Value<String>? category,
    Value<String>? body,
    Value<String>? sourceUrl,
    Value<String>? sourceDate,
    Value<String?>? conditionJson,
    Value<int>? rowid,
  }) {
    return MotivationContentCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      category: category ?? this.category,
      body: body ?? this.body,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceDate: sourceDate ?? this.sourceDate,
      conditionJson: conditionJson ?? this.conditionJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (sourceDate.present) {
      map['source_date'] = Variable<String>(sourceDate.value);
    }
    if (conditionJson.present) {
      map['condition_json'] = Variable<String>(conditionJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotivationContentCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('category: $category, ')
          ..write('body: $body, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('conditionJson: $conditionJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseEntitlementTable extends PurchaseEntitlement
    with TableInfo<$PurchaseEntitlementTable, PurchaseEntitlementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseEntitlementTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<String> store = GeneratedColumn<String>(
    'store',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseTokenMeta = const VerificationMeta(
    'purchaseToken',
  );
  @override
  late final GeneratedColumn<String> purchaseToken = GeneratedColumn<String>(
    'purchase_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastVerifiedAtMeta = const VerificationMeta(
    'lastVerifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerifiedAt =
      GeneratedColumn<DateTime>(
        'last_verified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    store,
    productId,
    purchaseToken,
    state,
    lastVerifiedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_entitlement';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseEntitlementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('store')) {
      context.handle(
        _storeMeta,
        store.isAcceptableOrUnknown(data['store']!, _storeMeta),
      );
    } else if (isInserting) {
      context.missing(_storeMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('purchase_token')) {
      context.handle(
        _purchaseTokenMeta,
        purchaseToken.isAcceptableOrUnknown(
          data['purchase_token']!,
          _purchaseTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseTokenMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('last_verified_at')) {
      context.handle(
        _lastVerifiedAtMeta,
        lastVerifiedAt.isAcceptableOrUnknown(
          data['last_verified_at']!,
          _lastVerifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastVerifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseEntitlementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseEntitlementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      store: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      purchaseToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_token'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      lastVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified_at'],
      )!,
    );
  }

  @override
  $PurchaseEntitlementTable createAlias(String alias) {
    return $PurchaseEntitlementTable(attachedDatabase, alias);
  }
}

class PurchaseEntitlementRow extends DataClass
    implements Insertable<PurchaseEntitlementRow> {
  final int id;
  final String store;
  final String productId;
  final String purchaseToken;
  final String state;
  final DateTime lastVerifiedAt;
  const PurchaseEntitlementRow({
    required this.id,
    required this.store,
    required this.productId,
    required this.purchaseToken,
    required this.state,
    required this.lastVerifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['store'] = Variable<String>(store);
    map['product_id'] = Variable<String>(productId);
    map['purchase_token'] = Variable<String>(purchaseToken);
    map['state'] = Variable<String>(state);
    map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt);
    return map;
  }

  PurchaseEntitlementCompanion toCompanion(bool nullToAbsent) {
    return PurchaseEntitlementCompanion(
      id: Value(id),
      store: Value(store),
      productId: Value(productId),
      purchaseToken: Value(purchaseToken),
      state: Value(state),
      lastVerifiedAt: Value(lastVerifiedAt),
    );
  }

  factory PurchaseEntitlementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseEntitlementRow(
      id: serializer.fromJson<int>(json['id']),
      store: serializer.fromJson<String>(json['store']),
      productId: serializer.fromJson<String>(json['productId']),
      purchaseToken: serializer.fromJson<String>(json['purchaseToken']),
      state: serializer.fromJson<String>(json['state']),
      lastVerifiedAt: serializer.fromJson<DateTime>(json['lastVerifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'store': serializer.toJson<String>(store),
      'productId': serializer.toJson<String>(productId),
      'purchaseToken': serializer.toJson<String>(purchaseToken),
      'state': serializer.toJson<String>(state),
      'lastVerifiedAt': serializer.toJson<DateTime>(lastVerifiedAt),
    };
  }

  PurchaseEntitlementRow copyWith({
    int? id,
    String? store,
    String? productId,
    String? purchaseToken,
    String? state,
    DateTime? lastVerifiedAt,
  }) => PurchaseEntitlementRow(
    id: id ?? this.id,
    store: store ?? this.store,
    productId: productId ?? this.productId,
    purchaseToken: purchaseToken ?? this.purchaseToken,
    state: state ?? this.state,
    lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
  );
  PurchaseEntitlementRow copyWithCompanion(PurchaseEntitlementCompanion data) {
    return PurchaseEntitlementRow(
      id: data.id.present ? data.id.value : this.id,
      store: data.store.present ? data.store.value : this.store,
      productId: data.productId.present ? data.productId.value : this.productId,
      purchaseToken: data.purchaseToken.present
          ? data.purchaseToken.value
          : this.purchaseToken,
      state: data.state.present ? data.state.value : this.state,
      lastVerifiedAt: data.lastVerifiedAt.present
          ? data.lastVerifiedAt.value
          : this.lastVerifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseEntitlementRow(')
          ..write('id: $id, ')
          ..write('store: $store, ')
          ..write('productId: $productId, ')
          ..write('purchaseToken: $purchaseToken, ')
          ..write('state: $state, ')
          ..write('lastVerifiedAt: $lastVerifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, store, productId, purchaseToken, state, lastVerifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseEntitlementRow &&
          other.id == this.id &&
          other.store == this.store &&
          other.productId == this.productId &&
          other.purchaseToken == this.purchaseToken &&
          other.state == this.state &&
          other.lastVerifiedAt == this.lastVerifiedAt);
}

class PurchaseEntitlementCompanion
    extends UpdateCompanion<PurchaseEntitlementRow> {
  final Value<int> id;
  final Value<String> store;
  final Value<String> productId;
  final Value<String> purchaseToken;
  final Value<String> state;
  final Value<DateTime> lastVerifiedAt;
  const PurchaseEntitlementCompanion({
    this.id = const Value.absent(),
    this.store = const Value.absent(),
    this.productId = const Value.absent(),
    this.purchaseToken = const Value.absent(),
    this.state = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
  });
  PurchaseEntitlementCompanion.insert({
    this.id = const Value.absent(),
    required String store,
    required String productId,
    required String purchaseToken,
    required String state,
    required DateTime lastVerifiedAt,
  }) : store = Value(store),
       productId = Value(productId),
       purchaseToken = Value(purchaseToken),
       state = Value(state),
       lastVerifiedAt = Value(lastVerifiedAt);
  static Insertable<PurchaseEntitlementRow> custom({
    Expression<int>? id,
    Expression<String>? store,
    Expression<String>? productId,
    Expression<String>? purchaseToken,
    Expression<String>? state,
    Expression<DateTime>? lastVerifiedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (store != null) 'store': store,
      if (productId != null) 'product_id': productId,
      if (purchaseToken != null) 'purchase_token': purchaseToken,
      if (state != null) 'state': state,
      if (lastVerifiedAt != null) 'last_verified_at': lastVerifiedAt,
    });
  }

  PurchaseEntitlementCompanion copyWith({
    Value<int>? id,
    Value<String>? store,
    Value<String>? productId,
    Value<String>? purchaseToken,
    Value<String>? state,
    Value<DateTime>? lastVerifiedAt,
  }) {
    return PurchaseEntitlementCompanion(
      id: id ?? this.id,
      store: store ?? this.store,
      productId: productId ?? this.productId,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      state: state ?? this.state,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (store.present) {
      map['store'] = Variable<String>(store.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (purchaseToken.present) {
      map['purchase_token'] = Variable<String>(purchaseToken.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (lastVerifiedAt.present) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseEntitlementCompanion(')
          ..write('id: $id, ')
          ..write('store: $store, ')
          ..write('productId: $productId, ')
          ..write('purchaseToken: $purchaseToken, ')
          ..write('state: $state, ')
          ..write('lastVerifiedAt: $lastVerifiedAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<NotificationDensity, String>
  notifLevel = GeneratedColumn<String>(
    'notif_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('standard'),
  ).withConverter<NotificationDensity>($SettingsTable.$converternotifLevel);
  @override
  late final GeneratedColumnWithTypeConverter<ThemeOption, String> theme =
      GeneratedColumn<String>(
        'theme',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('system'),
      ).withConverter<ThemeOption>($SettingsTable.$convertertheme);
  static const VerificationMeta _reduceMotionMeta = const VerificationMeta(
    'reduceMotion',
  );
  @override
  late final GeneratedColumn<bool> reduceMotion = GeneratedColumn<bool>(
    'reduce_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hapticsMeta = const VerificationMeta(
    'haptics',
  );
  @override
  late final GeneratedColumn<bool> haptics = GeneratedColumn<bool>(
    'haptics',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _trialStartedAtMeta = const VerificationMeta(
    'trialStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trialStartedAt =
      GeneratedColumn<DateTime>(
        'trial_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notifLevel,
    theme,
    reduceMotion,
    haptics,
    trialStartedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reduce_motion')) {
      context.handle(
        _reduceMotionMeta,
        reduceMotion.isAcceptableOrUnknown(
          data['reduce_motion']!,
          _reduceMotionMeta,
        ),
      );
    }
    if (data.containsKey('haptics')) {
      context.handle(
        _hapticsMeta,
        haptics.isAcceptableOrUnknown(data['haptics']!, _hapticsMeta),
      );
    }
    if (data.containsKey('trial_started_at')) {
      context.handle(
        _trialStartedAtMeta,
        trialStartedAt.isAcceptableOrUnknown(
          data['trial_started_at']!,
          _trialStartedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notifLevel: $SettingsTable.$converternotifLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}notif_level'],
        )!,
      ),
      theme: $SettingsTable.$convertertheme.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme'],
        )!,
      ),
      reduceMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion'],
      )!,
      haptics: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics'],
      )!,
      trialStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_started_at'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationDensity, String, String>
  $converternotifLevel = const EnumNameConverter<NotificationDensity>(
    NotificationDensity.values,
  );
  static JsonTypeConverter2<ThemeOption, String, String> $convertertheme =
      const EnumNameConverter<ThemeOption>(ThemeOption.values);
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final NotificationDensity notifLevel;
  final ThemeOption theme;
  final bool reduceMotion;
  final bool haptics;
  final DateTime? trialStartedAt;
  const SettingsRow({
    required this.id,
    required this.notifLevel,
    required this.theme,
    required this.reduceMotion,
    required this.haptics,
    this.trialStartedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['notif_level'] = Variable<String>(
        $SettingsTable.$converternotifLevel.toSql(notifLevel),
      );
    }
    {
      map['theme'] = Variable<String>(
        $SettingsTable.$convertertheme.toSql(theme),
      );
    }
    map['reduce_motion'] = Variable<bool>(reduceMotion);
    map['haptics'] = Variable<bool>(haptics);
    if (!nullToAbsent || trialStartedAt != null) {
      map['trial_started_at'] = Variable<DateTime>(trialStartedAt);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      notifLevel: Value(notifLevel),
      theme: Value(theme),
      reduceMotion: Value(reduceMotion),
      haptics: Value(haptics),
      trialStartedAt: trialStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trialStartedAt),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      notifLevel: $SettingsTable.$converternotifLevel.fromJson(
        serializer.fromJson<String>(json['notifLevel']),
      ),
      theme: $SettingsTable.$convertertheme.fromJson(
        serializer.fromJson<String>(json['theme']),
      ),
      reduceMotion: serializer.fromJson<bool>(json['reduceMotion']),
      haptics: serializer.fromJson<bool>(json['haptics']),
      trialStartedAt: serializer.fromJson<DateTime?>(json['trialStartedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notifLevel': serializer.toJson<String>(
        $SettingsTable.$converternotifLevel.toJson(notifLevel),
      ),
      'theme': serializer.toJson<String>(
        $SettingsTable.$convertertheme.toJson(theme),
      ),
      'reduceMotion': serializer.toJson<bool>(reduceMotion),
      'haptics': serializer.toJson<bool>(haptics),
      'trialStartedAt': serializer.toJson<DateTime?>(trialStartedAt),
    };
  }

  SettingsRow copyWith({
    int? id,
    NotificationDensity? notifLevel,
    ThemeOption? theme,
    bool? reduceMotion,
    bool? haptics,
    Value<DateTime?> trialStartedAt = const Value.absent(),
  }) => SettingsRow(
    id: id ?? this.id,
    notifLevel: notifLevel ?? this.notifLevel,
    theme: theme ?? this.theme,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    haptics: haptics ?? this.haptics,
    trialStartedAt: trialStartedAt.present
        ? trialStartedAt.value
        : this.trialStartedAt,
  );
  SettingsRow copyWithCompanion(SettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      notifLevel: data.notifLevel.present
          ? data.notifLevel.value
          : this.notifLevel,
      theme: data.theme.present ? data.theme.value : this.theme,
      reduceMotion: data.reduceMotion.present
          ? data.reduceMotion.value
          : this.reduceMotion,
      haptics: data.haptics.present ? data.haptics.value : this.haptics,
      trialStartedAt: data.trialStartedAt.present
          ? data.trialStartedAt.value
          : this.trialStartedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('notifLevel: $notifLevel, ')
          ..write('theme: $theme, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('haptics: $haptics, ')
          ..write('trialStartedAt: $trialStartedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, notifLevel, theme, reduceMotion, haptics, trialStartedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.notifLevel == this.notifLevel &&
          other.theme == this.theme &&
          other.reduceMotion == this.reduceMotion &&
          other.haptics == this.haptics &&
          other.trialStartedAt == this.trialStartedAt);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<NotificationDensity> notifLevel;
  final Value<ThemeOption> theme;
  final Value<bool> reduceMotion;
  final Value<bool> haptics;
  final Value<DateTime?> trialStartedAt;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.notifLevel = const Value.absent(),
    this.theme = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.haptics = const Value.absent(),
    this.trialStartedAt = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.notifLevel = const Value.absent(),
    this.theme = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.haptics = const Value.absent(),
    this.trialStartedAt = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? notifLevel,
    Expression<String>? theme,
    Expression<bool>? reduceMotion,
    Expression<bool>? haptics,
    Expression<DateTime>? trialStartedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notifLevel != null) 'notif_level': notifLevel,
      if (theme != null) 'theme': theme,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (haptics != null) 'haptics': haptics,
      if (trialStartedAt != null) 'trial_started_at': trialStartedAt,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<NotificationDensity>? notifLevel,
    Value<ThemeOption>? theme,
    Value<bool>? reduceMotion,
    Value<bool>? haptics,
    Value<DateTime?>? trialStartedAt,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      notifLevel: notifLevel ?? this.notifLevel,
      theme: theme ?? this.theme,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      haptics: haptics ?? this.haptics,
      trialStartedAt: trialStartedAt ?? this.trialStartedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notifLevel.present) {
      map['notif_level'] = Variable<String>(
        $SettingsTable.$converternotifLevel.toSql(notifLevel.value),
      );
    }
    if (theme.present) {
      map['theme'] = Variable<String>(
        $SettingsTable.$convertertheme.toSql(theme.value),
      );
    }
    if (reduceMotion.present) {
      map['reduce_motion'] = Variable<bool>(reduceMotion.value);
    }
    if (haptics.present) {
      map['haptics'] = Variable<bool>(haptics.value);
    }
    if (trialStartedAt.present) {
      map['trial_started_at'] = Variable<DateTime>(trialStartedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('notifLevel: $notifLevel, ')
          ..write('theme: $theme, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('haptics: $haptics, ')
          ..write('trialStartedAt: $trialStartedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $SmokingProfileTable smokingProfile = $SmokingProfileTable(this);
  late final $CigaretteEventTable cigaretteEvent = $CigaretteEventTable(this);
  late final $CigaretteProductTable cigaretteProduct = $CigaretteProductTable(
    this,
  );
  late final $DailyPlanTable dailyPlan = $DailyPlanTable(this);
  late final $PlanAdjustmentTable planAdjustment = $PlanAdjustmentTable(this);
  late final $TriggerTable trigger = $TriggerTable(this);
  late final $CravingEventTable cravingEvent = $CravingEventTable(this);
  late final $DailySummaryTable dailySummary = $DailySummaryTable(this);
  late final $HealthTimelineStateTable healthTimelineState =
      $HealthTimelineStateTable(this);
  late final $MotivationContentTable motivationContent =
      $MotivationContentTable(this);
  late final $PurchaseEntitlementTable purchaseEntitlement =
      $PurchaseEntitlementTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final RecordDao recordDao = RecordDao(this as AppDatabase);
  late final PlanDao planDao = PlanDao(this as AppDatabase);
  late final CravingDao cravingDao = CravingDao(this as AppDatabase);
  late final StatsDao statsDao = StatsDao(this as AppDatabase);
  late final ContentDao contentDao = ContentDao(this as AppDatabase);
  late final PurchaseDao purchaseDao = PurchaseDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final TimelineDao timelineDao = TimelineDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfile,
    smokingProfile,
    cigaretteEvent,
    cigaretteProduct,
    dailyPlan,
    planAdjustment,
    trigger,
    cravingEvent,
    dailySummary,
    healthTimelineState,
    motivationContent,
    purchaseEntitlement,
    settings,
  ];
}

typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      required String locale,
      required AgeBand ageBand,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String> locale,
      Value<AgeBand> ageBand,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AgeBand, AgeBand, String> get ageBand =>
      $composableBuilder(
        column: $table.ageBand,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AgeBand, String> get ageBand =>
      $composableBuilder(column: $table.ageBand, builder: (column) => column);
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileRow,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileRow,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileRow>,
          ),
          UserProfileRow,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<AgeBand> ageBand = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                createdAt: createdAt,
                locale: locale,
                ageBand: ageBand,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                required String locale,
                required AgeBand ageBand,
              }) => UserProfileCompanion.insert(
                id: id,
                createdAt: createdAt,
                locale: locale,
                ageBand: ageBand,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfileTable, UserProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfileTable,
                    UserProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileRow,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileRow,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileRow>,
      ),
      UserProfileRow,
      PrefetchHooks Function()
    >;
typedef $$SmokingProfileTableCreateCompanionBuilder =
    SmokingProfileCompanion Function({
      Value<int> id,
      required int baselineCpd,
      required TtfcBand ttfcBand,
      required double pricePerPack,
      Value<int> packSize,
      Value<String?> brandId,
      Value<String?> brandName,
      required TargetMode targetMode,
      required Pace pace,
      required DateTime startedAt,
    });
typedef $$SmokingProfileTableUpdateCompanionBuilder =
    SmokingProfileCompanion Function({
      Value<int> id,
      Value<int> baselineCpd,
      Value<TtfcBand> ttfcBand,
      Value<double> pricePerPack,
      Value<int> packSize,
      Value<String?> brandId,
      Value<String?> brandName,
      Value<TargetMode> targetMode,
      Value<Pace> pace,
      Value<DateTime> startedAt,
    });

class $$SmokingProfileTableFilterComposer
    extends Composer<_$AppDatabase, $SmokingProfileTable> {
  $$SmokingProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baselineCpd => $composableBuilder(
    column: $table.baselineCpd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TtfcBand, TtfcBand, String> get ttfcBand =>
      $composableBuilder(
        column: $table.ttfcBand,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get pricePerPack => $composableBuilder(
    column: $table.pricePerPack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TargetMode, TargetMode, String>
  get targetMode => $composableBuilder(
    column: $table.targetMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Pace, Pace, String> get pace =>
      $composableBuilder(
        column: $table.pace,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SmokingProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $SmokingProfileTable> {
  $$SmokingProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baselineCpd => $composableBuilder(
    column: $table.baselineCpd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ttfcBand => $composableBuilder(
    column: $table.ttfcBand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerPack => $composableBuilder(
    column: $table.pricePerPack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMode => $composableBuilder(
    column: $table.targetMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pace => $composableBuilder(
    column: $table.pace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmokingProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmokingProfileTable> {
  $$SmokingProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get baselineCpd => $composableBuilder(
    column: $table.baselineCpd,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TtfcBand, String> get ttfcBand =>
      $composableBuilder(column: $table.ttfcBand, builder: (column) => column);

  GeneratedColumn<double> get pricePerPack => $composableBuilder(
    column: $table.pricePerPack,
    builder: (column) => column,
  );

  GeneratedColumn<int> get packSize =>
      $composableBuilder(column: $table.packSize, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get brandName =>
      $composableBuilder(column: $table.brandName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TargetMode, String> get targetMode =>
      $composableBuilder(
        column: $table.targetMode,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Pace, String> get pace =>
      $composableBuilder(column: $table.pace, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);
}

class $$SmokingProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmokingProfileTable,
          SmokingProfileRow,
          $$SmokingProfileTableFilterComposer,
          $$SmokingProfileTableOrderingComposer,
          $$SmokingProfileTableAnnotationComposer,
          $$SmokingProfileTableCreateCompanionBuilder,
          $$SmokingProfileTableUpdateCompanionBuilder,
          (
            SmokingProfileRow,
            BaseReferences<
              _$AppDatabase,
              $SmokingProfileTable,
              SmokingProfileRow
            >,
          ),
          SmokingProfileRow,
          PrefetchHooks Function()
        > {
  $$SmokingProfileTableTableManager(
    _$AppDatabase db,
    $SmokingProfileTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmokingProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmokingProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmokingProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> baselineCpd = const Value.absent(),
                Value<TtfcBand> ttfcBand = const Value.absent(),
                Value<double> pricePerPack = const Value.absent(),
                Value<int> packSize = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> brandName = const Value.absent(),
                Value<TargetMode> targetMode = const Value.absent(),
                Value<Pace> pace = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
              }) => SmokingProfileCompanion(
                id: id,
                baselineCpd: baselineCpd,
                ttfcBand: ttfcBand,
                pricePerPack: pricePerPack,
                packSize: packSize,
                brandId: brandId,
                brandName: brandName,
                targetMode: targetMode,
                pace: pace,
                startedAt: startedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int baselineCpd,
                required TtfcBand ttfcBand,
                required double pricePerPack,
                Value<int> packSize = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> brandName = const Value.absent(),
                required TargetMode targetMode,
                required Pace pace,
                required DateTime startedAt,
              }) => SmokingProfileCompanion.insert(
                id: id,
                baselineCpd: baselineCpd,
                ttfcBand: ttfcBand,
                pricePerPack: pricePerPack,
                packSize: packSize,
                brandId: brandId,
                brandName: brandName,
                targetMode: targetMode,
                pace: pace,
                startedAt: startedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SmokingProfileTable, SmokingProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SmokingProfileTable,
                    SmokingProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmokingProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmokingProfileTable,
      SmokingProfileRow,
      $$SmokingProfileTableFilterComposer,
      $$SmokingProfileTableOrderingComposer,
      $$SmokingProfileTableAnnotationComposer,
      $$SmokingProfileTableCreateCompanionBuilder,
      $$SmokingProfileTableUpdateCompanionBuilder,
      (
        SmokingProfileRow,
        BaseReferences<_$AppDatabase, $SmokingProfileTable, SmokingProfileRow>,
      ),
      SmokingProfileRow,
      PrefetchHooks Function()
    >;
typedef $$CigaretteEventTableCreateCompanionBuilder =
    CigaretteEventCompanion Function({
      Value<int> id,
      required DateTime ts,
      required RecordSource source,
      Value<TriggerLabel?> triggerLabel,
      Value<String?> mood,
      Value<String?> context,
      Value<String?> planDay,
    });
typedef $$CigaretteEventTableUpdateCompanionBuilder =
    CigaretteEventCompanion Function({
      Value<int> id,
      Value<DateTime> ts,
      Value<RecordSource> source,
      Value<TriggerLabel?> triggerLabel,
      Value<String?> mood,
      Value<String?> context,
      Value<String?> planDay,
    });

class $$CigaretteEventTableFilterComposer
    extends Composer<_$AppDatabase, $CigaretteEventTable> {
  $$CigaretteEventTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecordSource, RecordSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TriggerLabel?, TriggerLabel, String>
  get triggerLabel => $composableBuilder(
    column: $table.triggerLabel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planDay => $composableBuilder(
    column: $table.planDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CigaretteEventTableOrderingComposer
    extends Composer<_$AppDatabase, $CigaretteEventTable> {
  $$CigaretteEventTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerLabel => $composableBuilder(
    column: $table.triggerLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planDay => $composableBuilder(
    column: $table.planDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CigaretteEventTableAnnotationComposer
    extends Composer<_$AppDatabase, $CigaretteEventTable> {
  $$CigaretteEventTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecordSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TriggerLabel?, String> get triggerLabel =>
      $composableBuilder(
        column: $table.triggerLabel,
        builder: (column) => column,
      );

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get planDay =>
      $composableBuilder(column: $table.planDay, builder: (column) => column);
}

class $$CigaretteEventTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CigaretteEventTable,
          CigaretteEventRow,
          $$CigaretteEventTableFilterComposer,
          $$CigaretteEventTableOrderingComposer,
          $$CigaretteEventTableAnnotationComposer,
          $$CigaretteEventTableCreateCompanionBuilder,
          $$CigaretteEventTableUpdateCompanionBuilder,
          (
            CigaretteEventRow,
            BaseReferences<
              _$AppDatabase,
              $CigaretteEventTable,
              CigaretteEventRow
            >,
          ),
          CigaretteEventRow,
          PrefetchHooks Function()
        > {
  $$CigaretteEventTableTableManager(
    _$AppDatabase db,
    $CigaretteEventTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CigaretteEventTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CigaretteEventTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CigaretteEventTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> ts = const Value.absent(),
                Value<RecordSource> source = const Value.absent(),
                Value<TriggerLabel?> triggerLabel = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<String?> context = const Value.absent(),
                Value<String?> planDay = const Value.absent(),
              }) => CigaretteEventCompanion(
                id: id,
                ts: ts,
                source: source,
                triggerLabel: triggerLabel,
                mood: mood,
                context: context,
                planDay: planDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime ts,
                required RecordSource source,
                Value<TriggerLabel?> triggerLabel = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<String?> context = const Value.absent(),
                Value<String?> planDay = const Value.absent(),
              }) => CigaretteEventCompanion.insert(
                id: id,
                ts: ts,
                source: source,
                triggerLabel: triggerLabel,
                mood: mood,
                context: context,
                planDay: planDay,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CigaretteEventTable, CigaretteEventRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CigaretteEventTable,
                    CigaretteEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CigaretteEventTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CigaretteEventTable,
      CigaretteEventRow,
      $$CigaretteEventTableFilterComposer,
      $$CigaretteEventTableOrderingComposer,
      $$CigaretteEventTableAnnotationComposer,
      $$CigaretteEventTableCreateCompanionBuilder,
      $$CigaretteEventTableUpdateCompanionBuilder,
      (
        CigaretteEventRow,
        BaseReferences<_$AppDatabase, $CigaretteEventTable, CigaretteEventRow>,
      ),
      CigaretteEventRow,
      PrefetchHooks Function()
    >;
typedef $$CigaretteProductTableCreateCompanionBuilder =
    CigaretteProductCompanion Function({
      required String barcode,
      required String brand,
      Value<String?> variant,
      required int packSize,
      required String market,
      required String source,
      Value<bool> verifiedByUser,
      Value<int> rowid,
    });
typedef $$CigaretteProductTableUpdateCompanionBuilder =
    CigaretteProductCompanion Function({
      Value<String> barcode,
      Value<String> brand,
      Value<String?> variant,
      Value<int> packSize,
      Value<String> market,
      Value<String> source,
      Value<bool> verifiedByUser,
      Value<int> rowid,
    });

class $$CigaretteProductTableFilterComposer
    extends Composer<_$AppDatabase, $CigaretteProductTable> {
  $$CigaretteProductTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get market => $composableBuilder(
    column: $table.market,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verifiedByUser => $composableBuilder(
    column: $table.verifiedByUser,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CigaretteProductTableOrderingComposer
    extends Composer<_$AppDatabase, $CigaretteProductTable> {
  $$CigaretteProductTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get market => $composableBuilder(
    column: $table.market,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verifiedByUser => $composableBuilder(
    column: $table.verifiedByUser,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CigaretteProductTableAnnotationComposer
    extends Composer<_$AppDatabase, $CigaretteProductTable> {
  $$CigaretteProductTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<int> get packSize =>
      $composableBuilder(column: $table.packSize, builder: (column) => column);

  GeneratedColumn<String> get market =>
      $composableBuilder(column: $table.market, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get verifiedByUser => $composableBuilder(
    column: $table.verifiedByUser,
    builder: (column) => column,
  );
}

class $$CigaretteProductTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CigaretteProductTable,
          CigaretteProductRow,
          $$CigaretteProductTableFilterComposer,
          $$CigaretteProductTableOrderingComposer,
          $$CigaretteProductTableAnnotationComposer,
          $$CigaretteProductTableCreateCompanionBuilder,
          $$CigaretteProductTableUpdateCompanionBuilder,
          (
            CigaretteProductRow,
            BaseReferences<
              _$AppDatabase,
              $CigaretteProductTable,
              CigaretteProductRow
            >,
          ),
          CigaretteProductRow,
          PrefetchHooks Function()
        > {
  $$CigaretteProductTableTableManager(
    _$AppDatabase db,
    $CigaretteProductTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CigaretteProductTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CigaretteProductTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CigaretteProductTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> barcode = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<int> packSize = const Value.absent(),
                Value<String> market = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> verifiedByUser = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CigaretteProductCompanion(
                barcode: barcode,
                brand: brand,
                variant: variant,
                packSize: packSize,
                market: market,
                source: source,
                verifiedByUser: verifiedByUser,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String barcode,
                required String brand,
                Value<String?> variant = const Value.absent(),
                required int packSize,
                required String market,
                required String source,
                Value<bool> verifiedByUser = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CigaretteProductCompanion.insert(
                barcode: barcode,
                brand: brand,
                variant: variant,
                packSize: packSize,
                market: market,
                source: source,
                verifiedByUser: verifiedByUser,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CigaretteProductTable, CigaretteProductRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CigaretteProductTable,
                    CigaretteProductRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CigaretteProductTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CigaretteProductTable,
      CigaretteProductRow,
      $$CigaretteProductTableFilterComposer,
      $$CigaretteProductTableOrderingComposer,
      $$CigaretteProductTableAnnotationComposer,
      $$CigaretteProductTableCreateCompanionBuilder,
      $$CigaretteProductTableUpdateCompanionBuilder,
      (
        CigaretteProductRow,
        BaseReferences<
          _$AppDatabase,
          $CigaretteProductTable,
          CigaretteProductRow
        >,
      ),
      CigaretteProductRow,
      PrefetchHooks Function()
    >;
typedef $$DailyPlanTableCreateCompanionBuilder = DailyPlanCompanion Function({
  required String date,
  required int targetCount,
  Value<String> windowsJson,
  required PlanPhase phase,
  required Pace tempo,
  Value<String?> quitDate,
  Value<int> rowid,
});
typedef $$DailyPlanTableUpdateCompanionBuilder = DailyPlanCompanion Function({
  Value<String> date,
  Value<int> targetCount,
  Value<String> windowsJson,
  Value<PlanPhase> phase,
  Value<Pace> tempo,
  Value<String?> quitDate,
  Value<int> rowid,
});

class $$DailyPlanTableFilterComposer
    extends Composer<_$AppDatabase, $DailyPlanTable> {
  $$DailyPlanTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windowsJson => $composableBuilder(
    column: $table.windowsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlanPhase, PlanPhase, String> get phase =>
      $composableBuilder(
        column: $table.phase,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Pace, Pace, String> get tempo =>
      $composableBuilder(
        column: $table.tempo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get quitDate => $composableBuilder(
    column: $table.quitDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyPlanTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyPlanTable> {
  $$DailyPlanTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowsJson => $composableBuilder(
    column: $table.windowsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quitDate => $composableBuilder(
    column: $table.quitDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyPlanTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyPlanTable> {
  $$DailyPlanTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get windowsJson => $composableBuilder(
    column: $table.windowsJson,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlanPhase, String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Pace, String> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<String> get quitDate =>
      $composableBuilder(column: $table.quitDate, builder: (column) => column);
}

class $$DailyPlanTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyPlanTable,
          DailyPlanRow,
          $$DailyPlanTableFilterComposer,
          $$DailyPlanTableOrderingComposer,
          $$DailyPlanTableAnnotationComposer,
          $$DailyPlanTableCreateCompanionBuilder,
          $$DailyPlanTableUpdateCompanionBuilder,
          (
            DailyPlanRow,
            BaseReferences<_$AppDatabase, $DailyPlanTable, DailyPlanRow>,
          ),
          DailyPlanRow,
          PrefetchHooks Function()
        > {
  $$DailyPlanTableTableManager(_$AppDatabase db, $DailyPlanTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyPlanTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyPlanTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyPlanTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<String> windowsJson = const Value.absent(),
                Value<PlanPhase> phase = const Value.absent(),
                Value<Pace> tempo = const Value.absent(),
                Value<String?> quitDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyPlanCompanion(
                date: date,
                targetCount: targetCount,
                windowsJson: windowsJson,
                phase: phase,
                tempo: tempo,
                quitDate: quitDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int targetCount,
                Value<String> windowsJson = const Value.absent(),
                required PlanPhase phase,
                required Pace tempo,
                Value<String?> quitDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyPlanCompanion.insert(
                date: date,
                targetCount: targetCount,
                windowsJson: windowsJson,
                phase: phase,
                tempo: tempo,
                quitDate: quitDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyPlanTable, DailyPlanRow>(table),
                  BaseReferences<_$AppDatabase, $DailyPlanTable, DailyPlanRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyPlanTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyPlanTable,
      DailyPlanRow,
      $$DailyPlanTableFilterComposer,
      $$DailyPlanTableOrderingComposer,
      $$DailyPlanTableAnnotationComposer,
      $$DailyPlanTableCreateCompanionBuilder,
      $$DailyPlanTableUpdateCompanionBuilder,
      (
        DailyPlanRow,
        BaseReferences<_$AppDatabase, $DailyPlanTable, DailyPlanRow>,
      ),
      DailyPlanRow,
      PrefetchHooks Function()
    >;
typedef $$PlanAdjustmentTableCreateCompanionBuilder =
    PlanAdjustmentCompanion Function({
      Value<int> id,
      required String date,
      required AdjustmentReason reason,
      required int fromCount,
      required int toCount,
      required String messageKey,
    });
typedef $$PlanAdjustmentTableUpdateCompanionBuilder =
    PlanAdjustmentCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<AdjustmentReason> reason,
      Value<int> fromCount,
      Value<int> toCount,
      Value<String> messageKey,
    });

class $$PlanAdjustmentTableFilterComposer
    extends Composer<_$AppDatabase, $PlanAdjustmentTable> {
  $$PlanAdjustmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AdjustmentReason, AdjustmentReason, String>
  get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get fromCount => $composableBuilder(
    column: $table.fromCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toCount => $composableBuilder(
    column: $table.toCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageKey => $composableBuilder(
    column: $table.messageKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanAdjustmentTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanAdjustmentTable> {
  $$PlanAdjustmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromCount => $composableBuilder(
    column: $table.fromCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toCount => $composableBuilder(
    column: $table.toCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageKey => $composableBuilder(
    column: $table.messageKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanAdjustmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanAdjustmentTable> {
  $$PlanAdjustmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AdjustmentReason, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get fromCount =>
      $composableBuilder(column: $table.fromCount, builder: (column) => column);

  GeneratedColumn<int> get toCount =>
      $composableBuilder(column: $table.toCount, builder: (column) => column);

  GeneratedColumn<String> get messageKey => $composableBuilder(
    column: $table.messageKey,
    builder: (column) => column,
  );
}

class $$PlanAdjustmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanAdjustmentTable,
          PlanAdjustmentRow,
          $$PlanAdjustmentTableFilterComposer,
          $$PlanAdjustmentTableOrderingComposer,
          $$PlanAdjustmentTableAnnotationComposer,
          $$PlanAdjustmentTableCreateCompanionBuilder,
          $$PlanAdjustmentTableUpdateCompanionBuilder,
          (
            PlanAdjustmentRow,
            BaseReferences<
              _$AppDatabase,
              $PlanAdjustmentTable,
              PlanAdjustmentRow
            >,
          ),
          PlanAdjustmentRow,
          PrefetchHooks Function()
        > {
  $$PlanAdjustmentTableTableManager(
    _$AppDatabase db,
    $PlanAdjustmentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanAdjustmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanAdjustmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanAdjustmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<AdjustmentReason> reason = const Value.absent(),
                Value<int> fromCount = const Value.absent(),
                Value<int> toCount = const Value.absent(),
                Value<String> messageKey = const Value.absent(),
              }) => PlanAdjustmentCompanion(
                id: id,
                date: date,
                reason: reason,
                fromCount: fromCount,
                toCount: toCount,
                messageKey: messageKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required AdjustmentReason reason,
                required int fromCount,
                required int toCount,
                required String messageKey,
              }) => PlanAdjustmentCompanion.insert(
                id: id,
                date: date,
                reason: reason,
                fromCount: fromCount,
                toCount: toCount,
                messageKey: messageKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanAdjustmentTable, PlanAdjustmentRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PlanAdjustmentTable,
                    PlanAdjustmentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanAdjustmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanAdjustmentTable,
      PlanAdjustmentRow,
      $$PlanAdjustmentTableFilterComposer,
      $$PlanAdjustmentTableOrderingComposer,
      $$PlanAdjustmentTableAnnotationComposer,
      $$PlanAdjustmentTableCreateCompanionBuilder,
      $$PlanAdjustmentTableUpdateCompanionBuilder,
      (
        PlanAdjustmentRow,
        BaseReferences<_$AppDatabase, $PlanAdjustmentTable, PlanAdjustmentRow>,
      ),
      PlanAdjustmentRow,
      PrefetchHooks Function()
    >;
typedef $$TriggerTableCreateCompanionBuilder = TriggerCompanion Function({
  Value<int> id,
  required TriggerLabel labelKey,
  Value<String?> custom,
});
typedef $$TriggerTableUpdateCompanionBuilder = TriggerCompanion Function({
  Value<int> id,
  Value<TriggerLabel> labelKey,
  Value<String?> custom,
});

class $$TriggerTableFilterComposer
    extends Composer<_$AppDatabase, $TriggerTable> {
  $$TriggerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TriggerLabel, TriggerLabel, String>
  get labelKey => $composableBuilder(
    column: $table.labelKey,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get custom => $composableBuilder(
    column: $table.custom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TriggerTableOrderingComposer
    extends Composer<_$AppDatabase, $TriggerTable> {
  $$TriggerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelKey => $composableBuilder(
    column: $table.labelKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get custom => $composableBuilder(
    column: $table.custom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TriggerTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriggerTable> {
  $$TriggerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TriggerLabel, String> get labelKey =>
      $composableBuilder(column: $table.labelKey, builder: (column) => column);

  GeneratedColumn<String> get custom =>
      $composableBuilder(column: $table.custom, builder: (column) => column);
}

class $$TriggerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriggerTable,
          TriggerRow,
          $$TriggerTableFilterComposer,
          $$TriggerTableOrderingComposer,
          $$TriggerTableAnnotationComposer,
          $$TriggerTableCreateCompanionBuilder,
          $$TriggerTableUpdateCompanionBuilder,
          (
            TriggerRow,
            BaseReferences<_$AppDatabase, $TriggerTable, TriggerRow>,
          ),
          TriggerRow,
          PrefetchHooks Function()
        > {
  $$TriggerTableTableManager(_$AppDatabase db, $TriggerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriggerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriggerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriggerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<TriggerLabel> labelKey = const Value.absent(),
            Value<String?> custom = const Value.absent(),
          }) => TriggerCompanion(id: id, labelKey: labelKey, custom: custom),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TriggerLabel labelKey,
                Value<String?> custom = const Value.absent(),
              }) => TriggerCompanion.insert(
                id: id,
                labelKey: labelKey,
                custom: custom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TriggerTable, TriggerRow>(table),
                  BaseReferences<_$AppDatabase, $TriggerTable, TriggerRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TriggerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriggerTable,
      TriggerRow,
      $$TriggerTableFilterComposer,
      $$TriggerTableOrderingComposer,
      $$TriggerTableAnnotationComposer,
      $$TriggerTableCreateCompanionBuilder,
      $$TriggerTableUpdateCompanionBuilder,
      (TriggerRow, BaseReferences<_$AppDatabase, $TriggerTable, TriggerRow>),
      TriggerRow,
      PrefetchHooks Function()
    >;
typedef $$CravingEventTableCreateCompanionBuilder =
    CravingEventCompanion Function({
      Value<int> id,
      required DateTime ts,
      required CravingIntensity intensity,
      Value<TriggerLabel?> triggerLabel,
      required CravingOutcome outcome,
    });
typedef $$CravingEventTableUpdateCompanionBuilder =
    CravingEventCompanion Function({
      Value<int> id,
      Value<DateTime> ts,
      Value<CravingIntensity> intensity,
      Value<TriggerLabel?> triggerLabel,
      Value<CravingOutcome> outcome,
    });

class $$CravingEventTableFilterComposer
    extends Composer<_$AppDatabase, $CravingEventTable> {
  $$CravingEventTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CravingIntensity, CravingIntensity, int>
  get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TriggerLabel?, TriggerLabel, String>
  get triggerLabel => $composableBuilder(
    column: $table.triggerLabel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<CravingOutcome, CravingOutcome, String>
  get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$CravingEventTableOrderingComposer
    extends Composer<_$AppDatabase, $CravingEventTable> {
  $$CravingEventTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerLabel => $composableBuilder(
    column: $table.triggerLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CravingEventTableAnnotationComposer
    extends Composer<_$AppDatabase, $CravingEventTable> {
  $$CravingEventTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CravingIntensity, int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TriggerLabel?, String> get triggerLabel =>
      $composableBuilder(
        column: $table.triggerLabel,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<CravingOutcome, String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);
}

class $$CravingEventTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CravingEventTable,
          CravingEventRow,
          $$CravingEventTableFilterComposer,
          $$CravingEventTableOrderingComposer,
          $$CravingEventTableAnnotationComposer,
          $$CravingEventTableCreateCompanionBuilder,
          $$CravingEventTableUpdateCompanionBuilder,
          (
            CravingEventRow,
            BaseReferences<_$AppDatabase, $CravingEventTable, CravingEventRow>,
          ),
          CravingEventRow,
          PrefetchHooks Function()
        > {
  $$CravingEventTableTableManager(_$AppDatabase db, $CravingEventTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CravingEventTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CravingEventTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CravingEventTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> ts = const Value.absent(),
                Value<CravingIntensity> intensity = const Value.absent(),
                Value<TriggerLabel?> triggerLabel = const Value.absent(),
                Value<CravingOutcome> outcome = const Value.absent(),
              }) => CravingEventCompanion(
                id: id,
                ts: ts,
                intensity: intensity,
                triggerLabel: triggerLabel,
                outcome: outcome,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime ts,
                required CravingIntensity intensity,
                Value<TriggerLabel?> triggerLabel = const Value.absent(),
                required CravingOutcome outcome,
              }) => CravingEventCompanion.insert(
                id: id,
                ts: ts,
                intensity: intensity,
                triggerLabel: triggerLabel,
                outcome: outcome,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CravingEventTable, CravingEventRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CravingEventTable,
                    CravingEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CravingEventTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CravingEventTable,
      CravingEventRow,
      $$CravingEventTableFilterComposer,
      $$CravingEventTableOrderingComposer,
      $$CravingEventTableAnnotationComposer,
      $$CravingEventTableCreateCompanionBuilder,
      $$CravingEventTableUpdateCompanionBuilder,
      (
        CravingEventRow,
        BaseReferences<_$AppDatabase, $CravingEventTable, CravingEventRow>,
      ),
      CravingEventRow,
      PrefetchHooks Function()
    >;
typedef $$DailySummaryTableCreateCompanionBuilder =
    DailySummaryCompanion Function({
      required String date,
      required int count,
      Value<int?> planTarget,
      Value<double?> adherence,
      Value<double> savings,
      Value<int> avoidedCount,
      Value<int> resistedCount,
      Value<DateTime?> firstTs,
      Value<DateTime?> lastTs,
      Value<int?> minGapMinutes,
      Value<int> rowid,
    });
typedef $$DailySummaryTableUpdateCompanionBuilder =
    DailySummaryCompanion Function({
      Value<String> date,
      Value<int> count,
      Value<int?> planTarget,
      Value<double?> adherence,
      Value<double> savings,
      Value<int> avoidedCount,
      Value<int> resistedCount,
      Value<DateTime?> firstTs,
      Value<DateTime?> lastTs,
      Value<int?> minGapMinutes,
      Value<int> rowid,
    });

class $$DailySummaryTableFilterComposer
    extends Composer<_$AppDatabase, $DailySummaryTable> {
  $$DailySummaryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planTarget => $composableBuilder(
    column: $table.planTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get adherence => $composableBuilder(
    column: $table.adherence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savings => $composableBuilder(
    column: $table.savings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avoidedCount => $composableBuilder(
    column: $table.avoidedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resistedCount => $composableBuilder(
    column: $table.resistedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstTs => $composableBuilder(
    column: $table.firstTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastTs => $composableBuilder(
    column: $table.lastTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minGapMinutes => $composableBuilder(
    column: $table.minGapMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailySummaryTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySummaryTable> {
  $$DailySummaryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planTarget => $composableBuilder(
    column: $table.planTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get adherence => $composableBuilder(
    column: $table.adherence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savings => $composableBuilder(
    column: $table.savings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avoidedCount => $composableBuilder(
    column: $table.avoidedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resistedCount => $composableBuilder(
    column: $table.resistedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstTs => $composableBuilder(
    column: $table.firstTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastTs => $composableBuilder(
    column: $table.lastTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minGapMinutes => $composableBuilder(
    column: $table.minGapMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailySummaryTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySummaryTable> {
  $$DailySummaryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get planTarget => $composableBuilder(
    column: $table.planTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get adherence =>
      $composableBuilder(column: $table.adherence, builder: (column) => column);

  GeneratedColumn<double> get savings =>
      $composableBuilder(column: $table.savings, builder: (column) => column);

  GeneratedColumn<int> get avoidedCount => $composableBuilder(
    column: $table.avoidedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resistedCount => $composableBuilder(
    column: $table.resistedCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstTs =>
      $composableBuilder(column: $table.firstTs, builder: (column) => column);

  GeneratedColumn<DateTime> get lastTs =>
      $composableBuilder(column: $table.lastTs, builder: (column) => column);

  GeneratedColumn<int> get minGapMinutes => $composableBuilder(
    column: $table.minGapMinutes,
    builder: (column) => column,
  );
}

class $$DailySummaryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySummaryTable,
          DailySummaryRow,
          $$DailySummaryTableFilterComposer,
          $$DailySummaryTableOrderingComposer,
          $$DailySummaryTableAnnotationComposer,
          $$DailySummaryTableCreateCompanionBuilder,
          $$DailySummaryTableUpdateCompanionBuilder,
          (
            DailySummaryRow,
            BaseReferences<_$AppDatabase, $DailySummaryTable, DailySummaryRow>,
          ),
          DailySummaryRow,
          PrefetchHooks Function()
        > {
  $$DailySummaryTableTableManager(_$AppDatabase db, $DailySummaryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySummaryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySummaryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySummaryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int?> planTarget = const Value.absent(),
                Value<double?> adherence = const Value.absent(),
                Value<double> savings = const Value.absent(),
                Value<int> avoidedCount = const Value.absent(),
                Value<int> resistedCount = const Value.absent(),
                Value<DateTime?> firstTs = const Value.absent(),
                Value<DateTime?> lastTs = const Value.absent(),
                Value<int?> minGapMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySummaryCompanion(
                date: date,
                count: count,
                planTarget: planTarget,
                adherence: adherence,
                savings: savings,
                avoidedCount: avoidedCount,
                resistedCount: resistedCount,
                firstTs: firstTs,
                lastTs: lastTs,
                minGapMinutes: minGapMinutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int count,
                Value<int?> planTarget = const Value.absent(),
                Value<double?> adherence = const Value.absent(),
                Value<double> savings = const Value.absent(),
                Value<int> avoidedCount = const Value.absent(),
                Value<int> resistedCount = const Value.absent(),
                Value<DateTime?> firstTs = const Value.absent(),
                Value<DateTime?> lastTs = const Value.absent(),
                Value<int?> minGapMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySummaryCompanion.insert(
                date: date,
                count: count,
                planTarget: planTarget,
                adherence: adherence,
                savings: savings,
                avoidedCount: avoidedCount,
                resistedCount: resistedCount,
                firstTs: firstTs,
                lastTs: lastTs,
                minGapMinutes: minGapMinutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailySummaryTable, DailySummaryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailySummaryTable,
                    DailySummaryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySummaryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySummaryTable,
      DailySummaryRow,
      $$DailySummaryTableFilterComposer,
      $$DailySummaryTableOrderingComposer,
      $$DailySummaryTableAnnotationComposer,
      $$DailySummaryTableCreateCompanionBuilder,
      $$DailySummaryTableUpdateCompanionBuilder,
      (
        DailySummaryRow,
        BaseReferences<_$AppDatabase, $DailySummaryTable, DailySummaryRow>,
      ),
      DailySummaryRow,
      PrefetchHooks Function()
    >;
typedef $$HealthTimelineStateTableCreateCompanionBuilder =
    HealthTimelineStateCompanion Function({
      Value<int> id,
      Value<DateTime?> quitTs,
      Value<String> acknowledgedMilestones,
    });
typedef $$HealthTimelineStateTableUpdateCompanionBuilder =
    HealthTimelineStateCompanion Function({
      Value<int> id,
      Value<DateTime?> quitTs,
      Value<String> acknowledgedMilestones,
    });

class $$HealthTimelineStateTableFilterComposer
    extends Composer<_$AppDatabase, $HealthTimelineStateTable> {
  $$HealthTimelineStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get quitTs => $composableBuilder(
    column: $table.quitTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acknowledgedMilestones => $composableBuilder(
    column: $table.acknowledgedMilestones,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthTimelineStateTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthTimelineStateTable> {
  $$HealthTimelineStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get quitTs => $composableBuilder(
    column: $table.quitTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acknowledgedMilestones => $composableBuilder(
    column: $table.acknowledgedMilestones,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthTimelineStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthTimelineStateTable> {
  $$HealthTimelineStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get quitTs =>
      $composableBuilder(column: $table.quitTs, builder: (column) => column);

  GeneratedColumn<String> get acknowledgedMilestones => $composableBuilder(
    column: $table.acknowledgedMilestones,
    builder: (column) => column,
  );
}

class $$HealthTimelineStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthTimelineStateTable,
          TimelineStateRow,
          $$HealthTimelineStateTableFilterComposer,
          $$HealthTimelineStateTableOrderingComposer,
          $$HealthTimelineStateTableAnnotationComposer,
          $$HealthTimelineStateTableCreateCompanionBuilder,
          $$HealthTimelineStateTableUpdateCompanionBuilder,
          (
            TimelineStateRow,
            BaseReferences<
              _$AppDatabase,
              $HealthTimelineStateTable,
              TimelineStateRow
            >,
          ),
          TimelineStateRow,
          PrefetchHooks Function()
        > {
  $$HealthTimelineStateTableTableManager(
    _$AppDatabase db,
    $HealthTimelineStateTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthTimelineStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthTimelineStateTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HealthTimelineStateTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> quitTs = const Value.absent(),
                Value<String> acknowledgedMilestones = const Value.absent(),
              }) => HealthTimelineStateCompanion(
                id: id,
                quitTs: quitTs,
                acknowledgedMilestones: acknowledgedMilestones,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> quitTs = const Value.absent(),
                Value<String> acknowledgedMilestones = const Value.absent(),
              }) => HealthTimelineStateCompanion.insert(
                id: id,
                quitTs: quitTs,
                acknowledgedMilestones: acknowledgedMilestones,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HealthTimelineStateTable, TimelineStateRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $HealthTimelineStateTable,
                    TimelineStateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthTimelineStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthTimelineStateTable,
      TimelineStateRow,
      $$HealthTimelineStateTableFilterComposer,
      $$HealthTimelineStateTableOrderingComposer,
      $$HealthTimelineStateTableAnnotationComposer,
      $$HealthTimelineStateTableCreateCompanionBuilder,
      $$HealthTimelineStateTableUpdateCompanionBuilder,
      (
        TimelineStateRow,
        BaseReferences<
          _$AppDatabase,
          $HealthTimelineStateTable,
          TimelineStateRow
        >,
      ),
      TimelineStateRow,
      PrefetchHooks Function()
    >;
typedef $$MotivationContentTableCreateCompanionBuilder =
    MotivationContentCompanion Function({
      required String id,
      required String lang,
      required String category,
      required String body,
      required String sourceUrl,
      required String sourceDate,
      Value<String?> conditionJson,
      Value<int> rowid,
    });
typedef $$MotivationContentTableUpdateCompanionBuilder =
    MotivationContentCompanion Function({
      Value<String> id,
      Value<String> lang,
      Value<String> category,
      Value<String> body,
      Value<String> sourceUrl,
      Value<String> sourceDate,
      Value<String?> conditionJson,
      Value<int> rowid,
    });

class $$MotivationContentTableFilterComposer
    extends Composer<_$AppDatabase, $MotivationContentTable> {
  $$MotivationContentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionJson => $composableBuilder(
    column: $table.conditionJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MotivationContentTableOrderingComposer
    extends Composer<_$AppDatabase, $MotivationContentTable> {
  $$MotivationContentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionJson => $composableBuilder(
    column: $table.conditionJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MotivationContentTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotivationContentTable> {
  $$MotivationContentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionJson => $composableBuilder(
    column: $table.conditionJson,
    builder: (column) => column,
  );
}

class $$MotivationContentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MotivationContentTable,
          MotivationContentRow,
          $$MotivationContentTableFilterComposer,
          $$MotivationContentTableOrderingComposer,
          $$MotivationContentTableAnnotationComposer,
          $$MotivationContentTableCreateCompanionBuilder,
          $$MotivationContentTableUpdateCompanionBuilder,
          (
            MotivationContentRow,
            BaseReferences<
              _$AppDatabase,
              $MotivationContentTable,
              MotivationContentRow
            >,
          ),
          MotivationContentRow,
          PrefetchHooks Function()
        > {
  $$MotivationContentTableTableManager(
    _$AppDatabase db,
    $MotivationContentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotivationContentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotivationContentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotivationContentTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> sourceDate = const Value.absent(),
                Value<String?> conditionJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MotivationContentCompanion(
                id: id,
                lang: lang,
                category: category,
                body: body,
                sourceUrl: sourceUrl,
                sourceDate: sourceDate,
                conditionJson: conditionJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lang,
                required String category,
                required String body,
                required String sourceUrl,
                required String sourceDate,
                Value<String?> conditionJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MotivationContentCompanion.insert(
                id: id,
                lang: lang,
                category: category,
                body: body,
                sourceUrl: sourceUrl,
                sourceDate: sourceDate,
                conditionJson: conditionJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MotivationContentTable, MotivationContentRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $MotivationContentTable,
                    MotivationContentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MotivationContentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MotivationContentTable,
      MotivationContentRow,
      $$MotivationContentTableFilterComposer,
      $$MotivationContentTableOrderingComposer,
      $$MotivationContentTableAnnotationComposer,
      $$MotivationContentTableCreateCompanionBuilder,
      $$MotivationContentTableUpdateCompanionBuilder,
      (
        MotivationContentRow,
        BaseReferences<
          _$AppDatabase,
          $MotivationContentTable,
          MotivationContentRow
        >,
      ),
      MotivationContentRow,
      PrefetchHooks Function()
    >;
typedef $$PurchaseEntitlementTableCreateCompanionBuilder =
    PurchaseEntitlementCompanion Function({
      Value<int> id,
      required String store,
      required String productId,
      required String purchaseToken,
      required String state,
      required DateTime lastVerifiedAt,
    });
typedef $$PurchaseEntitlementTableUpdateCompanionBuilder =
    PurchaseEntitlementCompanion Function({
      Value<int> id,
      Value<String> store,
      Value<String> productId,
      Value<String> purchaseToken,
      Value<String> state,
      Value<DateTime> lastVerifiedAt,
    });

class $$PurchaseEntitlementTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseEntitlementTable> {
  $$PurchaseEntitlementTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseToken => $composableBuilder(
    column: $table.purchaseToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseEntitlementTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseEntitlementTable> {
  $$PurchaseEntitlementTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseToken => $composableBuilder(
    column: $table.purchaseToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseEntitlementTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseEntitlementTable> {
  $$PurchaseEntitlementTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get store =>
      $composableBuilder(column: $table.store, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get purchaseToken => $composableBuilder(
    column: $table.purchaseToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => column,
  );
}

class $$PurchaseEntitlementTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseEntitlementTable,
          PurchaseEntitlementRow,
          $$PurchaseEntitlementTableFilterComposer,
          $$PurchaseEntitlementTableOrderingComposer,
          $$PurchaseEntitlementTableAnnotationComposer,
          $$PurchaseEntitlementTableCreateCompanionBuilder,
          $$PurchaseEntitlementTableUpdateCompanionBuilder,
          (
            PurchaseEntitlementRow,
            BaseReferences<
              _$AppDatabase,
              $PurchaseEntitlementTable,
              PurchaseEntitlementRow
            >,
          ),
          PurchaseEntitlementRow,
          PrefetchHooks Function()
        > {
  $$PurchaseEntitlementTableTableManager(
    _$AppDatabase db,
    $PurchaseEntitlementTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseEntitlementTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseEntitlementTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PurchaseEntitlementTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> store = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> purchaseToken = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime> lastVerifiedAt = const Value.absent(),
              }) => PurchaseEntitlementCompanion(
                id: id,
                store: store,
                productId: productId,
                purchaseToken: purchaseToken,
                state: state,
                lastVerifiedAt: lastVerifiedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String store,
                required String productId,
                required String purchaseToken,
                required String state,
                required DateTime lastVerifiedAt,
              }) => PurchaseEntitlementCompanion.insert(
                id: id,
                store: store,
                productId: productId,
                purchaseToken: purchaseToken,
                state: state,
                lastVerifiedAt: lastVerifiedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PurchaseEntitlementTable,
                    PurchaseEntitlementRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PurchaseEntitlementTable,
                    PurchaseEntitlementRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseEntitlementTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseEntitlementTable,
      PurchaseEntitlementRow,
      $$PurchaseEntitlementTableFilterComposer,
      $$PurchaseEntitlementTableOrderingComposer,
      $$PurchaseEntitlementTableAnnotationComposer,
      $$PurchaseEntitlementTableCreateCompanionBuilder,
      $$PurchaseEntitlementTableUpdateCompanionBuilder,
      (
        PurchaseEntitlementRow,
        BaseReferences<
          _$AppDatabase,
          $PurchaseEntitlementTable,
          PurchaseEntitlementRow
        >,
      ),
      PurchaseEntitlementRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<NotificationDensity> notifLevel,
  Value<ThemeOption> theme,
  Value<bool> reduceMotion,
  Value<bool> haptics,
  Value<DateTime?> trialStartedAt,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<NotificationDensity> notifLevel,
  Value<ThemeOption> theme,
  Value<bool> reduceMotion,
  Value<bool> haptics,
  Value<DateTime?> trialStartedAt,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    NotificationDensity,
    NotificationDensity,
    String
  >
  get notifLevel => $composableBuilder(
    column: $table.notifLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ThemeOption, ThemeOption, String> get theme =>
      $composableBuilder(
        column: $table.theme,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get haptics => $composableBuilder(
    column: $table.haptics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialStartedAt => $composableBuilder(
    column: $table.trialStartedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notifLevel => $composableBuilder(
    column: $table.notifLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get haptics => $composableBuilder(
    column: $table.haptics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialStartedAt => $composableBuilder(
    column: $table.trialStartedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationDensity, String>
  get notifLevel => $composableBuilder(
    column: $table.notifLevel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ThemeOption, String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get haptics =>
      $composableBuilder(column: $table.haptics, builder: (column) => column);

  GeneratedColumn<DateTime> get trialStartedAt => $composableBuilder(
    column: $table.trialStartedAt,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<NotificationDensity> notifLevel = const Value.absent(),
                Value<ThemeOption> theme = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<DateTime?> trialStartedAt = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                notifLevel: notifLevel,
                theme: theme,
                reduceMotion: reduceMotion,
                haptics: haptics,
                trialStartedAt: trialStartedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<NotificationDensity> notifLevel = const Value.absent(),
                Value<ThemeOption> theme = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<DateTime?> trialStartedAt = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                notifLevel: notifLevel,
                theme: theme,
                reduceMotion: reduceMotion,
                haptics: haptics,
                trialStartedAt: trialStartedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingsRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingsRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>),
      SettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$SmokingProfileTableTableManager get smokingProfile =>
      $$SmokingProfileTableTableManager(_db, _db.smokingProfile);
  $$CigaretteEventTableTableManager get cigaretteEvent =>
      $$CigaretteEventTableTableManager(_db, _db.cigaretteEvent);
  $$CigaretteProductTableTableManager get cigaretteProduct =>
      $$CigaretteProductTableTableManager(_db, _db.cigaretteProduct);
  $$DailyPlanTableTableManager get dailyPlan =>
      $$DailyPlanTableTableManager(_db, _db.dailyPlan);
  $$PlanAdjustmentTableTableManager get planAdjustment =>
      $$PlanAdjustmentTableTableManager(_db, _db.planAdjustment);
  $$TriggerTableTableManager get trigger =>
      $$TriggerTableTableManager(_db, _db.trigger);
  $$CravingEventTableTableManager get cravingEvent =>
      $$CravingEventTableTableManager(_db, _db.cravingEvent);
  $$DailySummaryTableTableManager get dailySummary =>
      $$DailySummaryTableTableManager(_db, _db.dailySummary);
  $$HealthTimelineStateTableTableManager get healthTimelineState =>
      $$HealthTimelineStateTableTableManager(_db, _db.healthTimelineState);
  $$MotivationContentTableTableManager get motivationContent =>
      $$MotivationContentTableTableManager(_db, _db.motivationContent);
  $$PurchaseEntitlementTableTableManager get purchaseEntitlement =>
      $$PurchaseEntitlementTableTableManager(_db, _db.purchaseEntitlement);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
