// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cybersafe_drift_database.dart';

// ignore_for_file: type=lint
class $CategoryDriftModelTable extends CategoryDriftModel
    with TableInfo<$CategoryDriftModelTable, CategoryDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indexPosMeta = const VerificationMeta('indexPos');
  @override
  late final GeneratedColumn<int> indexPos = GeneratedColumn<int>(
    'index_pos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
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
  List<GeneratedColumn> get $columns => [id, categoryName, indexPos, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(data['category_name']!, _categoryNameMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('index_pos')) {
      context.handle(
        _indexPosMeta,
        indexPos.isAcceptableOrUnknown(data['index_pos']!, _indexPosMeta),
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
  CategoryDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      indexPos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index_pos'],
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
  $CategoryDriftModelTable createAlias(String alias) {
    return $CategoryDriftModelTable(attachedDatabase, alias);
  }
}

class CategoryDriftModelData extends DataClass implements Insertable<CategoryDriftModelData> {
  final int id;
  final String categoryName;
  final int indexPos;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoryDriftModelData({
    required this.id,
    required this.categoryName,
    required this.indexPos,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_name'] = Variable<String>(categoryName);
    map['index_pos'] = Variable<int>(indexPos);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoryDriftModelCompanion toCompanion(bool nullToAbsent) {
    return CategoryDriftModelCompanion(
      id: Value(id),
      categoryName: Value(categoryName),
      indexPos: Value(indexPos),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryDriftModelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      indexPos: serializer.fromJson<int>(json['indexPos']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryName': serializer.toJson<String>(categoryName),
      'indexPos': serializer.toJson<int>(indexPos),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryDriftModelData copyWith({
    int? id,
    String? categoryName,
    int? indexPos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoryDriftModelData(
    id: id ?? this.id,
    categoryName: categoryName ?? this.categoryName,
    indexPos: indexPos ?? this.indexPos,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryDriftModelData copyWithCompanion(CategoryDriftModelCompanion data) {
    return CategoryDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      categoryName: data.categoryName.present ? data.categoryName.value : this.categoryName,
      indexPos: data.indexPos.present ? data.indexPos.value : this.indexPos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDriftModelData(')
          ..write('id: $id, ')
          ..write('categoryName: $categoryName, ')
          ..write('indexPos: $indexPos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryName, indexPos, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryDriftModelData &&
          other.id == this.id &&
          other.categoryName == this.categoryName &&
          other.indexPos == this.indexPos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoryDriftModelCompanion extends UpdateCompanion<CategoryDriftModelData> {
  final Value<int> id;
  final Value<String> categoryName;
  final Value<int> indexPos;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoryDriftModelCompanion({
    this.id = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.indexPos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoryDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required String categoryName,
    this.indexPos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : categoryName = Value(categoryName);
  static Insertable<CategoryDriftModelData> custom({
    Expression<int>? id,
    Expression<String>? categoryName,
    Expression<int>? indexPos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryName != null) 'category_name': categoryName,
      if (indexPos != null) 'index_pos': indexPos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoryDriftModelCompanion copyWith({
    Value<int>? id,
    Value<String>? categoryName,
    Value<int>? indexPos,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CategoryDriftModelCompanion(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      indexPos: indexPos ?? this.indexPos,
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
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (indexPos.present) {
      map['index_pos'] = Variable<int>(indexPos.value);
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
    return (StringBuffer('CategoryDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('categoryName: $categoryName, ')
          ..write('indexPos: $indexPos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $IconCustomDriftModelTable extends IconCustomDriftModel
    with TableInfo<$IconCustomDriftModelTable, IconCustomDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IconCustomDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
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
  static const VerificationMeta _imageBase64Meta = const VerificationMeta('imageBase64');
  @override
  late final GeneratedColumn<String> imageBase64 = GeneratedColumn<String>(
    'image_base64',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, imageBase64];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'icon_custom_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<IconCustomDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_base64')) {
      context.handle(
        _imageBase64Meta,
        imageBase64.isAcceptableOrUnknown(data['image_base64']!, _imageBase64Meta),
      );
    } else if (isInserting) {
      context.missing(_imageBase64Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IconCustomDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IconCustomDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_base64'],
      )!,
    );
  }

  @override
  $IconCustomDriftModelTable createAlias(String alias) {
    return $IconCustomDriftModelTable(attachedDatabase, alias);
  }
}

class IconCustomDriftModelData extends DataClass implements Insertable<IconCustomDriftModelData> {
  final int id;
  final String name;
  final String imageBase64;
  const IconCustomDriftModelData({required this.id, required this.name, required this.imageBase64});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_base64'] = Variable<String>(imageBase64);
    return map;
  }

  IconCustomDriftModelCompanion toCompanion(bool nullToAbsent) {
    return IconCustomDriftModelCompanion(
      id: Value(id),
      name: Value(name),
      imageBase64: Value(imageBase64),
    );
  }

  factory IconCustomDriftModelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IconCustomDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageBase64: serializer.fromJson<String>(json['imageBase64']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageBase64': serializer.toJson<String>(imageBase64),
    };
  }

  IconCustomDriftModelData copyWith({int? id, String? name, String? imageBase64}) =>
      IconCustomDriftModelData(
        id: id ?? this.id,
        name: name ?? this.name,
        imageBase64: imageBase64 ?? this.imageBase64,
      );
  IconCustomDriftModelData copyWithCompanion(IconCustomDriftModelCompanion data) {
    return IconCustomDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageBase64: data.imageBase64.present ? data.imageBase64.value : this.imageBase64,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IconCustomDriftModelData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageBase64: $imageBase64')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, imageBase64);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IconCustomDriftModelData &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageBase64 == this.imageBase64);
}

class IconCustomDriftModelCompanion extends UpdateCompanion<IconCustomDriftModelData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> imageBase64;
  const IconCustomDriftModelCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageBase64 = const Value.absent(),
  });
  IconCustomDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String imageBase64,
  }) : name = Value(name),
       imageBase64 = Value(imageBase64);
  static Insertable<IconCustomDriftModelData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageBase64,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageBase64 != null) 'image_base64': imageBase64,
    });
  }

  IconCustomDriftModelCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? imageBase64,
  }) {
    return IconCustomDriftModelCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageBase64: imageBase64 ?? this.imageBase64,
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
    if (imageBase64.present) {
      map['image_base64'] = Variable<String>(imageBase64.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IconCustomDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageBase64: $imageBase64')
          ..write(')'))
        .toString();
  }
}

class $AccountDriftModelTable extends AccountDriftModel
    with TableInfo<$AccountDriftModelTable, AccountDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
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
  static const VerificationMeta _usernameMeta = const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openCountMeta = const VerificationMeta('openCount');
  @override
  late final GeneratedColumn<int> openCount = GeneratedColumn<int>(
    'open_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES category_drift_model (id)'),
  );
  static const VerificationMeta _iconCustomIdMeta = const VerificationMeta('iconCustomId');
  @override
  late final GeneratedColumn<int> iconCustomId = GeneratedColumn<int>(
    'icon_custom_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES icon_custom_drift_model (id)',
    ),
  );
  static const VerificationMeta _passwordUpdatedAtMeta = const VerificationMeta(
    'passwordUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> passwordUpdatedAt = GeneratedColumn<DateTime>(
    'password_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    username,
    password,
    notes,
    icon,
    openCount,
    categoryId,
    iconCustomId,
    passwordUpdatedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(_iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('open_count')) {
      context.handle(
        _openCountMeta,
        openCount.isAcceptableOrUnknown(data['open_count']!, _openCountMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('icon_custom_id')) {
      context.handle(
        _iconCustomIdMeta,
        iconCustomId.isAcceptableOrUnknown(data['icon_custom_id']!, _iconCustomIdMeta),
      );
    }
    if (data.containsKey('password_updated_at')) {
      context.handle(
        _passwordUpdatedAtMeta,
        passwordUpdatedAt.isAcceptableOrUnknown(
          data['password_updated_at']!,
          _passwordUpdatedAtMeta,
        ),
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      icon: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}icon']),
      openCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}open_count'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      iconCustomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_custom_id'],
      ),
      passwordUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}password_updated_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $AccountDriftModelTable createAlias(String alias) {
    return $AccountDriftModelTable(attachedDatabase, alias);
  }
}

class AccountDriftModelData extends DataClass implements Insertable<AccountDriftModelData> {
  final int id;
  final String title;
  final String? username;
  final String? password;
  final String? notes;
  final String? icon;
  final int openCount;
  final int categoryId;
  final int? iconCustomId;
  final DateTime? passwordUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const AccountDriftModelData({
    required this.id,
    required this.title,
    this.username,
    this.password,
    this.notes,
    this.icon,
    required this.openCount,
    required this.categoryId,
    this.iconCustomId,
    this.passwordUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || openCount != null) {
      map['open_count'] = Variable<int>(openCount);
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || iconCustomId != null) {
      map['icon_custom_id'] = Variable<int>(iconCustomId);
    }
    if (!nullToAbsent || passwordUpdatedAt != null) {
      map['password_updated_at'] = Variable<DateTime>(passwordUpdatedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  AccountDriftModelCompanion toCompanion(bool nullToAbsent) {
    return AccountDriftModelCompanion(
      id: Value(id),
      title: Value(title),
      username: username == null && nullToAbsent ? const Value.absent() : Value(username),
      password: password == null && nullToAbsent ? const Value.absent() : Value(password),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      openCount: Value(openCount),
      categoryId: Value(categoryId),
      iconCustomId: iconCustomId == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCustomId),
      passwordUpdatedAt: passwordUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordUpdatedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
    );
  }

  factory AccountDriftModelData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      username: serializer.fromJson<String?>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      notes: serializer.fromJson<String?>(json['notes']),
      icon: serializer.fromJson<String?>(json['icon']),
      openCount: serializer.fromJson<int>(json['openCount']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      iconCustomId: serializer.fromJson<int?>(json['iconCustomId']),
      passwordUpdatedAt: serializer.fromJson<DateTime?>(json['passwordUpdatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'username': serializer.toJson<String?>(username),
      'password': serializer.toJson<String?>(password),
      'notes': serializer.toJson<String?>(notes),
      'icon': serializer.toJson<String?>(icon),
      'openCount': serializer.toJson<int>(openCount),
      'categoryId': serializer.toJson<int>(categoryId),
      'iconCustomId': serializer.toJson<int?>(iconCustomId),
      'passwordUpdatedAt': serializer.toJson<DateTime?>(passwordUpdatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  AccountDriftModelData copyWith({
    int? id,
    String? title,
    Value<String?> username = const Value.absent(),
    Value<String?> password = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    int? openCount,
    int? categoryId,
    Value<int?> iconCustomId = const Value.absent(),
    Value<DateTime?> passwordUpdatedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => AccountDriftModelData(
    id: id ?? this.id,
    title: title ?? this.title,
    username: username.present ? username.value : this.username,
    password: password.present ? password.value : this.password,
    notes: notes.present ? notes.value : this.notes,
    icon: icon.present ? icon.value : this.icon,
    openCount: openCount ?? this.openCount,
    categoryId: categoryId ?? this.categoryId,
    iconCustomId: iconCustomId.present ? iconCustomId.value : this.iconCustomId,
    passwordUpdatedAt: passwordUpdatedAt.present ? passwordUpdatedAt.value : this.passwordUpdatedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  AccountDriftModelData copyWithCompanion(AccountDriftModelCompanion data) {
    return AccountDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      notes: data.notes.present ? data.notes.value : this.notes,
      icon: data.icon.present ? data.icon.value : this.icon,
      openCount: data.openCount.present ? data.openCount.value : this.openCount,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      iconCustomId: data.iconCustomId.present ? data.iconCustomId.value : this.iconCustomId,
      passwordUpdatedAt: data.passwordUpdatedAt.present
          ? data.passwordUpdatedAt.value
          : this.passwordUpdatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountDriftModelData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('notes: $notes, ')
          ..write('icon: $icon, ')
          ..write('openCount: $openCount, ')
          ..write('categoryId: $categoryId, ')
          ..write('iconCustomId: $iconCustomId, ')
          ..write('passwordUpdatedAt: $passwordUpdatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    username,
    password,
    notes,
    icon,
    openCount,
    categoryId,
    iconCustomId,
    passwordUpdatedAt,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountDriftModelData &&
          other.id == this.id &&
          other.title == this.title &&
          other.username == this.username &&
          other.password == this.password &&
          other.notes == this.notes &&
          other.icon == this.icon &&
          other.openCount == this.openCount &&
          other.categoryId == this.categoryId &&
          other.iconCustomId == this.iconCustomId &&
          other.passwordUpdatedAt == this.passwordUpdatedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AccountDriftModelCompanion extends UpdateCompanion<AccountDriftModelData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> username;
  final Value<String?> password;
  final Value<String?> notes;
  final Value<String?> icon;
  final Value<int> openCount;
  final Value<int> categoryId;
  final Value<int?> iconCustomId;
  final Value<DateTime?> passwordUpdatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const AccountDriftModelCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.notes = const Value.absent(),
    this.icon = const Value.absent(),
    this.openCount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.iconCustomId = const Value.absent(),
    this.passwordUpdatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  AccountDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.notes = const Value.absent(),
    this.icon = const Value.absent(),
    this.openCount = const Value.absent(),
    required int categoryId,
    this.iconCustomId = const Value.absent(),
    this.passwordUpdatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : title = Value(title),
       categoryId = Value(categoryId);
  static Insertable<AccountDriftModelData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? notes,
    Expression<String>? icon,
    Expression<int>? openCount,
    Expression<int>? categoryId,
    Expression<int>? iconCustomId,
    Expression<DateTime>? passwordUpdatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (notes != null) 'notes': notes,
      if (icon != null) 'icon': icon,
      if (openCount != null) 'open_count': openCount,
      if (categoryId != null) 'category_id': categoryId,
      if (iconCustomId != null) 'icon_custom_id': iconCustomId,
      if (passwordUpdatedAt != null) 'password_updated_at': passwordUpdatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  AccountDriftModelCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? username,
    Value<String?>? password,
    Value<String?>? notes,
    Value<String?>? icon,
    Value<int>? openCount,
    Value<int>? categoryId,
    Value<int?>? iconCustomId,
    Value<DateTime?>? passwordUpdatedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return AccountDriftModelCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      notes: notes ?? this.notes,
      icon: icon ?? this.icon,
      openCount: openCount ?? this.openCount,
      categoryId: categoryId ?? this.categoryId,
      iconCustomId: iconCustomId ?? this.iconCustomId,
      passwordUpdatedAt: passwordUpdatedAt ?? this.passwordUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (openCount.present) {
      map['open_count'] = Variable<int>(openCount.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (iconCustomId.present) {
      map['icon_custom_id'] = Variable<int>(iconCustomId.value);
    }
    if (passwordUpdatedAt.present) {
      map['password_updated_at'] = Variable<DateTime>(passwordUpdatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('notes: $notes, ')
          ..write('icon: $icon, ')
          ..write('openCount: $openCount, ')
          ..write('categoryId: $categoryId, ')
          ..write('iconCustomId: $iconCustomId, ')
          ..write('passwordUpdatedAt: $passwordUpdatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $TOTPDriftModelTable extends TOTPDriftModel
    with TableInfo<$TOTPDriftModelTable, TOTPDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TOTPDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES account_drift_model (id)'),
  );
  static const VerificationMeta _secretKeyMeta = const VerificationMeta('secretKey');
  @override
  late final GeneratedColumn<String> secretKey = GeneratedColumn<String>(
    'secret_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isShowToHomeMeta = const VerificationMeta('isShowToHome');
  @override
  late final GeneratedColumn<bool> isShowToHome = GeneratedColumn<bool>(
    'is_show_to_home',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_show_to_home" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
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
    accountId,
    secretKey,
    isShowToHome,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_o_t_p_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<TOTPDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('secret_key')) {
      context.handle(
        _secretKeyMeta,
        secretKey.isAcceptableOrUnknown(data['secret_key']!, _secretKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_secretKeyMeta);
    }
    if (data.containsKey('is_show_to_home')) {
      context.handle(
        _isShowToHomeMeta,
        isShowToHome.isAcceptableOrUnknown(data['is_show_to_home']!, _isShowToHomeMeta),
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
  TOTPDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TOTPDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      secretKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secret_key'],
      )!,
      isShowToHome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_show_to_home'],
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
  $TOTPDriftModelTable createAlias(String alias) {
    return $TOTPDriftModelTable(attachedDatabase, alias);
  }
}

class TOTPDriftModelData extends DataClass implements Insertable<TOTPDriftModelData> {
  final int id;
  final int accountId;
  final String secretKey;
  final bool isShowToHome;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TOTPDriftModelData({
    required this.id,
    required this.accountId,
    required this.secretKey,
    required this.isShowToHome,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['secret_key'] = Variable<String>(secretKey);
    map['is_show_to_home'] = Variable<bool>(isShowToHome);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TOTPDriftModelCompanion toCompanion(bool nullToAbsent) {
    return TOTPDriftModelCompanion(
      id: Value(id),
      accountId: Value(accountId),
      secretKey: Value(secretKey),
      isShowToHome: Value(isShowToHome),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TOTPDriftModelData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TOTPDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      secretKey: serializer.fromJson<String>(json['secretKey']),
      isShowToHome: serializer.fromJson<bool>(json['isShowToHome']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'secretKey': serializer.toJson<String>(secretKey),
      'isShowToHome': serializer.toJson<bool>(isShowToHome),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TOTPDriftModelData copyWith({
    int? id,
    int? accountId,
    String? secretKey,
    bool? isShowToHome,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TOTPDriftModelData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    secretKey: secretKey ?? this.secretKey,
    isShowToHome: isShowToHome ?? this.isShowToHome,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TOTPDriftModelData copyWithCompanion(TOTPDriftModelCompanion data) {
    return TOTPDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      secretKey: data.secretKey.present ? data.secretKey.value : this.secretKey,
      isShowToHome: data.isShowToHome.present ? data.isShowToHome.value : this.isShowToHome,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TOTPDriftModelData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('secretKey: $secretKey, ')
          ..write('isShowToHome: $isShowToHome, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, secretKey, isShowToHome, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TOTPDriftModelData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.secretKey == this.secretKey &&
          other.isShowToHome == this.isShowToHome &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TOTPDriftModelCompanion extends UpdateCompanion<TOTPDriftModelData> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> secretKey;
  final Value<bool> isShowToHome;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TOTPDriftModelCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.secretKey = const Value.absent(),
    this.isShowToHome = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TOTPDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String secretKey,
    this.isShowToHome = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       secretKey = Value(secretKey);
  static Insertable<TOTPDriftModelData> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? secretKey,
    Expression<bool>? isShowToHome,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (secretKey != null) 'secret_key': secretKey,
      if (isShowToHome != null) 'is_show_to_home': isShowToHome,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TOTPDriftModelCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? secretKey,
    Value<bool>? isShowToHome,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TOTPDriftModelCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      secretKey: secretKey ?? this.secretKey,
      isShowToHome: isShowToHome ?? this.isShowToHome,
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
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (secretKey.present) {
      map['secret_key'] = Variable<String>(secretKey.value);
    }
    if (isShowToHome.present) {
      map['is_show_to_home'] = Variable<bool>(isShowToHome.value);
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
    return (StringBuffer('TOTPDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('secretKey: $secretKey, ')
          ..write('isShowToHome: $isShowToHome, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PasswordHistoryDriftModelTable extends PasswordHistoryDriftModel
    with TableInfo<$PasswordHistoryDriftModelTable, PasswordHistoryDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PasswordHistoryDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES account_drift_model (id)'),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
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
  List<GeneratedColumn> get $columns => [id, accountId, password, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'password_history_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<PasswordHistoryDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
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
  PasswordHistoryDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PasswordHistoryDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PasswordHistoryDriftModelTable createAlias(String alias) {
    return $PasswordHistoryDriftModelTable(attachedDatabase, alias);
  }
}

class PasswordHistoryDriftModelData extends DataClass
    implements Insertable<PasswordHistoryDriftModelData> {
  final int id;
  final int accountId;
  final String password;
  final DateTime createdAt;
  const PasswordHistoryDriftModelData({
    required this.id,
    required this.accountId,
    required this.password,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['password'] = Variable<String>(password);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PasswordHistoryDriftModelCompanion toCompanion(bool nullToAbsent) {
    return PasswordHistoryDriftModelCompanion(
      id: Value(id),
      accountId: Value(accountId),
      password: Value(password),
      createdAt: Value(createdAt),
    );
  }

  factory PasswordHistoryDriftModelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PasswordHistoryDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      password: serializer.fromJson<String>(json['password']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'password': serializer.toJson<String>(password),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PasswordHistoryDriftModelData copyWith({
    int? id,
    int? accountId,
    String? password,
    DateTime? createdAt,
  }) => PasswordHistoryDriftModelData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    password: password ?? this.password,
    createdAt: createdAt ?? this.createdAt,
  );
  PasswordHistoryDriftModelData copyWithCompanion(PasswordHistoryDriftModelCompanion data) {
    return PasswordHistoryDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      password: data.password.present ? data.password.value : this.password,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PasswordHistoryDriftModelData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, password, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PasswordHistoryDriftModelData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.password == this.password &&
          other.createdAt == this.createdAt);
}

class PasswordHistoryDriftModelCompanion extends UpdateCompanion<PasswordHistoryDriftModelData> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> password;
  final Value<DateTime> createdAt;
  const PasswordHistoryDriftModelCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PasswordHistoryDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String password,
    this.createdAt = const Value.absent(),
  }) : accountId = Value(accountId),
       password = Value(password);
  static Insertable<PasswordHistoryDriftModelData> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PasswordHistoryDriftModelCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? password,
    Value<DateTime>? createdAt,
  }) {
    return PasswordHistoryDriftModelCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordHistoryDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AccountCustomFieldDriftModelTable extends AccountCustomFieldDriftModel
    with TableInfo<$AccountCustomFieldDriftModelTable, AccountCustomFieldDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountCustomFieldDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES account_drift_model (id)'),
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
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintTextMeta = const VerificationMeta('hintText');
  @override
  late final GeneratedColumn<String> hintText = GeneratedColumn<String>(
    'hint_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeFieldMeta = const VerificationMeta('typeField');
  @override
  late final GeneratedColumn<String> typeField = GeneratedColumn<String>(
    'type_field',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, accountId, name, value, hintText, typeField];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_custom_field_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountCustomFieldDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('hint_text')) {
      context.handle(
        _hintTextMeta,
        hintText.isAcceptableOrUnknown(data['hint_text']!, _hintTextMeta),
      );
    } else if (isInserting) {
      context.missing(_hintTextMeta);
    }
    if (data.containsKey('type_field')) {
      context.handle(
        _typeFieldMeta,
        typeField.isAcceptableOrUnknown(data['type_field']!, _typeFieldMeta),
      );
    } else if (isInserting) {
      context.missing(_typeFieldMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountCustomFieldDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountCustomFieldDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      hintText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hint_text'],
      )!,
      typeField: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_field'],
      )!,
    );
  }

  @override
  $AccountCustomFieldDriftModelTable createAlias(String alias) {
    return $AccountCustomFieldDriftModelTable(attachedDatabase, alias);
  }
}

class AccountCustomFieldDriftModelData extends DataClass
    implements Insertable<AccountCustomFieldDriftModelData> {
  final int id;
  final int accountId;
  final String name;
  final String value;
  final String hintText;
  final String typeField;
  const AccountCustomFieldDriftModelData({
    required this.id,
    required this.accountId,
    required this.name,
    required this.value,
    required this.hintText,
    required this.typeField,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    map['hint_text'] = Variable<String>(hintText);
    map['type_field'] = Variable<String>(typeField);
    return map;
  }

  AccountCustomFieldDriftModelCompanion toCompanion(bool nullToAbsent) {
    return AccountCustomFieldDriftModelCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      value: Value(value),
      hintText: Value(hintText),
      typeField: Value(typeField),
    );
  }

  factory AccountCustomFieldDriftModelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountCustomFieldDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
      hintText: serializer.fromJson<String>(json['hintText']),
      typeField: serializer.fromJson<String>(json['typeField']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
      'hintText': serializer.toJson<String>(hintText),
      'typeField': serializer.toJson<String>(typeField),
    };
  }

  AccountCustomFieldDriftModelData copyWith({
    int? id,
    int? accountId,
    String? name,
    String? value,
    String? hintText,
    String? typeField,
  }) => AccountCustomFieldDriftModelData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    name: name ?? this.name,
    value: value ?? this.value,
    hintText: hintText ?? this.hintText,
    typeField: typeField ?? this.typeField,
  );
  AccountCustomFieldDriftModelData copyWithCompanion(AccountCustomFieldDriftModelCompanion data) {
    return AccountCustomFieldDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      hintText: data.hintText.present ? data.hintText.value : this.hintText,
      typeField: data.typeField.present ? data.typeField.value : this.typeField,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountCustomFieldDriftModelData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('hintText: $hintText, ')
          ..write('typeField: $typeField')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, name, value, hintText, typeField);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountCustomFieldDriftModelData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.value == this.value &&
          other.hintText == this.hintText &&
          other.typeField == this.typeField);
}

class AccountCustomFieldDriftModelCompanion
    extends UpdateCompanion<AccountCustomFieldDriftModelData> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<String> value;
  final Value<String> hintText;
  final Value<String> typeField;
  const AccountCustomFieldDriftModelCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.hintText = const Value.absent(),
    this.typeField = const Value.absent(),
  });
  AccountCustomFieldDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String name,
    required String value,
    required String hintText,
    required String typeField,
  }) : accountId = Value(accountId),
       name = Value(name),
       value = Value(value),
       hintText = Value(hintText),
       typeField = Value(typeField);
  static Insertable<AccountCustomFieldDriftModelData> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<String>? value,
    Expression<String>? hintText,
    Expression<String>? typeField,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (hintText != null) 'hint_text': hintText,
      if (typeField != null) 'type_field': typeField,
    });
  }

  AccountCustomFieldDriftModelCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? name,
    Value<String>? value,
    Value<String>? hintText,
    Value<String>? typeField,
  }) {
    return AccountCustomFieldDriftModelCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      value: value ?? this.value,
      hintText: hintText ?? this.hintText,
      typeField: typeField ?? this.typeField,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (hintText.present) {
      map['hint_text'] = Variable<String>(hintText.value);
    }
    if (typeField.present) {
      map['type_field'] = Variable<String>(typeField.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountCustomFieldDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('hintText: $hintText, ')
          ..write('typeField: $typeField')
          ..write(')'))
        .toString();
  }
}

class $TextNotesDriftModelTable extends TextNotesDriftModel
    with TableInfo<$TextNotesDriftModelTable, TextNotesDriftModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextNotesDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
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
  static const VerificationMeta _contentMeta = const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _indexPosMeta = const VerificationMeta('indexPos');
  @override
  late final GeneratedColumn<int> indexPos = GeneratedColumn<int>(
    'index_pos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
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
    title,
    content,
    color,
    isFavorite,
    isPinned,
    indexPos,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'text_notes_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<TextNotesDriftModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta, content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('color')) {
      context.handle(_colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('index_pos')) {
      context.handle(
        _indexPosMeta,
        indexPos.isAcceptableOrUnknown(data['index_pos']!, _indexPosMeta),
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
  TextNotesDriftModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TextNotesDriftModelData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      indexPos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index_pos'],
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
  $TextNotesDriftModelTable createAlias(String alias) {
    return $TextNotesDriftModelTable(attachedDatabase, alias);
  }
}

class TextNotesDriftModelData extends DataClass implements Insertable<TextNotesDriftModelData> {
  final int id;
  final String title;
  final String? content;
  final String? color;
  final bool isFavorite;
  final bool isPinned;
  final int indexPos;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TextNotesDriftModelData({
    required this.id,
    required this.title,
    this.content,
    this.color,
    required this.isFavorite,
    required this.isPinned,
    required this.indexPos,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['index_pos'] = Variable<int>(indexPos);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TextNotesDriftModelCompanion toCompanion(bool nullToAbsent) {
    return TextNotesDriftModelCompanion(
      id: Value(id),
      title: Value(title),
      content: content == null && nullToAbsent ? const Value.absent() : Value(content),
      color: color == null && nullToAbsent ? const Value.absent() : Value(color),
      isFavorite: Value(isFavorite),
      isPinned: Value(isPinned),
      indexPos: Value(indexPos),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TextNotesDriftModelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TextNotesDriftModelData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      color: serializer.fromJson<String?>(json['color']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      indexPos: serializer.fromJson<int>(json['indexPos']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String?>(content),
      'color': serializer.toJson<String?>(color),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isPinned': serializer.toJson<bool>(isPinned),
      'indexPos': serializer.toJson<int>(indexPos),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TextNotesDriftModelData copyWith({
    int? id,
    String? title,
    Value<String?> content = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isFavorite,
    bool? isPinned,
    int? indexPos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TextNotesDriftModelData(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content.present ? content.value : this.content,
    color: color.present ? color.value : this.color,
    isFavorite: isFavorite ?? this.isFavorite,
    isPinned: isPinned ?? this.isPinned,
    indexPos: indexPos ?? this.indexPos,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TextNotesDriftModelData copyWithCompanion(TextNotesDriftModelCompanion data) {
    return TextNotesDriftModelData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      color: data.color.present ? data.color.value : this.color,
      isFavorite: data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      indexPos: data.indexPos.present ? data.indexPos.value : this.indexPos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TextNotesDriftModelData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('color: $color, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isPinned: $isPinned, ')
          ..write('indexPos: $indexPos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, color, isFavorite, isPinned, indexPos, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextNotesDriftModelData &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.color == this.color &&
          other.isFavorite == this.isFavorite &&
          other.isPinned == this.isPinned &&
          other.indexPos == this.indexPos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TextNotesDriftModelCompanion extends UpdateCompanion<TextNotesDriftModelData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> content;
  final Value<String?> color;
  final Value<bool> isFavorite;
  final Value<bool> isPinned;
  final Value<int> indexPos;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TextNotesDriftModelCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.color = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.indexPos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TextNotesDriftModelCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.content = const Value.absent(),
    this.color = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.indexPos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<TextNotesDriftModelData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? color,
    Expression<bool>? isFavorite,
    Expression<bool>? isPinned,
    Expression<int>? indexPos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (color != null) 'color': color,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isPinned != null) 'is_pinned': isPinned,
      if (indexPos != null) 'index_pos': indexPos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TextNotesDriftModelCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? content,
    Value<String?>? color,
    Value<bool>? isFavorite,
    Value<bool>? isPinned,
    Value<int>? indexPos,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TextNotesDriftModelCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      indexPos: indexPos ?? this.indexPos,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (indexPos.present) {
      map['index_pos'] = Variable<int>(indexPos.value);
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
    return (StringBuffer('TextNotesDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('color: $color, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isPinned: $isPinned, ')
          ..write('indexPos: $indexPos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftSqliteDatabase extends GeneratedDatabase {
  _$DriftSqliteDatabase(QueryExecutor e) : super(e);
  $DriftSqliteDatabaseManager get managers => $DriftSqliteDatabaseManager(this);
  late final $CategoryDriftModelTable categoryDriftModel = $CategoryDriftModelTable(this);
  late final $IconCustomDriftModelTable iconCustomDriftModel = $IconCustomDriftModelTable(this);
  late final $AccountDriftModelTable accountDriftModel = $AccountDriftModelTable(this);
  late final $TOTPDriftModelTable tOTPDriftModel = $TOTPDriftModelTable(this);
  late final $PasswordHistoryDriftModelTable passwordHistoryDriftModel =
      $PasswordHistoryDriftModelTable(this);
  late final $AccountCustomFieldDriftModelTable accountCustomFieldDriftModel =
      $AccountCustomFieldDriftModelTable(this);
  late final $TextNotesDriftModelTable textNotesDriftModel = $TextNotesDriftModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoryDriftModel,
    iconCustomDriftModel,
    accountDriftModel,
    tOTPDriftModel,
    passwordHistoryDriftModel,
    accountCustomFieldDriftModel,
    textNotesDriftModel,
  ];
}

typedef $$CategoryDriftModelTableCreateCompanionBuilder =
    CategoryDriftModelCompanion Function({
      Value<int> id,
      required String categoryName,
      Value<int> indexPos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CategoryDriftModelTableUpdateCompanionBuilder =
    CategoryDriftModelCompanion Function({
      Value<int> id,
      Value<String> categoryName,
      Value<int> indexPos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CategoryDriftModelTableReferences
    extends
        BaseReferences<_$DriftSqliteDatabase, $CategoryDriftModelTable, CategoryDriftModelData> {
  $$CategoryDriftModelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountDriftModelTable, List<AccountDriftModelData>>
  _accountDriftModelRefsTable(_$DriftSqliteDatabase db) => MultiTypedResultKey.fromTable(
    db.accountDriftModel,
    aliasName: $_aliasNameGenerator(db.categoryDriftModel.id, db.accountDriftModel.categoryId),
  );

  $$AccountDriftModelTableProcessedTableManager get accountDriftModelRefs {
    final manager = $$AccountDriftModelTableTableManager(
      $_db,
      $_db.accountDriftModel,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountDriftModelRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoryDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $CategoryDriftModelTable> {
  $$CategoryDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get indexPos =>
      $composableBuilder(column: $table.indexPos, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> accountDriftModelRefs(
    Expression<bool> Function($$AccountDriftModelTableFilterComposer f) f,
  ) {
    final $$AccountDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.categoryId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $CategoryDriftModelTable> {
  $$CategoryDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get indexPos =>
      $composableBuilder(column: $table.indexPos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoryDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $CategoryDriftModelTable> {
  $$CategoryDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<int> get indexPos =>
      $composableBuilder(column: $table.indexPos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> accountDriftModelRefs<T extends Object>(
    Expression<T> Function($$AccountDriftModelTableAnnotationComposer a) f,
  ) {
    final $$AccountDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.categoryId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $CategoryDriftModelTable,
          CategoryDriftModelData,
          $$CategoryDriftModelTableFilterComposer,
          $$CategoryDriftModelTableOrderingComposer,
          $$CategoryDriftModelTableAnnotationComposer,
          $$CategoryDriftModelTableCreateCompanionBuilder,
          $$CategoryDriftModelTableUpdateCompanionBuilder,
          (CategoryDriftModelData, $$CategoryDriftModelTableReferences),
          CategoryDriftModelData,
          PrefetchHooks Function({bool accountDriftModelRefs})
        > {
  $$CategoryDriftModelTableTableManager(_$DriftSqliteDatabase db, $CategoryDriftModelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<int> indexPos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoryDriftModelCompanion(
                id: id,
                categoryName: categoryName,
                indexPos: indexPos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoryName,
                Value<int> indexPos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoryDriftModelCompanion.insert(
                id: id,
                categoryName: categoryName,
                indexPos: indexPos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$CategoryDriftModelTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({accountDriftModelRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (accountDriftModelRefs) db.accountDriftModel],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountDriftModelRefs)
                    await $_getPrefetchedData<
                      CategoryDriftModelData,
                      $CategoryDriftModelTable,
                      AccountDriftModelData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoryDriftModelTableReferences
                          ._accountDriftModelRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoryDriftModelTableReferences(db, table, p0).accountDriftModelRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoryDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $CategoryDriftModelTable,
      CategoryDriftModelData,
      $$CategoryDriftModelTableFilterComposer,
      $$CategoryDriftModelTableOrderingComposer,
      $$CategoryDriftModelTableAnnotationComposer,
      $$CategoryDriftModelTableCreateCompanionBuilder,
      $$CategoryDriftModelTableUpdateCompanionBuilder,
      (CategoryDriftModelData, $$CategoryDriftModelTableReferences),
      CategoryDriftModelData,
      PrefetchHooks Function({bool accountDriftModelRefs})
    >;
typedef $$IconCustomDriftModelTableCreateCompanionBuilder =
    IconCustomDriftModelCompanion Function({
      Value<int> id,
      required String name,
      required String imageBase64,
    });
typedef $$IconCustomDriftModelTableUpdateCompanionBuilder =
    IconCustomDriftModelCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> imageBase64,
    });

final class $$IconCustomDriftModelTableReferences
    extends
        BaseReferences<
          _$DriftSqliteDatabase,
          $IconCustomDriftModelTable,
          IconCustomDriftModelData
        > {
  $$IconCustomDriftModelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountDriftModelTable, List<AccountDriftModelData>>
  _accountDriftModelRefsTable(_$DriftSqliteDatabase db) => MultiTypedResultKey.fromTable(
    db.accountDriftModel,
    aliasName: $_aliasNameGenerator(db.iconCustomDriftModel.id, db.accountDriftModel.iconCustomId),
  );

  $$AccountDriftModelTableProcessedTableManager get accountDriftModelRefs {
    final manager = $$AccountDriftModelTableTableManager(
      $_db,
      $_db.accountDriftModel,
    ).filter((f) => f.iconCustomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountDriftModelRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IconCustomDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $IconCustomDriftModelTable> {
  $$IconCustomDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageBase64 =>
      $composableBuilder(column: $table.imageBase64, builder: (column) => ColumnFilters(column));

  Expression<bool> accountDriftModelRefs(
    Expression<bool> Function($$AccountDriftModelTableFilterComposer f) f,
  ) {
    final $$AccountDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.iconCustomId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IconCustomDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $IconCustomDriftModelTable> {
  $$IconCustomDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageBase64 =>
      $composableBuilder(column: $table.imageBase64, builder: (column) => ColumnOrderings(column));
}

class $$IconCustomDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $IconCustomDriftModelTable> {
  $$IconCustomDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageBase64 =>
      $composableBuilder(column: $table.imageBase64, builder: (column) => column);

  Expression<T> accountDriftModelRefs<T extends Object>(
    Expression<T> Function($$AccountDriftModelTableAnnotationComposer a) f,
  ) {
    final $$AccountDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.iconCustomId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IconCustomDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $IconCustomDriftModelTable,
          IconCustomDriftModelData,
          $$IconCustomDriftModelTableFilterComposer,
          $$IconCustomDriftModelTableOrderingComposer,
          $$IconCustomDriftModelTableAnnotationComposer,
          $$IconCustomDriftModelTableCreateCompanionBuilder,
          $$IconCustomDriftModelTableUpdateCompanionBuilder,
          (IconCustomDriftModelData, $$IconCustomDriftModelTableReferences),
          IconCustomDriftModelData,
          PrefetchHooks Function({bool accountDriftModelRefs})
        > {
  $$IconCustomDriftModelTableTableManager(
    _$DriftSqliteDatabase db,
    $IconCustomDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IconCustomDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IconCustomDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IconCustomDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> imageBase64 = const Value.absent(),
              }) => IconCustomDriftModelCompanion(id: id, name: name, imageBase64: imageBase64),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String imageBase64,
              }) => IconCustomDriftModelCompanion.insert(
                id: id,
                name: name,
                imageBase64: imageBase64,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$IconCustomDriftModelTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({accountDriftModelRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (accountDriftModelRefs) db.accountDriftModel],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountDriftModelRefs)
                    await $_getPrefetchedData<
                      IconCustomDriftModelData,
                      $IconCustomDriftModelTable,
                      AccountDriftModelData
                    >(
                      currentTable: table,
                      referencedTable: $$IconCustomDriftModelTableReferences
                          ._accountDriftModelRefsTable(db),
                      managerFromTypedResult: (p0) => $$IconCustomDriftModelTableReferences(
                        db,
                        table,
                        p0,
                      ).accountDriftModelRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.iconCustomId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IconCustomDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $IconCustomDriftModelTable,
      IconCustomDriftModelData,
      $$IconCustomDriftModelTableFilterComposer,
      $$IconCustomDriftModelTableOrderingComposer,
      $$IconCustomDriftModelTableAnnotationComposer,
      $$IconCustomDriftModelTableCreateCompanionBuilder,
      $$IconCustomDriftModelTableUpdateCompanionBuilder,
      (IconCustomDriftModelData, $$IconCustomDriftModelTableReferences),
      IconCustomDriftModelData,
      PrefetchHooks Function({bool accountDriftModelRefs})
    >;
typedef $$AccountDriftModelTableCreateCompanionBuilder =
    AccountDriftModelCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> username,
      Value<String?> password,
      Value<String?> notes,
      Value<String?> icon,
      Value<int> openCount,
      required int categoryId,
      Value<int?> iconCustomId,
      Value<DateTime?> passwordUpdatedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$AccountDriftModelTableUpdateCompanionBuilder =
    AccountDriftModelCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> username,
      Value<String?> password,
      Value<String?> notes,
      Value<String?> icon,
      Value<int> openCount,
      Value<int> categoryId,
      Value<int?> iconCustomId,
      Value<DateTime?> passwordUpdatedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$AccountDriftModelTableReferences
    extends BaseReferences<_$DriftSqliteDatabase, $AccountDriftModelTable, AccountDriftModelData> {
  $$AccountDriftModelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryDriftModelTable _categoryIdTable(_$DriftSqliteDatabase db) => db
      .categoryDriftModel
      .createAlias($_aliasNameGenerator(db.accountDriftModel.categoryId, db.categoryDriftModel.id));

  $$CategoryDriftModelTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoryDriftModelTableTableManager(
      $_db,
      $_db.categoryDriftModel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IconCustomDriftModelTable _iconCustomIdTable(_$DriftSqliteDatabase db) =>
      db.iconCustomDriftModel.createAlias(
        $_aliasNameGenerator(db.accountDriftModel.iconCustomId, db.iconCustomDriftModel.id),
      );

  $$IconCustomDriftModelTableProcessedTableManager? get iconCustomId {
    final $_column = $_itemColumn<int>('icon_custom_id');
    if ($_column == null) return null;
    final manager = $$IconCustomDriftModelTableTableManager(
      $_db,
      $_db.iconCustomDriftModel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_iconCustomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TOTPDriftModelTable, List<TOTPDriftModelData>>
  _tOTPDriftModelRefsTable(_$DriftSqliteDatabase db) => MultiTypedResultKey.fromTable(
    db.tOTPDriftModel,
    aliasName: $_aliasNameGenerator(db.accountDriftModel.id, db.tOTPDriftModel.accountId),
  );

  $$TOTPDriftModelTableProcessedTableManager get tOTPDriftModelRefs {
    final manager = $$TOTPDriftModelTableTableManager(
      $_db,
      $_db.tOTPDriftModel,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tOTPDriftModelRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PasswordHistoryDriftModelTable, List<PasswordHistoryDriftModelData>>
  _passwordHistoryDriftModelRefsTable(_$DriftSqliteDatabase db) => MultiTypedResultKey.fromTable(
    db.passwordHistoryDriftModel,
    aliasName: $_aliasNameGenerator(
      db.accountDriftModel.id,
      db.passwordHistoryDriftModel.accountId,
    ),
  );

  $$PasswordHistoryDriftModelTableProcessedTableManager get passwordHistoryDriftModelRefs {
    final manager = $$PasswordHistoryDriftModelTableTableManager(
      $_db,
      $_db.passwordHistoryDriftModel,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_passwordHistoryDriftModelRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<
    $AccountCustomFieldDriftModelTable,
    List<AccountCustomFieldDriftModelData>
  >
  _accountCustomFieldDriftModelRefsTable(_$DriftSqliteDatabase db) => MultiTypedResultKey.fromTable(
    db.accountCustomFieldDriftModel,
    aliasName: $_aliasNameGenerator(
      db.accountDriftModel.id,
      db.accountCustomFieldDriftModel.accountId,
    ),
  );

  $$AccountCustomFieldDriftModelTableProcessedTableManager get accountCustomFieldDriftModelRefs {
    final manager = $$AccountCustomFieldDriftModelTableTableManager(
      $_db,
      $_db.accountCustomFieldDriftModel,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountCustomFieldDriftModelRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $AccountDriftModelTable> {
  $$AccountDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openCount =>
      $composableBuilder(column: $table.openCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get passwordUpdatedAt => $composableBuilder(
    column: $table.passwordUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$CategoryDriftModelTableFilterComposer get categoryId {
    final $$CategoryDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CategoryDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.categoryDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IconCustomDriftModelTableFilterComposer get iconCustomId {
    final $$IconCustomDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.iconCustomId,
      referencedTable: $db.iconCustomDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IconCustomDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.iconCustomDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tOTPDriftModelRefs(
    Expression<bool> Function($$TOTPDriftModelTableFilterComposer f) f,
  ) {
    final $$TOTPDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tOTPDriftModel,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TOTPDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.tOTPDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> passwordHistoryDriftModelRefs(
    Expression<bool> Function($$PasswordHistoryDriftModelTableFilterComposer f) f,
  ) {
    final $$PasswordHistoryDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passwordHistoryDriftModel,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PasswordHistoryDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.passwordHistoryDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountCustomFieldDriftModelRefs(
    Expression<bool> Function($$AccountCustomFieldDriftModelTableFilterComposer f) f,
  ) {
    final $$AccountCustomFieldDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountCustomFieldDriftModel,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountCustomFieldDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.accountCustomFieldDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $AccountDriftModelTable> {
  $$AccountDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openCount =>
      $composableBuilder(column: $table.openCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get passwordUpdatedAt => $composableBuilder(
    column: $table.passwordUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$CategoryDriftModelTableOrderingComposer get categoryId {
    final $$CategoryDriftModelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CategoryDriftModelTableOrderingComposer(
            $db: $db,
            $table: $db.categoryDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IconCustomDriftModelTableOrderingComposer get iconCustomId {
    final $$IconCustomDriftModelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.iconCustomId,
      referencedTable: $db.iconCustomDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IconCustomDriftModelTableOrderingComposer(
            $db: $db,
            $table: $db.iconCustomDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $AccountDriftModelTable> {
  $$AccountDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get openCount =>
      $composableBuilder(column: $table.openCount, builder: (column) => column);

  GeneratedColumn<DateTime> get passwordUpdatedAt =>
      $composableBuilder(column: $table.passwordUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$CategoryDriftModelTableAnnotationComposer get categoryId {
    final $$CategoryDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CategoryDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IconCustomDriftModelTableAnnotationComposer get iconCustomId {
    final $$IconCustomDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.iconCustomId,
      referencedTable: $db.iconCustomDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IconCustomDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.iconCustomDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tOTPDriftModelRefs<T extends Object>(
    Expression<T> Function($$TOTPDriftModelTableAnnotationComposer a) f,
  ) {
    final $$TOTPDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tOTPDriftModel,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TOTPDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.tOTPDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> passwordHistoryDriftModelRefs<T extends Object>(
    Expression<T> Function($$PasswordHistoryDriftModelTableAnnotationComposer a) f,
  ) {
    final $$PasswordHistoryDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passwordHistoryDriftModel,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PasswordHistoryDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.passwordHistoryDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accountCustomFieldDriftModelRefs<T extends Object>(
    Expression<T> Function($$AccountCustomFieldDriftModelTableAnnotationComposer a) f,
  ) {
    final $$AccountCustomFieldDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountCustomFieldDriftModel,
      getReferencedColumn: (t) => t.accountId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountCustomFieldDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.accountCustomFieldDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $AccountDriftModelTable,
          AccountDriftModelData,
          $$AccountDriftModelTableFilterComposer,
          $$AccountDriftModelTableOrderingComposer,
          $$AccountDriftModelTableAnnotationComposer,
          $$AccountDriftModelTableCreateCompanionBuilder,
          $$AccountDriftModelTableUpdateCompanionBuilder,
          (AccountDriftModelData, $$AccountDriftModelTableReferences),
          AccountDriftModelData,
          PrefetchHooks Function({
            bool categoryId,
            bool iconCustomId,
            bool tOTPDriftModelRefs,
            bool passwordHistoryDriftModelRefs,
            bool accountCustomFieldDriftModelRefs,
          })
        > {
  $$AccountDriftModelTableTableManager(_$DriftSqliteDatabase db, $AccountDriftModelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> openCount = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int?> iconCustomId = const Value.absent(),
                Value<DateTime?> passwordUpdatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => AccountDriftModelCompanion(
                id: id,
                title: title,
                username: username,
                password: password,
                notes: notes,
                icon: icon,
                openCount: openCount,
                categoryId: categoryId,
                iconCustomId: iconCustomId,
                passwordUpdatedAt: passwordUpdatedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> openCount = const Value.absent(),
                required int categoryId,
                Value<int?> iconCustomId = const Value.absent(),
                Value<DateTime?> passwordUpdatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => AccountDriftModelCompanion.insert(
                id: id,
                title: title,
                username: username,
                password: password,
                notes: notes,
                icon: icon,
                openCount: openCount,
                categoryId: categoryId,
                iconCustomId: iconCustomId,
                passwordUpdatedAt: passwordUpdatedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$AccountDriftModelTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                iconCustomId = false,
                tOTPDriftModelRefs = false,
                passwordHistoryDriftModelRefs = false,
                accountCustomFieldDriftModelRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tOTPDriftModelRefs) db.tOTPDriftModel,
                    if (passwordHistoryDriftModelRefs) db.passwordHistoryDriftModel,
                    if (accountCustomFieldDriftModelRefs) db.accountCustomFieldDriftModel,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$AccountDriftModelTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$AccountDriftModelTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (iconCustomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.iconCustomId,
                                    referencedTable: $$AccountDriftModelTableReferences
                                        ._iconCustomIdTable(db),
                                    referencedColumn: $$AccountDriftModelTableReferences
                                        ._iconCustomIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tOTPDriftModelRefs)
                        await $_getPrefetchedData<
                          AccountDriftModelData,
                          $AccountDriftModelTable,
                          TOTPDriftModelData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountDriftModelTableReferences
                              ._tOTPDriftModelRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountDriftModelTableReferences(db, table, p0).tOTPDriftModelRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.accountId == item.id),
                          typedResults: items,
                        ),
                      if (passwordHistoryDriftModelRefs)
                        await $_getPrefetchedData<
                          AccountDriftModelData,
                          $AccountDriftModelTable,
                          PasswordHistoryDriftModelData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountDriftModelTableReferences
                              ._passwordHistoryDriftModelRefsTable(db),
                          managerFromTypedResult: (p0) => $$AccountDriftModelTableReferences(
                            db,
                            table,
                            p0,
                          ).passwordHistoryDriftModelRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.accountId == item.id),
                          typedResults: items,
                        ),
                      if (accountCustomFieldDriftModelRefs)
                        await $_getPrefetchedData<
                          AccountDriftModelData,
                          $AccountDriftModelTable,
                          AccountCustomFieldDriftModelData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountDriftModelTableReferences
                              ._accountCustomFieldDriftModelRefsTable(db),
                          managerFromTypedResult: (p0) => $$AccountDriftModelTableReferences(
                            db,
                            table,
                            p0,
                          ).accountCustomFieldDriftModelRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.accountId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $AccountDriftModelTable,
      AccountDriftModelData,
      $$AccountDriftModelTableFilterComposer,
      $$AccountDriftModelTableOrderingComposer,
      $$AccountDriftModelTableAnnotationComposer,
      $$AccountDriftModelTableCreateCompanionBuilder,
      $$AccountDriftModelTableUpdateCompanionBuilder,
      (AccountDriftModelData, $$AccountDriftModelTableReferences),
      AccountDriftModelData,
      PrefetchHooks Function({
        bool categoryId,
        bool iconCustomId,
        bool tOTPDriftModelRefs,
        bool passwordHistoryDriftModelRefs,
        bool accountCustomFieldDriftModelRefs,
      })
    >;
typedef $$TOTPDriftModelTableCreateCompanionBuilder =
    TOTPDriftModelCompanion Function({
      Value<int> id,
      required int accountId,
      required String secretKey,
      Value<bool> isShowToHome,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TOTPDriftModelTableUpdateCompanionBuilder =
    TOTPDriftModelCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> secretKey,
      Value<bool> isShowToHome,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TOTPDriftModelTableReferences
    extends BaseReferences<_$DriftSqliteDatabase, $TOTPDriftModelTable, TOTPDriftModelData> {
  $$TOTPDriftModelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountDriftModelTable _accountIdTable(_$DriftSqliteDatabase db) => db.accountDriftModel
      .createAlias($_aliasNameGenerator(db.tOTPDriftModel.accountId, db.accountDriftModel.id));

  $$AccountDriftModelTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountDriftModelTableTableManager(
      $_db,
      $_db.accountDriftModel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TOTPDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $TOTPDriftModelTable> {
  $$TOTPDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secretKey =>
      $composableBuilder(column: $table.secretKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isShowToHome =>
      $composableBuilder(column: $table.isShowToHome, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$AccountDriftModelTableFilterComposer get accountId {
    final $$AccountDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TOTPDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $TOTPDriftModelTable> {
  $$TOTPDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secretKey =>
      $composableBuilder(column: $table.secretKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isShowToHome =>
      $composableBuilder(column: $table.isShowToHome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$AccountDriftModelTableOrderingComposer get accountId {
    final $$AccountDriftModelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableOrderingComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TOTPDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $TOTPDriftModelTable> {
  $$TOTPDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get secretKey =>
      $composableBuilder(column: $table.secretKey, builder: (column) => column);

  GeneratedColumn<bool> get isShowToHome =>
      $composableBuilder(column: $table.isShowToHome, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AccountDriftModelTableAnnotationComposer get accountId {
    final $$AccountDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TOTPDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $TOTPDriftModelTable,
          TOTPDriftModelData,
          $$TOTPDriftModelTableFilterComposer,
          $$TOTPDriftModelTableOrderingComposer,
          $$TOTPDriftModelTableAnnotationComposer,
          $$TOTPDriftModelTableCreateCompanionBuilder,
          $$TOTPDriftModelTableUpdateCompanionBuilder,
          (TOTPDriftModelData, $$TOTPDriftModelTableReferences),
          TOTPDriftModelData,
          PrefetchHooks Function({bool accountId})
        > {
  $$TOTPDriftModelTableTableManager(_$DriftSqliteDatabase db, $TOTPDriftModelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TOTPDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TOTPDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TOTPDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> secretKey = const Value.absent(),
                Value<bool> isShowToHome = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TOTPDriftModelCompanion(
                id: id,
                accountId: accountId,
                secretKey: secretKey,
                isShowToHome: isShowToHome,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String secretKey,
                Value<bool> isShowToHome = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TOTPDriftModelCompanion.insert(
                id: id,
                accountId: accountId,
                secretKey: secretKey,
                isShowToHome: isShowToHome,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $$TOTPDriftModelTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$TOTPDriftModelTableReferences._accountIdTable(
                                  db,
                                ),
                                referencedColumn: $$TOTPDriftModelTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TOTPDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $TOTPDriftModelTable,
      TOTPDriftModelData,
      $$TOTPDriftModelTableFilterComposer,
      $$TOTPDriftModelTableOrderingComposer,
      $$TOTPDriftModelTableAnnotationComposer,
      $$TOTPDriftModelTableCreateCompanionBuilder,
      $$TOTPDriftModelTableUpdateCompanionBuilder,
      (TOTPDriftModelData, $$TOTPDriftModelTableReferences),
      TOTPDriftModelData,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$PasswordHistoryDriftModelTableCreateCompanionBuilder =
    PasswordHistoryDriftModelCompanion Function({
      Value<int> id,
      required int accountId,
      required String password,
      Value<DateTime> createdAt,
    });
typedef $$PasswordHistoryDriftModelTableUpdateCompanionBuilder =
    PasswordHistoryDriftModelCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> password,
      Value<DateTime> createdAt,
    });

final class $$PasswordHistoryDriftModelTableReferences
    extends
        BaseReferences<
          _$DriftSqliteDatabase,
          $PasswordHistoryDriftModelTable,
          PasswordHistoryDriftModelData
        > {
  $$PasswordHistoryDriftModelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountDriftModelTable _accountIdTable(_$DriftSqliteDatabase db) =>
      db.accountDriftModel.createAlias(
        $_aliasNameGenerator(db.passwordHistoryDriftModel.accountId, db.accountDriftModel.id),
      );

  $$AccountDriftModelTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountDriftModelTableTableManager(
      $_db,
      $_db.accountDriftModel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PasswordHistoryDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $PasswordHistoryDriftModelTable> {
  $$PasswordHistoryDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AccountDriftModelTableFilterComposer get accountId {
    final $$AccountDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordHistoryDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $PasswordHistoryDriftModelTable> {
  $$PasswordHistoryDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AccountDriftModelTableOrderingComposer get accountId {
    final $$AccountDriftModelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableOrderingComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordHistoryDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $PasswordHistoryDriftModelTable> {
  $$PasswordHistoryDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountDriftModelTableAnnotationComposer get accountId {
    final $$AccountDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordHistoryDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $PasswordHistoryDriftModelTable,
          PasswordHistoryDriftModelData,
          $$PasswordHistoryDriftModelTableFilterComposer,
          $$PasswordHistoryDriftModelTableOrderingComposer,
          $$PasswordHistoryDriftModelTableAnnotationComposer,
          $$PasswordHistoryDriftModelTableCreateCompanionBuilder,
          $$PasswordHistoryDriftModelTableUpdateCompanionBuilder,
          (PasswordHistoryDriftModelData, $$PasswordHistoryDriftModelTableReferences),
          PasswordHistoryDriftModelData,
          PrefetchHooks Function({bool accountId})
        > {
  $$PasswordHistoryDriftModelTableTableManager(
    _$DriftSqliteDatabase db,
    $PasswordHistoryDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PasswordHistoryDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PasswordHistoryDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PasswordHistoryDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PasswordHistoryDriftModelCompanion(
                id: id,
                accountId: accountId,
                password: password,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String password,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PasswordHistoryDriftModelCompanion.insert(
                id: id,
                accountId: accountId,
                password: password,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PasswordHistoryDriftModelTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$PasswordHistoryDriftModelTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$PasswordHistoryDriftModelTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PasswordHistoryDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $PasswordHistoryDriftModelTable,
      PasswordHistoryDriftModelData,
      $$PasswordHistoryDriftModelTableFilterComposer,
      $$PasswordHistoryDriftModelTableOrderingComposer,
      $$PasswordHistoryDriftModelTableAnnotationComposer,
      $$PasswordHistoryDriftModelTableCreateCompanionBuilder,
      $$PasswordHistoryDriftModelTableUpdateCompanionBuilder,
      (PasswordHistoryDriftModelData, $$PasswordHistoryDriftModelTableReferences),
      PasswordHistoryDriftModelData,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$AccountCustomFieldDriftModelTableCreateCompanionBuilder =
    AccountCustomFieldDriftModelCompanion Function({
      Value<int> id,
      required int accountId,
      required String name,
      required String value,
      required String hintText,
      required String typeField,
    });
typedef $$AccountCustomFieldDriftModelTableUpdateCompanionBuilder =
    AccountCustomFieldDriftModelCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> name,
      Value<String> value,
      Value<String> hintText,
      Value<String> typeField,
    });

final class $$AccountCustomFieldDriftModelTableReferences
    extends
        BaseReferences<
          _$DriftSqliteDatabase,
          $AccountCustomFieldDriftModelTable,
          AccountCustomFieldDriftModelData
        > {
  $$AccountCustomFieldDriftModelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountDriftModelTable _accountIdTable(_$DriftSqliteDatabase db) =>
      db.accountDriftModel.createAlias(
        $_aliasNameGenerator(db.accountCustomFieldDriftModel.accountId, db.accountDriftModel.id),
      );

  $$AccountDriftModelTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountDriftModelTableTableManager(
      $_db,
      $_db.accountDriftModel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AccountCustomFieldDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $AccountCustomFieldDriftModelTable> {
  $$AccountCustomFieldDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hintText =>
      $composableBuilder(column: $table.hintText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeField =>
      $composableBuilder(column: $table.typeField, builder: (column) => ColumnFilters(column));

  $$AccountDriftModelTableFilterComposer get accountId {
    final $$AccountDriftModelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableFilterComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountCustomFieldDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $AccountCustomFieldDriftModelTable> {
  $$AccountCustomFieldDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hintText =>
      $composableBuilder(column: $table.hintText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeField =>
      $composableBuilder(column: $table.typeField, builder: (column) => ColumnOrderings(column));

  $$AccountDriftModelTableOrderingComposer get accountId {
    final $$AccountDriftModelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableOrderingComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountCustomFieldDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $AccountCustomFieldDriftModelTable> {
  $$AccountCustomFieldDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get hintText =>
      $composableBuilder(column: $table.hintText, builder: (column) => column);

  GeneratedColumn<String> get typeField =>
      $composableBuilder(column: $table.typeField, builder: (column) => column);

  $$AccountDriftModelTableAnnotationComposer get accountId {
    final $$AccountDriftModelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountDriftModel,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AccountDriftModelTableAnnotationComposer(
            $db: $db,
            $table: $db.accountDriftModel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountCustomFieldDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $AccountCustomFieldDriftModelTable,
          AccountCustomFieldDriftModelData,
          $$AccountCustomFieldDriftModelTableFilterComposer,
          $$AccountCustomFieldDriftModelTableOrderingComposer,
          $$AccountCustomFieldDriftModelTableAnnotationComposer,
          $$AccountCustomFieldDriftModelTableCreateCompanionBuilder,
          $$AccountCustomFieldDriftModelTableUpdateCompanionBuilder,
          (AccountCustomFieldDriftModelData, $$AccountCustomFieldDriftModelTableReferences),
          AccountCustomFieldDriftModelData,
          PrefetchHooks Function({bool accountId})
        > {
  $$AccountCustomFieldDriftModelTableTableManager(
    _$DriftSqliteDatabase db,
    $AccountCustomFieldDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountCustomFieldDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountCustomFieldDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountCustomFieldDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> hintText = const Value.absent(),
                Value<String> typeField = const Value.absent(),
              }) => AccountCustomFieldDriftModelCompanion(
                id: id,
                accountId: accountId,
                name: name,
                value: value,
                hintText: hintText,
                typeField: typeField,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String name,
                required String value,
                required String hintText,
                required String typeField,
              }) => AccountCustomFieldDriftModelCompanion.insert(
                id: id,
                accountId: accountId,
                name: name,
                value: value,
                hintText: hintText,
                typeField: typeField,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountCustomFieldDriftModelTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$AccountCustomFieldDriftModelTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$AccountCustomFieldDriftModelTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AccountCustomFieldDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $AccountCustomFieldDriftModelTable,
      AccountCustomFieldDriftModelData,
      $$AccountCustomFieldDriftModelTableFilterComposer,
      $$AccountCustomFieldDriftModelTableOrderingComposer,
      $$AccountCustomFieldDriftModelTableAnnotationComposer,
      $$AccountCustomFieldDriftModelTableCreateCompanionBuilder,
      $$AccountCustomFieldDriftModelTableUpdateCompanionBuilder,
      (AccountCustomFieldDriftModelData, $$AccountCustomFieldDriftModelTableReferences),
      AccountCustomFieldDriftModelData,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$TextNotesDriftModelTableCreateCompanionBuilder =
    TextNotesDriftModelCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> content,
      Value<String?> color,
      Value<bool> isFavorite,
      Value<bool> isPinned,
      Value<int> indexPos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TextNotesDriftModelTableUpdateCompanionBuilder =
    TextNotesDriftModelCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> content,
      Value<String?> color,
      Value<bool> isFavorite,
      Value<bool> isPinned,
      Value<int> indexPos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TextNotesDriftModelTableFilterComposer
    extends Composer<_$DriftSqliteDatabase, $TextNotesDriftModelTable> {
  $$TextNotesDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get indexPos =>
      $composableBuilder(column: $table.indexPos, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TextNotesDriftModelTableOrderingComposer
    extends Composer<_$DriftSqliteDatabase, $TextNotesDriftModelTable> {
  $$TextNotesDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get indexPos =>
      $composableBuilder(column: $table.indexPos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TextNotesDriftModelTableAnnotationComposer
    extends Composer<_$DriftSqliteDatabase, $TextNotesDriftModelTable> {
  $$TextNotesDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<int> get indexPos =>
      $composableBuilder(column: $table.indexPos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TextNotesDriftModelTableTableManager
    extends
        RootTableManager<
          _$DriftSqliteDatabase,
          $TextNotesDriftModelTable,
          TextNotesDriftModelData,
          $$TextNotesDriftModelTableFilterComposer,
          $$TextNotesDriftModelTableOrderingComposer,
          $$TextNotesDriftModelTableAnnotationComposer,
          $$TextNotesDriftModelTableCreateCompanionBuilder,
          $$TextNotesDriftModelTableUpdateCompanionBuilder,
          (
            TextNotesDriftModelData,
            BaseReferences<
              _$DriftSqliteDatabase,
              $TextNotesDriftModelTable,
              TextNotesDriftModelData
            >,
          ),
          TextNotesDriftModelData,
          PrefetchHooks Function()
        > {
  $$TextNotesDriftModelTableTableManager(_$DriftSqliteDatabase db, $TextNotesDriftModelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextNotesDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextNotesDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextNotesDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> indexPos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TextNotesDriftModelCompanion(
                id: id,
                title: title,
                content: content,
                color: color,
                isFavorite: isFavorite,
                isPinned: isPinned,
                indexPos: indexPos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> content = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> indexPos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TextNotesDriftModelCompanion.insert(
                id: id,
                title: title,
                content: content,
                color: color,
                isFavorite: isFavorite,
                isPinned: isPinned,
                indexPos: indexPos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TextNotesDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftSqliteDatabase,
      $TextNotesDriftModelTable,
      TextNotesDriftModelData,
      $$TextNotesDriftModelTableFilterComposer,
      $$TextNotesDriftModelTableOrderingComposer,
      $$TextNotesDriftModelTableAnnotationComposer,
      $$TextNotesDriftModelTableCreateCompanionBuilder,
      $$TextNotesDriftModelTableUpdateCompanionBuilder,
      (
        TextNotesDriftModelData,
        BaseReferences<_$DriftSqliteDatabase, $TextNotesDriftModelTable, TextNotesDriftModelData>,
      ),
      TextNotesDriftModelData,
      PrefetchHooks Function()
    >;

class $DriftSqliteDatabaseManager {
  final _$DriftSqliteDatabase _db;
  $DriftSqliteDatabaseManager(this._db);
  $$CategoryDriftModelTableTableManager get categoryDriftModel =>
      $$CategoryDriftModelTableTableManager(_db, _db.categoryDriftModel);
  $$IconCustomDriftModelTableTableManager get iconCustomDriftModel =>
      $$IconCustomDriftModelTableTableManager(_db, _db.iconCustomDriftModel);
  $$AccountDriftModelTableTableManager get accountDriftModel =>
      $$AccountDriftModelTableTableManager(_db, _db.accountDriftModel);
  $$TOTPDriftModelTableTableManager get tOTPDriftModel =>
      $$TOTPDriftModelTableTableManager(_db, _db.tOTPDriftModel);
  $$PasswordHistoryDriftModelTableTableManager get passwordHistoryDriftModel =>
      $$PasswordHistoryDriftModelTableTableManager(_db, _db.passwordHistoryDriftModel);
  $$AccountCustomFieldDriftModelTableTableManager get accountCustomFieldDriftModel =>
      $$AccountCustomFieldDriftModelTableTableManager(_db, _db.accountCustomFieldDriftModel);
  $$TextNotesDriftModelTableTableManager get textNotesDriftModel =>
      $$TextNotesDriftModelTableTableManager(_db, _db.textNotesDriftModel);
}
