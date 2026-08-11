// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FuelTypesTable extends FuelTypes
    with TableInfo<$FuelTypesTable, FuelType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelTypesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FuelTypesTable createAlias(String alias) {
    return $FuelTypesTable(attachedDatabase, alias);
  }
}

class FuelType extends DataClass implements Insertable<FuelType> {
  final int id;
  final String name;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FuelType({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FuelTypesCompanion toCompanion(bool nullToAbsent) {
    return FuelTypesCompanion(
      id: Value(id),
      name: Value(name),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FuelType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FuelType copyWith({
    int? id,
    String? name,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FuelType(
    id: id ?? this.id,
    name: name ?? this.name,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FuelType copyWithCompanion(FuelTypesCompanion data) {
    return FuelType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelType &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FuelTypesCompanion extends UpdateCompanion<FuelType> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FuelTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FuelTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<FuelType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FuelTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FuelTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CarBrandsTable extends CarBrands
    with TableInfo<$CarBrandsTable, CarBrand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarBrandsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'car_brands';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarBrand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarBrand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarBrand(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CarBrandsTable createAlias(String alias) {
    return $CarBrandsTable(attachedDatabase, alias);
  }
}

class CarBrand extends DataClass implements Insertable<CarBrand> {
  final int id;
  final String name;
  final DateTime createdAt;
  const CarBrand({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CarBrandsCompanion toCompanion(bool nullToAbsent) {
    return CarBrandsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory CarBrand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarBrand(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CarBrand copyWith({int? id, String? name, DateTime? createdAt}) => CarBrand(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  CarBrand copyWithCompanion(CarBrandsCompanion data) {
    return CarBrand(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarBrand(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarBrand &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CarBrandsCompanion extends UpdateCompanion<CarBrand> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const CarBrandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CarBrandsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CarBrand> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CarBrandsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return CarBrandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarBrandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CarsTable extends Cars with TableInfo<$CarsTable, Car> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<int> brandId = GeneratedColumn<int>(
    'brand_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List> photo = GeneratedColumn<Uint8List>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brandId,
    model,
    year,
    photo,
    colorArgb,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars';
  @override
  VerificationContext validateIntegrity(
    Insertable<Car> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brandIdMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Car map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Car(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brand_id'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}photo'],
      ),
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CarsTable createAlias(String alias) {
    return $CarsTable(attachedDatabase, alias);
  }
}

class Car extends DataClass implements Insertable<Car> {
  final int id;
  final int brandId;
  final String? model;
  final int? year;
  final Uint8List? photo;
  final int? colorArgb;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Car({
    required this.id,
    required this.brandId,
    this.model,
    this.year,
    this.photo,
    this.colorArgb,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand_id'] = Variable<int>(brandId);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List>(photo);
    }
    if (!nullToAbsent || colorArgb != null) {
      map['color_argb'] = Variable<int>(colorArgb);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CarsCompanion toCompanion(bool nullToAbsent) {
    return CarsCompanion(
      id: Value(id),
      brandId: Value(brandId),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      colorArgb: colorArgb == null && nullToAbsent
          ? const Value.absent()
          : Value(colorArgb),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Car.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Car(
      id: serializer.fromJson<int>(json['id']),
      brandId: serializer.fromJson<int>(json['brandId']),
      model: serializer.fromJson<String?>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
      colorArgb: serializer.fromJson<int?>(json['colorArgb']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brandId': serializer.toJson<int>(brandId),
      'model': serializer.toJson<String?>(model),
      'year': serializer.toJson<int?>(year),
      'photo': serializer.toJson<Uint8List?>(photo),
      'colorArgb': serializer.toJson<int?>(colorArgb),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Car copyWith({
    int? id,
    int? brandId,
    Value<String?> model = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<Uint8List?> photo = const Value.absent(),
    Value<int?> colorArgb = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Car(
    id: id ?? this.id,
    brandId: brandId ?? this.brandId,
    model: model.present ? model.value : this.model,
    year: year.present ? year.value : this.year,
    photo: photo.present ? photo.value : this.photo,
    colorArgb: colorArgb.present ? colorArgb.value : this.colorArgb,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Car copyWithCompanion(CarsCompanion data) {
    return Car(
      id: data.id.present ? data.id.value : this.id,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      photo: data.photo.present ? data.photo.value : this.photo,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Car(')
          ..write('id: $id, ')
          ..write('brandId: $brandId, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('photo: $photo, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brandId,
    model,
    year,
    $driftBlobEquality.hash(photo),
    colorArgb,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Car &&
          other.id == this.id &&
          other.brandId == this.brandId &&
          other.model == this.model &&
          other.year == this.year &&
          $driftBlobEquality.equals(other.photo, this.photo) &&
          other.colorArgb == this.colorArgb &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CarsCompanion extends UpdateCompanion<Car> {
  final Value<int> id;
  final Value<int> brandId;
  final Value<String?> model;
  final Value<int?> year;
  final Value<Uint8List?> photo;
  final Value<int?> colorArgb;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CarsCompanion({
    this.id = const Value.absent(),
    this.brandId = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.photo = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CarsCompanion.insert({
    this.id = const Value.absent(),
    required int brandId,
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.photo = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : brandId = Value(brandId);
  static Insertable<Car> custom({
    Expression<int>? id,
    Expression<int>? brandId,
    Expression<String>? model,
    Expression<int>? year,
    Expression<Uint8List>? photo,
    Expression<int>? colorArgb,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brandId != null) 'brand_id': brandId,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (photo != null) 'photo': photo,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CarsCompanion copyWith({
    Value<int>? id,
    Value<int>? brandId,
    Value<String?>? model,
    Value<int?>? year,
    Value<Uint8List?>? photo,
    Value<int?>? colorArgb,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CarsCompanion(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      model: model ?? this.model,
      year: year ?? this.year,
      photo: photo ?? this.photo,
      colorArgb: colorArgb ?? this.colorArgb,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<int>(brandId.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsCompanion(')
          ..write('id: $id, ')
          ..write('brandId: $brandId, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('photo: $photo, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FuelTypeCarsTable extends FuelTypeCars
    with TableInfo<$FuelTypeCarsTable, FuelTypeCar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelTypeCarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fuelTypeIdMeta = const VerificationMeta(
    'fuelTypeId',
  );
  @override
  late final GeneratedColumn<int> fuelTypeId = GeneratedColumn<int>(
    'fuel_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fuelTypeId, carId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_type_cars';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelTypeCar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fuel_type_id')) {
      context.handle(
        _fuelTypeIdMeta,
        fuelTypeId.isAcceptableOrUnknown(
          data['fuel_type_id']!,
          _fuelTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeIdMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fuelTypeId, carId};
  @override
  FuelTypeCar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelTypeCar(
      fuelTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fuel_type_id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}car_id'],
      )!,
    );
  }

  @override
  $FuelTypeCarsTable createAlias(String alias) {
    return $FuelTypeCarsTable(attachedDatabase, alias);
  }
}

class FuelTypeCar extends DataClass implements Insertable<FuelTypeCar> {
  final int fuelTypeId;
  final int carId;
  const FuelTypeCar({required this.fuelTypeId, required this.carId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fuel_type_id'] = Variable<int>(fuelTypeId);
    map['car_id'] = Variable<int>(carId);
    return map;
  }

  FuelTypeCarsCompanion toCompanion(bool nullToAbsent) {
    return FuelTypeCarsCompanion(
      fuelTypeId: Value(fuelTypeId),
      carId: Value(carId),
    );
  }

  factory FuelTypeCar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelTypeCar(
      fuelTypeId: serializer.fromJson<int>(json['fuelTypeId']),
      carId: serializer.fromJson<int>(json['carId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fuelTypeId': serializer.toJson<int>(fuelTypeId),
      'carId': serializer.toJson<int>(carId),
    };
  }

  FuelTypeCar copyWith({int? fuelTypeId, int? carId}) => FuelTypeCar(
    fuelTypeId: fuelTypeId ?? this.fuelTypeId,
    carId: carId ?? this.carId,
  );
  FuelTypeCar copyWithCompanion(FuelTypeCarsCompanion data) {
    return FuelTypeCar(
      fuelTypeId: data.fuelTypeId.present
          ? data.fuelTypeId.value
          : this.fuelTypeId,
      carId: data.carId.present ? data.carId.value : this.carId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelTypeCar(')
          ..write('fuelTypeId: $fuelTypeId, ')
          ..write('carId: $carId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fuelTypeId, carId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelTypeCar &&
          other.fuelTypeId == this.fuelTypeId &&
          other.carId == this.carId);
}

class FuelTypeCarsCompanion extends UpdateCompanion<FuelTypeCar> {
  final Value<int> fuelTypeId;
  final Value<int> carId;
  final Value<int> rowid;
  const FuelTypeCarsCompanion({
    this.fuelTypeId = const Value.absent(),
    this.carId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FuelTypeCarsCompanion.insert({
    required int fuelTypeId,
    required int carId,
    this.rowid = const Value.absent(),
  }) : fuelTypeId = Value(fuelTypeId),
       carId = Value(carId);
  static Insertable<FuelTypeCar> custom({
    Expression<int>? fuelTypeId,
    Expression<int>? carId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fuelTypeId != null) 'fuel_type_id': fuelTypeId,
      if (carId != null) 'car_id': carId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FuelTypeCarsCompanion copyWith({
    Value<int>? fuelTypeId,
    Value<int>? carId,
    Value<int>? rowid,
  }) {
    return FuelTypeCarsCompanion(
      fuelTypeId: fuelTypeId ?? this.fuelTypeId,
      carId: carId ?? this.carId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fuelTypeId.present) {
      map['fuel_type_id'] = Variable<int>(fuelTypeId.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelTypeCarsCompanion(')
          ..write('fuelTypeId: $fuelTypeId, ')
          ..write('carId: $carId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Part> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class Part extends DataClass implements Insertable<Part> {
  final int id;
  final String name;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Part({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      name: Value(name),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Part.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Part copyWith({
    int? id,
    String? name,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Part(
    id: id ?? this.id,
    name: name ?? this.name,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Part> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PartsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PartsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PartCarsTable extends PartCars with TableInfo<$PartCarsTable, PartCar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartCarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [partId, carId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_cars';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartCar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {partId, carId};
  @override
  PartCar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartCar(
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}car_id'],
      )!,
    );
  }

  @override
  $PartCarsTable createAlias(String alias) {
    return $PartCarsTable(attachedDatabase, alias);
  }
}

class PartCar extends DataClass implements Insertable<PartCar> {
  final int partId;
  final int carId;
  const PartCar({required this.partId, required this.carId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['part_id'] = Variable<int>(partId);
    map['car_id'] = Variable<int>(carId);
    return map;
  }

  PartCarsCompanion toCompanion(bool nullToAbsent) {
    return PartCarsCompanion(partId: Value(partId), carId: Value(carId));
  }

  factory PartCar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartCar(
      partId: serializer.fromJson<int>(json['partId']),
      carId: serializer.fromJson<int>(json['carId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'partId': serializer.toJson<int>(partId),
      'carId': serializer.toJson<int>(carId),
    };
  }

  PartCar copyWith({int? partId, int? carId}) =>
      PartCar(partId: partId ?? this.partId, carId: carId ?? this.carId);
  PartCar copyWithCompanion(PartCarsCompanion data) {
    return PartCar(
      partId: data.partId.present ? data.partId.value : this.partId,
      carId: data.carId.present ? data.carId.value : this.carId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartCar(')
          ..write('partId: $partId, ')
          ..write('carId: $carId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(partId, carId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartCar &&
          other.partId == this.partId &&
          other.carId == this.carId);
}

class PartCarsCompanion extends UpdateCompanion<PartCar> {
  final Value<int> partId;
  final Value<int> carId;
  final Value<int> rowid;
  const PartCarsCompanion({
    this.partId = const Value.absent(),
    this.carId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartCarsCompanion.insert({
    required int partId,
    required int carId,
    this.rowid = const Value.absent(),
  }) : partId = Value(partId),
       carId = Value(carId);
  static Insertable<PartCar> custom({
    Expression<int>? partId,
    Expression<int>? carId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (partId != null) 'part_id': partId,
      if (carId != null) 'car_id': carId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartCarsCompanion copyWith({
    Value<int>? partId,
    Value<int>? carId,
    Value<int>? rowid,
  }) {
    return PartCarsCompanion(
      partId: partId ?? this.partId,
      carId: carId ?? this.carId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartCarsCompanion(')
          ..write('partId: $partId, ')
          ..write('carId: $carId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartUnitsTable extends PartUnits
    with TableInfo<$PartUnitsTable, PartUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartUnitsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartUnitsTable createAlias(String alias) {
    return $PartUnitsTable(attachedDatabase, alias);
  }
}

class PartUnit extends DataClass implements Insertable<PartUnit> {
  final int id;
  final String name;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PartUnit({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartUnitsCompanion toCompanion(bool nullToAbsent) {
    return PartUnitsCompanion(
      id: Value(id),
      name: Value(name),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PartUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartUnit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PartUnit copyWith({
    int? id,
    String? name,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartUnit(
    id: id ?? this.id,
    name: name ?? this.name,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PartUnit copyWithCompanion(PartUnitsCompanion data) {
    return PartUnit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartUnit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartUnit &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartUnitsCompanion extends UpdateCompanion<PartUnit> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PartUnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PartUnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PartUnit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PartUnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PartUnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartUnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    iconKey,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<Service> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final String name;

  /// Optional catalog key; null ⇒ default handyman icon.
  final String? iconKey;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Service({
    required this.id,
    required this.name,
    this.iconKey,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || iconKey != null) {
      map['icon_key'] = Variable<String>(iconKey);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      name: Value(name),
      iconKey: iconKey == null && nullToAbsent
          ? const Value.absent()
          : Value(iconKey),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Service.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconKey: serializer.fromJson<String?>(json['iconKey']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconKey': serializer.toJson<String?>(iconKey),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Service copyWith({
    int? id,
    String? name,
    Value<String?> iconKey = const Value.absent(),
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Service(
    id: id ?? this.id,
    name: name ?? this.name,
    iconKey: iconKey.present ? iconKey.value : this.iconKey,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, iconKey, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconKey == this.iconKey &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> iconKey;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.iconKey = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iconKey,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconKey != null) 'icon_key': iconKey,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? iconKey,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ServiceCentersTable extends ServiceCenters
    with TableInfo<$ServiceCentersTable, ServiceCenter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCentersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_centers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceCenter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceCenter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCenter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ServiceCentersTable createAlias(String alias) {
    return $ServiceCentersTable(attachedDatabase, alias);
  }
}

class ServiceCenter extends DataClass implements Insertable<ServiceCenter> {
  final int id;
  final String name;
  final String? address;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ServiceCenter({
    required this.id,
    required this.name,
    this.address,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServiceCentersCompanion toCompanion(bool nullToAbsent) {
    return ServiceCentersCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ServiceCenter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCenter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ServiceCenter copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ServiceCenter(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ServiceCenter copyWithCompanion(ServiceCentersCompanion data) {
    return ServiceCenter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCenter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, address, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCenter &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServiceCentersCompanion extends UpdateCompanion<ServiceCenter> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ServiceCentersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ServiceCentersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ServiceCenter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ServiceCentersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ServiceCentersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCentersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GasStationChainsTable extends GasStationChains
    with TableInfo<$GasStationChainsTable, GasStationChain> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GasStationChainsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gas_station_chains';
  @override
  VerificationContext validateIntegrity(
    Insertable<GasStationChain> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GasStationChain map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GasStationChain(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GasStationChainsTable createAlias(String alias) {
    return $GasStationChainsTable(attachedDatabase, alias);
  }
}

class GasStationChain extends DataClass implements Insertable<GasStationChain> {
  final int id;
  final String name;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GasStationChain({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GasStationChainsCompanion toCompanion(bool nullToAbsent) {
    return GasStationChainsCompanion(
      id: Value(id),
      name: Value(name),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GasStationChain.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GasStationChain(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GasStationChain copyWith({
    int? id,
    String? name,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GasStationChain(
    id: id ?? this.id,
    name: name ?? this.name,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GasStationChain copyWithCompanion(GasStationChainsCompanion data) {
    return GasStationChain(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GasStationChain(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GasStationChain &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GasStationChainsCompanion extends UpdateCompanion<GasStationChain> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const GasStationChainsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GasStationChainsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<GasStationChain> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GasStationChainsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return GasStationChainsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GasStationChainsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GasStationLocationsTable extends GasStationLocations
    with TableInfo<$GasStationLocationsTable, GasStationLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GasStationLocationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chainIdMeta = const VerificationMeta(
    'chainId',
  );
  @override
  late final GeneratedColumn<int> chainId = GeneratedColumn<int>(
    'chain_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chainId,
    address,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gas_station_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<GasStationLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chain_id')) {
      context.handle(
        _chainIdMeta,
        chainId.isAcceptableOrUnknown(data['chain_id']!, _chainIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chainIdMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GasStationLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GasStationLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chainId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chain_id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GasStationLocationsTable createAlias(String alias) {
    return $GasStationLocationsTable(attachedDatabase, alias);
  }
}

class GasStationLocation extends DataClass
    implements Insertable<GasStationLocation> {
  final int id;
  final int chainId;
  final String? address;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GasStationLocation({
    required this.id,
    required this.chainId,
    this.address,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chain_id'] = Variable<int>(chainId);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GasStationLocationsCompanion toCompanion(bool nullToAbsent) {
    return GasStationLocationsCompanion(
      id: Value(id),
      chainId: Value(chainId),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GasStationLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GasStationLocation(
      id: serializer.fromJson<int>(json['id']),
      chainId: serializer.fromJson<int>(json['chainId']),
      address: serializer.fromJson<String?>(json['address']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chainId': serializer.toJson<int>(chainId),
      'address': serializer.toJson<String?>(address),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GasStationLocation copyWith({
    int? id,
    int? chainId,
    Value<String?> address = const Value.absent(),
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GasStationLocation(
    id: id ?? this.id,
    chainId: chainId ?? this.chainId,
    address: address.present ? address.value : this.address,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GasStationLocation copyWithCompanion(GasStationLocationsCompanion data) {
    return GasStationLocation(
      id: data.id.present ? data.id.value : this.id,
      chainId: data.chainId.present ? data.chainId.value : this.chainId,
      address: data.address.present ? data.address.value : this.address,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GasStationLocation(')
          ..write('id: $id, ')
          ..write('chainId: $chainId, ')
          ..write('address: $address, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chainId, address, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GasStationLocation &&
          other.id == this.id &&
          other.chainId == this.chainId &&
          other.address == this.address &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GasStationLocationsCompanion extends UpdateCompanion<GasStationLocation> {
  final Value<int> id;
  final Value<int> chainId;
  final Value<String?> address;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const GasStationLocationsCompanion({
    this.id = const Value.absent(),
    this.chainId = const Value.absent(),
    this.address = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GasStationLocationsCompanion.insert({
    this.id = const Value.absent(),
    required int chainId,
    this.address = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : chainId = Value(chainId);
  static Insertable<GasStationLocation> custom({
    Expression<int>? id,
    Expression<int>? chainId,
    Expression<String>? address,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chainId != null) 'chain_id': chainId,
      if (address != null) 'address': address,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GasStationLocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? chainId,
    Value<String?>? address,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return GasStationLocationsCompanion(
      id: id ?? this.id,
      chainId: chainId ?? this.chainId,
      address: address ?? this.address,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chainId.present) {
      map['chain_id'] = Variable<int>(chainId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GasStationLocationsCompanion(')
          ..write('id: $id, ')
          ..write('chainId: $chainId, ')
          ..write('address: $address, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FuelingsTable extends Fuelings with TableInfo<$FuelingsTable, Fueling> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelTypeIdMeta = const VerificationMeta(
    'fuelTypeId',
  );
  @override
  late final GeneratedColumn<int> fuelTypeId = GeneratedColumn<int>(
    'fuel_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gasStationIdMeta = const VerificationMeta(
    'gasStationId',
  );
  @override
  late final GeneratedColumn<int> gasStationId = GeneratedColumn<int>(
    'gas_station_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fueledAtMeta = const VerificationMeta(
    'fueledAt',
  );
  @override
  late final GeneratedColumn<DateTime> fueledAt = GeneratedColumn<DateTime>(
    'fueled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerLiterMeta = const VerificationMeta(
    'pricePerLiter',
  );
  @override
  late final GeneratedColumn<double> pricePerLiter = GeneratedColumn<double>(
    'price_per_liter',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _litersMeta = const VerificationMeta('liters');
  @override
  late final GeneratedColumn<double> liters = GeneratedColumn<double>(
    'liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _odometerKmMeta = const VerificationMeta(
    'odometerKm',
  );
  @override
  late final GeneratedColumn<double> odometerKm = GeneratedColumn<double>(
    'odometer_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    carId,
    fuelTypeId,
    gasStationId,
    fueledAt,
    pricePerLiter,
    liters,
    totalAmount,
    currencyCode,
    odometerKm,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuelings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Fueling> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('fuel_type_id')) {
      context.handle(
        _fuelTypeIdMeta,
        fuelTypeId.isAcceptableOrUnknown(
          data['fuel_type_id']!,
          _fuelTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('gas_station_id')) {
      context.handle(
        _gasStationIdMeta,
        gasStationId.isAcceptableOrUnknown(
          data['gas_station_id']!,
          _gasStationIdMeta,
        ),
      );
    }
    if (data.containsKey('fueled_at')) {
      context.handle(
        _fueledAtMeta,
        fueledAt.isAcceptableOrUnknown(data['fueled_at']!, _fueledAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fueledAtMeta);
    }
    if (data.containsKey('price_per_liter')) {
      context.handle(
        _pricePerLiterMeta,
        pricePerLiter.isAcceptableOrUnknown(
          data['price_per_liter']!,
          _pricePerLiterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerLiterMeta);
    }
    if (data.containsKey('liters')) {
      context.handle(
        _litersMeta,
        liters.isAcceptableOrUnknown(data['liters']!, _litersMeta),
      );
    } else if (isInserting) {
      context.missing(_litersMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
        _odometerKmMeta,
        odometerKm.isAcceptableOrUnknown(data['odometer_km']!, _odometerKmMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Fueling map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Fueling(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}car_id'],
      )!,
      fuelTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fuel_type_id'],
      ),
      gasStationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gas_station_id'],
      ),
      fueledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fueled_at'],
      )!,
      pricePerLiter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_liter'],
      )!,
      liters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}liters'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      odometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_km'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FuelingsTable createAlias(String alias) {
    return $FuelingsTable(attachedDatabase, alias);
  }
}

class Fueling extends DataClass implements Insertable<Fueling> {
  final int id;
  final int carId;
  final int? fuelTypeId;

  /// Points to a concrete location (chain + optional address).
  final int? gasStationId;
  final DateTime fueledAt;
  final double pricePerLiter;
  final double liters;
  final double totalAmount;

  /// ISO-like currency code snapshot at save time (e.g. EUR, RSD).
  final String currencyCode;

  /// Odometer reading stored in kilometers; null if not provided.
  final double? odometerKm;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Fueling({
    required this.id,
    required this.carId,
    this.fuelTypeId,
    this.gasStationId,
    required this.fueledAt,
    required this.pricePerLiter,
    required this.liters,
    required this.totalAmount,
    required this.currencyCode,
    this.odometerKm,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['car_id'] = Variable<int>(carId);
    if (!nullToAbsent || fuelTypeId != null) {
      map['fuel_type_id'] = Variable<int>(fuelTypeId);
    }
    if (!nullToAbsent || gasStationId != null) {
      map['gas_station_id'] = Variable<int>(gasStationId);
    }
    map['fueled_at'] = Variable<DateTime>(fueledAt);
    map['price_per_liter'] = Variable<double>(pricePerLiter);
    map['liters'] = Variable<double>(liters);
    map['total_amount'] = Variable<double>(totalAmount);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || odometerKm != null) {
      map['odometer_km'] = Variable<double>(odometerKm);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FuelingsCompanion toCompanion(bool nullToAbsent) {
    return FuelingsCompanion(
      id: Value(id),
      carId: Value(carId),
      fuelTypeId: fuelTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelTypeId),
      gasStationId: gasStationId == null && nullToAbsent
          ? const Value.absent()
          : Value(gasStationId),
      fueledAt: Value(fueledAt),
      pricePerLiter: Value(pricePerLiter),
      liters: Value(liters),
      totalAmount: Value(totalAmount),
      currencyCode: Value(currencyCode),
      odometerKm: odometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerKm),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Fueling.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Fueling(
      id: serializer.fromJson<int>(json['id']),
      carId: serializer.fromJson<int>(json['carId']),
      fuelTypeId: serializer.fromJson<int?>(json['fuelTypeId']),
      gasStationId: serializer.fromJson<int?>(json['gasStationId']),
      fueledAt: serializer.fromJson<DateTime>(json['fueledAt']),
      pricePerLiter: serializer.fromJson<double>(json['pricePerLiter']),
      liters: serializer.fromJson<double>(json['liters']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      odometerKm: serializer.fromJson<double?>(json['odometerKm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'carId': serializer.toJson<int>(carId),
      'fuelTypeId': serializer.toJson<int?>(fuelTypeId),
      'gasStationId': serializer.toJson<int?>(gasStationId),
      'fueledAt': serializer.toJson<DateTime>(fueledAt),
      'pricePerLiter': serializer.toJson<double>(pricePerLiter),
      'liters': serializer.toJson<double>(liters),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'odometerKm': serializer.toJson<double?>(odometerKm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Fueling copyWith({
    int? id,
    int? carId,
    Value<int?> fuelTypeId = const Value.absent(),
    Value<int?> gasStationId = const Value.absent(),
    DateTime? fueledAt,
    double? pricePerLiter,
    double? liters,
    double? totalAmount,
    String? currencyCode,
    Value<double?> odometerKm = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Fueling(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    fuelTypeId: fuelTypeId.present ? fuelTypeId.value : this.fuelTypeId,
    gasStationId: gasStationId.present ? gasStationId.value : this.gasStationId,
    fueledAt: fueledAt ?? this.fueledAt,
    pricePerLiter: pricePerLiter ?? this.pricePerLiter,
    liters: liters ?? this.liters,
    totalAmount: totalAmount ?? this.totalAmount,
    currencyCode: currencyCode ?? this.currencyCode,
    odometerKm: odometerKm.present ? odometerKm.value : this.odometerKm,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Fueling copyWithCompanion(FuelingsCompanion data) {
    return Fueling(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      fuelTypeId: data.fuelTypeId.present
          ? data.fuelTypeId.value
          : this.fuelTypeId,
      gasStationId: data.gasStationId.present
          ? data.gasStationId.value
          : this.gasStationId,
      fueledAt: data.fueledAt.present ? data.fueledAt.value : this.fueledAt,
      pricePerLiter: data.pricePerLiter.present
          ? data.pricePerLiter.value
          : this.pricePerLiter,
      liters: data.liters.present ? data.liters.value : this.liters,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      odometerKm: data.odometerKm.present
          ? data.odometerKm.value
          : this.odometerKm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Fueling(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('fuelTypeId: $fuelTypeId, ')
          ..write('gasStationId: $gasStationId, ')
          ..write('fueledAt: $fueledAt, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('liters: $liters, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    carId,
    fuelTypeId,
    gasStationId,
    fueledAt,
    pricePerLiter,
    liters,
    totalAmount,
    currencyCode,
    odometerKm,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Fueling &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.fuelTypeId == this.fuelTypeId &&
          other.gasStationId == this.gasStationId &&
          other.fueledAt == this.fueledAt &&
          other.pricePerLiter == this.pricePerLiter &&
          other.liters == this.liters &&
          other.totalAmount == this.totalAmount &&
          other.currencyCode == this.currencyCode &&
          other.odometerKm == this.odometerKm &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FuelingsCompanion extends UpdateCompanion<Fueling> {
  final Value<int> id;
  final Value<int> carId;
  final Value<int?> fuelTypeId;
  final Value<int?> gasStationId;
  final Value<DateTime> fueledAt;
  final Value<double> pricePerLiter;
  final Value<double> liters;
  final Value<double> totalAmount;
  final Value<String> currencyCode;
  final Value<double?> odometerKm;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FuelingsCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.fuelTypeId = const Value.absent(),
    this.gasStationId = const Value.absent(),
    this.fueledAt = const Value.absent(),
    this.pricePerLiter = const Value.absent(),
    this.liters = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FuelingsCompanion.insert({
    this.id = const Value.absent(),
    required int carId,
    this.fuelTypeId = const Value.absent(),
    this.gasStationId = const Value.absent(),
    required DateTime fueledAt,
    required double pricePerLiter,
    required double liters,
    required double totalAmount,
    this.currencyCode = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : carId = Value(carId),
       fueledAt = Value(fueledAt),
       pricePerLiter = Value(pricePerLiter),
       liters = Value(liters),
       totalAmount = Value(totalAmount);
  static Insertable<Fueling> custom({
    Expression<int>? id,
    Expression<int>? carId,
    Expression<int>? fuelTypeId,
    Expression<int>? gasStationId,
    Expression<DateTime>? fueledAt,
    Expression<double>? pricePerLiter,
    Expression<double>? liters,
    Expression<double>? totalAmount,
    Expression<String>? currencyCode,
    Expression<double>? odometerKm,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (fuelTypeId != null) 'fuel_type_id': fuelTypeId,
      if (gasStationId != null) 'gas_station_id': gasStationId,
      if (fueledAt != null) 'fueled_at': fueledAt,
      if (pricePerLiter != null) 'price_per_liter': pricePerLiter,
      if (liters != null) 'liters': liters,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FuelingsCompanion copyWith({
    Value<int>? id,
    Value<int>? carId,
    Value<int?>? fuelTypeId,
    Value<int?>? gasStationId,
    Value<DateTime>? fueledAt,
    Value<double>? pricePerLiter,
    Value<double>? liters,
    Value<double>? totalAmount,
    Value<String>? currencyCode,
    Value<double?>? odometerKm,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FuelingsCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      fuelTypeId: fuelTypeId ?? this.fuelTypeId,
      gasStationId: gasStationId ?? this.gasStationId,
      fueledAt: fueledAt ?? this.fueledAt,
      pricePerLiter: pricePerLiter ?? this.pricePerLiter,
      liters: liters ?? this.liters,
      totalAmount: totalAmount ?? this.totalAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      odometerKm: odometerKm ?? this.odometerKm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (fuelTypeId.present) {
      map['fuel_type_id'] = Variable<int>(fuelTypeId.value);
    }
    if (gasStationId.present) {
      map['gas_station_id'] = Variable<int>(gasStationId.value);
    }
    if (fueledAt.present) {
      map['fueled_at'] = Variable<DateTime>(fueledAt.value);
    }
    if (pricePerLiter.present) {
      map['price_per_liter'] = Variable<double>(pricePerLiter.value);
    }
    if (liters.present) {
      map['liters'] = Variable<double>(liters.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<double>(odometerKm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelingsCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('fuelTypeId: $fuelTypeId, ')
          ..write('gasStationId: $gasStationId, ')
          ..write('fueledAt: $fueledAt, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('liters: $liters, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MaintenancesTable extends Maintenances
    with TableInfo<$MaintenancesTable, Maintenance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenancesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<int> reminderId = GeneratedColumn<int>(
    'reminder_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servicedAtMeta = const VerificationMeta(
    'servicedAt',
  );
  @override
  late final GeneratedColumn<DateTime> servicedAt = GeneratedColumn<DateTime>(
    'serviced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _odometerKmMeta = const VerificationMeta(
    'odometerKm',
  );
  @override
  late final GeneratedColumn<double> odometerKm = GeneratedColumn<double>(
    'odometer_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    carId,
    serviceId,
    reminderId,
    servicedAt,
    totalAmount,
    currencyCode,
    odometerKm,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Maintenance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    }
    if (data.containsKey('serviced_at')) {
      context.handle(
        _servicedAtMeta,
        servicedAt.isAcceptableOrUnknown(data['serviced_at']!, _servicedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_servicedAtMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
        _odometerKmMeta,
        odometerKm.isAcceptableOrUnknown(data['odometer_km']!, _odometerKmMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Maintenance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Maintenance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}car_id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      ),
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_id'],
      ),
      servicedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}serviced_at'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      odometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_km'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MaintenancesTable createAlias(String alias) {
    return $MaintenancesTable(attachedDatabase, alias);
  }
}

class Maintenance extends DataClass implements Insertable<Maintenance> {
  final int id;
  final int carId;
  final int? serviceId;

  /// Optional linked reminder; title is synced from the service name.
  final int? reminderId;
  final DateTime servicedAt;

  /// Cost of the service; null if not provided.
  final double? totalAmount;

  /// ISO-like currency code snapshot at save time (e.g. EUR, RSD).
  final String currencyCode;

  /// Odometer reading stored in kilometers; null if not provided.
  final double? odometerKm;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Maintenance({
    required this.id,
    required this.carId,
    this.serviceId,
    this.reminderId,
    required this.servicedAt,
    this.totalAmount,
    required this.currencyCode,
    this.odometerKm,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['car_id'] = Variable<int>(carId);
    if (!nullToAbsent || serviceId != null) {
      map['service_id'] = Variable<int>(serviceId);
    }
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<int>(reminderId);
    }
    map['serviced_at'] = Variable<DateTime>(servicedAt);
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<double>(totalAmount);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || odometerKm != null) {
      map['odometer_km'] = Variable<double>(odometerKm);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MaintenancesCompanion toCompanion(bool nullToAbsent) {
    return MaintenancesCompanion(
      id: Value(id),
      carId: Value(carId),
      serviceId: serviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceId),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      servicedAt: Value(servicedAt),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      currencyCode: Value(currencyCode),
      odometerKm: odometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerKm),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Maintenance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Maintenance(
      id: serializer.fromJson<int>(json['id']),
      carId: serializer.fromJson<int>(json['carId']),
      serviceId: serializer.fromJson<int?>(json['serviceId']),
      reminderId: serializer.fromJson<int?>(json['reminderId']),
      servicedAt: serializer.fromJson<DateTime>(json['servicedAt']),
      totalAmount: serializer.fromJson<double?>(json['totalAmount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      odometerKm: serializer.fromJson<double?>(json['odometerKm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'carId': serializer.toJson<int>(carId),
      'serviceId': serializer.toJson<int?>(serviceId),
      'reminderId': serializer.toJson<int?>(reminderId),
      'servicedAt': serializer.toJson<DateTime>(servicedAt),
      'totalAmount': serializer.toJson<double?>(totalAmount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'odometerKm': serializer.toJson<double?>(odometerKm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Maintenance copyWith({
    int? id,
    int? carId,
    Value<int?> serviceId = const Value.absent(),
    Value<int?> reminderId = const Value.absent(),
    DateTime? servicedAt,
    Value<double?> totalAmount = const Value.absent(),
    String? currencyCode,
    Value<double?> odometerKm = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Maintenance(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    serviceId: serviceId.present ? serviceId.value : this.serviceId,
    reminderId: reminderId.present ? reminderId.value : this.reminderId,
    servicedAt: servicedAt ?? this.servicedAt,
    totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
    currencyCode: currencyCode ?? this.currencyCode,
    odometerKm: odometerKm.present ? odometerKm.value : this.odometerKm,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Maintenance copyWithCompanion(MaintenancesCompanion data) {
    return Maintenance(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      servicedAt: data.servicedAt.present
          ? data.servicedAt.value
          : this.servicedAt,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      odometerKm: data.odometerKm.present
          ? data.odometerKm.value
          : this.odometerKm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Maintenance(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('serviceId: $serviceId, ')
          ..write('reminderId: $reminderId, ')
          ..write('servicedAt: $servicedAt, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    carId,
    serviceId,
    reminderId,
    servicedAt,
    totalAmount,
    currencyCode,
    odometerKm,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Maintenance &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.serviceId == this.serviceId &&
          other.reminderId == this.reminderId &&
          other.servicedAt == this.servicedAt &&
          other.totalAmount == this.totalAmount &&
          other.currencyCode == this.currencyCode &&
          other.odometerKm == this.odometerKm &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MaintenancesCompanion extends UpdateCompanion<Maintenance> {
  final Value<int> id;
  final Value<int> carId;
  final Value<int?> serviceId;
  final Value<int?> reminderId;
  final Value<DateTime> servicedAt;
  final Value<double?> totalAmount;
  final Value<String> currencyCode;
  final Value<double?> odometerKm;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MaintenancesCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.servicedAt = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MaintenancesCompanion.insert({
    this.id = const Value.absent(),
    required int carId,
    this.serviceId = const Value.absent(),
    this.reminderId = const Value.absent(),
    required DateTime servicedAt,
    this.totalAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : carId = Value(carId),
       servicedAt = Value(servicedAt);
  static Insertable<Maintenance> custom({
    Expression<int>? id,
    Expression<int>? carId,
    Expression<int>? serviceId,
    Expression<int>? reminderId,
    Expression<DateTime>? servicedAt,
    Expression<double>? totalAmount,
    Expression<String>? currencyCode,
    Expression<double>? odometerKm,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (serviceId != null) 'service_id': serviceId,
      if (reminderId != null) 'reminder_id': reminderId,
      if (servicedAt != null) 'serviced_at': servicedAt,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MaintenancesCompanion copyWith({
    Value<int>? id,
    Value<int>? carId,
    Value<int?>? serviceId,
    Value<int?>? reminderId,
    Value<DateTime>? servicedAt,
    Value<double?>? totalAmount,
    Value<String>? currencyCode,
    Value<double?>? odometerKm,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MaintenancesCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      serviceId: serviceId ?? this.serviceId,
      reminderId: reminderId ?? this.reminderId,
      servicedAt: servicedAt ?? this.servicedAt,
      totalAmount: totalAmount ?? this.totalAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      odometerKm: odometerKm ?? this.odometerKm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<int>(reminderId.value);
    }
    if (servicedAt.present) {
      map['serviced_at'] = Variable<DateTime>(servicedAt.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<double>(odometerKm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenancesCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('serviceId: $serviceId, ')
          ..write('reminderId: $reminderId, ')
          ..write('servicedAt: $servicedAt, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MaintenancePartsTable extends MaintenanceParts
    with TableInfo<$MaintenancePartsTable, MaintenancePart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenancePartsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _maintenanceIdMeta = const VerificationMeta(
    'maintenanceId',
  );
  @override
  late final GeneratedColumn<int> maintenanceId = GeneratedColumn<int>(
    'maintenance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    maintenanceId,
    partId,
    quantity,
    unitId,
    amount,
    comment,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenancePart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('maintenance_id')) {
      context.handle(
        _maintenanceIdMeta,
        maintenanceId.isAcceptableOrUnknown(
          data['maintenance_id']!,
          _maintenanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maintenanceIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenancePart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenancePart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      maintenanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maintenance_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MaintenancePartsTable createAlias(String alias) {
    return $MaintenancePartsTable(attachedDatabase, alias);
  }
}

class MaintenancePart extends DataClass implements Insertable<MaintenancePart> {
  final int id;
  final int maintenanceId;
  final int? partId;
  final double quantity;
  final int? unitId;

  /// Unit price; null if not provided.
  final double? amount;

  /// Optional free-text note for this part line.
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MaintenancePart({
    required this.id,
    required this.maintenanceId,
    this.partId,
    required this.quantity,
    this.unitId,
    this.amount,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['maintenance_id'] = Variable<int>(maintenanceId);
    if (!nullToAbsent || partId != null) {
      map['part_id'] = Variable<int>(partId);
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<int>(unitId);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MaintenancePartsCompanion toCompanion(bool nullToAbsent) {
    return MaintenancePartsCompanion(
      id: Value(id),
      maintenanceId: Value(maintenanceId),
      partId: partId == null && nullToAbsent
          ? const Value.absent()
          : Value(partId),
      quantity: Value(quantity),
      unitId: unitId == null && nullToAbsent
          ? const Value.absent()
          : Value(unitId),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MaintenancePart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenancePart(
      id: serializer.fromJson<int>(json['id']),
      maintenanceId: serializer.fromJson<int>(json['maintenanceId']),
      partId: serializer.fromJson<int?>(json['partId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitId: serializer.fromJson<int?>(json['unitId']),
      amount: serializer.fromJson<double?>(json['amount']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maintenanceId': serializer.toJson<int>(maintenanceId),
      'partId': serializer.toJson<int?>(partId),
      'quantity': serializer.toJson<double>(quantity),
      'unitId': serializer.toJson<int?>(unitId),
      'amount': serializer.toJson<double?>(amount),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MaintenancePart copyWith({
    int? id,
    int? maintenanceId,
    Value<int?> partId = const Value.absent(),
    double? quantity,
    Value<int?> unitId = const Value.absent(),
    Value<double?> amount = const Value.absent(),
    Value<String?> comment = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MaintenancePart(
    id: id ?? this.id,
    maintenanceId: maintenanceId ?? this.maintenanceId,
    partId: partId.present ? partId.value : this.partId,
    quantity: quantity ?? this.quantity,
    unitId: unitId.present ? unitId.value : this.unitId,
    amount: amount.present ? amount.value : this.amount,
    comment: comment.present ? comment.value : this.comment,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MaintenancePart copyWithCompanion(MaintenancePartsCompanion data) {
    return MaintenancePart(
      id: data.id.present ? data.id.value : this.id,
      maintenanceId: data.maintenanceId.present
          ? data.maintenanceId.value
          : this.maintenanceId,
      partId: data.partId.present ? data.partId.value : this.partId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      amount: data.amount.present ? data.amount.value : this.amount,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenancePart(')
          ..write('id: $id, ')
          ..write('maintenanceId: $maintenanceId, ')
          ..write('partId: $partId, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('amount: $amount, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    maintenanceId,
    partId,
    quantity,
    unitId,
    amount,
    comment,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenancePart &&
          other.id == this.id &&
          other.maintenanceId == this.maintenanceId &&
          other.partId == this.partId &&
          other.quantity == this.quantity &&
          other.unitId == this.unitId &&
          other.amount == this.amount &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MaintenancePartsCompanion extends UpdateCompanion<MaintenancePart> {
  final Value<int> id;
  final Value<int> maintenanceId;
  final Value<int?> partId;
  final Value<double> quantity;
  final Value<int?> unitId;
  final Value<double?> amount;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MaintenancePartsCompanion({
    this.id = const Value.absent(),
    this.maintenanceId = const Value.absent(),
    this.partId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitId = const Value.absent(),
    this.amount = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MaintenancePartsCompanion.insert({
    this.id = const Value.absent(),
    required int maintenanceId,
    this.partId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitId = const Value.absent(),
    this.amount = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : maintenanceId = Value(maintenanceId);
  static Insertable<MaintenancePart> custom({
    Expression<int>? id,
    Expression<int>? maintenanceId,
    Expression<int>? partId,
    Expression<double>? quantity,
    Expression<int>? unitId,
    Expression<double>? amount,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maintenanceId != null) 'maintenance_id': maintenanceId,
      if (partId != null) 'part_id': partId,
      if (quantity != null) 'quantity': quantity,
      if (unitId != null) 'unit_id': unitId,
      if (amount != null) 'amount': amount,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MaintenancePartsCompanion copyWith({
    Value<int>? id,
    Value<int>? maintenanceId,
    Value<int?>? partId,
    Value<double>? quantity,
    Value<int?>? unitId,
    Value<double?>? amount,
    Value<String?>? comment,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MaintenancePartsCompanion(
      id: id ?? this.id,
      maintenanceId: maintenanceId ?? this.maintenanceId,
      partId: partId ?? this.partId,
      quantity: quantity ?? this.quantity,
      unitId: unitId ?? this.unitId,
      amount: amount ?? this.amount,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maintenanceId.present) {
      map['maintenance_id'] = Variable<int>(maintenanceId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenancePartsCompanion(')
          ..write('id: $id, ')
          ..write('maintenanceId: $maintenanceId, ')
          ..write('partId: $partId, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('amount: $amount, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
    'car_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueOdometerKmMeta = const VerificationMeta(
    'dueOdometerKm',
  );
  @override
  late final GeneratedColumn<double> dueOdometerKm = GeneratedColumn<double>(
    'due_odometer_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindBeforeDaysMeta = const VerificationMeta(
    'remindBeforeDays',
  );
  @override
  late final GeneratedColumn<int> remindBeforeDays = GeneratedColumn<int>(
    'remind_before_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindBeforeKmMeta = const VerificationMeta(
    'remindBeforeKm',
  );
  @override
  late final GeneratedColumn<double> remindBeforeKm = GeneratedColumn<double>(
    'remind_before_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    carId,
    title,
    dueAt,
    dueOdometerKm,
    remindBeforeDays,
    remindBeforeKm,
    isCompleted,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('car_id')) {
      context.handle(
        _carIdMeta,
        carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta),
      );
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('due_odometer_km')) {
      context.handle(
        _dueOdometerKmMeta,
        dueOdometerKm.isAcceptableOrUnknown(
          data['due_odometer_km']!,
          _dueOdometerKmMeta,
        ),
      );
    }
    if (data.containsKey('remind_before_days')) {
      context.handle(
        _remindBeforeDaysMeta,
        remindBeforeDays.isAcceptableOrUnknown(
          data['remind_before_days']!,
          _remindBeforeDaysMeta,
        ),
      );
    }
    if (data.containsKey('remind_before_km')) {
      context.handle(
        _remindBeforeKmMeta,
        remindBeforeKm.isAcceptableOrUnknown(
          data['remind_before_km']!,
          _remindBeforeKmMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      carId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}car_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      dueOdometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}due_odometer_km'],
      ),
      remindBeforeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_before_days'],
      ),
      remindBeforeKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remind_before_km'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int carId;
  final String title;

  /// Target date; null if mileage-only.
  final DateTime? dueAt;

  /// Target odometer in km; null if date-only.
  final double? dueOdometerKm;

  /// Days before [dueAt] to enter the "soon" (orange) state.
  final int? remindBeforeDays;

  /// Kilometers before [dueOdometerKm] to enter the "soon" (orange) state.
  final double? remindBeforeKm;
  final bool isCompleted;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Reminder({
    required this.id,
    required this.carId,
    required this.title,
    this.dueAt,
    this.dueOdometerKm,
    this.remindBeforeDays,
    this.remindBeforeKm,
    required this.isCompleted,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['car_id'] = Variable<int>(carId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || dueOdometerKm != null) {
      map['due_odometer_km'] = Variable<double>(dueOdometerKm);
    }
    if (!nullToAbsent || remindBeforeDays != null) {
      map['remind_before_days'] = Variable<int>(remindBeforeDays);
    }
    if (!nullToAbsent || remindBeforeKm != null) {
      map['remind_before_km'] = Variable<double>(remindBeforeKm);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      carId: Value(carId),
      title: Value(title),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      dueOdometerKm: dueOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOdometerKm),
      remindBeforeDays: remindBeforeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(remindBeforeDays),
      remindBeforeKm: remindBeforeKm == null && nullToAbsent
          ? const Value.absent()
          : Value(remindBeforeKm),
      isCompleted: Value(isCompleted),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      carId: serializer.fromJson<int>(json['carId']),
      title: serializer.fromJson<String>(json['title']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      dueOdometerKm: serializer.fromJson<double?>(json['dueOdometerKm']),
      remindBeforeDays: serializer.fromJson<int?>(json['remindBeforeDays']),
      remindBeforeKm: serializer.fromJson<double?>(json['remindBeforeKm']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'carId': serializer.toJson<int>(carId),
      'title': serializer.toJson<String>(title),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'dueOdometerKm': serializer.toJson<double?>(dueOdometerKm),
      'remindBeforeDays': serializer.toJson<int?>(remindBeforeDays),
      'remindBeforeKm': serializer.toJson<double?>(remindBeforeKm),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reminder copyWith({
    int? id,
    int? carId,
    String? title,
    Value<DateTime?> dueAt = const Value.absent(),
    Value<double?> dueOdometerKm = const Value.absent(),
    Value<int?> remindBeforeDays = const Value.absent(),
    Value<double?> remindBeforeKm = const Value.absent(),
    bool? isCompleted,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Reminder(
    id: id ?? this.id,
    carId: carId ?? this.carId,
    title: title ?? this.title,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    dueOdometerKm: dueOdometerKm.present
        ? dueOdometerKm.value
        : this.dueOdometerKm,
    remindBeforeDays: remindBeforeDays.present
        ? remindBeforeDays.value
        : this.remindBeforeDays,
    remindBeforeKm: remindBeforeKm.present
        ? remindBeforeKm.value
        : this.remindBeforeKm,
    isCompleted: isCompleted ?? this.isCompleted,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      carId: data.carId.present ? data.carId.value : this.carId,
      title: data.title.present ? data.title.value : this.title,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      dueOdometerKm: data.dueOdometerKm.present
          ? data.dueOdometerKm.value
          : this.dueOdometerKm,
      remindBeforeDays: data.remindBeforeDays.present
          ? data.remindBeforeDays.value
          : this.remindBeforeDays,
      remindBeforeKm: data.remindBeforeKm.present
          ? data.remindBeforeKm.value
          : this.remindBeforeKm,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('dueOdometerKm: $dueOdometerKm, ')
          ..write('remindBeforeDays: $remindBeforeDays, ')
          ..write('remindBeforeKm: $remindBeforeKm, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    carId,
    title,
    dueAt,
    dueOdometerKm,
    remindBeforeDays,
    remindBeforeKm,
    isCompleted,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.title == this.title &&
          other.dueAt == this.dueAt &&
          other.dueOdometerKm == this.dueOdometerKm &&
          other.remindBeforeDays == this.remindBeforeDays &&
          other.remindBeforeKm == this.remindBeforeKm &&
          other.isCompleted == this.isCompleted &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> carId;
  final Value<String> title;
  final Value<DateTime?> dueAt;
  final Value<double?> dueOdometerKm;
  final Value<int?> remindBeforeDays;
  final Value<double?> remindBeforeKm;
  final Value<bool> isCompleted;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.dueOdometerKm = const Value.absent(),
    this.remindBeforeDays = const Value.absent(),
    this.remindBeforeKm = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int carId,
    required String title,
    this.dueAt = const Value.absent(),
    this.dueOdometerKm = const Value.absent(),
    this.remindBeforeDays = const Value.absent(),
    this.remindBeforeKm = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : carId = Value(carId),
       title = Value(title);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? carId,
    Expression<String>? title,
    Expression<DateTime>? dueAt,
    Expression<double>? dueOdometerKm,
    Expression<int>? remindBeforeDays,
    Expression<double>? remindBeforeKm,
    Expression<bool>? isCompleted,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (title != null) 'title': title,
      if (dueAt != null) 'due_at': dueAt,
      if (dueOdometerKm != null) 'due_odometer_km': dueOdometerKm,
      if (remindBeforeDays != null) 'remind_before_days': remindBeforeDays,
      if (remindBeforeKm != null) 'remind_before_km': remindBeforeKm,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? carId,
    Value<String>? title,
    Value<DateTime?>? dueAt,
    Value<double?>? dueOdometerKm,
    Value<int?>? remindBeforeDays,
    Value<double?>? remindBeforeKm,
    Value<bool>? isCompleted,
    Value<bool>? isDeleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      dueOdometerKm: dueOdometerKm ?? this.dueOdometerKm,
      remindBeforeDays: remindBeforeDays ?? this.remindBeforeDays,
      remindBeforeKm: remindBeforeKm ?? this.remindBeforeKm,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (dueOdometerKm.present) {
      map['due_odometer_km'] = Variable<double>(dueOdometerKm.value);
    }
    if (remindBeforeDays.present) {
      map['remind_before_days'] = Variable<int>(remindBeforeDays.value);
    }
    if (remindBeforeKm.present) {
      map['remind_before_km'] = Variable<double>(remindBeforeKm.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('dueOdometerKm: $dueOdometerKm, ')
          ..write('remindBeforeDays: $remindBeforeDays, ')
          ..write('remindBeforeKm: $remindBeforeKm, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FuelTypesTable fuelTypes = $FuelTypesTable(this);
  late final $CarBrandsTable carBrands = $CarBrandsTable(this);
  late final $CarsTable cars = $CarsTable(this);
  late final $FuelTypeCarsTable fuelTypeCars = $FuelTypeCarsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $PartCarsTable partCars = $PartCarsTable(this);
  late final $PartUnitsTable partUnits = $PartUnitsTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $ServiceCentersTable serviceCenters = $ServiceCentersTable(this);
  late final $GasStationChainsTable gasStationChains = $GasStationChainsTable(
    this,
  );
  late final $GasStationLocationsTable gasStationLocations =
      $GasStationLocationsTable(this);
  late final $FuelingsTable fuelings = $FuelingsTable(this);
  late final $MaintenancesTable maintenances = $MaintenancesTable(this);
  late final $MaintenancePartsTable maintenanceParts = $MaintenancePartsTable(
    this,
  );
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    fuelTypes,
    carBrands,
    cars,
    fuelTypeCars,
    parts,
    partCars,
    partUnits,
    services,
    serviceCenters,
    gasStationChains,
    gasStationLocations,
    fuelings,
    maintenances,
    maintenanceParts,
    reminders,
  ];
}

typedef $$FuelTypesTableCreateCompanionBuilder =
    FuelTypesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$FuelTypesTableUpdateCompanionBuilder =
    FuelTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$FuelTypesTableFilterComposer
    extends Composer<_$AppDatabase, $FuelTypesTable> {
  $$FuelTypesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FuelTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelTypesTable> {
  $$FuelTypesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FuelTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelTypesTable> {
  $$FuelTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FuelTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelTypesTable,
          FuelType,
          $$FuelTypesTableFilterComposer,
          $$FuelTypesTableOrderingComposer,
          $$FuelTypesTableAnnotationComposer,
          $$FuelTypesTableCreateCompanionBuilder,
          $$FuelTypesTableUpdateCompanionBuilder,
          (FuelType, BaseReferences<_$AppDatabase, $FuelTypesTable, FuelType>),
          FuelType,
          PrefetchHooks Function()
        > {
  $$FuelTypesTableTableManager(_$AppDatabase db, $FuelTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FuelTypesCompanion(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FuelTypesCompanion.insert(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FuelTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelTypesTable,
      FuelType,
      $$FuelTypesTableFilterComposer,
      $$FuelTypesTableOrderingComposer,
      $$FuelTypesTableAnnotationComposer,
      $$FuelTypesTableCreateCompanionBuilder,
      $$FuelTypesTableUpdateCompanionBuilder,
      (FuelType, BaseReferences<_$AppDatabase, $FuelTypesTable, FuelType>),
      FuelType,
      PrefetchHooks Function()
    >;
typedef $$CarBrandsTableCreateCompanionBuilder =
    CarBrandsCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$CarBrandsTableUpdateCompanionBuilder =
    CarBrandsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

class $$CarBrandsTableFilterComposer
    extends Composer<_$AppDatabase, $CarBrandsTable> {
  $$CarBrandsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CarBrandsTableOrderingComposer
    extends Composer<_$AppDatabase, $CarBrandsTable> {
  $$CarBrandsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CarBrandsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarBrandsTable> {
  $$CarBrandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CarBrandsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarBrandsTable,
          CarBrand,
          $$CarBrandsTableFilterComposer,
          $$CarBrandsTableOrderingComposer,
          $$CarBrandsTableAnnotationComposer,
          $$CarBrandsTableCreateCompanionBuilder,
          $$CarBrandsTableUpdateCompanionBuilder,
          (CarBrand, BaseReferences<_$AppDatabase, $CarBrandsTable, CarBrand>),
          CarBrand,
          PrefetchHooks Function()
        > {
  $$CarBrandsTableTableManager(_$AppDatabase db, $CarBrandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarBrandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarBrandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarBrandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) =>
                  CarBrandsCompanion(id: id, name: name, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CarBrandsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CarBrandsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarBrandsTable,
      CarBrand,
      $$CarBrandsTableFilterComposer,
      $$CarBrandsTableOrderingComposer,
      $$CarBrandsTableAnnotationComposer,
      $$CarBrandsTableCreateCompanionBuilder,
      $$CarBrandsTableUpdateCompanionBuilder,
      (CarBrand, BaseReferences<_$AppDatabase, $CarBrandsTable, CarBrand>),
      CarBrand,
      PrefetchHooks Function()
    >;
typedef $$CarsTableCreateCompanionBuilder =
    CarsCompanion Function({
      Value<int> id,
      required int brandId,
      Value<String?> model,
      Value<int?> year,
      Value<Uint8List?> photo,
      Value<int?> colorArgb,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CarsTableUpdateCompanionBuilder =
    CarsCompanion Function({
      Value<int> id,
      Value<int> brandId,
      Value<String?> model,
      Value<int?> year,
      Value<Uint8List?> photo,
      Value<int?> colorArgb,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CarsTableFilterComposer extends Composer<_$AppDatabase, $CarsTable> {
  $$CarsTableFilterComposer({
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

  ColumnFilters<int> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CarsTableOrderingComposer extends Composer<_$AppDatabase, $CarsTable> {
  $$CarsTableOrderingComposer({
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

  ColumnOrderings<int> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarsTable> {
  $$CarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<Uint8List> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarsTable,
          Car,
          $$CarsTableFilterComposer,
          $$CarsTableOrderingComposer,
          $$CarsTableAnnotationComposer,
          $$CarsTableCreateCompanionBuilder,
          $$CarsTableUpdateCompanionBuilder,
          (Car, BaseReferences<_$AppDatabase, $CarsTable, Car>),
          Car,
          PrefetchHooks Function()
        > {
  $$CarsTableTableManager(_$AppDatabase db, $CarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> brandId = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<int?> colorArgb = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CarsCompanion(
                id: id,
                brandId: brandId,
                model: model,
                year: year,
                photo: photo,
                colorArgb: colorArgb,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int brandId,
                Value<String?> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<Uint8List?> photo = const Value.absent(),
                Value<int?> colorArgb = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CarsCompanion.insert(
                id: id,
                brandId: brandId,
                model: model,
                year: year,
                photo: photo,
                colorArgb: colorArgb,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarsTable,
      Car,
      $$CarsTableFilterComposer,
      $$CarsTableOrderingComposer,
      $$CarsTableAnnotationComposer,
      $$CarsTableCreateCompanionBuilder,
      $$CarsTableUpdateCompanionBuilder,
      (Car, BaseReferences<_$AppDatabase, $CarsTable, Car>),
      Car,
      PrefetchHooks Function()
    >;
typedef $$FuelTypeCarsTableCreateCompanionBuilder =
    FuelTypeCarsCompanion Function({
      required int fuelTypeId,
      required int carId,
      Value<int> rowid,
    });
typedef $$FuelTypeCarsTableUpdateCompanionBuilder =
    FuelTypeCarsCompanion Function({
      Value<int> fuelTypeId,
      Value<int> carId,
      Value<int> rowid,
    });

class $$FuelTypeCarsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelTypeCarsTable> {
  $$FuelTypeCarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get fuelTypeId => $composableBuilder(
    column: $table.fuelTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FuelTypeCarsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelTypeCarsTable> {
  $$FuelTypeCarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get fuelTypeId => $composableBuilder(
    column: $table.fuelTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FuelTypeCarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelTypeCarsTable> {
  $$FuelTypeCarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get fuelTypeId => $composableBuilder(
    column: $table.fuelTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);
}

class $$FuelTypeCarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelTypeCarsTable,
          FuelTypeCar,
          $$FuelTypeCarsTableFilterComposer,
          $$FuelTypeCarsTableOrderingComposer,
          $$FuelTypeCarsTableAnnotationComposer,
          $$FuelTypeCarsTableCreateCompanionBuilder,
          $$FuelTypeCarsTableUpdateCompanionBuilder,
          (
            FuelTypeCar,
            BaseReferences<_$AppDatabase, $FuelTypeCarsTable, FuelTypeCar>,
          ),
          FuelTypeCar,
          PrefetchHooks Function()
        > {
  $$FuelTypeCarsTableTableManager(_$AppDatabase db, $FuelTypeCarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelTypeCarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelTypeCarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelTypeCarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> fuelTypeId = const Value.absent(),
                Value<int> carId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FuelTypeCarsCompanion(
                fuelTypeId: fuelTypeId,
                carId: carId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int fuelTypeId,
                required int carId,
                Value<int> rowid = const Value.absent(),
              }) => FuelTypeCarsCompanion.insert(
                fuelTypeId: fuelTypeId,
                carId: carId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FuelTypeCarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelTypeCarsTable,
      FuelTypeCar,
      $$FuelTypeCarsTableFilterComposer,
      $$FuelTypeCarsTableOrderingComposer,
      $$FuelTypeCarsTableAnnotationComposer,
      $$FuelTypeCarsTableCreateCompanionBuilder,
      $$FuelTypeCarsTableUpdateCompanionBuilder,
      (
        FuelTypeCar,
        BaseReferences<_$AppDatabase, $FuelTypeCarsTable, FuelTypeCar>,
      ),
      FuelTypeCar,
      PrefetchHooks Function()
    >;
typedef $$PartsTableCreateCompanionBuilder =
    PartsCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PartsTableUpdateCompanionBuilder =
    PartsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartsTable,
          Part,
          $$PartsTableFilterComposer,
          $$PartsTableOrderingComposer,
          $$PartsTableAnnotationComposer,
          $$PartsTableCreateCompanionBuilder,
          $$PartsTableUpdateCompanionBuilder,
          (Part, BaseReferences<_$AppDatabase, $PartsTable, Part>),
          Part,
          PrefetchHooks Function()
        > {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartsCompanion(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartsCompanion.insert(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartsTable,
      Part,
      $$PartsTableFilterComposer,
      $$PartsTableOrderingComposer,
      $$PartsTableAnnotationComposer,
      $$PartsTableCreateCompanionBuilder,
      $$PartsTableUpdateCompanionBuilder,
      (Part, BaseReferences<_$AppDatabase, $PartsTable, Part>),
      Part,
      PrefetchHooks Function()
    >;
typedef $$PartCarsTableCreateCompanionBuilder =
    PartCarsCompanion Function({
      required int partId,
      required int carId,
      Value<int> rowid,
    });
typedef $$PartCarsTableUpdateCompanionBuilder =
    PartCarsCompanion Function({
      Value<int> partId,
      Value<int> carId,
      Value<int> rowid,
    });

class $$PartCarsTableFilterComposer
    extends Composer<_$AppDatabase, $PartCarsTable> {
  $$PartCarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartCarsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartCarsTable> {
  $$PartCarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartCarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartCarsTable> {
  $$PartCarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);
}

class $$PartCarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartCarsTable,
          PartCar,
          $$PartCarsTableFilterComposer,
          $$PartCarsTableOrderingComposer,
          $$PartCarsTableAnnotationComposer,
          $$PartCarsTableCreateCompanionBuilder,
          $$PartCarsTableUpdateCompanionBuilder,
          (PartCar, BaseReferences<_$AppDatabase, $PartCarsTable, PartCar>),
          PartCar,
          PrefetchHooks Function()
        > {
  $$PartCarsTableTableManager(_$AppDatabase db, $PartCarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartCarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartCarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartCarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> partId = const Value.absent(),
                Value<int> carId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  PartCarsCompanion(partId: partId, carId: carId, rowid: rowid),
          createCompanionCallback:
              ({
                required int partId,
                required int carId,
                Value<int> rowid = const Value.absent(),
              }) => PartCarsCompanion.insert(
                partId: partId,
                carId: carId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartCarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartCarsTable,
      PartCar,
      $$PartCarsTableFilterComposer,
      $$PartCarsTableOrderingComposer,
      $$PartCarsTableAnnotationComposer,
      $$PartCarsTableCreateCompanionBuilder,
      $$PartCarsTableUpdateCompanionBuilder,
      (PartCar, BaseReferences<_$AppDatabase, $PartCarsTable, PartCar>),
      PartCar,
      PrefetchHooks Function()
    >;
typedef $$PartUnitsTableCreateCompanionBuilder =
    PartUnitsCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PartUnitsTableUpdateCompanionBuilder =
    PartUnitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PartUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $PartUnitsTable> {
  $$PartUnitsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartUnitsTable> {
  $$PartUnitsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartUnitsTable> {
  $$PartUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PartUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartUnitsTable,
          PartUnit,
          $$PartUnitsTableFilterComposer,
          $$PartUnitsTableOrderingComposer,
          $$PartUnitsTableAnnotationComposer,
          $$PartUnitsTableCreateCompanionBuilder,
          $$PartUnitsTableUpdateCompanionBuilder,
          (PartUnit, BaseReferences<_$AppDatabase, $PartUnitsTable, PartUnit>),
          PartUnit,
          PrefetchHooks Function()
        > {
  $$PartUnitsTableTableManager(_$AppDatabase db, $PartUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartUnitsCompanion(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartUnitsCompanion.insert(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartUnitsTable,
      PartUnit,
      $$PartUnitsTableFilterComposer,
      $$PartUnitsTableOrderingComposer,
      $$PartUnitsTableAnnotationComposer,
      $$PartUnitsTableCreateCompanionBuilder,
      $$PartUnitsTableUpdateCompanionBuilder,
      (PartUnit, BaseReferences<_$AppDatabase, $PartUnitsTable, PartUnit>),
      PartUnit,
      PrefetchHooks Function()
    >;
typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> iconKey,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> iconKey,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          Service,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (Service, BaseReferences<_$AppDatabase, $ServicesTable, Service>),
          Service,
          PrefetchHooks Function()
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                name: name,
                iconKey: iconKey,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> iconKey = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                name: name,
                iconKey: iconKey,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      Service,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (Service, BaseReferences<_$AppDatabase, $ServicesTable, Service>),
      Service,
      PrefetchHooks Function()
    >;
typedef $$ServiceCentersTableCreateCompanionBuilder =
    ServiceCentersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ServiceCentersTableUpdateCompanionBuilder =
    ServiceCentersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ServiceCentersTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceCentersTable> {
  $$ServiceCentersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceCentersTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceCentersTable> {
  $$ServiceCentersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceCentersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceCentersTable> {
  $$ServiceCentersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ServiceCentersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceCentersTable,
          ServiceCenter,
          $$ServiceCentersTableFilterComposer,
          $$ServiceCentersTableOrderingComposer,
          $$ServiceCentersTableAnnotationComposer,
          $$ServiceCentersTableCreateCompanionBuilder,
          $$ServiceCentersTableUpdateCompanionBuilder,
          (
            ServiceCenter,
            BaseReferences<_$AppDatabase, $ServiceCentersTable, ServiceCenter>,
          ),
          ServiceCenter,
          PrefetchHooks Function()
        > {
  $$ServiceCentersTableTableManager(
    _$AppDatabase db,
    $ServiceCentersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCentersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceCentersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceCentersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ServiceCentersCompanion(
                id: id,
                name: name,
                address: address,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ServiceCentersCompanion.insert(
                id: id,
                name: name,
                address: address,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceCentersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceCentersTable,
      ServiceCenter,
      $$ServiceCentersTableFilterComposer,
      $$ServiceCentersTableOrderingComposer,
      $$ServiceCentersTableAnnotationComposer,
      $$ServiceCentersTableCreateCompanionBuilder,
      $$ServiceCentersTableUpdateCompanionBuilder,
      (
        ServiceCenter,
        BaseReferences<_$AppDatabase, $ServiceCentersTable, ServiceCenter>,
      ),
      ServiceCenter,
      PrefetchHooks Function()
    >;
typedef $$GasStationChainsTableCreateCompanionBuilder =
    GasStationChainsCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$GasStationChainsTableUpdateCompanionBuilder =
    GasStationChainsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$GasStationChainsTableFilterComposer
    extends Composer<_$AppDatabase, $GasStationChainsTable> {
  $$GasStationChainsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GasStationChainsTableOrderingComposer
    extends Composer<_$AppDatabase, $GasStationChainsTable> {
  $$GasStationChainsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GasStationChainsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GasStationChainsTable> {
  $$GasStationChainsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GasStationChainsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GasStationChainsTable,
          GasStationChain,
          $$GasStationChainsTableFilterComposer,
          $$GasStationChainsTableOrderingComposer,
          $$GasStationChainsTableAnnotationComposer,
          $$GasStationChainsTableCreateCompanionBuilder,
          $$GasStationChainsTableUpdateCompanionBuilder,
          (
            GasStationChain,
            BaseReferences<
              _$AppDatabase,
              $GasStationChainsTable,
              GasStationChain
            >,
          ),
          GasStationChain,
          PrefetchHooks Function()
        > {
  $$GasStationChainsTableTableManager(
    _$AppDatabase db,
    $GasStationChainsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GasStationChainsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GasStationChainsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GasStationChainsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GasStationChainsCompanion(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GasStationChainsCompanion.insert(
                id: id,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GasStationChainsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GasStationChainsTable,
      GasStationChain,
      $$GasStationChainsTableFilterComposer,
      $$GasStationChainsTableOrderingComposer,
      $$GasStationChainsTableAnnotationComposer,
      $$GasStationChainsTableCreateCompanionBuilder,
      $$GasStationChainsTableUpdateCompanionBuilder,
      (
        GasStationChain,
        BaseReferences<_$AppDatabase, $GasStationChainsTable, GasStationChain>,
      ),
      GasStationChain,
      PrefetchHooks Function()
    >;
typedef $$GasStationLocationsTableCreateCompanionBuilder =
    GasStationLocationsCompanion Function({
      Value<int> id,
      required int chainId,
      Value<String?> address,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$GasStationLocationsTableUpdateCompanionBuilder =
    GasStationLocationsCompanion Function({
      Value<int> id,
      Value<int> chainId,
      Value<String?> address,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$GasStationLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $GasStationLocationsTable> {
  $$GasStationLocationsTableFilterComposer({
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

  ColumnFilters<int> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GasStationLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $GasStationLocationsTable> {
  $$GasStationLocationsTableOrderingComposer({
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

  ColumnOrderings<int> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GasStationLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GasStationLocationsTable> {
  $$GasStationLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chainId =>
      $composableBuilder(column: $table.chainId, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GasStationLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GasStationLocationsTable,
          GasStationLocation,
          $$GasStationLocationsTableFilterComposer,
          $$GasStationLocationsTableOrderingComposer,
          $$GasStationLocationsTableAnnotationComposer,
          $$GasStationLocationsTableCreateCompanionBuilder,
          $$GasStationLocationsTableUpdateCompanionBuilder,
          (
            GasStationLocation,
            BaseReferences<
              _$AppDatabase,
              $GasStationLocationsTable,
              GasStationLocation
            >,
          ),
          GasStationLocation,
          PrefetchHooks Function()
        > {
  $$GasStationLocationsTableTableManager(
    _$AppDatabase db,
    $GasStationLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GasStationLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GasStationLocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GasStationLocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chainId = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GasStationLocationsCompanion(
                id: id,
                chainId: chainId,
                address: address,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chainId,
                Value<String?> address = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GasStationLocationsCompanion.insert(
                id: id,
                chainId: chainId,
                address: address,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GasStationLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GasStationLocationsTable,
      GasStationLocation,
      $$GasStationLocationsTableFilterComposer,
      $$GasStationLocationsTableOrderingComposer,
      $$GasStationLocationsTableAnnotationComposer,
      $$GasStationLocationsTableCreateCompanionBuilder,
      $$GasStationLocationsTableUpdateCompanionBuilder,
      (
        GasStationLocation,
        BaseReferences<
          _$AppDatabase,
          $GasStationLocationsTable,
          GasStationLocation
        >,
      ),
      GasStationLocation,
      PrefetchHooks Function()
    >;
typedef $$FuelingsTableCreateCompanionBuilder =
    FuelingsCompanion Function({
      Value<int> id,
      required int carId,
      Value<int?> fuelTypeId,
      Value<int?> gasStationId,
      required DateTime fueledAt,
      required double pricePerLiter,
      required double liters,
      required double totalAmount,
      Value<String> currencyCode,
      Value<double?> odometerKm,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$FuelingsTableUpdateCompanionBuilder =
    FuelingsCompanion Function({
      Value<int> id,
      Value<int> carId,
      Value<int?> fuelTypeId,
      Value<int?> gasStationId,
      Value<DateTime> fueledAt,
      Value<double> pricePerLiter,
      Value<double> liters,
      Value<double> totalAmount,
      Value<String> currencyCode,
      Value<double?> odometerKm,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$FuelingsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelingsTable> {
  $$FuelingsTableFilterComposer({
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

  ColumnFilters<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fuelTypeId => $composableBuilder(
    column: $table.fuelTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gasStationId => $composableBuilder(
    column: $table.gasStationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fueledAt => $composableBuilder(
    column: $table.fueledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FuelingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelingsTable> {
  $$FuelingsTableOrderingComposer({
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

  ColumnOrderings<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fuelTypeId => $composableBuilder(
    column: $table.fuelTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gasStationId => $composableBuilder(
    column: $table.gasStationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fueledAt => $composableBuilder(
    column: $table.fueledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FuelingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelingsTable> {
  $$FuelingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);

  GeneratedColumn<int> get fuelTypeId => $composableBuilder(
    column: $table.fuelTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gasStationId => $composableBuilder(
    column: $table.gasStationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fueledAt =>
      $composableBuilder(column: $table.fueledAt, builder: (column) => column);

  GeneratedColumn<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => column,
  );

  GeneratedColumn<double> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FuelingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelingsTable,
          Fueling,
          $$FuelingsTableFilterComposer,
          $$FuelingsTableOrderingComposer,
          $$FuelingsTableAnnotationComposer,
          $$FuelingsTableCreateCompanionBuilder,
          $$FuelingsTableUpdateCompanionBuilder,
          (Fueling, BaseReferences<_$AppDatabase, $FuelingsTable, Fueling>),
          Fueling,
          PrefetchHooks Function()
        > {
  $$FuelingsTableTableManager(_$AppDatabase db, $FuelingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> carId = const Value.absent(),
                Value<int?> fuelTypeId = const Value.absent(),
                Value<int?> gasStationId = const Value.absent(),
                Value<DateTime> fueledAt = const Value.absent(),
                Value<double> pricePerLiter = const Value.absent(),
                Value<double> liters = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double?> odometerKm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FuelingsCompanion(
                id: id,
                carId: carId,
                fuelTypeId: fuelTypeId,
                gasStationId: gasStationId,
                fueledAt: fueledAt,
                pricePerLiter: pricePerLiter,
                liters: liters,
                totalAmount: totalAmount,
                currencyCode: currencyCode,
                odometerKm: odometerKm,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int carId,
                Value<int?> fuelTypeId = const Value.absent(),
                Value<int?> gasStationId = const Value.absent(),
                required DateTime fueledAt,
                required double pricePerLiter,
                required double liters,
                required double totalAmount,
                Value<String> currencyCode = const Value.absent(),
                Value<double?> odometerKm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FuelingsCompanion.insert(
                id: id,
                carId: carId,
                fuelTypeId: fuelTypeId,
                gasStationId: gasStationId,
                fueledAt: fueledAt,
                pricePerLiter: pricePerLiter,
                liters: liters,
                totalAmount: totalAmount,
                currencyCode: currencyCode,
                odometerKm: odometerKm,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FuelingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelingsTable,
      Fueling,
      $$FuelingsTableFilterComposer,
      $$FuelingsTableOrderingComposer,
      $$FuelingsTableAnnotationComposer,
      $$FuelingsTableCreateCompanionBuilder,
      $$FuelingsTableUpdateCompanionBuilder,
      (Fueling, BaseReferences<_$AppDatabase, $FuelingsTable, Fueling>),
      Fueling,
      PrefetchHooks Function()
    >;
typedef $$MaintenancesTableCreateCompanionBuilder =
    MaintenancesCompanion Function({
      Value<int> id,
      required int carId,
      Value<int?> serviceId,
      Value<int?> reminderId,
      required DateTime servicedAt,
      Value<double?> totalAmount,
      Value<String> currencyCode,
      Value<double?> odometerKm,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MaintenancesTableUpdateCompanionBuilder =
    MaintenancesCompanion Function({
      Value<int> id,
      Value<int> carId,
      Value<int?> serviceId,
      Value<int?> reminderId,
      Value<DateTime> servicedAt,
      Value<double?> totalAmount,
      Value<String> currencyCode,
      Value<double?> odometerKm,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$MaintenancesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenancesTable> {
  $$MaintenancesTableFilterComposer({
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

  ColumnFilters<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get servicedAt => $composableBuilder(
    column: $table.servicedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MaintenancesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenancesTable> {
  $$MaintenancesTableOrderingComposer({
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

  ColumnOrderings<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get servicedAt => $composableBuilder(
    column: $table.servicedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaintenancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenancesTable> {
  $$MaintenancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);

  GeneratedColumn<int> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<int> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get servicedAt => $composableBuilder(
    column: $table.servicedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MaintenancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenancesTable,
          Maintenance,
          $$MaintenancesTableFilterComposer,
          $$MaintenancesTableOrderingComposer,
          $$MaintenancesTableAnnotationComposer,
          $$MaintenancesTableCreateCompanionBuilder,
          $$MaintenancesTableUpdateCompanionBuilder,
          (
            Maintenance,
            BaseReferences<_$AppDatabase, $MaintenancesTable, Maintenance>,
          ),
          Maintenance,
          PrefetchHooks Function()
        > {
  $$MaintenancesTableTableManager(_$AppDatabase db, $MaintenancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> carId = const Value.absent(),
                Value<int?> serviceId = const Value.absent(),
                Value<int?> reminderId = const Value.absent(),
                Value<DateTime> servicedAt = const Value.absent(),
                Value<double?> totalAmount = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double?> odometerKm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MaintenancesCompanion(
                id: id,
                carId: carId,
                serviceId: serviceId,
                reminderId: reminderId,
                servicedAt: servicedAt,
                totalAmount: totalAmount,
                currencyCode: currencyCode,
                odometerKm: odometerKm,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int carId,
                Value<int?> serviceId = const Value.absent(),
                Value<int?> reminderId = const Value.absent(),
                required DateTime servicedAt,
                Value<double?> totalAmount = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double?> odometerKm = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MaintenancesCompanion.insert(
                id: id,
                carId: carId,
                serviceId: serviceId,
                reminderId: reminderId,
                servicedAt: servicedAt,
                totalAmount: totalAmount,
                currencyCode: currencyCode,
                odometerKm: odometerKm,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MaintenancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenancesTable,
      Maintenance,
      $$MaintenancesTableFilterComposer,
      $$MaintenancesTableOrderingComposer,
      $$MaintenancesTableAnnotationComposer,
      $$MaintenancesTableCreateCompanionBuilder,
      $$MaintenancesTableUpdateCompanionBuilder,
      (
        Maintenance,
        BaseReferences<_$AppDatabase, $MaintenancesTable, Maintenance>,
      ),
      Maintenance,
      PrefetchHooks Function()
    >;
typedef $$MaintenancePartsTableCreateCompanionBuilder =
    MaintenancePartsCompanion Function({
      Value<int> id,
      required int maintenanceId,
      Value<int?> partId,
      Value<double> quantity,
      Value<int?> unitId,
      Value<double?> amount,
      Value<String?> comment,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MaintenancePartsTableUpdateCompanionBuilder =
    MaintenancePartsCompanion Function({
      Value<int> id,
      Value<int> maintenanceId,
      Value<int?> partId,
      Value<double> quantity,
      Value<int?> unitId,
      Value<double?> amount,
      Value<String?> comment,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$MaintenancePartsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenancePartsTable> {
  $$MaintenancePartsTableFilterComposer({
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

  ColumnFilters<int> get maintenanceId => $composableBuilder(
    column: $table.maintenanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MaintenancePartsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenancePartsTable> {
  $$MaintenancePartsTableOrderingComposer({
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

  ColumnOrderings<int> get maintenanceId => $composableBuilder(
    column: $table.maintenanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaintenancePartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenancePartsTable> {
  $$MaintenancePartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get maintenanceId => $composableBuilder(
    column: $table.maintenanceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MaintenancePartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenancePartsTable,
          MaintenancePart,
          $$MaintenancePartsTableFilterComposer,
          $$MaintenancePartsTableOrderingComposer,
          $$MaintenancePartsTableAnnotationComposer,
          $$MaintenancePartsTableCreateCompanionBuilder,
          $$MaintenancePartsTableUpdateCompanionBuilder,
          (
            MaintenancePart,
            BaseReferences<
              _$AppDatabase,
              $MaintenancePartsTable,
              MaintenancePart
            >,
          ),
          MaintenancePart,
          PrefetchHooks Function()
        > {
  $$MaintenancePartsTableTableManager(
    _$AppDatabase db,
    $MaintenancePartsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenancePartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenancePartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenancePartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> maintenanceId = const Value.absent(),
                Value<int?> partId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int?> unitId = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MaintenancePartsCompanion(
                id: id,
                maintenanceId: maintenanceId,
                partId: partId,
                quantity: quantity,
                unitId: unitId,
                amount: amount,
                comment: comment,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int maintenanceId,
                Value<int?> partId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int?> unitId = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MaintenancePartsCompanion.insert(
                id: id,
                maintenanceId: maintenanceId,
                partId: partId,
                quantity: quantity,
                unitId: unitId,
                amount: amount,
                comment: comment,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MaintenancePartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenancePartsTable,
      MaintenancePart,
      $$MaintenancePartsTableFilterComposer,
      $$MaintenancePartsTableOrderingComposer,
      $$MaintenancePartsTableAnnotationComposer,
      $$MaintenancePartsTableCreateCompanionBuilder,
      $$MaintenancePartsTableUpdateCompanionBuilder,
      (
        MaintenancePart,
        BaseReferences<_$AppDatabase, $MaintenancePartsTable, MaintenancePart>,
      ),
      MaintenancePart,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required int carId,
      required String title,
      Value<DateTime?> dueAt,
      Value<double?> dueOdometerKm,
      Value<int?> remindBeforeDays,
      Value<double?> remindBeforeKm,
      Value<bool> isCompleted,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<int> carId,
      Value<String> title,
      Value<DateTime?> dueAt,
      Value<double?> dueOdometerKm,
      Value<int?> remindBeforeDays,
      Value<double?> remindBeforeKm,
      Value<bool> isCompleted,
      Value<bool> isDeleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
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

  ColumnFilters<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dueOdometerKm => $composableBuilder(
    column: $table.dueOdometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindBeforeDays => $composableBuilder(
    column: $table.remindBeforeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remindBeforeKm => $composableBuilder(
    column: $table.remindBeforeKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
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

  ColumnOrderings<int> get carId => $composableBuilder(
    column: $table.carId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dueOdometerKm => $composableBuilder(
    column: $table.dueOdometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindBeforeDays => $composableBuilder(
    column: $table.remindBeforeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remindBeforeKm => $composableBuilder(
    column: $table.remindBeforeKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get carId =>
      $composableBuilder(column: $table.carId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<double> get dueOdometerKm => $composableBuilder(
    column: $table.dueOdometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remindBeforeDays => $composableBuilder(
    column: $table.remindBeforeDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remindBeforeKm => $composableBuilder(
    column: $table.remindBeforeKm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> carId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<double?> dueOdometerKm = const Value.absent(),
                Value<int?> remindBeforeDays = const Value.absent(),
                Value<double?> remindBeforeKm = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                carId: carId,
                title: title,
                dueAt: dueAt,
                dueOdometerKm: dueOdometerKm,
                remindBeforeDays: remindBeforeDays,
                remindBeforeKm: remindBeforeKm,
                isCompleted: isCompleted,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int carId,
                required String title,
                Value<DateTime?> dueAt = const Value.absent(),
                Value<double?> dueOdometerKm = const Value.absent(),
                Value<int?> remindBeforeDays = const Value.absent(),
                Value<double?> remindBeforeKm = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                carId: carId,
                title: title,
                dueAt: dueAt,
                dueOdometerKm: dueOdometerKm,
                remindBeforeDays: remindBeforeDays,
                remindBeforeKm: remindBeforeKm,
                isCompleted: isCompleted,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FuelTypesTableTableManager get fuelTypes =>
      $$FuelTypesTableTableManager(_db, _db.fuelTypes);
  $$CarBrandsTableTableManager get carBrands =>
      $$CarBrandsTableTableManager(_db, _db.carBrands);
  $$CarsTableTableManager get cars => $$CarsTableTableManager(_db, _db.cars);
  $$FuelTypeCarsTableTableManager get fuelTypeCars =>
      $$FuelTypeCarsTableTableManager(_db, _db.fuelTypeCars);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$PartCarsTableTableManager get partCars =>
      $$PartCarsTableTableManager(_db, _db.partCars);
  $$PartUnitsTableTableManager get partUnits =>
      $$PartUnitsTableTableManager(_db, _db.partUnits);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$ServiceCentersTableTableManager get serviceCenters =>
      $$ServiceCentersTableTableManager(_db, _db.serviceCenters);
  $$GasStationChainsTableTableManager get gasStationChains =>
      $$GasStationChainsTableTableManager(_db, _db.gasStationChains);
  $$GasStationLocationsTableTableManager get gasStationLocations =>
      $$GasStationLocationsTableTableManager(_db, _db.gasStationLocations);
  $$FuelingsTableTableManager get fuelings =>
      $$FuelingsTableTableManager(_db, _db.fuelings);
  $$MaintenancesTableTableManager get maintenances =>
      $$MaintenancesTableTableManager(_db, _db.maintenances);
  $$MaintenancePartsTableTableManager get maintenanceParts =>
      $$MaintenancePartsTableTableManager(_db, _db.maintenanceParts);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
