import 'package:tickly/src/core/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widget/tickly_logo.dart';
import '../../../../router/route.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [colors.primaryContainer, colors.surface],
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: -.12,
                          child: Container(
                            width: 190,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: .12),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TicklyLogo(size: 42),
                                const SizedBox(height: 20),
                                Text(
                                  context.loc.welcomeGoodDay,
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 16),
                                for (var i = 0; i < 3; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          i < 2
                                              ? Icons.check_circle_rounded
                                              : Icons.radio_button_unchecked,
                                          color: i < 2
                                              ? colors.primary
                                              : colors.outline,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color: colors.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 20,
                          child: Icon(
                            Icons.alarm_rounded,
                            size: 46,
                            color: const Color(0xFFFFB547),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 28,
                          child: Icon(
                            Icons.eco_rounded,
                            size: 48,
                            color: const Color(0xFF61B577),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TicklyLogo(size: 42),
                      const SizedBox(width: 12),
                      Text(
                        context.loc.appName,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.loc.welcomeHeadline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.loc.welcomeDescription,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.push(AppRoute.signUp),
                      child: Text(context.loc.welcomeStart),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(context.loc.signUpAlreadyHaveAccount),
                      TextButton(
                        onPressed: () => context.push(AppRoute.signIn),
                        child: Text(context.loc.signUpSignIn),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
