import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/local_storage/local_storage_key.dart';
import 'package:tickly/src/core/notification/task_reminder_service.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late Directory directory;
  late TaskReminderService service;
  late List<MethodCall> calls;
  late Map<int, Map<String, dynamic>> pending;
  late bool exact;
  late bool permission;
  late bool revokeDuringSchedule;

  TaskEntity task({
    TaskStatus status = TaskStatus.pending,
    DateTime? reminder,
  }) => TaskEntity(
    id: 'task-1',
    userId: 'user-1',
    title: 'Study',
    status: status,
    reminderAt: reminder ?? DateTime.now().add(const Duration(minutes: 5)),
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    directory = await Directory.systemTemp.createTemp('tickly-reminder-test-');
    Hive.init(directory.path);
    await Hive.openBox<dynamic>(LocalStorageKey.localStorage);
    AppLocalStorage.currentLanguageCode = 'en';
    service = TaskReminderService.forTesting();
    calls = [];
    pending = {};
    exact = true;
    permission = false;
    revokeDuringSchedule = false;
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter_timezone'),
      (_) async => 'Asia/Ho_Chi_Minh',
    );
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'initialize':
          return true;
        case 'areNotificationsEnabled':
          return permission;
        case 'requestNotificationsPermission':
          permission = true;
          return true;
        case 'canScheduleExactNotifications':
          return exact;
        case 'pendingNotificationRequests':
          return pending.values.toList();
        case 'cancel':
          pending.remove(call.arguments['id']);
          return null;
        case 'zonedSchedule':
          final args = Map<String, dynamic>.from(call.arguments as Map);
          if (revokeDuringSchedule) {
            revokeDuringSchedule = false;
            throw PlatformException(code: 'exact_alarms_not_permitted');
          }
          pending[args['id'] as int] = {
            'id': args['id'],
            'title': args['title'],
            'body': args['body'],
            'payload': args['payload'],
          };
          return null;
        default:
          return null;
      }
    });
  });
  tearDown(() async {
    messenger.setMockMethodCallHandler(channel, null);
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter_timezone'),
      null,
    );
    await Hive.close();
    await directory.delete(recursive: true);
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'First active reminder requests notification permission and uses exact scheduling',
    () async {
      await service.syncReminders([task()], 'user-1');
      expect(
        calls.any((c) => c.method == 'requestNotificationsPermission'),
        isTrue,
      );
      expect(
        pending.values.single['payload'],
        contains(':exactAllowWhileIdle:v2'),
      );
    },
  );
  test(
    'Granting exact permission replaces a pending inexact reminder; unchanged schedules stay intact',
    () async {
      final item = task();
      exact = false;
      await service.syncReminders([item], 'user-1');
      expect(
        pending.values.single['payload'],
        contains(':inexactAllowWhileIdle:v2'),
      );
      exact = true;
      await service.syncReminders([item], 'user-1');
      expect(
        pending.values.single['payload'],
        contains(':exactAllowWhileIdle:v2'),
      );
      final scheduled = calls.where((c) => c.method == 'zonedSchedule').length;
      await service.syncReminders([item], 'user-1');
      expect(calls.where((c) => c.method == 'zonedSchedule').length, scheduled);
    },
  );
  test(
    'Exact permission revoked during scheduling falls back without dropping the reminder',
    () async {
      revokeDuringSchedule = true;
      await service.syncReminders([task()], 'user-1');
      expect(
        pending.values.single['payload'],
        contains(':inexactAllowWhileIdle:v2'),
      );
    },
  );
  test('Completing a task cancels its pending notification', () async {
    await service.syncReminders([task()], 'user-1');
    await service.syncReminders([task(status: TaskStatus.completed)], 'user-1');
    expect(pending, isEmpty);
  });
  test(
    'Disabled reminders cancel schedules and do not request notification permission',
    () async {
      await service.syncReminders([task()], 'user-1');
      await AppLocalStorage.localBox.put('taskRemindersEnabled', false);
      calls.clear();
      await service.syncReminders([task()], 'user-1');
      expect(pending, isEmpty);
      expect(
        calls.any((c) => c.method == 'requestNotificationsPermission'),
        isFalse,
      );
    },
  );
}
