import '../../../core/localization/ui/widget/language_selector_tile.dart';
import 'package:tickly/src/core/extensions/context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/local_storage/app_local_storage.dart';
import '../../../core/notification/task_reminder_service.dart';
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../core/theme/model/theme_model.dart';
import '../../../core/presentation/widget/tickly_logo.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_event.dart';
import '../../auth/presentation/bloc/auth_state.dart';
import '../../tasks/presentation/bloc/task_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _busy = false;
  bool get _notifications =>
      AppLocalStorage.get('taskRemindersEnabled') != false;
  void _message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _toggleNotifications(bool enabled) async {
    final loc = context.loc;
    setState(() => _busy = true);
    try {
      final service = TaskReminderService.instance;
      if (enabled && !await service.requestPermission()) {
        _message(loc.notificationPermissionHint);
        return;
      }
      await AppLocalStorage.localBox.put('taskRemindersEnabled', enabled);
      if (!mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await service.syncReminders(
          context.read<TaskBloc>().state.tasks,
          user.uid,
        );
      }
    } catch (_) {
      _message(loc.reminderUpdateFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _profile() async {
    final loc = context.loc;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final controller = TextEditingController(text: user.displayName ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.profileTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 80,
          decoration: InputDecoration(labelText: loc.fullName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: Text(loc.commonSave),
          ),
        ],
      ),
    );
    // The closing dialog still uses its controller during the reverse animation.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
    if (name == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await user.updateDisplayName(name);
      if (mounted) {
        context.read<AuthBloc>().add(const AuthReloadUserRequested());
      }
      _message(loc.profileUpdated);
    } catch (_) {
      _message(loc.profileUpdateFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final loc = context.loc;
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.changePassword),
        content: Text(loc.resetPasswordConfirmation(email)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.sendLink),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _message(loc.resetLinkSent);
    } catch (_) {
      _message(loc.emailSendFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.loc.signOutTitle),
        content: Text(context.loc.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.loc.homeSignOut),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      context.read<AuthBloc>().add(const AuthSignOutRequested());
    }
  }

  Future<void> _theme() async {
    final bloc = context.read<ThemeBloc>();
    final selected = await showModalBottomSheet<ThemeModel>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.loc.themeTitle,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
            ),
            for (final theme in ThemeModel.values)
              ListTile(
                leading: Icon(switch (theme) {
                  ThemeModel.light => Icons.light_mode_outlined,
                  ThemeModel.dark => Icons.dark_mode_outlined,
                  ThemeModel.system => Icons.brightness_auto_outlined,
                }),
                title: Text(_themeLabel(theme)),
                trailing: bloc.state.selectedTheme == theme
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.pop(ctx, theme),
              ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) {
      bloc.add(ChangeTheme(selectedTheme: selected));
    }
  }

  String _themeLabel(ThemeModel theme) => switch (theme) {
    ThemeModel.system => context.loc.themeSystem,
    ThemeModel.light => context.loc.themeLight,
    ThemeModel.dark => context.loc.themeDark,
  };
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    final theme = context.watch<ThemeBloc>().state.selectedTheme;
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (a, b) => a.actionStatus != b.actionStatus,
      listener: (ctx, state) {
        if (state.actionStatus == AuthActionStatus.failure) {
          _message(state.errorMessage ?? context.loc.actionFailed);
        }
      },
      builder: (ctx, auth) {
        final busy = _busy || auth.actionStatus == AuthActionStatus.loading;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                TicklyLogo(size: 30),
                SizedBox(width: 12),
                Text(context.loc.settingsTitle),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                context.loc.accountTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colors.primaryContainer,
                        child: const Icon(Icons.person_outline),
                      ),
                      title: Text(
                        user?.displayName?.trim().isNotEmpty == true
                            ? user!.displayName!
                            : context.loc.defaultUserName,
                      ),
                      subtitle: Text(
                        user?.email ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: busy ? null : _profile,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(context.loc.profileTitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: busy ? null : _profile,
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: Text(context.loc.changePassword),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: busy ? null : _resetPassword,
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_rounded, color: colors.error),
                      title: Text(
                        context.loc.homeSignOut,
                        style: TextStyle(color: colors.error),
                      ),
                      onTap: busy ? null : _signOut,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                context.loc.applicationTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_none_rounded),
                      title: Text(context.loc.taskReminders),
                      value: _notifications,
                      onChanged: busy ? null : _toggleNotifications,
                    ),
                    ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: Text(context.loc.themeTitle),
                      subtitle: Text(_themeLabel(theme)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _theme,
                    ),
                    const LanguageSelectorTile(),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(context.loc.aboutTitle),
                      trailing: const Text('1.0.0'),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: context.loc.appName,
                        applicationVersion: '1.0.0',
                        applicationIcon: const TicklyLogo(size: 48),
                        children: [Text(context.loc.appDescription)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
