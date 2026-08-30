// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UploadItemsTable extends UploadItems
    with TableInfo<$UploadItemsTable, UploadItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UploadItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UploadState, int> state =
      GeneratedColumn<int>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<UploadState>($UploadItemsTable.$converterstate);
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bytesSentMeta = const VerificationMeta(
    'bytesSent',
  );
  @override
  late final GeneratedColumn<int> bytesSent = GeneratedColumn<int>(
    'bytes_sent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalBytesMeta = const VerificationMeta(
    'totalBytes',
  );
  @override
  late final GeneratedColumn<int> totalBytes = GeneratedColumn<int>(
    'total_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    filePath,
    state,
    attempts,
    lastError,
    bytesSent,
    totalBytes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'upload_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<UploadItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('bytes_sent')) {
      context.handle(
        _bytesSentMeta,
        bytesSent.isAcceptableOrUnknown(data['bytes_sent']!, _bytesSentMeta),
      );
    }
    if (data.containsKey('total_bytes')) {
      context.handle(
        _totalBytesMeta,
        totalBytes.isAcceptableOrUnknown(data['total_bytes']!, _totalBytesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UploadItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UploadItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      state: $UploadItemsTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}state'],
        )!,
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      bytesSent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes_sent'],
      )!,
      totalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_bytes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UploadItemsTable createAlias(String alias) {
    return $UploadItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UploadState, int, int> $converterstate =
      const EnumIndexConverter<UploadState>(UploadState.values);
}

