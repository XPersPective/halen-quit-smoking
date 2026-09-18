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
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SexOption?, String> sex =
      GeneratedColumn<String>(
        'sex',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SexOption?>($SmokingProfileTable.$convertersexn);
  static const VerificationMeta _smokingYearsMeta = const VerificationMeta(
    'smokingYears',
  );
  @override
  late final GeneratedColumn<double> smokingYears = GeneratedColumn<double>(
    'smoking_years',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsiMeta = const VerificationMeta('hsi');
  @override
  late final GeneratedColumn<int> hsi = GeneratedColumn<int>(
    'hsi',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MetabolismSpeed, String>
  metabolism = GeneratedColumn<String>(
    'metabolism',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  ).withConverter<MetabolismSpeed>($SmokingProfileTable.$convertermetabolism);
  static const VerificationMeta _tarMgPerCigaretteMeta = const VerificationMeta(
    'tarMgPerCigarette',
  );
  @override
  late final GeneratedColumn<double> tarMgPerCigarette =
      GeneratedColumn<double>(
        'tar_mg_per_cigarette',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nicotineMgPerCigaretteMeta =
      const VerificationMeta('nicotineMgPerCigarette');
  @override
  late final GeneratedColumn<double> nicotineMgPerCigarette =
      GeneratedColumn<double>(
        'nicotine_mg_per_cigarette',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
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
    heightCm,
    weightKg,
    sex,
    smokingYears,
    hsi,
    metabolism,
    tarMgPerCigarette,
    nicotineMgPerCigarette,
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
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('smoking_years')) {
      context.handle(
        _smokingYearsMeta,
        smokingYears.isAcceptableOrUnknown(
          data['smoking_years']!,
          _smokingYearsMeta,
        ),
      );
    }
    if (data.containsKey('hsi')) {
      context.handle(
        _hsiMeta,
        hsi.isAcceptableOrUnknown(data['hsi']!, _hsiMeta),
      );
    }
    if (data.containsKey('tar_mg_per_cigarette')) {
      context.handle(
        _tarMgPerCigaretteMeta,
        tarMgPerCigarette.isAcceptableOrUnknown(
          data['tar_mg_per_cigarette']!,
          _tarMgPerCigaretteMeta,
        ),
      );
    }
    if (data.containsKey('nicotine_mg_per_cigarette')) {
      context.handle(
        _nicotineMgPerCigaretteMeta,
        nicotineMgPerCigarette.isAcceptableOrUnknown(
          data['nicotine_mg_per_cigarette']!,
          _nicotineMgPerCigaretteMeta,
        ),
      );
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
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      sex: $SmokingProfileTable.$convertersexn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        ),
      ),
      smokingYears: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}smoking_years'],
      ),
      hsi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hsi'],
      ),
      metabolism: $SmokingProfileTable.$convertermetabolism.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metabolism'],
        )!,
      ),
      tarMgPerCigarette: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tar_mg_per_cigarette'],
      ),
      nicotineMgPerCigarette: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nicotine_mg_per_cigarette'],
      ),
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
  static JsonTypeConverter2<SexOption, String, String> $convertersex =
      const EnumNameConverter<SexOption>(SexOption.values);
  static JsonTypeConverter2<SexOption?, String?, String?> $convertersexn =
      JsonTypeConverter2.asNullable($convertersex);
  static JsonTypeConverter2<MetabolismSpeed, String, String>
  $convertermetabolism = const EnumNameConverter<MetabolismSpeed>(
    MetabolismSpeed.values,
  );
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
  final double? heightCm;
  final double? weightKg;
  final SexOption? sex;
  final double? smokingYears;
  final int? hsi;
  final MetabolismSpeed metabolism;
  final double? tarMgPerCigarette;
  final double? nicotineMgPerCigarette;
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
    this.heightCm,
    this.weightKg,
    this.sex,
    this.smokingYears,
    this.hsi,
    required this.metabolism,
    this.tarMgPerCigarette,
    this.nicotineMgPerCigarette,
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
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(
        $SmokingProfileTable.$convertersexn.toSql(sex),
      );
    }
    if (!nullToAbsent || smokingYears != null) {
      map['smoking_years'] = Variable<double>(smokingYears);
    }
    if (!nullToAbsent || hsi != null) {
      map['hsi'] = Variable<int>(hsi);
    }
    {
      map['metabolism'] = Variable<String>(
        $SmokingProfileTable.$convertermetabolism.toSql(metabolism),
      );
    }
    if (!nullToAbsent || tarMgPerCigarette != null) {
      map['tar_mg_per_cigarette'] = Variable<double>(tarMgPerCigarette);
    }
    if (!nullToAbsent || nicotineMgPerCigarette != null) {
      map['nicotine_mg_per_cigarette'] = Variable<double>(
        nicotineMgPerCigarette,
      );
    }
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
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      smokingYears: smokingYears == null && nullToAbsent
          ? const Value.absent()
          : Value(smokingYears),
      hsi: hsi == null && nullToAbsent ? const Value.absent() : Value(hsi),
      metabolism: Value(metabolism),
      tarMgPerCigarette: tarMgPerCigarette == null && nullToAbsent
          ? const Value.absent()
          : Value(tarMgPerCigarette),
      nicotineMgPerCigarette: nicotineMgPerCigarette == null && nullToAbsent
          ? const Value.absent()
          : Value(nicotineMgPerCigarette),
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
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      sex: $SmokingProfileTable.$convertersexn.fromJson(
        serializer.fromJson<String?>(json['sex']),
      ),
      smokingYears: serializer.fromJson<double?>(json['smokingYears']),
      hsi: serializer.fromJson<int?>(json['hsi']),
      metabolism: $SmokingProfileTable.$convertermetabolism.fromJson(
        serializer.fromJson<String>(json['metabolism']),
      ),
      tarMgPerCigarette: serializer.fromJson<double?>(
        json['tarMgPerCigarette'],
      ),
      nicotineMgPerCigarette: serializer.fromJson<double?>(
        json['nicotineMgPerCigarette'],
      ),
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
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'sex': serializer.toJson<String?>(
        $SmokingProfileTable.$convertersexn.toJson(sex),
      ),
      'smokingYears': serializer.toJson<double?>(smokingYears),
      'hsi': serializer.toJson<int?>(hsi),
      'metabolism': serializer.toJson<String>(
        $SmokingProfileTable.$convertermetabolism.toJson(metabolism),
      ),
      'tarMgPerCigarette': serializer.toJson<double?>(tarMgPerCigarette),
      'nicotineMgPerCigarette': serializer.toJson<double?>(
        nicotineMgPerCigarette,
      ),
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
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<SexOption?> sex = const Value.absent(),
    Value<double?> smokingYears = const Value.absent(),
    Value<int?> hsi = const Value.absent(),
    MetabolismSpeed? metabolism,
    Value<double?> tarMgPerCigarette = const Value.absent(),
    Value<double?> nicotineMgPerCigarette = const Value.absent(),
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
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    sex: sex.present ? sex.value : this.sex,
    smokingYears: smokingYears.present ? smokingYears.value : this.smokingYears,
    hsi: hsi.present ? hsi.value : this.hsi,
    metabolism: metabolism ?? this.metabolism,
    tarMgPerCigarette: tarMgPerCigarette.present
        ? tarMgPerCigarette.value
        : this.tarMgPerCigarette,
    nicotineMgPerCigarette: nicotineMgPerCigarette.present
        ? nicotineMgPerCigarette.value
        : this.nicotineMgPerCigarette,
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
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      sex: data.sex.present ? data.sex.value : this.sex,
      smokingYears: data.smokingYears.present
          ? data.smokingYears.value
          : this.smokingYears,
      hsi: data.hsi.present ? data.hsi.value : this.hsi,
      metabolism: data.metabolism.present
          ? data.metabolism.value
          : this.metabolism,
      tarMgPerCigarette: data.tarMgPerCigarette.present
          ? data.tarMgPerCigarette.value
          : this.tarMgPerCigarette,
      nicotineMgPerCigarette: data.nicotineMgPerCigarette.present
          ? data.nicotineMgPerCigarette.value
          : this.nicotineMgPerCigarette,
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
          ..write('startedAt: $startedAt, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('sex: $sex, ')
          ..write('smokingYears: $smokingYears, ')
          ..write('hsi: $hsi, ')
          ..write('metabolism: $metabolism, ')
          ..write('tarMgPerCigarette: $tarMgPerCigarette, ')
          ..write('nicotineMgPerCigarette: $nicotineMgPerCigarette')
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
    heightCm,
    weightKg,
    sex,
    smokingYears,
    hsi,
    metabolism,
    tarMgPerCigarette,
    nicotineMgPerCigarette,
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
          other.startedAt == this.startedAt &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.sex == this.sex &&
          other.smokingYears == this.smokingYears &&
          other.hsi == this.hsi &&
          other.metabolism == this.metabolism &&
          other.tarMgPerCigarette == this.tarMgPerCigarette &&
          other.nicotineMgPerCigarette == this.nicotineMgPerCigarette);
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
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<SexOption?> sex;
  final Value<double?> smokingYears;
  final Value<int?> hsi;
  final Value<MetabolismSpeed> metabolism;
  final Value<double?> tarMgPerCigarette;
  final Value<double?> nicotineMgPerCigarette;
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
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.sex = const Value.absent(),
    this.smokingYears = const Value.absent(),
    this.hsi = const Value.absent(),
    this.metabolism = const Value.absent(),
    this.tarMgPerCigarette = const Value.absent(),
    this.nicotineMgPerCigarette = const Value.absent(),
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
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.sex = const Value.absent(),
    this.smokingYears = const Value.absent(),
    this.hsi = const Value.absent(),
    this.metabolism = const Value.absent(),
    this.tarMgPerCigarette = const Value.absent(),
    this.nicotineMgPerCigarette = const Value.absent(),
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
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? sex,
    Expression<double>? smokingYears,
    Expression<int>? hsi,
    Expression<String>? metabolism,
    Expression<double>? tarMgPerCigarette,
    Expression<double>? nicotineMgPerCigarette,
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
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (sex != null) 'sex': sex,
      if (smokingYears != null) 'smoking_years': smokingYears,
      if (hsi != null) 'hsi': hsi,
      if (metabolism != null) 'metabolism': metabolism,
      if (tarMgPerCigarette != null) 'tar_mg_per_cigarette': tarMgPerCigarette,
      if (nicotineMgPerCigarette != null)
        'nicotine_mg_per_cigarette': nicotineMgPerCigarette,
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
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<SexOption?>? sex,
    Value<double?>? smokingYears,
    Value<int?>? hsi,
    Value<MetabolismSpeed>? metabolism,
    Value<double?>? tarMgPerCigarette,
    Value<double?>? nicotineMgPerCigarette,
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
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      sex: sex ?? this.sex,
      smokingYears: smokingYears ?? this.smokingYears,
      hsi: hsi ?? this.hsi,
      metabolism: metabolism ?? this.metabolism,
      tarMgPerCigarette: tarMgPerCigarette ?? this.tarMgPerCigarette,
      nicotineMgPerCigarette:
          nicotineMgPerCigarette ?? this.nicotineMgPerCigarette,
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
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(
        $SmokingProfileTable.$convertersexn.toSql(sex.value),
      );
    }
    if (smokingYears.present) {
      map['smoking_years'] = Variable<double>(smokingYears.value);
    }
    if (hsi.present) {
      map['hsi'] = Variable<int>(hsi.value);
    }
    if (metabolism.present) {
      map['metabolism'] = Variable<String>(
        $SmokingProfileTable.$convertermetabolism.toSql(metabolism.value),
      );
    }
    if (tarMgPerCigarette.present) {
      map['tar_mg_per_cigarette'] = Variable<double>(tarMgPerCigarette.value);
    }
    if (nicotineMgPerCigarette.present) {
      map['nicotine_mg_per_cigarette'] = Variable<double>(
        nicotineMgPerCigarette.value,
      );
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
          ..write('startedAt: $startedAt, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('sex: $sex, ')
          ..write('smokingYears: $smokingYears, ')
          ..write('hsi: $hsi, ')
          ..write('metabolism: $metabolism, ')
          ..write('tarMgPerCigarette: $tarMgPerCigarette, ')
          ..write('nicotineMgPerCigarette: $nicotineMgPerCigarette')
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
  Set<GeneratedColumn> get $primaryKey => {date};
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
  static const VerificationMeta _techniqueKeyMeta = const VerificationMeta(
    'techniqueKey',
  );
  @override
  late final GeneratedColumn<String> techniqueKey = GeneratedColumn<String>(
    'technique_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ts,
    intensity,
    triggerLabel,
    outcome,
    techniqueKey,
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
    if (data.containsKey('technique_key')) {
      context.handle(
        _techniqueKeyMeta,
        techniqueKey.isAcceptableOrUnknown(
          data['technique_key']!,
          _techniqueKeyMeta,
        ),
      );
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
      techniqueKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technique_key'],
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

  /// Which SOS technique the user reached for (module report §5.⑤) — powers
  /// the "what worked for you before" ordering. Null for older records.
  final String? techniqueKey;
  const CravingEventRow({
    required this.id,
    required this.ts,
    required this.intensity,
    this.triggerLabel,
    required this.outcome,
    this.techniqueKey,
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
    if (!nullToAbsent || techniqueKey != null) {
      map['technique_key'] = Variable<String>(techniqueKey);
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
      techniqueKey: techniqueKey == null && nullToAbsent
          ? const Value.absent()
          : Value(techniqueKey),
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
      techniqueKey: serializer.fromJson<String?>(json['techniqueKey']),
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
      'techniqueKey': serializer.toJson<String?>(techniqueKey),
    };
  }

  CravingEventRow copyWith({
    int? id,
    DateTime? ts,
    CravingIntensity? intensity,
    Value<TriggerLabel?> triggerLabel = const Value.absent(),
    CravingOutcome? outcome,
    Value<String?> techniqueKey = const Value.absent(),
  }) => CravingEventRow(
    id: id ?? this.id,
    ts: ts ?? this.ts,
    intensity: intensity ?? this.intensity,
    triggerLabel: triggerLabel.present ? triggerLabel.value : this.triggerLabel,
    outcome: outcome ?? this.outcome,
    techniqueKey: techniqueKey.present ? techniqueKey.value : this.techniqueKey,
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
      techniqueKey: data.techniqueKey.present
          ? data.techniqueKey.value
          : this.techniqueKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CravingEventRow(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('intensity: $intensity, ')
          ..write('triggerLabel: $triggerLabel, ')
          ..write('outcome: $outcome, ')
          ..write('techniqueKey: $techniqueKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ts, intensity, triggerLabel, outcome, techniqueKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CravingEventRow &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.intensity == this.intensity &&
          other.triggerLabel == this.triggerLabel &&
          other.outcome == this.outcome &&
          other.techniqueKey == this.techniqueKey);
}

class CravingEventCompanion extends UpdateCompanion<CravingEventRow> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<CravingIntensity> intensity;
  final Value<TriggerLabel?> triggerLabel;
  final Value<CravingOutcome> outcome;
  final Value<String?> techniqueKey;
  const CravingEventCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.intensity = const Value.absent(),
    this.triggerLabel = const Value.absent(),
    this.outcome = const Value.absent(),
    this.techniqueKey = const Value.absent(),
  });
  CravingEventCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required CravingIntensity intensity,
    this.triggerLabel = const Value.absent(),
    required CravingOutcome outcome,
    this.techniqueKey = const Value.absent(),
  }) : ts = Value(ts),
       intensity = Value(intensity),
       outcome = Value(outcome);
  static Insertable<CravingEventRow> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<int>? intensity,
    Expression<String>? triggerLabel,
    Expression<String>? outcome,
    Expression<String>? techniqueKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (intensity != null) 'intensity': intensity,
      if (triggerLabel != null) 'trigger_label': triggerLabel,
      if (outcome != null) 'outcome': outcome,
      if (techniqueKey != null) 'technique_key': techniqueKey,
    });
  }

  CravingEventCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? ts,
    Value<CravingIntensity>? intensity,
    Value<TriggerLabel?>? triggerLabel,
    Value<CravingOutcome>? outcome,
    Value<String?>? techniqueKey,
  }) {
    return CravingEventCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      intensity: intensity ?? this.intensity,
      triggerLabel: triggerLabel ?? this.triggerLabel,
      outcome: outcome ?? this.outcome,
      techniqueKey: techniqueKey ?? this.techniqueKey,
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
    if (techniqueKey.present) {
      map['technique_key'] = Variable<String>(techniqueKey.value);
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
          ..write('outcome: $outcome, ')
          ..write('techniqueKey: $techniqueKey')
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
  Set<GeneratedColumn> get $primaryKey => {date};
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
  Set<GeneratedColumn> get $primaryKey => {id};
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
  static const VerificationMeta _preLogPauseSecondsMeta =
      const VerificationMeta('preLogPauseSeconds');
  @override
  late final GeneratedColumn<int> preLogPauseSeconds = GeneratedColumn<int>(
    'pre_log_pause_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _riskyWindowReminderMeta =
      const VerificationMeta('riskyWindowReminder');
  @override
  late final GeneratedColumn<bool> riskyWindowReminder = GeneratedColumn<bool>(
    'risky_window_reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("risky_window_reminder" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _appLocaleMeta = const VerificationMeta(
    'appLocale',
  );
  @override
  late final GeneratedColumn<String> appLocale = GeneratedColumn<String>(
    'app_locale',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialNudgeMeta = const VerificationMeta(
    'trialNudge',
  );
  @override
  late final GeneratedColumn<bool> trialNudge = GeneratedColumn<bool>(
    'trial_nudge',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("trial_nudge" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notifLevel,
    theme,
    reduceMotion,
    haptics,
    trialStartedAt,
    preLogPauseSeconds,
    riskyWindowReminder,
    appLocale,
    trialNudge,
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
    if (data.containsKey('pre_log_pause_seconds')) {
      context.handle(
        _preLogPauseSecondsMeta,
        preLogPauseSeconds.isAcceptableOrUnknown(
          data['pre_log_pause_seconds']!,
          _preLogPauseSecondsMeta,
        ),
      );
    }
    if (data.containsKey('risky_window_reminder')) {
      context.handle(
        _riskyWindowReminderMeta,
        riskyWindowReminder.isAcceptableOrUnknown(
          data['risky_window_reminder']!,
          _riskyWindowReminderMeta,
        ),
      );
    }
    if (data.containsKey('app_locale')) {
      context.handle(
        _appLocaleMeta,
        appLocale.isAcceptableOrUnknown(data['app_locale']!, _appLocaleMeta),
      );
    }
    if (data.containsKey('trial_nudge')) {
      context.handle(
        _trialNudgeMeta,
        trialNudge.isAcceptableOrUnknown(data['trial_nudge']!, _trialNudgeMeta),
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
      preLogPauseSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_log_pause_seconds'],
      )!,
      riskyWindowReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}risky_window_reminder'],
      )!,
      appLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_locale'],
      ),
      trialNudge: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}trial_nudge'],
      )!,
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

  /// Opt-in pre-log pause in seconds (module report §12.③). The record is
  /// still written immediately; the pause only offers a window to undo it.
  /// 0 = off, the default.
  final int preLogPauseSeconds;

  /// Opt-in heads-up 20 minutes before the riskiest hour of the day
  /// (module report §4.③). Off by default — the category's own reviews show
  /// what unrequested pushes do to a quit app's rating.
  final bool riskyWindowReminder;

  /// UI language override: 'en', 'tr' or 'de'. Null = follow the system
  /// language, the default.
  final String? appLocale;

  /// Opt-in day-5 trial nudge (brain T2). A marketing reminder needs its own
  /// user preference; the default notification density never implies it.
  final bool trialNudge;
  const SettingsRow({
    required this.id,
    required this.notifLevel,
    required this.theme,
    required this.reduceMotion,
    required this.haptics,
    this.trialStartedAt,
    required this.preLogPauseSeconds,
    required this.riskyWindowReminder,
    this.appLocale,
    required this.trialNudge,
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
    map['pre_log_pause_seconds'] = Variable<int>(preLogPauseSeconds);
    map['risky_window_reminder'] = Variable<bool>(riskyWindowReminder);
    if (!nullToAbsent || appLocale != null) {
      map['app_locale'] = Variable<String>(appLocale);
    }
    map['trial_nudge'] = Variable<bool>(trialNudge);
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
      preLogPauseSeconds: Value(preLogPauseSeconds),
      riskyWindowReminder: Value(riskyWindowReminder),
      appLocale: appLocale == null && nullToAbsent
          ? const Value.absent()
          : Value(appLocale),
      trialNudge: Value(trialNudge),
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
      preLogPauseSeconds: serializer.fromJson<int>(json['preLogPauseSeconds']),
      riskyWindowReminder: serializer.fromJson<bool>(
        json['riskyWindowReminder'],
      ),
      appLocale: serializer.fromJson<String?>(json['appLocale']),
      trialNudge: serializer.fromJson<bool>(json['trialNudge']),
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
      'preLogPauseSeconds': serializer.toJson<int>(preLogPauseSeconds),
      'riskyWindowReminder': serializer.toJson<bool>(riskyWindowReminder),
      'appLocale': serializer.toJson<String?>(appLocale),
      'trialNudge': serializer.toJson<bool>(trialNudge),
    };
  }

  SettingsRow copyWith({
    int? id,
    NotificationDensity? notifLevel,
    ThemeOption? theme,
    bool? reduceMotion,
    bool? haptics,
    Value<DateTime?> trialStartedAt = const Value.absent(),
    int? preLogPauseSeconds,
    bool? riskyWindowReminder,
    Value<String?> appLocale = const Value.absent(),
    bool? trialNudge,
  }) => SettingsRow(
    id: id ?? this.id,
    notifLevel: notifLevel ?? this.notifLevel,
    theme: theme ?? this.theme,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    haptics: haptics ?? this.haptics,
    trialStartedAt: trialStartedAt.present
        ? trialStartedAt.value
        : this.trialStartedAt,
    preLogPauseSeconds: preLogPauseSeconds ?? this.preLogPauseSeconds,
    riskyWindowReminder: riskyWindowReminder ?? this.riskyWindowReminder,
    appLocale: appLocale.present ? appLocale.value : this.appLocale,
    trialNudge: trialNudge ?? this.trialNudge,
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
      preLogPauseSeconds: data.preLogPauseSeconds.present
          ? data.preLogPauseSeconds.value
          : this.preLogPauseSeconds,
      riskyWindowReminder: data.riskyWindowReminder.present
          ? data.riskyWindowReminder.value
          : this.riskyWindowReminder,
      appLocale: data.appLocale.present ? data.appLocale.value : this.appLocale,
      trialNudge: data.trialNudge.present
          ? data.trialNudge.value
          : this.trialNudge,
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
          ..write('trialStartedAt: $trialStartedAt, ')
          ..write('preLogPauseSeconds: $preLogPauseSeconds, ')
          ..write('riskyWindowReminder: $riskyWindowReminder, ')
          ..write('appLocale: $appLocale, ')
          ..write('trialNudge: $trialNudge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notifLevel,
    theme,
    reduceMotion,
    haptics,
    trialStartedAt,
    preLogPauseSeconds,
    riskyWindowReminder,
    appLocale,
    trialNudge,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.notifLevel == this.notifLevel &&
          other.theme == this.theme &&
          other.reduceMotion == this.reduceMotion &&
          other.haptics == this.haptics &&
          other.trialStartedAt == this.trialStartedAt &&
          other.preLogPauseSeconds == this.preLogPauseSeconds &&
          other.riskyWindowReminder == this.riskyWindowReminder &&
          other.appLocale == this.appLocale &&
          other.trialNudge == this.trialNudge);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<NotificationDensity> notifLevel;
  final Value<ThemeOption> theme;
  final Value<bool> reduceMotion;
  final Value<bool> haptics;
  final Value<DateTime?> trialStartedAt;
  final Value<int> preLogPauseSeconds;
  final Value<bool> riskyWindowReminder;
  final Value<String?> appLocale;
  final Value<bool> trialNudge;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.notifLevel = const Value.absent(),
    this.theme = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.haptics = const Value.absent(),
    this.trialStartedAt = const Value.absent(),
    this.preLogPauseSeconds = const Value.absent(),
    this.riskyWindowReminder = const Value.absent(),
    this.appLocale = const Value.absent(),
    this.trialNudge = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.notifLevel = const Value.absent(),
    this.theme = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.haptics = const Value.absent(),
    this.trialStartedAt = const Value.absent(),
    this.preLogPauseSeconds = const Value.absent(),
    this.riskyWindowReminder = const Value.absent(),
    this.appLocale = const Value.absent(),
    this.trialNudge = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? notifLevel,
    Expression<String>? theme,
    Expression<bool>? reduceMotion,
    Expression<bool>? haptics,
    Expression<DateTime>? trialStartedAt,
    Expression<int>? preLogPauseSeconds,
    Expression<bool>? riskyWindowReminder,
    Expression<String>? appLocale,
    Expression<bool>? trialNudge,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notifLevel != null) 'notif_level': notifLevel,
      if (theme != null) 'theme': theme,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (haptics != null) 'haptics': haptics,
      if (trialStartedAt != null) 'trial_started_at': trialStartedAt,
      if (preLogPauseSeconds != null)
        'pre_log_pause_seconds': preLogPauseSeconds,
      if (riskyWindowReminder != null)
        'risky_window_reminder': riskyWindowReminder,
      if (appLocale != null) 'app_locale': appLocale,
      if (trialNudge != null) 'trial_nudge': trialNudge,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<NotificationDensity>? notifLevel,
    Value<ThemeOption>? theme,
    Value<bool>? reduceMotion,
    Value<bool>? haptics,
    Value<DateTime?>? trialStartedAt,
    Value<int>? preLogPauseSeconds,
    Value<bool>? riskyWindowReminder,
    Value<String?>? appLocale,
    Value<bool>? trialNudge,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      notifLevel: notifLevel ?? this.notifLevel,
      theme: theme ?? this.theme,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      haptics: haptics ?? this.haptics,
      trialStartedAt: trialStartedAt ?? this.trialStartedAt,
      preLogPauseSeconds: preLogPauseSeconds ?? this.preLogPauseSeconds,
      riskyWindowReminder: riskyWindowReminder ?? this.riskyWindowReminder,
      appLocale: appLocale ?? this.appLocale,
      trialNudge: trialNudge ?? this.trialNudge,
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
    if (preLogPauseSeconds.present) {
      map['pre_log_pause_seconds'] = Variable<int>(preLogPauseSeconds.value);
    }
    if (riskyWindowReminder.present) {
      map['risky_window_reminder'] = Variable<bool>(riskyWindowReminder.value);
    }
    if (appLocale.present) {
      map['app_locale'] = Variable<String>(appLocale.value);
    }
    if (trialNudge.present) {
      map['trial_nudge'] = Variable<bool>(trialNudge.value);
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
          ..write('trialStartedAt: $trialStartedAt, ')
          ..write('preLogPauseSeconds: $preLogPauseSeconds, ')
          ..write('riskyWindowReminder: $riskyWindowReminder, ')
          ..write('appLocale: $appLocale, ')
          ..write('trialNudge: $trialNudge')
          ..write(')'))
        .toString();
  }
}

