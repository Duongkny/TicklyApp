import 'package:flutter/material.dart';
import '../extensions/context.dart';
import '../local_storage/app_local_storage.dart';
import 'task_reminder_service.dart';

Future<bool> prepareTaskReminder(BuildContext context) async {
  final loc = context.loc;
  try {
    if (AppLocalStorage.get('taskRemindersEnabled') == false) {
      final enable = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(loc.taskReminders),
          content: Text(loc.enableRemindersPrompt),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(loc.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(loc.enableReminders),
            ),
          ],
        ),
      );
      if (enable != true) return false;
    }
    final service = TaskReminderService.instance;
    if (!await service.requestPermission()) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.notificationPermissionHint)));
      }
      return false;
    }
    await AppLocalStorage.localBox.put('taskRemindersEnabled', true);
    final exact = await service.requestExactPermission();
    if (!exact && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.reminderMayBeDelayed)));
    }
    return true;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.reminderUpdateFailed)));
    }
    return false;
  }
}