class UploadItem extends DataClass implements Insertable<UploadItem> {
  final int id;
  final int batchId;
  final String filePath;
  final UploadState state;
  final int attempts;
  final String? lastError;
  final int bytesSent;
  final int totalBytes;
  final DateTime createdAt;
  const UploadItem({
    required this.id,
    required this.batchId,
    required this.filePath,
    required this.state,
    required this.attempts,
    this.lastError,
    required this.bytesSent,
    required this.totalBytes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<int>(batchId);
    map['file_path'] = Variable<String>(filePath);
    {
      map['state'] = Variable<int>(
        $UploadItemsTable.$converterstate.toSql(state),
      );
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['bytes_sent'] = Variable<int>(bytesSent);
    map['total_bytes'] = Variable<int>(totalBytes);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UploadItemsCompanion toCompanion(bool nullToAbsent) {
    return UploadItemsCompanion(
      id: Value(id),
      batchId: Value(batchId),
      filePath: Value(filePath),
      state: Value(state),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      bytesSent: Value(bytesSent),
      totalBytes: Value(totalBytes),
      createdAt: Value(createdAt),
    );
  }

  factory UploadItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UploadItem(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<int>(json['batchId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      state: $UploadItemsTable.$converterstate.fromJson(
        serializer.fromJson<int>(json['state']),
      ),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      bytesSent: serializer.fromJson<int>(json['bytesSent']),
      totalBytes: serializer.fromJson<int>(json['totalBytes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<int>(batchId),
      'filePath': serializer.toJson<String>(filePath),
      'state': serializer.toJson<int>(
        $UploadItemsTable.$converterstate.toJson(state),
      ),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'bytesSent': serializer.toJson<int>(bytesSent),
      'totalBytes': serializer.toJson<int>(totalBytes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UploadItem copyWith({
    int? id,
    int? batchId,
    String? filePath,
    UploadState? state,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    int? bytesSent,
    int? totalBytes,
    DateTime? createdAt,
  }) => UploadItem(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    filePath: filePath ?? this.filePath,
    state: state ?? this.state,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    bytesSent: bytesSent ?? this.bytesSent,
    totalBytes: totalBytes ?? this.totalBytes,
    createdAt: createdAt ?? this.createdAt,
  );
  UploadItem copyWithCompanion(UploadItemsCompanion data) {
    return UploadItem(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      state: data.state.present ? data.state.value : this.state,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      bytesSent: data.bytesSent.present ? data.bytesSent.value : this.bytesSent,
      totalBytes: data.totalBytes.present
          ? data.totalBytes.value
          : this.totalBytes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UploadItem(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('filePath: $filePath, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('bytesSent: $bytesSent, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batchId,
    filePath,
    state,
    attempts,
    lastError,
    bytesSent,
    totalBytes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UploadItem &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.filePath == this.filePath &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.bytesSent == this.bytesSent &&
          other.totalBytes == this.totalBytes &&
          other.createdAt == this.createdAt);
}

class UploadItemsCompanion extends UpdateCompanion<UploadItem> {
  final Value<int> id;
  final Value<int> batchId;
  final Value<String> filePath;
  final Value<UploadState> state;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> bytesSent;
  final Value<int> totalBytes;
  final Value<DateTime> createdAt;
  const UploadItemsCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.bytesSent = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UploadItemsCompanion.insert({
    this.id = const Value.absent(),
    required int batchId,
    required String filePath,
    required UploadState state,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.bytesSent = const Value.absent(),
    this.totalBytes = const Value.absent(),
    required DateTime createdAt,
  }) : batchId = Value(batchId),
       filePath = Value(filePath),
       state = Value(state),
       createdAt = Value(createdAt);
  static Insertable<UploadItem> custom({
    Expression<int>? id,
    Expression<int>? batchId,
    Expression<String>? filePath,
    Expression<int>? state,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? bytesSent,
    Expression<int>? totalBytes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (filePath != null) 'file_path': filePath,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (bytesSent != null) 'bytes_sent': bytesSent,
      if (totalBytes != null) 'total_bytes': totalBytes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UploadItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? batchId,
    Value<String>? filePath,
    Value<UploadState>? state,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? bytesSent,
    Value<int>? totalBytes,
    Value<DateTime>? createdAt,
  }) {
    return UploadItemsCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      filePath: filePath ?? this.filePath,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      bytesSent: bytesSent ?? this.bytesSent,
      totalBytes: totalBytes ?? this.totalBytes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(
        $UploadItemsTable.$converterstate.toSql(state.value),
      );
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (bytesSent.present) {
      map['bytes_sent'] = Variable<int>(bytesSent.value);
    }
    if (totalBytes.present) {
      map['total_bytes'] = Variable<int>(totalBytes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UploadItemsCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('filePath: $filePath, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('bytesSent: $bytesSent, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $QueueSettingsTable extends QueueSettings
    with TableInfo<$QueueSettingsTable, QueueSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentBatchIdMeta = const VerificationMeta(
    'currentBatchId',
  );
  @override
  late final GeneratedColumn<int> currentBatchId = GeneratedColumn<int>(
    'current_batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [id, currentBatchId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueueSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_batch_id')) {
      context.handle(
        _currentBatchIdMeta,
        currentBatchId.isAcceptableOrUnknown(
          data['current_batch_id']!,
          _currentBatchIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QueueSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_batch_id'],
      )!,
    );
  }

  @override
  $QueueSettingsTable createAlias(String alias) {
    return $QueueSettingsTable(attachedDatabase, alias);
  }
}

class QueueSetting extends DataClass implements Insertable<QueueSetting> {
  final int id;
  final int currentBatchId;
  const QueueSetting({required this.id, required this.currentBatchId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_batch_id'] = Variable<int>(currentBatchId);
    return map;
  }

  QueueSettingsCompanion toCompanion(bool nullToAbsent) {
    return QueueSettingsCompanion(
      id: Value(id),
      currentBatchId: Value(currentBatchId),
    );
  }

  factory QueueSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueSetting(
      id: serializer.fromJson<int>(json['id']),
      currentBatchId: serializer.fromJson<int>(json['currentBatchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentBatchId': serializer.toJson<int>(currentBatchId),
    };
  }

  QueueSetting copyWith({int? id, int? currentBatchId}) => QueueSetting(
    id: id ?? this.id,
    currentBatchId: currentBatchId ?? this.currentBatchId,
  );
  QueueSetting copyWithCompanion(QueueSettingsCompanion data) {
    return QueueSetting(
      id: data.id.present ? data.id.value : this.id,
      currentBatchId: data.currentBatchId.present
          ? data.currentBatchId.value
          : this.currentBatchId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueSetting(')
          ..write('id: $id, ')
          ..write('currentBatchId: $currentBatchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentBatchId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueSetting &&
          other.id == this.id &&
          other.currentBatchId == this.currentBatchId);
}

class QueueSettingsCompanion extends UpdateCompanion<QueueSetting> {
  final Value<int> id;
  final Value<int> currentBatchId;
  const QueueSettingsCompanion({
    this.id = const Value.absent(),
    this.currentBatchId = const Value.absent(),
  });
  QueueSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.currentBatchId = const Value.absent(),
  });
  static Insertable<QueueSetting> custom({
    Expression<int>? id,
    Expression<int>? currentBatchId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentBatchId != null) 'current_batch_id': currentBatchId,
    });
  }

  QueueSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? currentBatchId,
  }) {
    return QueueSettingsCompanion(
      id: id ?? this.id,
      currentBatchId: currentBatchId ?? this.currentBatchId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentBatchId.present) {
      map['current_batch_id'] = Variable<int>(currentBatchId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueSettingsCompanion(')
          ..write('id: $id, ')
          ..write('currentBatchId: $currentBatchId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UploadItemsTable uploadItems = $UploadItemsTable(this);
  late final $QueueSettingsTable queueSettings = $QueueSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    uploadItems,
    queueSettings,
  ];
}

typedef $$UploadItemsTableCreateCompanionBuilder =
    UploadItemsCompanion Function({
      Value<int> id,
      required int batchId,
      required String filePath,
      required UploadState state,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> bytesSent,
      Value<int> totalBytes,
      required DateTime createdAt,
    });
typedef $$UploadItemsTableUpdateCompanionBuilder =
    UploadItemsCompanion Function({
      Value<int> id,
      Value<int> batchId,
      Value<String> filePath,
      Value<UploadState> state,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> bytesSent,
      Value<int> totalBytes,
      Value<DateTime> createdAt,
    });

class $$UploadItemsTableFilterComposer
    extends Composer<_$AppDatabase, $UploadItemsTable> {
  $$UploadItemsTableFilterComposer({
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

  ColumnFilters<int> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UploadState, UploadState, int> get state =>
      $composableBuilder(
        column: $table.state,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytesSent => $composableBuilder(
    column: $table.bytesSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalBytes => $composableBuilder(
    column: $table.totalBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UploadItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $UploadItemsTable> {
  $$UploadItemsTableOrderingComposer({
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

  ColumnOrderings<int> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytesSent => $composableBuilder(
    column: $table.bytesSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalBytes => $composableBuilder(
    column: $table.totalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UploadItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UploadItemsTable> {
  $$UploadItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UploadState, int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get bytesSent =>
      $composableBuilder(column: $table.bytesSent, builder: (column) => column);

  GeneratedColumn<int> get totalBytes => $composableBuilder(
    column: $table.totalBytes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UploadItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UploadItemsTable,
          UploadItem,
          $$UploadItemsTableFilterComposer,
          $$UploadItemsTableOrderingComposer,
          $$UploadItemsTableAnnotationComposer,
          $$UploadItemsTableCreateCompanionBuilder,
          $$UploadItemsTableUpdateCompanionBuilder,
          (
            UploadItem,
            BaseReferences<_$AppDatabase, $UploadItemsTable, UploadItem>,
          ),
          UploadItem,
          PrefetchHooks Function()
        > {
  $$UploadItemsTableTableManager(_$AppDatabase db, $UploadItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UploadItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UploadItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UploadItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> batchId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<UploadState> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> bytesSent = const Value.absent(),
                Value<int> totalBytes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UploadItemsCompanion(
                id: id,
                batchId: batchId,
                filePath: filePath,
                state: state,
                attempts: attempts,
                lastError: lastError,
                bytesSent: bytesSent,
                totalBytes: totalBytes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int batchId,
                required String filePath,
                required UploadState state,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> bytesSent = const Value.absent(),
                Value<int> totalBytes = const Value.absent(),
                required DateTime createdAt,
              }) => UploadItemsCompanion.insert(
                id: id,
                batchId: batchId,
                filePath: filePath,
                state: state,
                attempts: attempts,
                lastError: lastError,
                bytesSent: bytesSent,
                totalBytes: totalBytes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UploadItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UploadItemsTable,
      UploadItem,
      $$UploadItemsTableFilterComposer,
      $$UploadItemsTableOrderingComposer,
      $$UploadItemsTableAnnotationComposer,
      $$UploadItemsTableCreateCompanionBuilder,
      $$UploadItemsTableUpdateCompanionBuilder,
      (
        UploadItem,
        BaseReferences<_$AppDatabase, $UploadItemsTable, UploadItem>,
      ),
      UploadItem,
      PrefetchHooks Function()
    >;
typedef $$QueueSettingsTableCreateCompanionBuilder =
    QueueSettingsCompanion Function({Value<int> id, Value<int> currentBatchId});
typedef $$QueueSettingsTableUpdateCompanionBuilder =
    QueueSettingsCompanion Function({Value<int> id, Value<int> currentBatchId});

class $$QueueSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $QueueSettingsTable> {
  $$QueueSettingsTableFilterComposer({
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

  ColumnFilters<int> get currentBatchId => $composableBuilder(
    column: $table.currentBatchId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueueSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $QueueSettingsTable> {
  $$QueueSettingsTableOrderingComposer({
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

  ColumnOrderings<int> get currentBatchId => $composableBuilder(
    column: $table.currentBatchId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueueSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QueueSettingsTable> {
  $$QueueSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentBatchId => $composableBuilder(
    column: $table.currentBatchId,
    builder: (column) => column,
  );
}

class $$QueueSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QueueSettingsTable,
          QueueSetting,
          $$QueueSettingsTableFilterComposer,
          $$QueueSettingsTableOrderingComposer,
          $$QueueSettingsTableAnnotationComposer,
          $$QueueSettingsTableCreateCompanionBuilder,
          $$QueueSettingsTableUpdateCompanionBuilder,
          (
            QueueSetting,
            BaseReferences<_$AppDatabase, $QueueSettingsTable, QueueSetting>,
          ),
          QueueSetting,
          PrefetchHooks Function()
        > {
  $$QueueSettingsTableTableManager(_$AppDatabase db, $QueueSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentBatchId = const Value.absent(),
              }) => QueueSettingsCompanion(
                id: id,
                currentBatchId: currentBatchId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentBatchId = const Value.absent(),
              }) => QueueSettingsCompanion.insert(
                id: id,
                currentBatchId: currentBatchId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueueSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QueueSettingsTable,
      QueueSetting,
      $$QueueSettingsTableFilterComposer,
      $$QueueSettingsTableOrderingComposer,
      $$QueueSettingsTableAnnotationComposer,
      $$QueueSettingsTableCreateCompanionBuilder,
      $$QueueSettingsTableUpdateCompanionBuilder,
      (
        QueueSetting,
        BaseReferences<_$AppDatabase, $QueueSettingsTable, QueueSetting>,
      ),
      QueueSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UploadItemsTableTableManager get uploadItems =>
      $$UploadItemsTableTableManager(_db, _db.uploadItems);
  $$QueueSettingsTableTableManager get queueSettings =>
      $$QueueSettingsTableTableManager(_db, _db.queueSettings);
}