class $MoodLogTable extends MoodLog with TableInfo<$MoodLogTable, MoodLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodLogTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _reportedBandMeta = const VerificationMeta(
    'reportedBand',
  );
  @override
  late final GeneratedColumn<int> reportedBand = GeneratedColumn<int>(
    'reported_band',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMeta = const VerificationMeta(
    'estimated',
  );
  @override
  late final GeneratedColumn<double> estimated = GeneratedColumn<double>(
    'estimated',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptedMeta = const VerificationMeta(
    'prompted',
  );
  @override
  late final GeneratedColumn<bool> prompted = GeneratedColumn<bool>(
    'prompted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prompted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ts,
    reportedBand,
    estimated,
    prompted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodLogRow> instance, {
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
    if (data.containsKey('reported_band')) {
      context.handle(
        _reportedBandMeta,
        reportedBand.isAcceptableOrUnknown(
          data['reported_band']!,
          _reportedBandMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reportedBandMeta);
    }
    if (data.containsKey('estimated')) {
      context.handle(
        _estimatedMeta,
        estimated.isAcceptableOrUnknown(data['estimated']!, _estimatedMeta),
      );
    } else if (isInserting) {
      context.missing(_estimatedMeta);
    }
    if (data.containsKey('prompted')) {
      context.handle(
        _promptedMeta,
        prompted.isAcceptableOrUnknown(data['prompted']!, _promptedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ts'],
      )!,
      reportedBand: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reported_band'],
      )!,
      estimated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated'],
      )!,
      prompted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prompted'],
      )!,
    );
  }

  @override
  $MoodLogTable createAlias(String alias) {
    return $MoodLogTable(attachedDatabase, alias);
  }
}

class MoodLogRow extends DataClass implements Insertable<MoodLogRow> {
  final int id;
  final DateTime ts;

  /// The user's own report, 0 = calm, 1 = under pressure, 2 = tough.
  final int reportedBand;

  /// What the model estimated at that moment, 0..1 — kept so accuracy can be
  /// computed later without re-deriving history.
  final double estimated;

  /// True when the app asked, false when the user opened it themselves.
  final bool prompted;
  const MoodLogRow({
    required this.id,
    required this.ts,
    required this.reportedBand,
    required this.estimated,
    required this.prompted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    map['reported_band'] = Variable<int>(reportedBand);
    map['estimated'] = Variable<double>(estimated);
    map['prompted'] = Variable<bool>(prompted);
    return map;
  }

  MoodLogCompanion toCompanion(bool nullToAbsent) {
    return MoodLogCompanion(
      id: Value(id),
      ts: Value(ts),
      reportedBand: Value(reportedBand),
      estimated: Value(estimated),
      prompted: Value(prompted),
    );
  }

  factory MoodLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodLogRow(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      reportedBand: serializer.fromJson<int>(json['reportedBand']),
      estimated: serializer.fromJson<double>(json['estimated']),
      prompted: serializer.fromJson<bool>(json['prompted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'reportedBand': serializer.toJson<int>(reportedBand),
      'estimated': serializer.toJson<double>(estimated),
      'prompted': serializer.toJson<bool>(prompted),
    };
  }

  MoodLogRow copyWith({
    int? id,
    DateTime? ts,
    int? reportedBand,
    double? estimated,
    bool? prompted,
  }) => MoodLogRow(
    id: id ?? this.id,
    ts: ts ?? this.ts,
    reportedBand: reportedBand ?? this.reportedBand,
    estimated: estimated ?? this.estimated,
    prompted: prompted ?? this.prompted,
  );
  MoodLogRow copyWithCompanion(MoodLogCompanion data) {
    return MoodLogRow(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      reportedBand: data.reportedBand.present
          ? data.reportedBand.value
          : this.reportedBand,
      estimated: data.estimated.present ? data.estimated.value : this.estimated,
      prompted: data.prompted.present ? data.prompted.value : this.prompted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodLogRow(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('reportedBand: $reportedBand, ')
          ..write('estimated: $estimated, ')
          ..write('prompted: $prompted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ts, reportedBand, estimated, prompted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodLogRow &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.reportedBand == this.reportedBand &&
          other.estimated == this.estimated &&
          other.prompted == this.prompted);
}

class MoodLogCompanion extends UpdateCompanion<MoodLogRow> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<int> reportedBand;
  final Value<double> estimated;
  final Value<bool> prompted;
  const MoodLogCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.reportedBand = const Value.absent(),
    this.estimated = const Value.absent(),
    this.prompted = const Value.absent(),
  });
  MoodLogCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required int reportedBand,
    required double estimated,
    this.prompted = const Value.absent(),
  }) : ts = Value(ts),
       reportedBand = Value(reportedBand),
       estimated = Value(estimated);
  static Insertable<MoodLogRow> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<int>? reportedBand,
    Expression<double>? estimated,
    Expression<bool>? prompted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (reportedBand != null) 'reported_band': reportedBand,
      if (estimated != null) 'estimated': estimated,
      if (prompted != null) 'prompted': prompted,
    });
  }

  MoodLogCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? ts,
    Value<int>? reportedBand,
    Value<double>? estimated,
    Value<bool>? prompted,
  }) {
    return MoodLogCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      reportedBand: reportedBand ?? this.reportedBand,
      estimated: estimated ?? this.estimated,
      prompted: prompted ?? this.prompted,
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
    if (reportedBand.present) {
      map['reported_band'] = Variable<int>(reportedBand.value);
    }
    if (estimated.present) {
      map['estimated'] = Variable<double>(estimated.value);
    }
    if (prompted.present) {
      map['prompted'] = Variable<bool>(prompted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodLogCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('reportedBand: $reportedBand, ')
          ..write('estimated: $estimated, ')
          ..write('prompted: $prompted')
          ..write(')'))
        .toString();
  }
}

