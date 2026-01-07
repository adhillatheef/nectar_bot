// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TicketsTable extends Tickets with TableInfo<$TicketsTable, Ticket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Open'));
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportedByMeta =
      const VerificationMeta('reportedBy');
  @override
  late final GeneratedColumn<String> reportedBy = GeneratedColumn<String>(
      'reported_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        category,
        priority,
        status,
        location,
        reportedBy,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickets';
  @override
  VerificationContext validateIntegrity(Insertable<Ticket> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('reported_by')) {
      context.handle(
          _reportedByMeta,
          reportedBy.isAcceptableOrUnknown(
              data['reported_by']!, _reportedByMeta));
    } else if (isInserting) {
      context.missing(_reportedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ticket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ticket(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      reportedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reported_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TicketsTable createAlias(String alias) {
    return $TicketsTable(attachedDatabase, alias);
  }
}

class Ticket extends DataClass implements Insertable<Ticket> {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String location;
  final String reportedBy;
  final DateTime createdAt;
  const Ticket(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.priority,
      required this.status,
      required this.location,
      required this.reportedBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['location'] = Variable<String>(location);
    map['reported_by'] = Variable<String>(reportedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TicketsCompanion toCompanion(bool nullToAbsent) {
    return TicketsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      priority: Value(priority),
      status: Value(status),
      location: Value(location),
      reportedBy: Value(reportedBy),
      createdAt: Value(createdAt),
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ticket(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      location: serializer.fromJson<String>(json['location']),
      reportedBy: serializer.fromJson<String>(json['reportedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'location': serializer.toJson<String>(location),
      'reportedBy': serializer.toJson<String>(reportedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Ticket copyWith(
          {String? id,
          String? title,
          String? description,
          String? category,
          String? priority,
          String? status,
          String? location,
          String? reportedBy,
          DateTime? createdAt}) =>
      Ticket(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        location: location ?? this.location,
        reportedBy: reportedBy ?? this.reportedBy,
        createdAt: createdAt ?? this.createdAt,
      );
  Ticket copyWithCompanion(TicketsCompanion data) {
    return Ticket(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      location: data.location.present ? data.location.value : this.location,
      reportedBy:
          data.reportedBy.present ? data.reportedBy.value : this.reportedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ticket(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('location: $location, ')
          ..write('reportedBy: $reportedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, category, priority,
      status, location, reportedBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ticket &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.location == this.location &&
          other.reportedBy == this.reportedBy &&
          other.createdAt == this.createdAt);
}

class TicketsCompanion extends UpdateCompanion<Ticket> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<String> priority;
  final Value<String> status;
  final Value<String> location;
  final Value<String> reportedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.location = const Value.absent(),
    this.reportedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String category,
    required String priority,
    this.status = const Value.absent(),
    required String location,
    required String reportedBy,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        category = Value(category),
        priority = Value(priority),
        location = Value(location),
        reportedBy = Value(reportedBy),
        createdAt = Value(createdAt);
  static Insertable<Ticket> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<String>? location,
    Expression<String>? reportedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (location != null) 'location': location,
      if (reportedBy != null) 'reported_by': reportedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? category,
      Value<String>? priority,
      Value<String>? status,
      Value<String>? location,
      Value<String>? reportedBy,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TicketsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      location: location ?? this.location,
      reportedBy: reportedBy ?? this.reportedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (reportedBy.present) {
      map['reported_by'] = Variable<String>(reportedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('location: $location, ')
          ..write('reportedBy: $reportedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormSessionsTable extends FormSessions
    with TableInfo<$FormSessionsTable, FormSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastQuestionIdMeta =
      const VerificationMeta('lastQuestionId');
  @override
  late final GeneratedColumn<String> lastQuestionId = GeneratedColumn<String>(
      'last_question_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [sessionId, lastQuestionId, isCompleted, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'form_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<FormSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('last_question_id')) {
      context.handle(
          _lastQuestionIdMeta,
          lastQuestionId.isAcceptableOrUnknown(
              data['last_question_id']!, _lastQuestionIdMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  FormSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormSession(
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      lastQuestionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_question_id']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $FormSessionsTable createAlias(String alias) {
    return $FormSessionsTable(attachedDatabase, alias);
  }
}

class FormSession extends DataClass implements Insertable<FormSession> {
  final String sessionId;
  final String? lastQuestionId;
  final bool isCompleted;
  final DateTime lastUpdated;
  const FormSession(
      {required this.sessionId,
      this.lastQuestionId,
      required this.isCompleted,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || lastQuestionId != null) {
      map['last_question_id'] = Variable<String>(lastQuestionId);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  FormSessionsCompanion toCompanion(bool nullToAbsent) {
    return FormSessionsCompanion(
      sessionId: Value(sessionId),
      lastQuestionId: lastQuestionId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastQuestionId),
      isCompleted: Value(isCompleted),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory FormSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormSession(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      lastQuestionId: serializer.fromJson<String?>(json['lastQuestionId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'lastQuestionId': serializer.toJson<String?>(lastQuestionId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  FormSession copyWith(
          {String? sessionId,
          Value<String?> lastQuestionId = const Value.absent(),
          bool? isCompleted,
          DateTime? lastUpdated}) =>
      FormSession(
        sessionId: sessionId ?? this.sessionId,
        lastQuestionId:
            lastQuestionId.present ? lastQuestionId.value : this.lastQuestionId,
        isCompleted: isCompleted ?? this.isCompleted,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  FormSession copyWithCompanion(FormSessionsCompanion data) {
    return FormSession(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      lastQuestionId: data.lastQuestionId.present
          ? data.lastQuestionId.value
          : this.lastQuestionId,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormSession(')
          ..write('sessionId: $sessionId, ')
          ..write('lastQuestionId: $lastQuestionId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, lastQuestionId, isCompleted, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormSession &&
          other.sessionId == this.sessionId &&
          other.lastQuestionId == this.lastQuestionId &&
          other.isCompleted == this.isCompleted &&
          other.lastUpdated == this.lastUpdated);
}

class FormSessionsCompanion extends UpdateCompanion<FormSession> {
  final Value<String> sessionId;
  final Value<String?> lastQuestionId;
  final Value<bool> isCompleted;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const FormSessionsCompanion({
    this.sessionId = const Value.absent(),
    this.lastQuestionId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormSessionsCompanion.insert({
    required String sessionId,
    this.lastQuestionId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  })  : sessionId = Value(sessionId),
        lastUpdated = Value(lastUpdated);
  static Insertable<FormSession> custom({
    Expression<String>? sessionId,
    Expression<String>? lastQuestionId,
    Expression<bool>? isCompleted,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (lastQuestionId != null) 'last_question_id': lastQuestionId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormSessionsCompanion copyWith(
      {Value<String>? sessionId,
      Value<String?>? lastQuestionId,
      Value<bool>? isCompleted,
      Value<DateTime>? lastUpdated,
      Value<int>? rowid}) {
    return FormSessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      lastQuestionId: lastQuestionId ?? this.lastQuestionId,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (lastQuestionId.present) {
      map['last_question_id'] = Variable<String>(lastQuestionId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormSessionsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('lastQuestionId: $lastQuestionId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormAnswersTable extends FormAnswers
    with TableInfo<$FormAnswersTable, FormAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES form_sessions (session_id)'));
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, questionId, answer];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'form_answers';
  @override
  VerificationContext validateIntegrity(Insertable<FormAnswer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormAnswer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
    );
  }

  @override
  $FormAnswersTable createAlias(String alias) {
    return $FormAnswersTable(attachedDatabase, alias);
  }
}

class FormAnswer extends DataClass implements Insertable<FormAnswer> {
  final int id;
  final String sessionId;
  final String questionId;
  final String answer;
  const FormAnswer(
      {required this.id,
      required this.sessionId,
      required this.questionId,
      required this.answer});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['question_id'] = Variable<String>(questionId);
    map['answer'] = Variable<String>(answer);
    return map;
  }

  FormAnswersCompanion toCompanion(bool nullToAbsent) {
    return FormAnswersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      questionId: Value(questionId),
      answer: Value(answer),
    );
  }

  factory FormAnswer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormAnswer(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      answer: serializer.fromJson<String>(json['answer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'questionId': serializer.toJson<String>(questionId),
      'answer': serializer.toJson<String>(answer),
    };
  }

  FormAnswer copyWith(
          {int? id, String? sessionId, String? questionId, String? answer}) =>
      FormAnswer(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        questionId: questionId ?? this.questionId,
        answer: answer ?? this.answer,
      );
  FormAnswer copyWithCompanion(FormAnswersCompanion data) {
    return FormAnswer(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      answer: data.answer.present ? data.answer.value : this.answer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormAnswer(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, questionId, answer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormAnswer &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.questionId == this.questionId &&
          other.answer == this.answer);
}

class FormAnswersCompanion extends UpdateCompanion<FormAnswer> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<String> questionId;
  final Value<String> answer;
  const FormAnswersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.answer = const Value.absent(),
  });
  FormAnswersCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required String questionId,
    required String answer,
  })  : sessionId = Value(sessionId),
        questionId = Value(questionId),
        answer = Value(answer);
  static Insertable<FormAnswer> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<String>? questionId,
    Expression<String>? answer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (questionId != null) 'question_id': questionId,
      if (answer != null) 'answer': answer,
    });
  }

  FormAnswersCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessionId,
      Value<String>? questionId,
      Value<String>? answer}) {
    return FormAnswersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormAnswersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('answer: $answer')
          ..write(')'))
        .toString();
  }
}

class $TicketAttachmentsTable extends TicketAttachments
    with TableInfo<$TicketAttachmentsTable, TicketAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ticketIdMeta =
      const VerificationMeta('ticketId');
  @override
  late final GeneratedColumn<String> ticketId = GeneratedColumn<String>(
      'ticket_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tickets (id)'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, ticketId, filePath, fileType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ticket_attachments';
  @override
  VerificationContext validateIntegrity(Insertable<TicketAttachment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ticket_id')) {
      context.handle(_ticketIdMeta,
          ticketId.isAcceptableOrUnknown(data['ticket_id']!, _ticketIdMeta));
    } else if (isInserting) {
      context.missing(_ticketIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TicketAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TicketAttachment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ticketId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ticket_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
    );
  }

  @override
  $TicketAttachmentsTable createAlias(String alias) {
    return $TicketAttachmentsTable(attachedDatabase, alias);
  }
}

class TicketAttachment extends DataClass
    implements Insertable<TicketAttachment> {
  final int id;
  final String ticketId;
  final String filePath;
  final String fileType;
  const TicketAttachment(
      {required this.id,
      required this.ticketId,
      required this.filePath,
      required this.fileType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ticket_id'] = Variable<String>(ticketId);
    map['file_path'] = Variable<String>(filePath);
    map['file_type'] = Variable<String>(fileType);
    return map;
  }

  TicketAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return TicketAttachmentsCompanion(
      id: Value(id),
      ticketId: Value(ticketId),
      filePath: Value(filePath),
      fileType: Value(fileType),
    );
  }

  factory TicketAttachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TicketAttachment(
      id: serializer.fromJson<int>(json['id']),
      ticketId: serializer.fromJson<String>(json['ticketId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String>(json['fileType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ticketId': serializer.toJson<String>(ticketId),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String>(fileType),
    };
  }

  TicketAttachment copyWith(
          {int? id, String? ticketId, String? filePath, String? fileType}) =>
      TicketAttachment(
        id: id ?? this.id,
        ticketId: ticketId ?? this.ticketId,
        filePath: filePath ?? this.filePath,
        fileType: fileType ?? this.fileType,
      );
  TicketAttachment copyWithCompanion(TicketAttachmentsCompanion data) {
    return TicketAttachment(
      id: data.id.present ? data.id.value : this.id,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TicketAttachment(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ticketId, filePath, fileType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TicketAttachment &&
          other.id == this.id &&
          other.ticketId == this.ticketId &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType);
}

class TicketAttachmentsCompanion extends UpdateCompanion<TicketAttachment> {
  final Value<int> id;
  final Value<String> ticketId;
  final Value<String> filePath;
  final Value<String> fileType;
  const TicketAttachmentsCompanion({
    this.id = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
  });
  TicketAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required String ticketId,
    required String filePath,
    required String fileType,
  })  : ticketId = Value(ticketId),
        filePath = Value(filePath),
        fileType = Value(fileType);
  static Insertable<TicketAttachment> custom({
    Expression<int>? id,
    Expression<String>? ticketId,
    Expression<String>? filePath,
    Expression<String>? fileType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketId != null) 'ticket_id': ticketId,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
    });
  }

  TicketAttachmentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? ticketId,
      Value<String>? filePath,
      Value<String>? fileType}) {
    return TicketAttachmentsCompanion(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ticketId.present) {
      map['ticket_id'] = Variable<String>(ticketId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TicketsTable tickets = $TicketsTable(this);
  late final $FormSessionsTable formSessions = $FormSessionsTable(this);
  late final $FormAnswersTable formAnswers = $FormAnswersTable(this);
  late final $TicketAttachmentsTable ticketAttachments =
      $TicketAttachmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tickets, formSessions, formAnswers, ticketAttachments];
}

typedef $$TicketsTableCreateCompanionBuilder = TicketsCompanion Function({
  required String id,
  required String title,
  required String description,
  required String category,
  required String priority,
  Value<String> status,
  required String location,
  required String reportedBy,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TicketsTableUpdateCompanionBuilder = TicketsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> category,
  Value<String> priority,
  Value<String> status,
  Value<String> location,
  Value<String> reportedBy,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$TicketsTableReferences
    extends BaseReferences<_$AppDatabase, $TicketsTable, Ticket> {
  $$TicketsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TicketAttachmentsTable, List<TicketAttachment>>
      _ticketAttachmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ticketAttachments,
              aliasName: $_aliasNameGenerator(
                  db.tickets.id, db.ticketAttachments.ticketId));

  $$TicketAttachmentsTableProcessedTableManager get ticketAttachmentsRefs {
    final manager = $$TicketAttachmentsTableTableManager(
            $_db, $_db.ticketAttachments)
        .filter((f) => f.ticketId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_ticketAttachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TicketsTableFilterComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportedBy => $composableBuilder(
      column: $table.reportedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> ticketAttachmentsRefs(
      Expression<bool> Function($$TicketAttachmentsTableFilterComposer f) f) {
    final $$TicketAttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ticketAttachments,
        getReferencedColumn: (t) => t.ticketId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TicketAttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.ticketAttachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TicketsTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportedBy => $composableBuilder(
      column: $table.reportedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TicketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get reportedBy => $composableBuilder(
      column: $table.reportedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> ticketAttachmentsRefs<T extends Object>(
      Expression<T> Function($$TicketAttachmentsTableAnnotationComposer a) f) {
    final $$TicketAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.ticketAttachments,
            getReferencedColumn: (t) => t.ticketId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TicketAttachmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.ticketAttachments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$TicketsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TicketsTable,
    Ticket,
    $$TicketsTableFilterComposer,
    $$TicketsTableOrderingComposer,
    $$TicketsTableAnnotationComposer,
    $$TicketsTableCreateCompanionBuilder,
    $$TicketsTableUpdateCompanionBuilder,
    (Ticket, $$TicketsTableReferences),
    Ticket,
    PrefetchHooks Function({bool ticketAttachmentsRefs})> {
  $$TicketsTableTableManager(_$AppDatabase db, $TicketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<String> reportedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TicketsCompanion(
            id: id,
            title: title,
            description: description,
            category: category,
            priority: priority,
            status: status,
            location: location,
            reportedBy: reportedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            required String category,
            required String priority,
            Value<String> status = const Value.absent(),
            required String location,
            required String reportedBy,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TicketsCompanion.insert(
            id: id,
            title: title,
            description: description,
            category: category,
            priority: priority,
            status: status,
            location: location,
            reportedBy: reportedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TicketsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ticketAttachmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ticketAttachmentsRefs) db.ticketAttachments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ticketAttachmentsRefs)
                    await $_getPrefetchedData<Ticket, $TicketsTable,
                            TicketAttachment>(
                        currentTable: table,
                        referencedTable: $$TicketsTableReferences
                            ._ticketAttachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TicketsTableReferences(db, table, p0)
                                .ticketAttachmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.ticketId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TicketsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TicketsTable,
    Ticket,
    $$TicketsTableFilterComposer,
    $$TicketsTableOrderingComposer,
    $$TicketsTableAnnotationComposer,
    $$TicketsTableCreateCompanionBuilder,
    $$TicketsTableUpdateCompanionBuilder,
    (Ticket, $$TicketsTableReferences),
    Ticket,
    PrefetchHooks Function({bool ticketAttachmentsRefs})>;
typedef $$FormSessionsTableCreateCompanionBuilder = FormSessionsCompanion
    Function({
  required String sessionId,
  Value<String?> lastQuestionId,
  Value<bool> isCompleted,
  required DateTime lastUpdated,
  Value<int> rowid,
});
typedef $$FormSessionsTableUpdateCompanionBuilder = FormSessionsCompanion
    Function({
  Value<String> sessionId,
  Value<String?> lastQuestionId,
  Value<bool> isCompleted,
  Value<DateTime> lastUpdated,
  Value<int> rowid,
});

final class $$FormSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $FormSessionsTable, FormSession> {
  $$FormSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FormAnswersTable, List<FormAnswer>>
      _formAnswersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.formAnswers,
              aliasName: $_aliasNameGenerator(
                  db.formSessions.sessionId, db.formAnswers.sessionId));

  $$FormAnswersTableProcessedTableManager get formAnswersRefs {
    final manager = $$FormAnswersTableTableManager($_db, $_db.formAnswers)
        .filter((f) => f.sessionId.sessionId
            .sqlEquals($_itemColumn<String>('session_id')!));

    final cache = $_typedResult.readTableOrNull(_formAnswersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FormSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FormSessionsTable> {
  $$FormSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastQuestionId => $composableBuilder(
      column: $table.lastQuestionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  Expression<bool> formAnswersRefs(
      Expression<bool> Function($$FormAnswersTableFilterComposer f) f) {
    final $$FormAnswersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.formAnswers,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FormAnswersTableFilterComposer(
              $db: $db,
              $table: $db.formAnswers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FormSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FormSessionsTable> {
  $$FormSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastQuestionId => $composableBuilder(
      column: $table.lastQuestionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$FormSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormSessionsTable> {
  $$FormSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get lastQuestionId => $composableBuilder(
      column: $table.lastQuestionId, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  Expression<T> formAnswersRefs<T extends Object>(
      Expression<T> Function($$FormAnswersTableAnnotationComposer a) f) {
    final $$FormAnswersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.formAnswers,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FormAnswersTableAnnotationComposer(
              $db: $db,
              $table: $db.formAnswers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FormSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FormSessionsTable,
    FormSession,
    $$FormSessionsTableFilterComposer,
    $$FormSessionsTableOrderingComposer,
    $$FormSessionsTableAnnotationComposer,
    $$FormSessionsTableCreateCompanionBuilder,
    $$FormSessionsTableUpdateCompanionBuilder,
    (FormSession, $$FormSessionsTableReferences),
    FormSession,
    PrefetchHooks Function({bool formAnswersRefs})> {
  $$FormSessionsTableTableManager(_$AppDatabase db, $FormSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> sessionId = const Value.absent(),
            Value<String?> lastQuestionId = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FormSessionsCompanion(
            sessionId: sessionId,
            lastQuestionId: lastQuestionId,
            isCompleted: isCompleted,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sessionId,
            Value<String?> lastQuestionId = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            required DateTime lastUpdated,
            Value<int> rowid = const Value.absent(),
          }) =>
              FormSessionsCompanion.insert(
            sessionId: sessionId,
            lastQuestionId: lastQuestionId,
            isCompleted: isCompleted,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FormSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({formAnswersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (formAnswersRefs) db.formAnswers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (formAnswersRefs)
                    await $_getPrefetchedData<FormSession, $FormSessionsTable,
                            FormAnswer>(
                        currentTable: table,
                        referencedTable: $$FormSessionsTableReferences
                            ._formAnswersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FormSessionsTableReferences(db, table, p0)
                                .formAnswersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.sessionId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FormSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FormSessionsTable,
    FormSession,
    $$FormSessionsTableFilterComposer,
    $$FormSessionsTableOrderingComposer,
    $$FormSessionsTableAnnotationComposer,
    $$FormSessionsTableCreateCompanionBuilder,
    $$FormSessionsTableUpdateCompanionBuilder,
    (FormSession, $$FormSessionsTableReferences),
    FormSession,
    PrefetchHooks Function({bool formAnswersRefs})>;
typedef $$FormAnswersTableCreateCompanionBuilder = FormAnswersCompanion
    Function({
  Value<int> id,
  required String sessionId,
  required String questionId,
  required String answer,
});
typedef $$FormAnswersTableUpdateCompanionBuilder = FormAnswersCompanion
    Function({
  Value<int> id,
  Value<String> sessionId,
  Value<String> questionId,
  Value<String> answer,
});

final class $$FormAnswersTableReferences
    extends BaseReferences<_$AppDatabase, $FormAnswersTable, FormAnswer> {
  $$FormAnswersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FormSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.formSessions.createAlias($_aliasNameGenerator(
          db.formAnswers.sessionId, db.formSessions.sessionId));

  $$FormSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$FormSessionsTableTableManager($_db, $_db.formSessions)
        .filter((f) => f.sessionId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FormAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $FormAnswersTable> {
  $$FormAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  $$FormSessionsTableFilterComposer get sessionId {
    final $$FormSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.formSessions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FormSessionsTableFilterComposer(
              $db: $db,
              $table: $db.formSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FormAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $FormAnswersTable> {
  $$FormAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  $$FormSessionsTableOrderingComposer get sessionId {
    final $$FormSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.formSessions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FormSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.formSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FormAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormAnswersTable> {
  $$FormAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  $$FormSessionsTableAnnotationComposer get sessionId {
    final $$FormSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.formSessions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FormSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.formSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FormAnswersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FormAnswersTable,
    FormAnswer,
    $$FormAnswersTableFilterComposer,
    $$FormAnswersTableOrderingComposer,
    $$FormAnswersTableAnnotationComposer,
    $$FormAnswersTableCreateCompanionBuilder,
    $$FormAnswersTableUpdateCompanionBuilder,
    (FormAnswer, $$FormAnswersTableReferences),
    FormAnswer,
    PrefetchHooks Function({bool sessionId})> {
  $$FormAnswersTableTableManager(_$AppDatabase db, $FormAnswersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<String> answer = const Value.absent(),
          }) =>
              FormAnswersCompanion(
            id: id,
            sessionId: sessionId,
            questionId: questionId,
            answer: answer,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessionId,
            required String questionId,
            required String answer,
          }) =>
              FormAnswersCompanion.insert(
            id: id,
            sessionId: sessionId,
            questionId: questionId,
            answer: answer,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FormAnswersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$FormAnswersTableReferences._sessionIdTable(db),
                    referencedColumn: $$FormAnswersTableReferences
                        ._sessionIdTable(db)
                        .sessionId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FormAnswersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FormAnswersTable,
    FormAnswer,
    $$FormAnswersTableFilterComposer,
    $$FormAnswersTableOrderingComposer,
    $$FormAnswersTableAnnotationComposer,
    $$FormAnswersTableCreateCompanionBuilder,
    $$FormAnswersTableUpdateCompanionBuilder,
    (FormAnswer, $$FormAnswersTableReferences),
    FormAnswer,
    PrefetchHooks Function({bool sessionId})>;
typedef $$TicketAttachmentsTableCreateCompanionBuilder
    = TicketAttachmentsCompanion Function({
  Value<int> id,
  required String ticketId,
  required String filePath,
  required String fileType,
});
typedef $$TicketAttachmentsTableUpdateCompanionBuilder
    = TicketAttachmentsCompanion Function({
  Value<int> id,
  Value<String> ticketId,
  Value<String> filePath,
  Value<String> fileType,
});

final class $$TicketAttachmentsTableReferences extends BaseReferences<
    _$AppDatabase, $TicketAttachmentsTable, TicketAttachment> {
  $$TicketAttachmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TicketsTable _ticketIdTable(_$AppDatabase db) =>
      db.tickets.createAlias(
          $_aliasNameGenerator(db.ticketAttachments.ticketId, db.tickets.id));

  $$TicketsTableProcessedTableManager get ticketId {
    final $_column = $_itemColumn<String>('ticket_id')!;

    final manager = $$TicketsTableTableManager($_db, $_db.tickets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ticketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TicketAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TicketAttachmentsTable> {
  $$TicketAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  $$TicketsTableFilterComposer get ticketId {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ticketId,
        referencedTable: $db.tickets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TicketsTableFilterComposer(
              $db: $db,
              $table: $db.tickets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TicketAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketAttachmentsTable> {
  $$TicketAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  $$TicketsTableOrderingComposer get ticketId {
    final $$TicketsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ticketId,
        referencedTable: $db.tickets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TicketsTableOrderingComposer(
              $db: $db,
              $table: $db.tickets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TicketAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketAttachmentsTable> {
  $$TicketAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  $$TicketsTableAnnotationComposer get ticketId {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ticketId,
        referencedTable: $db.tickets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TicketsTableAnnotationComposer(
              $db: $db,
              $table: $db.tickets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TicketAttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TicketAttachmentsTable,
    TicketAttachment,
    $$TicketAttachmentsTableFilterComposer,
    $$TicketAttachmentsTableOrderingComposer,
    $$TicketAttachmentsTableAnnotationComposer,
    $$TicketAttachmentsTableCreateCompanionBuilder,
    $$TicketAttachmentsTableUpdateCompanionBuilder,
    (TicketAttachment, $$TicketAttachmentsTableReferences),
    TicketAttachment,
    PrefetchHooks Function({bool ticketId})> {
  $$TicketAttachmentsTableTableManager(
      _$AppDatabase db, $TicketAttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketAttachmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> ticketId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> fileType = const Value.absent(),
          }) =>
              TicketAttachmentsCompanion(
            id: id,
            ticketId: ticketId,
            filePath: filePath,
            fileType: fileType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String ticketId,
            required String filePath,
            required String fileType,
          }) =>
              TicketAttachmentsCompanion.insert(
            id: id,
            ticketId: ticketId,
            filePath: filePath,
            fileType: fileType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TicketAttachmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ticketId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (ticketId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ticketId,
                    referencedTable:
                        $$TicketAttachmentsTableReferences._ticketIdTable(db),
                    referencedColumn: $$TicketAttachmentsTableReferences
                        ._ticketIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TicketAttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TicketAttachmentsTable,
    TicketAttachment,
    $$TicketAttachmentsTableFilterComposer,
    $$TicketAttachmentsTableOrderingComposer,
    $$TicketAttachmentsTableAnnotationComposer,
    $$TicketAttachmentsTableCreateCompanionBuilder,
    $$TicketAttachmentsTableUpdateCompanionBuilder,
    (TicketAttachment, $$TicketAttachmentsTableReferences),
    TicketAttachment,
    PrefetchHooks Function({bool ticketId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db, _db.tickets);
  $$FormSessionsTableTableManager get formSessions =>
      $$FormSessionsTableTableManager(_db, _db.formSessions);
  $$FormAnswersTableTableManager get formAnswers =>
      $$FormAnswersTableTableManager(_db, _db.formAnswers);
  $$TicketAttachmentsTableTableManager get ticketAttachments =>
      $$TicketAttachmentsTableTableManager(_db, _db.ticketAttachments);
}
