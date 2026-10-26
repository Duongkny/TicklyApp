import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:tickly/src/core/extensions/context.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:tickly/src/router/route.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _checking = false;
  bool _resending = false;

  void _checkVerification() {
    if (_checking || _resending) return;

    setState(() => _checking = true);

    context.read<AuthBloc>().add(const AuthReloadUserRequested());
  }

  void _resendVerification() {
    if (_checking || _resending) return;

    setState(() => _resending = true);

    context.read<AuthBloc>().add(const AuthEmailVerificationRequested());
  }

  void _signOut() {
    context.read<AuthBloc>().add(const AuthSignOutRequested());

    context.go(AppRoute.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous.user?.isEmailVerified !=
                current.user?.isEmailVerified ||
            previous.actionStatus != current.actionStatus ||
            previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go(AppRoute.signIn);
          return;
        }

        if (state.user?.isEmailVerified == true) {
          context.go(AppRoute.home);
          return;
        }

        if (state.actionStatus == AuthActionStatus.loading) {
          return;
        }

        if (_checking) {
          setState(() => _checking = false);

          if (state.actionStatus == AuthActionStatus.failure) {
            context.showSnackBarMessage(
              state.errorMessage ?? context.loc.verifyEmailCheckFailure,
              isError: true,
            );
          } else {
            context.showSnackBarMessage(context.loc.verifyEmailNotVerified);
          }
        } else if (_resending) {
          setState(() => _resending = false);

          if (state.actionStatus == AuthActionStatus.failure) {
            context.showSnackBarMessage(
              state.errorMessage ?? context.loc.verifyEmailResendFailure,
              isError: true,
            );
          } else {
            context.showSnackBarMessage(context.loc.verifyEmailResendSuccess);
          }
        }
      },
      builder: (context, state) {
        final email = state.user?.email ?? context.loc.emailAddressFallback;

        final busy = _checking || _resending;

        return Scaffold(
          backgroundColor: colors.surface,
          appBar: AppBar(
            title: Text(context.loc.verifyEmailTitle),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          height: 100.r,
                          width: 100.r,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            size: 52.r,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      Text(
                        context.loc.verifyEmailHeading,
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        context.loc.verifyEmailSentTo,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        context.loc.verifyEmailDescription,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),

                      SizedBox(height: 36.h),

                      FilledButton.icon(
                        onPressed: busy ? null : _checkVerification,
                        icon: _checking
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.verified_outlined),
                        label: Text(
                          _checking
                              ? context.loc.verifyEmailChecking
                              : context.loc.verifyEmailCheckButton,
                        ),
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 52.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      OutlinedButton.icon(
                        onPressed: busy ? null : _resendVerification,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          _resending
                              ? context.loc.verifyEmailResending
                              : context.loc.verifyEmailResendButton,
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 52.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      TextButton(
                        onPressed: busy ? null : _signOut,
                        child: Text(context.loc.verifyEmailSignOut),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