class $SupportLogTable extends SupportLog
    with TableInfo<$SupportLogTable, SupportLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupportLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardKeyMeta = const VerificationMeta(
    'cardKey',
  );
  @override
  late final GeneratedColumn<String> cardKey = GeneratedColumn<String>(
    'card_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [date, cardKey, done];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'support_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupportLogRow> instance, {
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
    if (data.containsKey('card_key')) {
      context.handle(
        _cardKeyMeta,
        cardKey.isAcceptableOrUnknown(data['card_key']!, _cardKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cardKeyMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, cardKey};
  @override
  SupportLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupportLogRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      cardKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_key'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $SupportLogTable createAlias(String alias) {
    return $SupportLogTable(attachedDatabase, alias);
  }
}

class SupportLogRow extends DataClass implements Insertable<SupportLogRow> {
  final String date;
  final String cardKey;
  final bool done;
  const SupportLogRow({
    required this.date,
    required this.cardKey,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['card_key'] = Variable<String>(cardKey);
    map['done'] = Variable<bool>(done);
    return map;
  }

  SupportLogCompanion toCompanion(bool nullToAbsent) {
    return SupportLogCompanion(
      date: Value(date),
      cardKey: Value(cardKey),
      done: Value(done),
    );
  }

  factory SupportLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupportLogRow(
      date: serializer.fromJson<String>(json['date']),
      cardKey: serializer.fromJson<String>(json['cardKey']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'cardKey': serializer.toJson<String>(cardKey),
      'done': serializer.toJson<bool>(done),
    };
  }

  SupportLogRow copyWith({String? date, String? cardKey, bool? done}) =>
      SupportLogRow(
        date: date ?? this.date,
        cardKey: cardKey ?? this.cardKey,
        done: done ?? this.done,
      );
  SupportLogRow copyWithCompanion(SupportLogCompanion data) {
    return SupportLogRow(
      date: data.date.present ? data.date.value : this.date,
      cardKey: data.cardKey.present ? data.cardKey.value : this.cardKey,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupportLogRow(')
          ..write('date: $date, ')
          ..write('cardKey: $cardKey, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, cardKey, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupportLogRow &&
          other.date == this.date &&
          other.cardKey == this.cardKey &&
          other.done == this.done);
}

class SupportLogCompanion extends UpdateCompanion<SupportLogRow> {
  final Value<String> date;
  final Value<String> cardKey;
  final Value<bool> done;
  final Value<int> rowid;
  const SupportLogCompanion({
    this.date = const Value.absent(),
    this.cardKey = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupportLogCompanion.insert({
    required String date,
    required String cardKey,
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       cardKey = Value(cardKey);
  static Insertable<SupportLogRow> custom({
    Expression<String>? date,
    Expression<String>? cardKey,
    Expression<bool>? done,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (cardKey != null) 'card_key': cardKey,
      if (done != null) 'done': done,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupportLogCompanion copyWith({
    Value<String>? date,
    Value<String>? cardKey,
    Value<bool>? done,
    Value<int>? rowid,
  }) {
    return SupportLogCompanion(
      date: date ?? this.date,
      cardKey: cardKey ?? this.cardKey,
      done: done ?? this.done,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (cardKey.present) {
      map['card_key'] = Variable<String>(cardKey.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupportLogCompanion(')
          ..write('date: $date, ')
          ..write('cardKey: $cardKey, ')
          ..write('done: $done, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IndexSnapshotTable extends IndexSnapshot
    with TableInfo<$IndexSnapshotTable, IndexSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndexSnapshotTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressScoreMeta = const VerificationMeta(
    'progressScore',
  );
  @override
  late final GeneratedColumn<int> progressScore = GeneratedColumn<int>(
    'progress_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _harmLoadMeta = const VerificationMeta(
    'harmLoad',
  );
  @override
  late final GeneratedColumn<int> harmLoad = GeneratedColumn<int>(
    'harm_load',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, progressScore, harmLoad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'index_snapshot';
  @override
  VerificationContext validateIntegrity(
    Insertable<IndexSnapshotRow> instance, {
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
    if (data.containsKey('progress_score')) {
      context.handle(
        _progressScoreMeta,
        progressScore.isAcceptableOrUnknown(
          data['progress_score']!,
          _progressScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressScoreMeta);
    }
    if (data.containsKey('harm_load')) {
      context.handle(
        _harmLoadMeta,
        harmLoad.isAcceptableOrUnknown(data['harm_load']!, _harmLoadMeta),
      );
    } else if (isInserting) {
      context.missing(_harmLoadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  IndexSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndexSnapshotRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      progressScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_score'],
      )!,
      harmLoad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harm_load'],
      )!,
    );
  }

  @override
  $IndexSnapshotTable createAlias(String alias) {
    return $IndexSnapshotTable(attachedDatabase, alias);
  }
}

class IndexSnapshotRow extends DataClass
    implements Insertable<IndexSnapshotRow> {
  final String date;
  final int progressScore;
  final int harmLoad;
  const IndexSnapshotRow({
    required this.date,
    required this.progressScore,
    required this.harmLoad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['progress_score'] = Variable<int>(progressScore);
    map['harm_load'] = Variable<int>(harmLoad);
    return map;
  }

  IndexSnapshotCompanion toCompanion(bool nullToAbsent) {
    return IndexSnapshotCompanion(
      date: Value(date),
      progressScore: Value(progressScore),
      harmLoad: Value(harmLoad),
    );
  }

  factory IndexSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IndexSnapshotRow(
      date: serializer.fromJson<String>(json['date']),
      progressScore: serializer.fromJson<int>(json['progressScore']),
      harmLoad: serializer.fromJson<int>(json['harmLoad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'progressScore': serializer.toJson<int>(progressScore),
      'harmLoad': serializer.toJson<int>(harmLoad),
    };
  }

  IndexSnapshotRow copyWith({
    String? date,
    int? progressScore,
    int? harmLoad,
  }) => IndexSnapshotRow(
    date: date ?? this.date,
    progressScore: progressScore ?? this.progressScore,
    harmLoad: harmLoad ?? this.harmLoad,
  );
  IndexSnapshotRow copyWithCompanion(IndexSnapshotCompanion data) {
    return IndexSnapshotRow(
      date: data.date.present ? data.date.value : this.date,
      progressScore: data.progressScore.present
          ? data.progressScore.value
          : this.progressScore,
      harmLoad: data.harmLoad.present ? data.harmLoad.value : this.harmLoad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IndexSnapshotRow(')
          ..write('date: $date, ')
          ..write('progressScore: $progressScore, ')
          ..write('harmLoad: $harmLoad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, progressScore, harmLoad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IndexSnapshotRow &&
          other.date == this.date &&
          other.progressScore == this.progressScore &&
          other.harmLoad == this.harmLoad);
}

class IndexSnapshotCompanion extends UpdateCompanion<IndexSnapshotRow> {
  final Value<String> date;
  final Value<int> progressScore;
  final Value<int> harmLoad;
  final Value<int> rowid;
  const IndexSnapshotCompanion({
    this.date = const Value.absent(),
    this.progressScore = const Value.absent(),
    this.harmLoad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IndexSnapshotCompanion.insert({
    required String date,
    required int progressScore,
    required int harmLoad,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       progressScore = Value(progressScore),
       harmLoad = Value(harmLoad);
  static Insertable<IndexSnapshotRow> custom({
    Expression<String>? date,
    Expression<int>? progressScore,
    Expression<int>? harmLoad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (progressScore != null) 'progress_score': progressScore,
      if (harmLoad != null) 'harm_load': harmLoad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IndexSnapshotCompanion copyWith({
    Value<String>? date,
    Value<int>? progressScore,
    Value<int>? harmLoad,
    Value<int>? rowid,
  }) {
    return IndexSnapshotCompanion(
      date: date ?? this.date,
      progressScore: progressScore ?? this.progressScore,
      harmLoad: harmLoad ?? this.harmLoad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (progressScore.present) {
      map['progress_score'] = Variable<int>(progressScore.value);
    }
    if (harmLoad.present) {
      map['harm_load'] = Variable<int>(harmLoad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndexSnapshotCompanion(')
          ..write('date: $date, ')
          ..write('progressScore: $progressScore, ')
          ..write('harmLoad: $harmLoad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanStateTable extends PlanState
    with TableInfo<$PlanStateTable, PlanStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanStateTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumnWithTypeConverter<PlanKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('gradualTaper'),
      ).withConverter<PlanKind>($PlanStateTable.$converterkind);
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
  static const VerificationMeta _intervalMinutesMeta = const VerificationMeta(
    'intervalMinutes',
  );
  @override
  late final GeneratedColumn<int> intervalMinutes = GeneratedColumn<int>(
    'interval_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetIntervalMinutesMeta =
      const VerificationMeta('targetIntervalMinutes');
  @override
  late final GeneratedColumn<int> targetIntervalMinutes = GeneratedColumn<int>(
    'target_interval_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _daysAtStepMeta = const VerificationMeta(
    'daysAtStep',
  );
  @override
  late final GeneratedColumn<int> daysAtStep = GeneratedColumn<int>(
    'days_at_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaperMode, String> taperMode =
      GeneratedColumn<String>(
        'taper_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('gentle'),
      ).withConverter<TaperMode>($PlanStateTable.$convertertaperMode);
  static const VerificationMeta _switchHistoryJsonMeta = const VerificationMeta(
    'switchHistoryJson',
  );
  @override
  late final GeneratedColumn<String> switchHistoryJson =
      GeneratedColumn<String>(
        'switch_history_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _lastStepDateMeta = const VerificationMeta(
    'lastStepDate',
  );
  @override
  late final GeneratedColumn<String> lastStepDate = GeneratedColumn<String>(
    'last_step_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaperDecision?, String>
  lastStepDecision = GeneratedColumn<String>(
    'last_step_decision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<TaperDecision?>($PlanStateTable.$converterlastStepDecisionn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    startedAt,
    intervalMinutes,
    targetIntervalMinutes,
    daysAtStep,
    taperMode,
    switchHistoryJson,
    lastStepDate,
    lastStepDecision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('interval_minutes')) {
      context.handle(
        _intervalMinutesMeta,
        intervalMinutes.isAcceptableOrUnknown(
          data['interval_minutes']!,
          _intervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('target_interval_minutes')) {
      context.handle(
        _targetIntervalMinutesMeta,
        targetIntervalMinutes.isAcceptableOrUnknown(
          data['target_interval_minutes']!,
          _targetIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('days_at_step')) {
      context.handle(
        _daysAtStepMeta,
        daysAtStep.isAcceptableOrUnknown(
          data['days_at_step']!,
          _daysAtStepMeta,
        ),
      );
    }
    if (data.containsKey('switch_history_json')) {
      context.handle(
        _switchHistoryJsonMeta,
        switchHistoryJson.isAcceptableOrUnknown(
          data['switch_history_json']!,
          _switchHistoryJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_step_date')) {
      context.handle(
        _lastStepDateMeta,
        lastStepDate.isAcceptableOrUnknown(
          data['last_step_date']!,
          _lastStepDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $PlanStateTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      intervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_minutes'],
      ),
      targetIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_interval_minutes'],
      ),
      daysAtStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_at_step'],
      )!,
      taperMode: $PlanStateTable.$convertertaperMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}taper_mode'],
        )!,
      ),
      switchHistoryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}switch_history_json'],
      )!,
      lastStepDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_step_date'],
      ),
      lastStepDecision: $PlanStateTable.$converterlastStepDecisionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_step_decision'],
        ),
      ),
    );
  }

  @override
  $PlanStateTable createAlias(String alias) {
    return $PlanStateTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlanKind, String, String> $converterkind =
      const EnumNameConverter<PlanKind>(PlanKind.values);
  static JsonTypeConverter2<TaperMode, String, String> $convertertaperMode =
      const EnumNameConverter<TaperMode>(TaperMode.values);
  static JsonTypeConverter2<TaperDecision, String, String>
  $converterlastStepDecision = const EnumNameConverter<TaperDecision>(
    TaperDecision.values,
  );
  static JsonTypeConverter2<TaperDecision?, String?, String?>
  $converterlastStepDecisionn = JsonTypeConverter2.asNullable(
    $converterlastStepDecision,
  );
}

class PlanStateRow extends DataClass implements Insertable<PlanStateRow> {
  final int id;
  final PlanKind kind;
  final DateTime startedAt;

  /// Current and final target interval for the taper engine, in minutes.
  final int? intervalMinutes;
  final int? targetIntervalMinutes;

  /// Days spent at the current taper step — the stabilization counter.
  final int daysAtStep;
  final TaperMode taperMode;

  /// ISO dates of recent plan switches, JSON array.
  final String switchHistoryJson;

  /// The local day the taper engine last ran, and what it decided. The
  /// engine acts at most once per calendar day, and reading a stored
  /// decision keeps the daily provider free of any write — a provider that
  /// both watches and writes this table would loop forever.
  final String? lastStepDate;
  final TaperDecision? lastStepDecision;
  const PlanStateRow({
    required this.id,
    required this.kind,
    required this.startedAt,
    this.intervalMinutes,
    this.targetIntervalMinutes,
    required this.daysAtStep,
    required this.taperMode,
    required this.switchHistoryJson,
    this.lastStepDate,
    this.lastStepDecision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $PlanStateTable.$converterkind.toSql(kind),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || intervalMinutes != null) {
      map['interval_minutes'] = Variable<int>(intervalMinutes);
    }
    if (!nullToAbsent || targetIntervalMinutes != null) {
      map['target_interval_minutes'] = Variable<int>(targetIntervalMinutes);
    }
    map['days_at_step'] = Variable<int>(daysAtStep);
    {
      map['taper_mode'] = Variable<String>(
        $PlanStateTable.$convertertaperMode.toSql(taperMode),
      );
    }
    map['switch_history_json'] = Variable<String>(switchHistoryJson);
    if (!nullToAbsent || lastStepDate != null) {
      map['last_step_date'] = Variable<String>(lastStepDate);
    }
    if (!nullToAbsent || lastStepDecision != null) {
      map['last_step_decision'] = Variable<String>(
        $PlanStateTable.$converterlastStepDecisionn.toSql(lastStepDecision),
      );
    }
    return map;
  }

  PlanStateCompanion toCompanion(bool nullToAbsent) {
    return PlanStateCompanion(
      id: Value(id),
      kind: Value(kind),
      startedAt: Value(startedAt),
      intervalMinutes: intervalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMinutes),
      targetIntervalMinutes: targetIntervalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(targetIntervalMinutes),
      daysAtStep: Value(daysAtStep),
      taperMode: Value(taperMode),
      switchHistoryJson: Value(switchHistoryJson),
      lastStepDate: lastStepDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStepDate),
      lastStepDecision: lastStepDecision == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStepDecision),
    );
  }

  factory PlanStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanStateRow(
      id: serializer.fromJson<int>(json['id']),
      kind: $PlanStateTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      intervalMinutes: serializer.fromJson<int?>(json['intervalMinutes']),
      targetIntervalMinutes: serializer.fromJson<int?>(
        json['targetIntervalMinutes'],
      ),
      daysAtStep: serializer.fromJson<int>(json['daysAtStep']),
      taperMode: $PlanStateTable.$convertertaperMode.fromJson(
        serializer.fromJson<String>(json['taperMode']),
      ),
      switchHistoryJson: serializer.fromJson<String>(json['switchHistoryJson']),
      lastStepDate: serializer.fromJson<String?>(json['lastStepDate']),
      lastStepDecision: $PlanStateTable.$converterlastStepDecisionn.fromJson(
        serializer.fromJson<String?>(json['lastStepDecision']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $PlanStateTable.$converterkind.toJson(kind),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'intervalMinutes': serializer.toJson<int?>(intervalMinutes),
      'targetIntervalMinutes': serializer.toJson<int?>(targetIntervalMinutes),
      'daysAtStep': serializer.toJson<int>(daysAtStep),
      'taperMode': serializer.toJson<String>(
        $PlanStateTable.$convertertaperMode.toJson(taperMode),
      ),
      'switchHistoryJson': serializer.toJson<String>(switchHistoryJson),
      'lastStepDate': serializer.toJson<String?>(lastStepDate),
      'lastStepDecision': serializer.toJson<String?>(
        $PlanStateTable.$converterlastStepDecisionn.toJson(lastStepDecision),
      ),
    };
  }

  PlanStateRow copyWith({
    int? id,
    PlanKind? kind,
    DateTime? startedAt,
    Value<int?> intervalMinutes = const Value.absent(),
    Value<int?> targetIntervalMinutes = const Value.absent(),
    int? daysAtStep,
    TaperMode? taperMode,
    String? switchHistoryJson,
    Value<String?> lastStepDate = const Value.absent(),
    Value<TaperDecision?> lastStepDecision = const Value.absent(),
  }) => PlanStateRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    startedAt: startedAt ?? this.startedAt,
    intervalMinutes: intervalMinutes.present
        ? intervalMinutes.value
        : this.intervalMinutes,
    targetIntervalMinutes: targetIntervalMinutes.present
        ? targetIntervalMinutes.value
        : this.targetIntervalMinutes,
    daysAtStep: daysAtStep ?? this.daysAtStep,
    taperMode: taperMode ?? this.taperMode,
    switchHistoryJson: switchHistoryJson ?? this.switchHistoryJson,
    lastStepDate: lastStepDate.present ? lastStepDate.value : this.lastStepDate,
    lastStepDecision: lastStepDecision.present
        ? lastStepDecision.value
        : this.lastStepDecision,
  );
  PlanStateRow copyWithCompanion(PlanStateCompanion data) {
    return PlanStateRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      intervalMinutes: data.intervalMinutes.present
          ? data.intervalMinutes.value
          : this.intervalMinutes,
      targetIntervalMinutes: data.targetIntervalMinutes.present
          ? data.targetIntervalMinutes.value
          : this.targetIntervalMinutes,
      daysAtStep: data.daysAtStep.present
          ? data.daysAtStep.value
          : this.daysAtStep,
      taperMode: data.taperMode.present ? data.taperMode.value : this.taperMode,
      switchHistoryJson: data.switchHistoryJson.present
          ? data.switchHistoryJson.value
          : this.switchHistoryJson,
      lastStepDate: data.lastStepDate.present
          ? data.lastStepDate.value
          : this.lastStepDate,
      lastStepDecision: data.lastStepDecision.present
          ? data.lastStepDecision.value
          : this.lastStepDecision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanStateRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('startedAt: $startedAt, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('targetIntervalMinutes: $targetIntervalMinutes, ')
          ..write('daysAtStep: $daysAtStep, ')
          ..write('taperMode: $taperMode, ')
          ..write('switchHistoryJson: $switchHistoryJson, ')
          ..write('lastStepDate: $lastStepDate, ')
          ..write('lastStepDecision: $lastStepDecision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    startedAt,
    intervalMinutes,
    targetIntervalMinutes,
    daysAtStep,
    taperMode,
    switchHistoryJson,
    lastStepDate,
    lastStepDecision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanStateRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.startedAt == this.startedAt &&
          other.intervalMinutes == this.intervalMinutes &&
          other.targetIntervalMinutes == this.targetIntervalMinutes &&
          other.daysAtStep == this.daysAtStep &&
          other.taperMode == this.taperMode &&
          other.switchHistoryJson == this.switchHistoryJson &&
          other.lastStepDate == this.lastStepDate &&
          other.lastStepDecision == this.lastStepDecision);
}

class PlanStateCompanion extends UpdateCompanion<PlanStateRow> {
  final Value<int> id;
  final Value<PlanKind> kind;
  final Value<DateTime> startedAt;
  final Value<int?> intervalMinutes;
  final Value<int?> targetIntervalMinutes;
  final Value<int> daysAtStep;
  final Value<TaperMode> taperMode;
  final Value<String> switchHistoryJson;
  final Value<String?> lastStepDate;
  final Value<TaperDecision?> lastStepDecision;
  const PlanStateCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.targetIntervalMinutes = const Value.absent(),
    this.daysAtStep = const Value.absent(),
    this.taperMode = const Value.absent(),
    this.switchHistoryJson = const Value.absent(),
    this.lastStepDate = const Value.absent(),
    this.lastStepDecision = const Value.absent(),
  });
  PlanStateCompanion.insert({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    required DateTime startedAt,
    this.intervalMinutes = const Value.absent(),
    this.targetIntervalMinutes = const Value.absent(),
    this.daysAtStep = const Value.absent(),
    this.taperMode = const Value.absent(),
    this.switchHistoryJson = const Value.absent(),
    this.lastStepDate = const Value.absent(),
    this.lastStepDecision = const Value.absent(),
  }) : startedAt = Value(startedAt);
  static Insertable<PlanStateRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<DateTime>? startedAt,
    Expression<int>? intervalMinutes,
    Expression<int>? targetIntervalMinutes,
    Expression<int>? daysAtStep,
    Expression<String>? taperMode,
    Expression<String>? switchHistoryJson,
    Expression<String>? lastStepDate,
    Expression<String>? lastStepDecision,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (startedAt != null) 'started_at': startedAt,
      if (intervalMinutes != null) 'interval_minutes': intervalMinutes,
      if (targetIntervalMinutes != null)
        'target_interval_minutes': targetIntervalMinutes,
      if (daysAtStep != null) 'days_at_step': daysAtStep,
      if (taperMode != null) 'taper_mode': taperMode,
      if (switchHistoryJson != null) 'switch_history_json': switchHistoryJson,
      if (lastStepDate != null) 'last_step_date': lastStepDate,
      if (lastStepDecision != null) 'last_step_decision': lastStepDecision,
    });
  }

  PlanStateCompanion copyWith({
    Value<int>? id,
    Value<PlanKind>? kind,
    Value<DateTime>? startedAt,
    Value<int?>? intervalMinutes,
    Value<int?>? targetIntervalMinutes,
    Value<int>? daysAtStep,
    Value<TaperMode>? taperMode,
    Value<String>? switchHistoryJson,
    Value<String?>? lastStepDate,
    Value<TaperDecision?>? lastStepDecision,
  }) {
    return PlanStateCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      startedAt: startedAt ?? this.startedAt,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      targetIntervalMinutes:
          targetIntervalMinutes ?? this.targetIntervalMinutes,
      daysAtStep: daysAtStep ?? this.daysAtStep,
      taperMode: taperMode ?? this.taperMode,
      switchHistoryJson: switchHistoryJson ?? this.switchHistoryJson,
      lastStepDate: lastStepDate ?? this.lastStepDate,
      lastStepDecision: lastStepDecision ?? this.lastStepDecision,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PlanStateTable.$converterkind.toSql(kind.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (intervalMinutes.present) {
      map['interval_minutes'] = Variable<int>(intervalMinutes.value);
    }
    if (targetIntervalMinutes.present) {
      map['target_interval_minutes'] = Variable<int>(
        targetIntervalMinutes.value,
      );
    }
    if (daysAtStep.present) {
      map['days_at_step'] = Variable<int>(daysAtStep.value);
    }
    if (taperMode.present) {
      map['taper_mode'] = Variable<String>(
        $PlanStateTable.$convertertaperMode.toSql(taperMode.value),
      );
    }
    if (switchHistoryJson.present) {
      map['switch_history_json'] = Variable<String>(switchHistoryJson.value);
    }
    if (lastStepDate.present) {
      map['last_step_date'] = Variable<String>(lastStepDate.value);
    }
    if (lastStepDecision.present) {
      map['last_step_decision'] = Variable<String>(
        $PlanStateTable.$converterlastStepDecisionn.toSql(
          lastStepDecision.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanStateCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('startedAt: $startedAt, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('targetIntervalMinutes: $targetIntervalMinutes, ')
          ..write('daysAtStep: $daysAtStep, ')
          ..write('taperMode: $taperMode, ')
          ..write('switchHistoryJson: $switchHistoryJson, ')
          ..write('lastStepDate: $lastStepDate, ')
          ..write('lastStepDecision: $lastStepDecision')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalTableTable extends SavingsGoalTable
    with TableInfo<$SavingsGoalTableTable, SavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goal_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $SavingsGoalTableTable createAlias(String alias) {
    return $SavingsGoalTableTable(attachedDatabase, alias);
  }
}

class SavingsGoalRow extends DataClass implements Insertable<SavingsGoalRow> {
  final int id;
  final String label;
  final double amount;
  const SavingsGoalRow({
    required this.id,
    required this.label,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  SavingsGoalTableCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalTableCompanion(
      id: Value(id),
      label: Value(label),
      amount: Value(amount),
    );
  }

  factory SavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalRow(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'amount': serializer.toJson<double>(amount),
    };
  }

  SavingsGoalRow copyWith({int? id, String? label, double? amount}) =>
      SavingsGoalRow(
        id: id ?? this.id,
        label: label ?? this.label,
        amount: amount ?? this.amount,
      );
  SavingsGoalRow copyWithCompanion(SavingsGoalTableCompanion data) {
    return SavingsGoalRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.amount == this.amount);
}

class SavingsGoalTableCompanion extends UpdateCompanion<SavingsGoalRow> {
  final Value<int> id;
  final Value<String> label;
  final Value<double> amount;
  const SavingsGoalTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.amount = const Value.absent(),
  });
  SavingsGoalTableCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required double amount,
  }) : label = Value(label),
       amount = Value(amount);
  static Insertable<SavingsGoalRow> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (amount != null) 'amount': amount,
    });
  }

  SavingsGoalTableCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<double>? amount,
  }) {
    return SavingsGoalTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $CessationPlanTableTable extends CessationPlanTable
    with TableInfo<$CessationPlanTableTable, CessationPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CessationPlanTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _quitDateMovesMeta = const VerificationMeta(
    'quitDateMoves',
  );
  @override
  late final GeneratedColumn<int> quitDateMoves = GeneratedColumn<int>(
    'quit_date_moves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuitReason?, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<QuitReason?>($CessationPlanTableTable.$converterreasonn);
  static const VerificationMeta _supportPersonMeta = const VerificationMeta(
    'supportPerson',
  );
  @override
  late final GeneratedColumn<String> supportPerson = GeneratedColumn<String>(
    'support_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notAPuffAcceptedMeta = const VerificationMeta(
    'notAPuffAccepted',
  );
  @override
  late final GeneratedColumn<bool> notAPuffAccepted = GeneratedColumn<bool>(
    'not_a_puff_accepted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("not_a_puff_accepted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quitDate,
    quitDateMoves,
    reason,
    supportPerson,
    notAPuffAccepted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cessation_plan_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CessationPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quit_date')) {
      context.handle(
        _quitDateMeta,
        quitDate.isAcceptableOrUnknown(data['quit_date']!, _quitDateMeta),
      );
    }
    if (data.containsKey('quit_date_moves')) {
      context.handle(
        _quitDateMovesMeta,
        quitDateMoves.isAcceptableOrUnknown(
          data['quit_date_moves']!,
          _quitDateMovesMeta,
        ),
      );
    }
    if (data.containsKey('support_person')) {
      context.handle(
        _supportPersonMeta,
        supportPerson.isAcceptableOrUnknown(
          data['support_person']!,
          _supportPersonMeta,
        ),
      );
    }
    if (data.containsKey('not_a_puff_accepted')) {
      context.handle(
        _notAPuffAcceptedMeta,
        notAPuffAccepted.isAcceptableOrUnknown(
          data['not_a_puff_accepted']!,
          _notAPuffAcceptedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CessationPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CessationPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quit_date'],
      ),
      quitDateMoves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quit_date_moves'],
      )!,
      reason: $CessationPlanTableTable.$converterreasonn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        ),
      ),
      supportPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}support_person'],
      ),
      notAPuffAccepted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}not_a_puff_accepted'],
      )!,
    );
  }

  @override
  $CessationPlanTableTable createAlias(String alias) {
    return $CessationPlanTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuitReason, String, String> $converterreason =
      const EnumNameConverter<QuitReason>(QuitReason.values);
  static JsonTypeConverter2<QuitReason?, String?, String?> $converterreasonn =
      JsonTypeConverter2.asNullable($converterreason);
}

class CessationPlanRow extends DataClass
    implements Insertable<CessationPlanRow> {
  final int id;

  /// Local calendar day, ISO "yyyy-MM-dd" — a quit date is a day, not an
  /// instant, and storing it as one keeps it stable across time zones.
  final String? quitDate;

  /// Times the date has been moved. Counted, never scolded.
  final int quitDateMoves;
  final QuitReason? reason;

  /// First name or nickname only. The app stores no contact details and
  /// never reads the address book.
  final String? supportPerson;
  final bool notAPuffAccepted;
  const CessationPlanRow({
    required this.id,
    this.quitDate,
    required this.quitDateMoves,
    this.reason,
    this.supportPerson,
    required this.notAPuffAccepted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || quitDate != null) {
      map['quit_date'] = Variable<String>(quitDate);
    }
    map['quit_date_moves'] = Variable<int>(quitDateMoves);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(
        $CessationPlanTableTable.$converterreasonn.toSql(reason),
      );
    }
    if (!nullToAbsent || supportPerson != null) {
      map['support_person'] = Variable<String>(supportPerson);
    }
    map['not_a_puff_accepted'] = Variable<bool>(notAPuffAccepted);
    return map;
  }

  CessationPlanTableCompanion toCompanion(bool nullToAbsent) {
    return CessationPlanTableCompanion(
      id: Value(id),
      quitDate: quitDate == null && nullToAbsent
          ? const Value.absent()
          : Value(quitDate),
      quitDateMoves: Value(quitDateMoves),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      supportPerson: supportPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(supportPerson),
      notAPuffAccepted: Value(notAPuffAccepted),
    );
  }

  factory CessationPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CessationPlanRow(
      id: serializer.fromJson<int>(json['id']),
      quitDate: serializer.fromJson<String?>(json['quitDate']),
      quitDateMoves: serializer.fromJson<int>(json['quitDateMoves']),
      reason: $CessationPlanTableTable.$converterreasonn.fromJson(
        serializer.fromJson<String?>(json['reason']),
      ),
      supportPerson: serializer.fromJson<String?>(json['supportPerson']),
      notAPuffAccepted: serializer.fromJson<bool>(json['notAPuffAccepted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quitDate': serializer.toJson<String?>(quitDate),
      'quitDateMoves': serializer.toJson<int>(quitDateMoves),
      'reason': serializer.toJson<String?>(
        $CessationPlanTableTable.$converterreasonn.toJson(reason),
      ),
      'supportPerson': serializer.toJson<String?>(supportPerson),
      'notAPuffAccepted': serializer.toJson<bool>(notAPuffAccepted),
    };
  }

  CessationPlanRow copyWith({
    int? id,
    Value<String?> quitDate = const Value.absent(),
    int? quitDateMoves,
    Value<QuitReason?> reason = const Value.absent(),
    Value<String?> supportPerson = const Value.absent(),
    bool? notAPuffAccepted,
  }) => CessationPlanRow(
    id: id ?? this.id,
    quitDate: quitDate.present ? quitDate.value : this.quitDate,
    quitDateMoves: quitDateMoves ?? this.quitDateMoves,
    reason: reason.present ? reason.value : this.reason,
    supportPerson: supportPerson.present
        ? supportPerson.value
        : this.supportPerson,
    notAPuffAccepted: notAPuffAccepted ?? this.notAPuffAccepted,
  );
  CessationPlanRow copyWithCompanion(CessationPlanTableCompanion data) {
    return CessationPlanRow(
      id: data.id.present ? data.id.value : this.id,
      quitDate: data.quitDate.present ? data.quitDate.value : this.quitDate,
      quitDateMoves: data.quitDateMoves.present
          ? data.quitDateMoves.value
          : this.quitDateMoves,
      reason: data.reason.present ? data.reason.value : this.reason,
      supportPerson: data.supportPerson.present
          ? data.supportPerson.value
          : this.supportPerson,
      notAPuffAccepted: data.notAPuffAccepted.present
          ? data.notAPuffAccepted.value
          : this.notAPuffAccepted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CessationPlanRow(')
          ..write('id: $id, ')
          ..write('quitDate: $quitDate, ')
          ..write('quitDateMoves: $quitDateMoves, ')
          ..write('reason: $reason, ')
          ..write('supportPerson: $supportPerson, ')
          ..write('notAPuffAccepted: $notAPuffAccepted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quitDate,
    quitDateMoves,
    reason,
    supportPerson,
    notAPuffAccepted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CessationPlanRow &&
          other.id == this.id &&
          other.quitDate == this.quitDate &&
          other.quitDateMoves == this.quitDateMoves &&
          other.reason == this.reason &&
          other.supportPerson == this.supportPerson &&
          other.notAPuffAccepted == this.notAPuffAccepted);
}

class CessationPlanTableCompanion extends UpdateCompanion<CessationPlanRow> {
  final Value<int> id;
  final Value<String?> quitDate;
  final Value<int> quitDateMoves;
  final Value<QuitReason?> reason;
  final Value<String?> supportPerson;
  final Value<bool> notAPuffAccepted;
  const CessationPlanTableCompanion({
    this.id = const Value.absent(),
    this.quitDate = const Value.absent(),
    this.quitDateMoves = const Value.absent(),
    this.reason = const Value.absent(),
    this.supportPerson = const Value.absent(),
    this.notAPuffAccepted = const Value.absent(),
  });
  CessationPlanTableCompanion.insert({
    this.id = const Value.absent(),
    this.quitDate = const Value.absent(),
    this.quitDateMoves = const Value.absent(),
    this.reason = const Value.absent(),
    this.supportPerson = const Value.absent(),
    this.notAPuffAccepted = const Value.absent(),
  });
  static Insertable<CessationPlanRow> custom({
    Expression<int>? id,
    Expression<String>? quitDate,
    Expression<int>? quitDateMoves,
    Expression<String>? reason,
    Expression<String>? supportPerson,
    Expression<bool>? notAPuffAccepted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quitDate != null) 'quit_date': quitDate,
      if (quitDateMoves != null) 'quit_date_moves': quitDateMoves,
      if (reason != null) 'reason': reason,
      if (supportPerson != null) 'support_person': supportPerson,
      if (notAPuffAccepted != null) 'not_a_puff_accepted': notAPuffAccepted,
    });
  }

  CessationPlanTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? quitDate,
    Value<int>? quitDateMoves,
    Value<QuitReason?>? reason,
    Value<String?>? supportPerson,
    Value<bool>? notAPuffAccepted,
  }) {
    return CessationPlanTableCompanion(
      id: id ?? this.id,
      quitDate: quitDate ?? this.quitDate,
      quitDateMoves: quitDateMoves ?? this.quitDateMoves,
      reason: reason ?? this.reason,
      supportPerson: supportPerson ?? this.supportPerson,
      notAPuffAccepted: notAPuffAccepted ?? this.notAPuffAccepted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (quitDate.present) {
      map['quit_date'] = Variable<String>(quitDate.value);
    }
    if (quitDateMoves.present) {
      map['quit_date_moves'] = Variable<int>(quitDateMoves.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $CessationPlanTableTable.$converterreasonn.toSql(reason.value),
      );
    }
    if (supportPerson.present) {
      map['support_person'] = Variable<String>(supportPerson.value);
    }
    if (notAPuffAccepted.present) {
      map['not_a_puff_accepted'] = Variable<bool>(notAPuffAccepted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CessationPlanTableCompanion(')
          ..write('id: $id, ')
          ..write('quitDate: $quitDate, ')
          ..write('quitDateMoves: $quitDateMoves, ')
          ..write('reason: $reason, ')
          ..write('supportPerson: $supportPerson, ')
          ..write('notAPuffAccepted: $notAPuffAccepted')
          ..write(')'))
        .toString();
  }
}

class $CopingPlanTableTable extends CopingPlanTable
    with TableInfo<$CopingPlanTableTable, CopingPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopingPlanTableTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<TriggerLabel, String> trigger =
      GeneratedColumn<String>(
        'trigger',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TriggerLabel>($CopingPlanTableTable.$convertertrigger);
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rehearsedMeta = const VerificationMeta(
    'rehearsed',
  );
  @override
  late final GeneratedColumn<bool> rehearsed = GeneratedColumn<bool>(
    'rehearsed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rehearsed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [trigger, plan, rehearsed, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coping_plan_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CopingPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    } else if (isInserting) {
      context.missing(_planMeta);
    }
    if (data.containsKey('rehearsed')) {
      context.handle(
        _rehearsedMeta,
        rehearsed.isAcceptableOrUnknown(data['rehearsed']!, _rehearsedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trigger};
  @override
  CopingPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CopingPlanRow(
      trigger: $CopingPlanTableTable.$convertertrigger.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trigger'],
        )!,
      ),
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      )!,
      rehearsed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rehearsed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CopingPlanTableTable createAlias(String alias) {
    return $CopingPlanTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TriggerLabel, String, String> $convertertrigger =
      const EnumNameConverter<TriggerLabel>(TriggerLabel.values);
}

class CopingPlanRow extends DataClass implements Insertable<CopingPlanRow> {
  final TriggerLabel trigger;
  final String plan;
  final bool rehearsed;
  final DateTime updatedAt;
  const CopingPlanRow({
    required this.trigger,
    required this.plan,
    required this.rehearsed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['trigger'] = Variable<String>(
        $CopingPlanTableTable.$convertertrigger.toSql(trigger),
      );
    }
    map['plan'] = Variable<String>(plan);
    map['rehearsed'] = Variable<bool>(rehearsed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CopingPlanTableCompanion toCompanion(bool nullToAbsent) {
    return CopingPlanTableCompanion(
      trigger: Value(trigger),
      plan: Value(plan),
      rehearsed: Value(rehearsed),
      updatedAt: Value(updatedAt),
    );
  }

  factory CopingPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CopingPlanRow(
      trigger: $CopingPlanTableTable.$convertertrigger.fromJson(
        serializer.fromJson<String>(json['trigger']),
      ),
      plan: serializer.fromJson<String>(json['plan']),
      rehearsed: serializer.fromJson<bool>(json['rehearsed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trigger': serializer.toJson<String>(
        $CopingPlanTableTable.$convertertrigger.toJson(trigger),
      ),
      'plan': serializer.toJson<String>(plan),
      'rehearsed': serializer.toJson<bool>(rehearsed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CopingPlanRow copyWith({
    TriggerLabel? trigger,
    String? plan,
    bool? rehearsed,
    DateTime? updatedAt,
  }) => CopingPlanRow(
    trigger: trigger ?? this.trigger,
    plan: plan ?? this.plan,
    rehearsed: rehearsed ?? this.rehearsed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CopingPlanRow copyWithCompanion(CopingPlanTableCompanion data) {
    return CopingPlanRow(
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      plan: data.plan.present ? data.plan.value : this.plan,
      rehearsed: data.rehearsed.present ? data.rehearsed.value : this.rehearsed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CopingPlanRow(')
          ..write('trigger: $trigger, ')
          ..write('plan: $plan, ')
          ..write('rehearsed: $rehearsed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(trigger, plan, rehearsed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CopingPlanRow &&
          other.trigger == this.trigger &&
          other.plan == this.plan &&
          other.rehearsed == this.rehearsed &&
          other.updatedAt == this.updatedAt);
}

class CopingPlanTableCompanion extends UpdateCompanion<CopingPlanRow> {
  final Value<TriggerLabel> trigger;
  final Value<String> plan;
  final Value<bool> rehearsed;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CopingPlanTableCompanion({
    this.trigger = const Value.absent(),
    this.plan = const Value.absent(),
    this.rehearsed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CopingPlanTableCompanion.insert({
    required TriggerLabel trigger,
    required String plan,
    this.rehearsed = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : trigger = Value(trigger),
       plan = Value(plan),
       updatedAt = Value(updatedAt);
  static Insertable<CopingPlanRow> custom({
    Expression<String>? trigger,
    Expression<String>? plan,
    Expression<bool>? rehearsed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trigger != null) 'trigger': trigger,
      if (plan != null) 'plan': plan,
      if (rehearsed != null) 'rehearsed': rehearsed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CopingPlanTableCompanion copyWith({
    Value<TriggerLabel>? trigger,
    Value<String>? plan,
    Value<bool>? rehearsed,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CopingPlanTableCompanion(
      trigger: trigger ?? this.trigger,
      plan: plan ?? this.plan,
      rehearsed: rehearsed ?? this.rehearsed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trigger.present) {
      map['trigger'] = Variable<String>(
        $CopingPlanTableTable.$convertertrigger.toSql(trigger.value),
      );
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (rehearsed.present) {
      map['rehearsed'] = Variable<bool>(rehearsed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopingPlanTableCompanion(')
          ..write('trigger: $trigger, ')
          ..write('plan: $plan, ')
          ..write('rehearsed: $rehearsed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodScreenTable extends MoodScreen
    with TableInfo<$MoodScreenTable, MoodScreenRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodScreenTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lowInterestMeta = const VerificationMeta(
    'lowInterest',
  );
  @override
  late final GeneratedColumn<int> lowInterest = GeneratedColumn<int>(
    'low_interest',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowMoodMeta = const VerificationMeta(
    'lowMood',
  );
  @override
  late final GeneratedColumn<int> lowMood = GeneratedColumn<int>(
    'low_mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ts, lowInterest, lowMood, total];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_screen';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodScreenRow> instance, {
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
    if (data.containsKey('low_interest')) {
      context.handle(
        _lowInterestMeta,
        lowInterest.isAcceptableOrUnknown(
          data['low_interest']!,
          _lowInterestMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lowInterestMeta);
    }
    if (data.containsKey('low_mood')) {
      context.handle(
        _lowMoodMeta,
        lowMood.isAcceptableOrUnknown(data['low_mood']!, _lowMoodMeta),
      );
    } else if (isInserting) {
      context.missing(_lowMoodMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodScreenRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodScreenRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ts'],
      )!,
      lowInterest: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_interest'],
      )!,
      lowMood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_mood'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
    );
  }

  @override
  $MoodScreenTable createAlias(String alias) {
    return $MoodScreenTable(attachedDatabase, alias);
  }
}

class MoodScreenRow extends DataClass implements Insertable<MoodScreenRow> {
  final int id;
  final DateTime ts;
  final int lowInterest;
  final int lowMood;
  final int total;
  const MoodScreenRow({
    required this.id,
    required this.ts,
    required this.lowInterest,
    required this.lowMood,
    required this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    map['low_interest'] = Variable<int>(lowInterest);
    map['low_mood'] = Variable<int>(lowMood);
    map['total'] = Variable<int>(total);
    return map;
  }

  MoodScreenCompanion toCompanion(bool nullToAbsent) {
    return MoodScreenCompanion(
      id: Value(id),
      ts: Value(ts),
      lowInterest: Value(lowInterest),
      lowMood: Value(lowMood),
      total: Value(total),
    );
  }

  factory MoodScreenRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodScreenRow(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      lowInterest: serializer.fromJson<int>(json['lowInterest']),
      lowMood: serializer.fromJson<int>(json['lowMood']),
      total: serializer.fromJson<int>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'lowInterest': serializer.toJson<int>(lowInterest),
      'lowMood': serializer.toJson<int>(lowMood),
      'total': serializer.toJson<int>(total),
    };
  }

  MoodScreenRow copyWith({
    int? id,
    DateTime? ts,
    int? lowInterest,
    int? lowMood,
    int? total,
  }) => MoodScreenRow(
    id: id ?? this.id,
    ts: ts ?? this.ts,
    lowInterest: lowInterest ?? this.lowInterest,
    lowMood: lowMood ?? this.lowMood,
    total: total ?? this.total,
  );
  MoodScreenRow copyWithCompanion(MoodScreenCompanion data) {
    return MoodScreenRow(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      lowInterest: data.lowInterest.present
          ? data.lowInterest.value
          : this.lowInterest,
      lowMood: data.lowMood.present ? data.lowMood.value : this.lowMood,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodScreenRow(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('lowInterest: $lowInterest, ')
          ..write('lowMood: $lowMood, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ts, lowInterest, lowMood, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodScreenRow &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.lowInterest == this.lowInterest &&
          other.lowMood == this.lowMood &&
          other.total == this.total);
}

class MoodScreenCompanion extends UpdateCompanion<MoodScreenRow> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<int> lowInterest;
  final Value<int> lowMood;
  final Value<int> total;
  const MoodScreenCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.lowInterest = const Value.absent(),
    this.lowMood = const Value.absent(),
    this.total = const Value.absent(),
  });
  MoodScreenCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    required int lowInterest,
    required int lowMood,
    required int total,
  }) : ts = Value(ts),
       lowInterest = Value(lowInterest),
       lowMood = Value(lowMood),
       total = Value(total);
  static Insertable<MoodScreenRow> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<int>? lowInterest,
    Expression<int>? lowMood,
    Expression<int>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (lowInterest != null) 'low_interest': lowInterest,
      if (lowMood != null) 'low_mood': lowMood,
      if (total != null) 'total': total,
    });
  }

  MoodScreenCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? ts,
    Value<int>? lowInterest,
    Value<int>? lowMood,
    Value<int>? total,
  }) {
    return MoodScreenCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      lowInterest: lowInterest ?? this.lowInterest,
      lowMood: lowMood ?? this.lowMood,
      total: total ?? this.total,
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
    if (lowInterest.present) {
      map['low_interest'] = Variable<int>(lowInterest.value);
    }
    if (lowMood.present) {
      map['low_mood'] = Variable<int>(lowMood.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodScreenCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('lowInterest: $lowInterest, ')
          ..write('lowMood: $lowMood, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class $PackPurchaseTableTable extends PackPurchaseTable
    with TableInfo<$PackPurchaseTableTable, PackPurchaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackPurchaseTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _packsMeta = const VerificationMeta('packs');
  @override
  late final GeneratedColumn<int> packs = GeneratedColumn<int>(
    'packs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
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
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ts,
    packs,
    pricePerPack,
    packSize,
    brand,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pack_purchase_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackPurchaseRow> instance, {
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
    if (data.containsKey('packs')) {
      context.handle(
        _packsMeta,
        packs.isAcceptableOrUnknown(data['packs']!, _packsMeta),
      );
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
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackPurchaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackPurchaseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ts'],
      )!,
      packs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}packs'],
      )!,
      pricePerPack: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_pack'],
      )!,
      packSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_size'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
    );
  }

  @override
  $PackPurchaseTableTable createAlias(String alias) {
    return $PackPurchaseTableTable(attachedDatabase, alias);
  }
}

class PackPurchaseRow extends DataClass implements Insertable<PackPurchaseRow> {
  final int id;
  final DateTime ts;
  final int packs;
  final double pricePerPack;
  final int packSize;
  final String? brand;
  const PackPurchaseRow({
    required this.id,
    required this.ts,
    required this.packs,
    required this.pricePerPack,
    required this.packSize,
    this.brand,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ts'] = Variable<DateTime>(ts);
    map['packs'] = Variable<int>(packs);
    map['price_per_pack'] = Variable<double>(pricePerPack);
    map['pack_size'] = Variable<int>(packSize);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    return map;
  }

  PackPurchaseTableCompanion toCompanion(bool nullToAbsent) {
    return PackPurchaseTableCompanion(
      id: Value(id),
      ts: Value(ts),
      packs: Value(packs),
      pricePerPack: Value(pricePerPack),
      packSize: Value(packSize),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
    );
  }

  factory PackPurchaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackPurchaseRow(
      id: serializer.fromJson<int>(json['id']),
      ts: serializer.fromJson<DateTime>(json['ts']),
      packs: serializer.fromJson<int>(json['packs']),
      pricePerPack: serializer.fromJson<double>(json['pricePerPack']),
      packSize: serializer.fromJson<int>(json['packSize']),
      brand: serializer.fromJson<String?>(json['brand']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ts': serializer.toJson<DateTime>(ts),
      'packs': serializer.toJson<int>(packs),
      'pricePerPack': serializer.toJson<double>(pricePerPack),
      'packSize': serializer.toJson<int>(packSize),
      'brand': serializer.toJson<String?>(brand),
    };
  }

  PackPurchaseRow copyWith({
    int? id,
    DateTime? ts,
    int? packs,
    double? pricePerPack,
    int? packSize,
    Value<String?> brand = const Value.absent(),
  }) => PackPurchaseRow(
    id: id ?? this.id,
    ts: ts ?? this.ts,
    packs: packs ?? this.packs,
    pricePerPack: pricePerPack ?? this.pricePerPack,
    packSize: packSize ?? this.packSize,
    brand: brand.present ? brand.value : this.brand,
  );
  PackPurchaseRow copyWithCompanion(PackPurchaseTableCompanion data) {
    return PackPurchaseRow(
      id: data.id.present ? data.id.value : this.id,
      ts: data.ts.present ? data.ts.value : this.ts,
      packs: data.packs.present ? data.packs.value : this.packs,
      pricePerPack: data.pricePerPack.present
          ? data.pricePerPack.value
          : this.pricePerPack,
      packSize: data.packSize.present ? data.packSize.value : this.packSize,
      brand: data.brand.present ? data.brand.value : this.brand,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackPurchaseRow(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('packs: $packs, ')
          ..write('pricePerPack: $pricePerPack, ')
          ..write('packSize: $packSize, ')
          ..write('brand: $brand')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ts, packs, pricePerPack, packSize, brand);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackPurchaseRow &&
          other.id == this.id &&
          other.ts == this.ts &&
          other.packs == this.packs &&
          other.pricePerPack == this.pricePerPack &&
          other.packSize == this.packSize &&
          other.brand == this.brand);
}

class PackPurchaseTableCompanion extends UpdateCompanion<PackPurchaseRow> {
  final Value<int> id;
  final Value<DateTime> ts;
  final Value<int> packs;
  final Value<double> pricePerPack;
  final Value<int> packSize;
  final Value<String?> brand;
  const PackPurchaseTableCompanion({
    this.id = const Value.absent(),
    this.ts = const Value.absent(),
    this.packs = const Value.absent(),
    this.pricePerPack = const Value.absent(),
    this.packSize = const Value.absent(),
    this.brand = const Value.absent(),
  });
  PackPurchaseTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime ts,
    this.packs = const Value.absent(),
    required double pricePerPack,
    this.packSize = const Value.absent(),
    this.brand = const Value.absent(),
  }) : ts = Value(ts),
       pricePerPack = Value(pricePerPack);
  static Insertable<PackPurchaseRow> custom({
    Expression<int>? id,
    Expression<DateTime>? ts,
    Expression<int>? packs,
    Expression<double>? pricePerPack,
    Expression<int>? packSize,
    Expression<String>? brand,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ts != null) 'ts': ts,
      if (packs != null) 'packs': packs,
      if (pricePerPack != null) 'price_per_pack': pricePerPack,
      if (packSize != null) 'pack_size': packSize,
      if (brand != null) 'brand': brand,
    });
  }

  PackPurchaseTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? ts,
    Value<int>? packs,
    Value<double>? pricePerPack,
    Value<int>? packSize,
    Value<String?>? brand,
  }) {
    return PackPurchaseTableCompanion(
      id: id ?? this.id,
      ts: ts ?? this.ts,
      packs: packs ?? this.packs,
      pricePerPack: pricePerPack ?? this.pricePerPack,
      packSize: packSize ?? this.packSize,
      brand: brand ?? this.brand,
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
    if (packs.present) {
      map['packs'] = Variable<int>(packs.value);
    }
    if (pricePerPack.present) {
      map['price_per_pack'] = Variable<double>(pricePerPack.value);
    }
    if (packSize.present) {
      map['pack_size'] = Variable<int>(packSize.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackPurchaseTableCompanion(')
          ..write('id: $id, ')
          ..write('ts: $ts, ')
          ..write('packs: $packs, ')
          ..write('pricePerPack: $pricePerPack, ')
          ..write('packSize: $packSize, ')
          ..write('brand: $brand')
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
  late final $MoodLogTable moodLog = $MoodLogTable(this);
  late final $SupportLogTable supportLog = $SupportLogTable(this);
  late final $IndexSnapshotTable indexSnapshot = $IndexSnapshotTable(this);
  late final $PlanStateTable planState = $PlanStateTable(this);
  late final $SavingsGoalTableTable savingsGoalTable = $SavingsGoalTableTable(
    this,
  );
  late final $CessationPlanTableTable cessationPlanTable =
      $CessationPlanTableTable(this);
  late final $CopingPlanTableTable copingPlanTable = $CopingPlanTableTable(
    this,
  );
  late final $MoodScreenTable moodScreen = $MoodScreenTable(this);
  late final $PackPurchaseTableTable packPurchaseTable =
      $PackPurchaseTableTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final RecordDao recordDao = RecordDao(this as AppDatabase);
  late final PlanDao planDao = PlanDao(this as AppDatabase);
  late final CravingDao cravingDao = CravingDao(this as AppDatabase);
  late final StatsDao statsDao = StatsDao(this as AppDatabase);
  late final ContentDao contentDao = ContentDao(this as AppDatabase);
  late final PurchaseDao purchaseDao = PurchaseDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final TimelineDao timelineDao = TimelineDao(this as AppDatabase);
  late final ModuleDao moduleDao = ModuleDao(this as AppDatabase);
  late final CessationDao cessationDao = CessationDao(this as AppDatabase);
  late final PackPurchaseDao packPurchaseDao = PackPurchaseDao(
    this as AppDatabase,
  );
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
    moodLog,
    supportLog,
    indexSnapshot,
    planState,
    savingsGoalTable,
    cessationPlanTable,
    copingPlanTable,
    moodScreen,
    packPurchaseTable,
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
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<SexOption?> sex,
      Value<double?> smokingYears,
      Value<int?> hsi,
      Value<MetabolismSpeed> metabolism,
      Value<double?> tarMgPerCigarette,
      Value<double?> nicotineMgPerCigarette,
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
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<SexOption?> sex,
      Value<double?> smokingYears,
      Value<int?> hsi,
      Value<MetabolismSpeed> metabolism,
      Value<double?> tarMgPerCigarette,
      Value<double?> nicotineMgPerCigarette,
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

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SexOption?, SexOption, String> get sex =>
      $composableBuilder(
        column: $table.sex,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get smokingYears => $composableBuilder(
    column: $table.smokingYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hsi => $composableBuilder(
    column: $table.hsi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MetabolismSpeed, MetabolismSpeed, String>
  get metabolism => $composableBuilder(
    column: $table.metabolism,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get tarMgPerCigarette => $composableBuilder(
    column: $table.tarMgPerCigarette,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nicotineMgPerCigarette => $composableBuilder(
    column: $table.nicotineMgPerCigarette,
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

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get smokingYears => $composableBuilder(
    column: $table.smokingYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hsi => $composableBuilder(
    column: $table.hsi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metabolism => $composableBuilder(
    column: $table.metabolism,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tarMgPerCigarette => $composableBuilder(
    column: $table.tarMgPerCigarette,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nicotineMgPerCigarette => $composableBuilder(
    column: $table.nicotineMgPerCigarette,
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

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SexOption?, String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get smokingYears => $composableBuilder(
    column: $table.smokingYears,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hsi =>
      $composableBuilder(column: $table.hsi, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MetabolismSpeed, String> get metabolism =>
      $composableBuilder(
        column: $table.metabolism,
        builder: (column) => column,
      );

  GeneratedColumn<double> get tarMgPerCigarette => $composableBuilder(
    column: $table.tarMgPerCigarette,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nicotineMgPerCigarette => $composableBuilder(
    column: $table.nicotineMgPerCigarette,
    builder: (column) => column,
  );
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
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<SexOption?> sex = const Value.absent(),
                Value<double?> smokingYears = const Value.absent(),
                Value<int?> hsi = const Value.absent(),
                Value<MetabolismSpeed> metabolism = const Value.absent(),
                Value<double?> tarMgPerCigarette = const Value.absent(),
                Value<double?> nicotineMgPerCigarette = const Value.absent(),
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
                heightCm: heightCm,
                weightKg: weightKg,
                sex: sex,
                smokingYears: smokingYears,
                hsi: hsi,
                metabolism: metabolism,
                tarMgPerCigarette: tarMgPerCigarette,
                nicotineMgPerCigarette: nicotineMgPerCigarette,
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
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<SexOption?> sex = const Value.absent(),
                Value<double?> smokingYears = const Value.absent(),
                Value<int?> hsi = const Value.absent(),
                Value<MetabolismSpeed> metabolism = const Value.absent(),
                Value<double?> tarMgPerCigarette = const Value.absent(),
                Value<double?> nicotineMgPerCigarette = const Value.absent(),
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
                heightCm: heightCm,
                weightKg: weightKg,
                sex: sex,
                smokingYears: smokingYears,
                hsi: hsi,
                metabolism: metabolism,
                tarMgPerCigarette: tarMgPerCigarette,
                nicotineMgPerCigarette: nicotineMgPerCigarette,
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
      Value<String?> techniqueKey,
    });
typedef $$CravingEventTableUpdateCompanionBuilder =
    CravingEventCompanion Function({
      Value<int> id,
      Value<DateTime> ts,
      Value<CravingIntensity> intensity,
      Value<TriggerLabel?> triggerLabel,
      Value<CravingOutcome> outcome,
      Value<String?> techniqueKey,
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

  ColumnFilters<String> get techniqueKey => $composableBuilder(
    column: $table.techniqueKey,
    builder: (column) => ColumnFilters(column),
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

  ColumnOrderings<String> get techniqueKey => $composableBuilder(
    column: $table.techniqueKey,
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

  GeneratedColumn<String> get techniqueKey => $composableBuilder(
    column: $table.techniqueKey,
    builder: (column) => column,
  );
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
                Value<String?> techniqueKey = const Value.absent(),
              }) => CravingEventCompanion(
                id: id,
                ts: ts,
                intensity: intensity,
                triggerLabel: triggerLabel,
                outcome: outcome,
                techniqueKey: techniqueKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime ts,
                required CravingIntensity intensity,
                Value<TriggerLabel?> triggerLabel = const Value.absent(),
                required CravingOutcome outcome,
                Value<String?> techniqueKey = const Value.absent(),
              }) => CravingEventCompanion.insert(
                id: id,
                ts: ts,
                intensity: intensity,
                triggerLabel: triggerLabel,
                outcome: outcome,
                techniqueKey: techniqueKey,
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
  Value<int> preLogPauseSeconds,
  Value<bool> riskyWindowReminder,
  Value<String?> appLocale,
  Value<bool> trialNudge,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<NotificationDensity> notifLevel,
  Value<ThemeOption> theme,
  Value<bool> reduceMotion,
  Value<bool> haptics,
  Value<DateTime?> trialStartedAt,
  Value<int> preLogPauseSeconds,
  Value<bool> riskyWindowReminder,
  Value<String?> appLocale,
  Value<bool> trialNudge,
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

  ColumnFilters<int> get preLogPauseSeconds => $composableBuilder(
    column: $table.preLogPauseSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get riskyWindowReminder => $composableBuilder(
    column: $table.riskyWindowReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appLocale => $composableBuilder(
    column: $table.appLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trialNudge => $composableBuilder(
    column: $table.trialNudge,
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

  ColumnOrderings<int> get preLogPauseSeconds => $composableBuilder(
    column: $table.preLogPauseSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get riskyWindowReminder => $composableBuilder(
    column: $table.riskyWindowReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appLocale => $composableBuilder(
    column: $table.appLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trialNudge => $composableBuilder(
    column: $table.trialNudge,
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

  GeneratedColumn<int> get preLogPauseSeconds => $composableBuilder(
    column: $table.preLogPauseSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get riskyWindowReminder => $composableBuilder(
    column: $table.riskyWindowReminder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appLocale =>
      $composableBuilder(column: $table.appLocale, builder: (column) => column);

  GeneratedColumn<bool> get trialNudge => $composableBuilder(
    column: $table.trialNudge,
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
                Value<int> preLogPauseSeconds = const Value.absent(),
                Value<bool> riskyWindowReminder = const Value.absent(),
                Value<String?> appLocale = const Value.absent(),
                Value<bool> trialNudge = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                notifLevel: notifLevel,
                theme: theme,
                reduceMotion: reduceMotion,
                haptics: haptics,
                trialStartedAt: trialStartedAt,
                preLogPauseSeconds: preLogPauseSeconds,
                riskyWindowReminder: riskyWindowReminder,
                appLocale: appLocale,
                trialNudge: trialNudge,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<NotificationDensity> notifLevel = const Value.absent(),
                Value<ThemeOption> theme = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<DateTime?> trialStartedAt = const Value.absent(),
                Value<int> preLogPauseSeconds = const Value.absent(),
                Value<bool> riskyWindowReminder = const Value.absent(),
                Value<String?> appLocale = const Value.absent(),
                Value<bool> trialNudge = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                notifLevel: notifLevel,
                theme: theme,
                reduceMotion: reduceMotion,
                haptics: haptics,
                trialStartedAt: trialStartedAt,
                preLogPauseSeconds: preLogPauseSeconds,
                riskyWindowReminder: riskyWindowReminder,
                appLocale: appLocale,
                trialNudge: trialNudge,
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
typedef $$MoodLogTableCreateCompanionBuilder = MoodLogCompanion Function({
  Value<int> id,
  required DateTime ts,
  required int reportedBand,
  required double estimated,
  Value<bool> prompted,
});
typedef $$MoodLogTableUpdateCompanionBuilder = MoodLogCompanion Function({
  Value<int> id,
  Value<DateTime> ts,
  Value<int> reportedBand,
  Value<double> estimated,
  Value<bool> prompted,
});

class $$MoodLogTableFilterComposer
    extends Composer<_$AppDatabase, $MoodLogTable> {
  $$MoodLogTableFilterComposer({
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

  ColumnFilters<int> get reportedBand => $composableBuilder(
    column: $table.reportedBand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimated => $composableBuilder(
    column: $table.estimated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get prompted => $composableBuilder(
    column: $table.prompted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodLogTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodLogTable> {
  $$MoodLogTableOrderingComposer({
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

  ColumnOrderings<int> get reportedBand => $composableBuilder(
    column: $table.reportedBand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimated => $composableBuilder(
    column: $table.estimated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get prompted => $composableBuilder(
    column: $table.prompted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodLogTable> {
  $$MoodLogTableAnnotationComposer({
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

  GeneratedColumn<int> get reportedBand => $composableBuilder(
    column: $table.reportedBand,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimated =>
      $composableBuilder(column: $table.estimated, builder: (column) => column);

  GeneratedColumn<bool> get prompted =>
      $composableBuilder(column: $table.prompted, builder: (column) => column);
}

class $$MoodLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodLogTable,
          MoodLogRow,
          $$MoodLogTableFilterComposer,
          $$MoodLogTableOrderingComposer,
          $$MoodLogTableAnnotationComposer,
          $$MoodLogTableCreateCompanionBuilder,
          $$MoodLogTableUpdateCompanionBuilder,
          (
            MoodLogRow,
            BaseReferences<_$AppDatabase, $MoodLogTable, MoodLogRow>,
          ),
          MoodLogRow,
          PrefetchHooks Function()
        > {
  $$MoodLogTableTableManager(_$AppDatabase db, $MoodLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> ts = const Value.absent(),
                Value<int> reportedBand = const Value.absent(),
                Value<double> estimated = const Value.absent(),
                Value<bool> prompted = const Value.absent(),
              }) => MoodLogCompanion(
                id: id,
                ts: ts,
                reportedBand: reportedBand,
                estimated: estimated,
                prompted: prompted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime ts,
                required int reportedBand,
                required double estimated,
                Value<bool> prompted = const Value.absent(),
              }) => MoodLogCompanion.insert(
                id: id,
                ts: ts,
                reportedBand: reportedBand,
                estimated: estimated,
                prompted: prompted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodLogTable, MoodLogRow>(table),
                  BaseReferences<_$AppDatabase, $MoodLogTable, MoodLogRow>(
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

typedef $$MoodLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodLogTable,
      MoodLogRow,
      $$MoodLogTableFilterComposer,
      $$MoodLogTableOrderingComposer,
      $$MoodLogTableAnnotationComposer,
      $$MoodLogTableCreateCompanionBuilder,
      $$MoodLogTableUpdateCompanionBuilder,
      (MoodLogRow, BaseReferences<_$AppDatabase, $MoodLogTable, MoodLogRow>),
      MoodLogRow,
      PrefetchHooks Function()
    >;
typedef $$SupportLogTableCreateCompanionBuilder = SupportLogCompanion Function({
  required String date,
  required String cardKey,
  Value<bool> done,
  Value<int> rowid,
});
typedef $$SupportLogTableUpdateCompanionBuilder = SupportLogCompanion Function({
  Value<String> date,
  Value<String> cardKey,
  Value<bool> done,
  Value<int> rowid,
});

class $$SupportLogTableFilterComposer
    extends Composer<_$AppDatabase, $SupportLogTable> {
  $$SupportLogTableFilterComposer({
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

  ColumnFilters<String> get cardKey => $composableBuilder(
    column: $table.cardKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupportLogTableOrderingComposer
    extends Composer<_$AppDatabase, $SupportLogTable> {
  $$SupportLogTableOrderingComposer({
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

  ColumnOrderings<String> get cardKey => $composableBuilder(
    column: $table.cardKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupportLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupportLogTable> {
  $$SupportLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get cardKey =>
      $composableBuilder(column: $table.cardKey, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);
}

class $$SupportLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupportLogTable,
          SupportLogRow,
          $$SupportLogTableFilterComposer,
          $$SupportLogTableOrderingComposer,
          $$SupportLogTableAnnotationComposer,
          $$SupportLogTableCreateCompanionBuilder,
          $$SupportLogTableUpdateCompanionBuilder,
          (
            SupportLogRow,
            BaseReferences<_$AppDatabase, $SupportLogTable, SupportLogRow>,
          ),
          SupportLogRow,
          PrefetchHooks Function()
        > {
  $$SupportLogTableTableManager(_$AppDatabase db, $SupportLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupportLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupportLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupportLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> cardKey = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupportLogCompanion(
                date: date,
                cardKey: cardKey,
                done: done,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String cardKey,
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupportLogCompanion.insert(
                date: date,
                cardKey: cardKey,
                done: done,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupportLogTable, SupportLogRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SupportLogTable,
                    SupportLogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupportLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupportLogTable,
      SupportLogRow,
      $$SupportLogTableFilterComposer,
      $$SupportLogTableOrderingComposer,
      $$SupportLogTableAnnotationComposer,
      $$SupportLogTableCreateCompanionBuilder,
      $$SupportLogTableUpdateCompanionBuilder,
      (
        SupportLogRow,
        BaseReferences<_$AppDatabase, $SupportLogTable, SupportLogRow>,
      ),
      SupportLogRow,
      PrefetchHooks Function()
    >;
typedef $$IndexSnapshotTableCreateCompanionBuilder =
    IndexSnapshotCompanion Function({
      required String date,
      required int progressScore,
      required int harmLoad,
      Value<int> rowid,
    });
typedef $$IndexSnapshotTableUpdateCompanionBuilder =
    IndexSnapshotCompanion Function({
      Value<String> date,
      Value<int> progressScore,
      Value<int> harmLoad,
      Value<int> rowid,
    });

class $$IndexSnapshotTableFilterComposer
    extends Composer<_$AppDatabase, $IndexSnapshotTable> {
  $$IndexSnapshotTableFilterComposer({
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

  ColumnFilters<int> get progressScore => $composableBuilder(
    column: $table.progressScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get harmLoad => $composableBuilder(
    column: $table.harmLoad,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IndexSnapshotTableOrderingComposer
    extends Composer<_$AppDatabase, $IndexSnapshotTable> {
  $$IndexSnapshotTableOrderingComposer({
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

  ColumnOrderings<int> get progressScore => $composableBuilder(
    column: $table.progressScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get harmLoad => $composableBuilder(
    column: $table.harmLoad,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IndexSnapshotTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndexSnapshotTable> {
  $$IndexSnapshotTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get progressScore => $composableBuilder(
    column: $table.progressScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get harmLoad =>
      $composableBuilder(column: $table.harmLoad, builder: (column) => column);
}

class $$IndexSnapshotTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IndexSnapshotTable,
          IndexSnapshotRow,
          $$IndexSnapshotTableFilterComposer,
          $$IndexSnapshotTableOrderingComposer,
          $$IndexSnapshotTableAnnotationComposer,
          $$IndexSnapshotTableCreateCompanionBuilder,
          $$IndexSnapshotTableUpdateCompanionBuilder,
          (
            IndexSnapshotRow,
            BaseReferences<
              _$AppDatabase,
              $IndexSnapshotTable,
              IndexSnapshotRow
            >,
          ),
          IndexSnapshotRow,
          PrefetchHooks Function()
        > {
  $$IndexSnapshotTableTableManager(_$AppDatabase db, $IndexSnapshotTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndexSnapshotTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndexSnapshotTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndexSnapshotTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> progressScore = const Value.absent(),
                Value<int> harmLoad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IndexSnapshotCompanion(
                date: date,
                progressScore: progressScore,
                harmLoad: harmLoad,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int progressScore,
                required int harmLoad,
                Value<int> rowid = const Value.absent(),
              }) => IndexSnapshotCompanion.insert(
                date: date,
                progressScore: progressScore,
                harmLoad: harmLoad,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IndexSnapshotTable, IndexSnapshotRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $IndexSnapshotTable,
                    IndexSnapshotRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IndexSnapshotTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IndexSnapshotTable,
      IndexSnapshotRow,
      $$IndexSnapshotTableFilterComposer,
      $$IndexSnapshotTableOrderingComposer,
      $$IndexSnapshotTableAnnotationComposer,
      $$IndexSnapshotTableCreateCompanionBuilder,
      $$IndexSnapshotTableUpdateCompanionBuilder,
      (
        IndexSnapshotRow,
        BaseReferences<_$AppDatabase, $IndexSnapshotTable, IndexSnapshotRow>,
      ),
      IndexSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$PlanStateTableCreateCompanionBuilder = PlanStateCompanion Function({
  Value<int> id,
  Value<PlanKind> kind,
  required DateTime startedAt,
  Value<int?> intervalMinutes,
  Value<int?> targetIntervalMinutes,
  Value<int> daysAtStep,
  Value<TaperMode> taperMode,
  Value<String> switchHistoryJson,
  Value<String?> lastStepDate,
  Value<TaperDecision?> lastStepDecision,
});
typedef $$PlanStateTableUpdateCompanionBuilder = PlanStateCompanion Function({
  Value<int> id,
  Value<PlanKind> kind,
  Value<DateTime> startedAt,
  Value<int?> intervalMinutes,
  Value<int?> targetIntervalMinutes,
  Value<int> daysAtStep,
  Value<TaperMode> taperMode,
  Value<String> switchHistoryJson,
  Value<String?> lastStepDate,
  Value<TaperDecision?> lastStepDecision,
});

class $$PlanStateTableFilterComposer
    extends Composer<_$AppDatabase, $PlanStateTable> {
  $$PlanStateTableFilterComposer({
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

  ColumnWithTypeConverterFilters<PlanKind, PlanKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetIntervalMinutes => $composableBuilder(
    column: $table.targetIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysAtStep => $composableBuilder(
    column: $table.daysAtStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaperMode, TaperMode, String> get taperMode =>
      $composableBuilder(
        column: $table.taperMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get switchHistoryJson => $composableBuilder(
    column: $table.switchHistoryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastStepDate => $composableBuilder(
    column: $table.lastStepDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaperDecision?, TaperDecision, String>
  get lastStepDecision => $composableBuilder(
    column: $table.lastStepDecision,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$PlanStateTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanStateTable> {
  $$PlanStateTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetIntervalMinutes => $composableBuilder(
    column: $table.targetIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysAtStep => $composableBuilder(
    column: $table.daysAtStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taperMode => $composableBuilder(
    column: $table.taperMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get switchHistoryJson => $composableBuilder(
    column: $table.switchHistoryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastStepDate => $composableBuilder(
    column: $table.lastStepDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastStepDecision => $composableBuilder(
    column: $table.lastStepDecision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanStateTable> {
  $$PlanStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlanKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetIntervalMinutes => $composableBuilder(
    column: $table.targetIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysAtStep => $composableBuilder(
    column: $table.daysAtStep,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaperMode, String> get taperMode =>
      $composableBuilder(column: $table.taperMode, builder: (column) => column);

  GeneratedColumn<String> get switchHistoryJson => $composableBuilder(
    column: $table.switchHistoryJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastStepDate => $composableBuilder(
    column: $table.lastStepDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaperDecision?, String>
  get lastStepDecision => $composableBuilder(
    column: $table.lastStepDecision,
    builder: (column) => column,
  );
}

class $$PlanStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanStateTable,
          PlanStateRow,
          $$PlanStateTableFilterComposer,
          $$PlanStateTableOrderingComposer,
          $$PlanStateTableAnnotationComposer,
          $$PlanStateTableCreateCompanionBuilder,
          $$PlanStateTableUpdateCompanionBuilder,
          (
            PlanStateRow,
            BaseReferences<_$AppDatabase, $PlanStateTable, PlanStateRow>,
          ),
          PlanStateRow,
          PrefetchHooks Function()
        > {
  $$PlanStateTableTableManager(_$AppDatabase db, $PlanStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<PlanKind> kind = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int?> intervalMinutes = const Value.absent(),
                Value<int?> targetIntervalMinutes = const Value.absent(),
                Value<int> daysAtStep = const Value.absent(),
                Value<TaperMode> taperMode = const Value.absent(),
                Value<String> switchHistoryJson = const Value.absent(),
                Value<String?> lastStepDate = const Value.absent(),
                Value<TaperDecision?> lastStepDecision = const Value.absent(),
              }) => PlanStateCompanion(
                id: id,
                kind: kind,
                startedAt: startedAt,
                intervalMinutes: intervalMinutes,
                targetIntervalMinutes: targetIntervalMinutes,
                daysAtStep: daysAtStep,
                taperMode: taperMode,
                switchHistoryJson: switchHistoryJson,
                lastStepDate: lastStepDate,
                lastStepDecision: lastStepDecision,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<PlanKind> kind = const Value.absent(),
                required DateTime startedAt,
                Value<int?> intervalMinutes = const Value.absent(),
                Value<int?> targetIntervalMinutes = const Value.absent(),
                Value<int> daysAtStep = const Value.absent(),
                Value<TaperMode> taperMode = const Value.absent(),
                Value<String> switchHistoryJson = const Value.absent(),
                Value<String?> lastStepDate = const Value.absent(),
                Value<TaperDecision?> lastStepDecision = const Value.absent(),
              }) => PlanStateCompanion.insert(
                id: id,
                kind: kind,
                startedAt: startedAt,
                intervalMinutes: intervalMinutes,
                targetIntervalMinutes: targetIntervalMinutes,
                daysAtStep: daysAtStep,
                taperMode: taperMode,
                switchHistoryJson: switchHistoryJson,
                lastStepDate: lastStepDate,
                lastStepDecision: lastStepDecision,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanStateTable, PlanStateRow>(table),
                  BaseReferences<_$AppDatabase, $PlanStateTable, PlanStateRow>(
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

typedef $$PlanStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanStateTable,
      PlanStateRow,
      $$PlanStateTableFilterComposer,
      $$PlanStateTableOrderingComposer,
      $$PlanStateTableAnnotationComposer,
      $$PlanStateTableCreateCompanionBuilder,
      $$PlanStateTableUpdateCompanionBuilder,
      (
        PlanStateRow,
        BaseReferences<_$AppDatabase, $PlanStateTable, PlanStateRow>,
      ),
      PlanStateRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalTableTableCreateCompanionBuilder =
    SavingsGoalTableCompanion Function({
      Value<int> id,
      required String label,
      required double amount,
    });
typedef $$SavingsGoalTableTableUpdateCompanionBuilder =
    SavingsGoalTableCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<double> amount,
    });

class $$SavingsGoalTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalTableTable> {
  $$SavingsGoalTableTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalTableTable> {
  $$SavingsGoalTableTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalTableTable> {
  $$SavingsGoalTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$SavingsGoalTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalTableTable,
          SavingsGoalRow,
          $$SavingsGoalTableTableFilterComposer,
          $$SavingsGoalTableTableOrderingComposer,
          $$SavingsGoalTableTableAnnotationComposer,
          $$SavingsGoalTableTableCreateCompanionBuilder,
          $$SavingsGoalTableTableUpdateCompanionBuilder,
          (
            SavingsGoalRow,
            BaseReferences<
              _$AppDatabase,
              $SavingsGoalTableTable,
              SavingsGoalRow
            >,
          ),
          SavingsGoalRow,
          PrefetchHooks Function()
        > {
  $$SavingsGoalTableTableTableManager(
    _$AppDatabase db,
    $SavingsGoalTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) => SavingsGoalTableCompanion(id: id, label: label, amount: amount),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                required double amount,
              }) => SavingsGoalTableCompanion.insert(
                id: id,
                label: label,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalTableTable, SavingsGoalRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SavingsGoalTableTable,
                    SavingsGoalRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalTableTable,
      SavingsGoalRow,
      $$SavingsGoalTableTableFilterComposer,
      $$SavingsGoalTableTableOrderingComposer,
      $$SavingsGoalTableTableAnnotationComposer,
      $$SavingsGoalTableTableCreateCompanionBuilder,
      $$SavingsGoalTableTableUpdateCompanionBuilder,
      (
        SavingsGoalRow,
        BaseReferences<_$AppDatabase, $SavingsGoalTableTable, SavingsGoalRow>,
      ),
      SavingsGoalRow,
      PrefetchHooks Function()
    >;
typedef $$CessationPlanTableTableCreateCompanionBuilder =
    CessationPlanTableCompanion Function({
      Value<int> id,
      Value<String?> quitDate,
      Value<int> quitDateMoves,
      Value<QuitReason?> reason,
      Value<String?> supportPerson,
      Value<bool> notAPuffAccepted,
    });
typedef $$CessationPlanTableTableUpdateCompanionBuilder =
    CessationPlanTableCompanion Function({
      Value<int> id,
      Value<String?> quitDate,
      Value<int> quitDateMoves,
      Value<QuitReason?> reason,
      Value<String?> supportPerson,
      Value<bool> notAPuffAccepted,
    });

class $$CessationPlanTableTableFilterComposer
    extends Composer<_$AppDatabase, $CessationPlanTableTable> {
  $$CessationPlanTableTableFilterComposer({
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

  ColumnFilters<String> get quitDate => $composableBuilder(
    column: $table.quitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quitDateMoves => $composableBuilder(
    column: $table.quitDateMoves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuitReason?, QuitReason, String> get reason =>
      $composableBuilder(
        column: $table.reason,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get supportPerson => $composableBuilder(
    column: $table.supportPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notAPuffAccepted => $composableBuilder(
    column: $table.notAPuffAccepted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CessationPlanTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CessationPlanTableTable> {
  $$CessationPlanTableTableOrderingComposer({
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

  ColumnOrderings<String> get quitDate => $composableBuilder(
    column: $table.quitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quitDateMoves => $composableBuilder(
    column: $table.quitDateMoves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supportPerson => $composableBuilder(
    column: $table.supportPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notAPuffAccepted => $composableBuilder(
    column: $table.notAPuffAccepted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CessationPlanTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CessationPlanTableTable> {
  $$CessationPlanTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quitDate =>
      $composableBuilder(column: $table.quitDate, builder: (column) => column);

  GeneratedColumn<int> get quitDateMoves => $composableBuilder(
    column: $table.quitDateMoves,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuitReason?, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get supportPerson => $composableBuilder(
    column: $table.supportPerson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notAPuffAccepted => $composableBuilder(
    column: $table.notAPuffAccepted,
    builder: (column) => column,
  );
}

class $$CessationPlanTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CessationPlanTableTable,
          CessationPlanRow,
          $$CessationPlanTableTableFilterComposer,
          $$CessationPlanTableTableOrderingComposer,
          $$CessationPlanTableTableAnnotationComposer,
          $$CessationPlanTableTableCreateCompanionBuilder,
          $$CessationPlanTableTableUpdateCompanionBuilder,
          (
            CessationPlanRow,
            BaseReferences<
              _$AppDatabase,
              $CessationPlanTableTable,
              CessationPlanRow
            >,
          ),
          CessationPlanRow,
          PrefetchHooks Function()
        > {
  $$CessationPlanTableTableTableManager(
    _$AppDatabase db,
    $CessationPlanTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CessationPlanTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CessationPlanTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CessationPlanTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> quitDate = const Value.absent(),
                Value<int> quitDateMoves = const Value.absent(),
                Value<QuitReason?> reason = const Value.absent(),
                Value<String?> supportPerson = const Value.absent(),
                Value<bool> notAPuffAccepted = const Value.absent(),
              }) => CessationPlanTableCompanion(
                id: id,
                quitDate: quitDate,
                quitDateMoves: quitDateMoves,
                reason: reason,
                supportPerson: supportPerson,
                notAPuffAccepted: notAPuffAccepted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> quitDate = const Value.absent(),
                Value<int> quitDateMoves = const Value.absent(),
                Value<QuitReason?> reason = const Value.absent(),
                Value<String?> supportPerson = const Value.absent(),
                Value<bool> notAPuffAccepted = const Value.absent(),
              }) => CessationPlanTableCompanion.insert(
                id: id,
                quitDate: quitDate,
                quitDateMoves: quitDateMoves,
                reason: reason,
                supportPerson: supportPerson,
                notAPuffAccepted: notAPuffAccepted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CessationPlanTableTable, CessationPlanRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CessationPlanTableTable,
                    CessationPlanRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CessationPlanTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CessationPlanTableTable,
      CessationPlanRow,
      $$CessationPlanTableTableFilterComposer,
      $$CessationPlanTableTableOrderingComposer,
      $$CessationPlanTableTableAnnotationComposer,
      $$CessationPlanTableTableCreateCompanionBuilder,
      $$CessationPlanTableTableUpdateCompanionBuilder,
      (
        CessationPlanRow,
        BaseReferences<
          _$AppDatabase,
          $CessationPlanTableTable,
          CessationPlanRow
        >,
      ),
      CessationPlanRow,
      PrefetchHooks Function()
    >;
typedef $$CopingPlanTableTableCreateCompanionBuilder =
    CopingPlanTableCompanion Function({
      required TriggerLabel trigger,
      required String plan,
      Value<bool> rehearsed,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CopingPlanTableTableUpdateCompanionBuilder =
    CopingPlanTableCompanion Function({
      Value<TriggerLabel> trigger,
      Value<String> plan,
      Value<bool> rehearsed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CopingPlanTableTableFilterComposer
    extends Composer<_$AppDatabase, $CopingPlanTableTable> {
  $$CopingPlanTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<TriggerLabel, TriggerLabel, String>
  get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rehearsed => $composableBuilder(
    column: $table.rehearsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CopingPlanTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CopingPlanTableTable> {
  $$CopingPlanTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rehearsed => $composableBuilder(
    column: $table.rehearsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CopingPlanTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CopingPlanTableTable> {
  $$CopingPlanTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<TriggerLabel, String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<bool> get rehearsed =>
      $composableBuilder(column: $table.rehearsed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CopingPlanTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CopingPlanTableTable,
          CopingPlanRow,
          $$CopingPlanTableTableFilterComposer,
          $$CopingPlanTableTableOrderingComposer,
          $$CopingPlanTableTableAnnotationComposer,
          $$CopingPlanTableTableCreateCompanionBuilder,
          $$CopingPlanTableTableUpdateCompanionBuilder,
          (
            CopingPlanRow,
            BaseReferences<_$AppDatabase, $CopingPlanTableTable, CopingPlanRow>,
          ),
          CopingPlanRow,
          PrefetchHooks Function()
        > {
  $$CopingPlanTableTableTableManager(
    _$AppDatabase db,
    $CopingPlanTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopingPlanTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopingPlanTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopingPlanTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<TriggerLabel> trigger = const Value.absent(),
                Value<String> plan = const Value.absent(),
                Value<bool> rehearsed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CopingPlanTableCompanion(
                trigger: trigger,
                plan: plan,
                rehearsed: rehearsed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required TriggerLabel trigger,
                required String plan,
                Value<bool> rehearsed = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CopingPlanTableCompanion.insert(
                trigger: trigger,
                plan: plan,
                rehearsed: rehearsed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CopingPlanTableTable, CopingPlanRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CopingPlanTableTable,
                    CopingPlanRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CopingPlanTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CopingPlanTableTable,
      CopingPlanRow,
      $$CopingPlanTableTableFilterComposer,
      $$CopingPlanTableTableOrderingComposer,
      $$CopingPlanTableTableAnnotationComposer,
      $$CopingPlanTableTableCreateCompanionBuilder,
      $$CopingPlanTableTableUpdateCompanionBuilder,
      (
        CopingPlanRow,
        BaseReferences<_$AppDatabase, $CopingPlanTableTable, CopingPlanRow>,
      ),
      CopingPlanRow,
      PrefetchHooks Function()
    >;
typedef $$MoodScreenTableCreateCompanionBuilder = MoodScreenCompanion Function({
  Value<int> id,
  required DateTime ts,
  required int lowInterest,
  required int lowMood,
  required int total,
});
typedef $$MoodScreenTableUpdateCompanionBuilder = MoodScreenCompanion Function({
  Value<int> id,
  Value<DateTime> ts,
  Value<int> lowInterest,
  Value<int> lowMood,
  Value<int> total,
});

class $$MoodScreenTableFilterComposer
    extends Composer<_$AppDatabase, $MoodScreenTable> {
  $$MoodScreenTableFilterComposer({
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

  ColumnFilters<int> get lowInterest => $composableBuilder(
    column: $table.lowInterest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowMood => $composableBuilder(
    column: $table.lowMood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodScreenTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodScreenTable> {
  $$MoodScreenTableOrderingComposer({
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

  ColumnOrderings<int> get lowInterest => $composableBuilder(
    column: $table.lowInterest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowMood => $composableBuilder(
    column: $table.lowMood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodScreenTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodScreenTable> {
  $$MoodScreenTableAnnotationComposer({
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

  GeneratedColumn<int> get lowInterest => $composableBuilder(
    column: $table.lowInterest,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowMood =>
      $composableBuilder(column: $table.lowMood, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);
}

class $$MoodScreenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodScreenTable,
          MoodScreenRow,
          $$MoodScreenTableFilterComposer,
          $$MoodScreenTableOrderingComposer,
          $$MoodScreenTableAnnotationComposer,
          $$MoodScreenTableCreateCompanionBuilder,
          $$MoodScreenTableUpdateCompanionBuilder,
          (
            MoodScreenRow,
            BaseReferences<_$AppDatabase, $MoodScreenTable, MoodScreenRow>,
          ),
          MoodScreenRow,
          PrefetchHooks Function()
        > {
  $$MoodScreenTableTableManager(_$AppDatabase db, $MoodScreenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodScreenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodScreenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodScreenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> ts = const Value.absent(),
                Value<int> lowInterest = const Value.absent(),
                Value<int> lowMood = const Value.absent(),
                Value<int> total = const Value.absent(),
              }) => MoodScreenCompanion(
                id: id,
                ts: ts,
                lowInterest: lowInterest,
                lowMood: lowMood,
                total: total,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime ts,
                required int lowInterest,
                required int lowMood,
                required int total,
              }) => MoodScreenCompanion.insert(
                id: id,
                ts: ts,
                lowInterest: lowInterest,
                lowMood: lowMood,
                total: total,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodScreenTable, MoodScreenRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MoodScreenTable,
                    MoodScreenRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodScreenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodScreenTable,
      MoodScreenRow,
      $$MoodScreenTableFilterComposer,
      $$MoodScreenTableOrderingComposer,
      $$MoodScreenTableAnnotationComposer,
      $$MoodScreenTableCreateCompanionBuilder,
      $$MoodScreenTableUpdateCompanionBuilder,
      (
        MoodScreenRow,
        BaseReferences<_$AppDatabase, $MoodScreenTable, MoodScreenRow>,
      ),
      MoodScreenRow,
      PrefetchHooks Function()
    >;
typedef $$PackPurchaseTableTableCreateCompanionBuilder =
    PackPurchaseTableCompanion Function({
      Value<int> id,
      required DateTime ts,
      Value<int> packs,
      required double pricePerPack,
      Value<int> packSize,
      Value<String?> brand,
    });
typedef $$PackPurchaseTableTableUpdateCompanionBuilder =
    PackPurchaseTableCompanion Function({
      Value<int> id,
      Value<DateTime> ts,
      Value<int> packs,
      Value<double> pricePerPack,
      Value<int> packSize,
      Value<String?> brand,
    });

class $$PackPurchaseTableTableFilterComposer
    extends Composer<_$AppDatabase, $PackPurchaseTableTable> {
  $$PackPurchaseTableTableFilterComposer({
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

  ColumnFilters<int> get packs => $composableBuilder(
    column: $table.packs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerPack => $composableBuilder(
    column: $table.pricePerPack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PackPurchaseTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PackPurchaseTableTable> {
  $$PackPurchaseTableTableOrderingComposer({
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

  ColumnOrderings<int> get packs => $composableBuilder(
    column: $table.packs,
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

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackPurchaseTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackPurchaseTableTable> {
  $$PackPurchaseTableTableAnnotationComposer({
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

  GeneratedColumn<int> get packs =>
      $composableBuilder(column: $table.packs, builder: (column) => column);

  GeneratedColumn<double> get pricePerPack => $composableBuilder(
    column: $table.pricePerPack,
    builder: (column) => column,
  );

  GeneratedColumn<int> get packSize =>
      $composableBuilder(column: $table.packSize, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);
}

class $$PackPurchaseTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackPurchaseTableTable,
          PackPurchaseRow,
          $$PackPurchaseTableTableFilterComposer,
          $$PackPurchaseTableTableOrderingComposer,
          $$PackPurchaseTableTableAnnotationComposer,
          $$PackPurchaseTableTableCreateCompanionBuilder,
          $$PackPurchaseTableTableUpdateCompanionBuilder,
          (
            PackPurchaseRow,
            BaseReferences<
              _$AppDatabase,
              $PackPurchaseTableTable,
              PackPurchaseRow
            >,
          ),
          PackPurchaseRow,
          PrefetchHooks Function()
        > {
  $$PackPurchaseTableTableTableManager(
    _$AppDatabase db,
    $PackPurchaseTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackPurchaseTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackPurchaseTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackPurchaseTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> ts = const Value.absent(),
                Value<int> packs = const Value.absent(),
                Value<double> pricePerPack = const Value.absent(),
                Value<int> packSize = const Value.absent(),
                Value<String?> brand = const Value.absent(),
              }) => PackPurchaseTableCompanion(
                id: id,
                ts: ts,
                packs: packs,
                pricePerPack: pricePerPack,
                packSize: packSize,
                brand: brand,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime ts,
                Value<int> packs = const Value.absent(),
                required double pricePerPack,
                Value<int> packSize = const Value.absent(),
                Value<String?> brand = const Value.absent(),
              }) => PackPurchaseTableCompanion.insert(
                id: id,
                ts: ts,
                packs: packs,
                pricePerPack: pricePerPack,
                packSize: packSize,
                brand: brand,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PackPurchaseTableTable, PackPurchaseRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PackPurchaseTableTable,
                    PackPurchaseRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PackPurchaseTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackPurchaseTableTable,
      PackPurchaseRow,
      $$PackPurchaseTableTableFilterComposer,
      $$PackPurchaseTableTableOrderingComposer,
      $$PackPurchaseTableTableAnnotationComposer,
      $$PackPurchaseTableTableCreateCompanionBuilder,
      $$PackPurchaseTableTableUpdateCompanionBuilder,
      (
        PackPurchaseRow,
        BaseReferences<_$AppDatabase, $PackPurchaseTableTable, PackPurchaseRow>,
      ),
      PackPurchaseRow,
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
  $$MoodLogTableTableManager get moodLog =>
      $$MoodLogTableTableManager(_db, _db.moodLog);
  $$SupportLogTableTableManager get supportLog =>
      $$SupportLogTableTableManager(_db, _db.supportLog);
  $$IndexSnapshotTableTableManager get indexSnapshot =>
      $$IndexSnapshotTableTableManager(_db, _db.indexSnapshot);
  $$PlanStateTableTableManager get planState =>
      $$PlanStateTableTableManager(_db, _db.planState);
  $$SavingsGoalTableTableTableManager get savingsGoalTable =>
      $$SavingsGoalTableTableTableManager(_db, _db.savingsGoalTable);
  $$CessationPlanTableTableTableManager get cessationPlanTable =>
      $$CessationPlanTableTableTableManager(_db, _db.cessationPlanTable);
  $$CopingPlanTableTableTableManager get copingPlanTable =>
      $$CopingPlanTableTableTableManager(_db, _db.copingPlanTable);
  $$MoodScreenTableTableManager get moodScreen =>
      $$MoodScreenTableTableManager(_db, _db.moodScreen);
  $$PackPurchaseTableTableTableManager get packPurchaseTable =>
      $$PackPurchaseTableTableTableManager(_db, _db.packPurchaseTable);
}
