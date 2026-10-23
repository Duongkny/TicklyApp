
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:tickly/src/core/extensions/context.dart';
import 'package:tickly/src/core/presentation/widget/input_field.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:tickly/src/router/route.dart';

// Điều chỉnh import nếu InputField nằm ở thư mục khác.


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _signInPending = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_signInPending) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.closeKeyboard();

    setState(() => _signInPending = true);

    context.read<AuthBloc>().add(
      AuthSignInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _signInWithGoogle() {
    if (_signInPending) return;

    context.closeKeyboard();

    setState(() => _signInPending = true);

    context.read<AuthBloc>().add(
      const AuthGoogleSignInRequested(),
    );
  }

  void _handleAuthenticated(AuthState state) {
    if (state.user?.isEmailVerified == true) {
      context.go(AppRoute.home);
    } else {
      context.go(AppRoute.verifyEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        if (!_signInPending) return false;

        return previous.actionStatus != current.actionStatus ||
            previous.status != current.status;
      },
      listener: (context, state) {
        if (!_signInPending) return;

        if (state.actionStatus == AuthActionStatus.failure) {
          setState(() => _signInPending = false);

          context.showSnackBarMessage(
            state.errorMessage ?? context.loc.signInFailure,
            isError: true,
          );
          return;
        }

        if (state.status == AuthStatus.authenticated &&
            state.user != null &&
            state.actionStatus == AuthActionStatus.success) {
          setState(() => _signInPending = false);
          _handleAuthenticated(state);
        }
      },
      builder: (context, state) {
        final isLoading = _signInPending;

        return Scaffold(
          backgroundColor: colors.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 24.h,
                ),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),

                        SizedBox(height: 40.h),

                        Text(
                          context.loc.commonEmail,
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),

                        InputField.email(
                          controller: _emailController,
                          hintText: 'name@example.com',
                          prefixIcon:
                              const Icon(Icons.email_outlined),
                          enabled: !isLoading,
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          context.loc.commonPassword,
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),

                        InputField.password(
                          controller: _passwordController,
                          hintText: context.loc.signInPasswordHint,
                          prefixIcon:
                              const Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          onFieldSubmitted: (_) {
                            if (!isLoading) _signIn();
                          },
                        ),

                        SizedBox(height: 8.h),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () => context.push(
                                      AppRoute.forgotPassword,
                                    ),
                            child:
                                Text(context.loc.signInForgotPassword),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        FilledButton(
                          onPressed: isLoading ? null : _signIn,
                          style: FilledButton.styleFrom(
                            minimumSize:
                                Size(double.infinity, 52.h),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14.r),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.loc.signInButton),
                        ),

                        SizedBox(height: 24.h),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              child: Text(context.loc.commonOr),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        OutlinedButton.icon(
                          onPressed:
                              isLoading ? null : _signInWithGoogle,
                          icon: const Icon(
                            Icons.account_circle_outlined,
                          ),
                          label: Text(
                            context.loc.signInWithGoogle,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize:
                                Size(double.infinity, 52.h),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14.r),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                context.loc.signUpAlreadyHaveAccount,
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.push(
                                        AppRoute.signUp,
                                      ),
                              child: Text(context.loc.signUpButton),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colorScheme;

    return Column(
      children: [
        Container(
          height: 76.r,
          width: 76.r,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius:
                BorderRadius.circular(22.r),
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 38.r,
            color: colors.onPrimaryContainer,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Welcome back!',
          style:
              context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in to continue managing your tasks.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
