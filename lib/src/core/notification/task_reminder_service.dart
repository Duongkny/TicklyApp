
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/tasks/domain/entities/task_entity.dart';

class TaskReminderService {
  TaskReminderService._();

  static final TaskReminderService instance =
      TaskReminderService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initializationFuture;
  Future<void> _syncQueue = Future<void>.value();

  static const String _taskPrefix = 'tickly-task:';

  static const NotificationDetails _notificationDetails =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'tickly_task_reminders',
      'Nhắc nhở công việc',
      channelDescription: 'Thông báo nhắc nhở từ Tickly',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  // ==================== INITIALIZE ====================

  Future<void> initialize() {
    return _initializationFuture ??= _initializePlugin().catchError(
      (Object error, StackTrace stackTrace) {
        _initializationFuture = null;
        Error.throwWithStackTrace(error, stackTrace);
      },
    );
  }

  Future<void> _initializePlugin() async {
    tz.initializeTimeZones();

    final timezoneInfo =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(timezoneInfo.identifier),
    );

    const settings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );

    await _plugin.initialize(settings: settings);

    debugPrint('[Reminder] Initialized: ${tz.local.name}');
  }

  // ==================== PERMISSION ====================

  Future<bool> requestPermission() async {
    await initialize();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    return await android
            ?.requestNotificationsPermission() ??
        false;
  }

  // ==================== NOTIFICATION ID ====================

  int _notificationId(TaskEntity task) {
    final value = '${task.userId}:${task.id}';

    var hash = 2166136261;

    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }

    return hash & 0x7FFFFFFF;
  }

  // Payload chứa dữ liệu dùng để so sánh lịch.
  String _payload(TaskEntity task) {
    final timestamp =
        task.reminderAt!.toUtc().millisecondsSinceEpoch;

    return '$_taskPrefix'
        '${Uri.encodeComponent(task.userId)}:'
        '${Uri.encodeComponent(task.id)}:'
        '$timestamp:'
        '${Uri.encodeComponent(task.title)}';
  }

  // ==================== SCHEDULE ====================

  Future<void> scheduleReminder(TaskEntity task) async {
    await initialize();

    final id = _notificationId(task);

    await _plugin.cancel(id: id);

    if (task.isCompleted || task.reminderAt == null) {
      return;
    }

    final reminderAt = task.reminderAt!;

    if (!reminderAt.isAfter(DateTime.now())) {
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: 'Nhắc nhở công việc',
      body: 'Đến giờ thực hiện: ${task.title}',
      scheduledDate: tz.TZDateTime.from(
        reminderAt,
        tz.local,
      ),
      notificationDetails: _notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _payload(task),
    );

    debugPrint('[Reminder] Scheduled: ${task.title}');
  }

  // ==================== CANCEL ====================

  Future<void> cancelReminder(TaskEntity task) async {
    await initialize();

    await _plugin.cancel(
      id: _notificationId(task),
    );

    debugPrint('[Reminder] Cancelled: ${task.title}');
  }

  // ==================== SYNC ====================

  Future<void> syncReminders(
    List<TaskEntity> tasks,
    String userId,
  ) {
    // Xếp hàng các lần đồng bộ để tránh chạy song song.
    final operation = _syncQueue.then(
      (_) => _syncNow(tasks, userId),
    );

    // Một lần sync lỗi không làm hỏng hàng đợi tiếp theo.
    _syncQueue = operation.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[Reminder] Sync failed: $error');
      },
    );

    return operation;
  }

  Future<void> _syncNow(
    List<TaskEntity> tasks,
    String userId,
  ) async {
    await initialize();

    final now = DateTime.now();

    final activeTasks = tasks.where((task) {
      return task.userId == userId &&
          !task.isCompleted &&
          task.reminderAt != null &&
          task.reminderAt!.isAfter(now);
    }).toList();

    // Đọc các thông báo còn chờ trên Android.
    final pending =
        await _plugin.pendingNotificationRequests();

    final pendingById = {
      for (final notification in pending)
        notification.id: notification,
    };

    final wantedById = {
      for (final task in activeTasks)
        _notificationId(task): task,
    };

    // Hủy những lịch Tickly không còn cần thiết.
    for (final notification in pending) {
      if (notification.payload?.startsWith(_taskPrefix) !=
          true) {
        continue;
      }

      final task = wantedById[notification.id];

      if (task == null) {
        await _plugin.cancel(id: notification.id);
        continue;
      }

      // Nếu lịch thay đổi, scheduleReminder()
      // sẽ thay thế thông báo cũ.
    }

    // Tạo hoặc cập nhật lịch cần thiết.
    for (final task in activeTasks) {
      final id = _notificationId(task);
      final existing = pendingById[id];

      // Không đặt lại lịch không thay đổi.
      if (existing?.payload == _payload(task)) {
        continue;
      }

      await scheduleReminder(task);
    }

    debugPrint(
      '[Reminder] Synced ${activeTasks.length} tasks',
    );
  }

  // ==================== CLEAR ON SIGN OUT ====================

  Future<void> clearTaskReminders() async {
    // Đợi những lần đồng bộ trước hoàn tất.
    await _syncQueue;
    await initialize();

    final pending =
        await _plugin.pendingNotificationRequests();

    for (final notification in pending) {
      if (notification.payload?.startsWith(_taskPrefix) ==
          true) {
        await _plugin.cancel(id: notification.id);
      }
    }

    debugPrint('[Reminder] Cleared task reminders');
  }

  // ==================== TEST ====================

  Future<void> showTestNotification() async {
    await initialize();

    await _plugin.show(
      id: 2147483647,
      title: 'Tickly',
      body: 'Thông báo thử nghiệm hoạt động!',
      notificationDetails: _notificationDetails,
    );
  }

  // ==================== DEBUG ====================

  Future<int> pendingCount() async {
    await initialize();

    final pending =
        await _plugin.pendingNotificationRequests();

    return pending
        .where(
          (notification) =>
              notification.payload?.startsWith(_taskPrefix) ==
              true,
        )
        .length;
  }
}
