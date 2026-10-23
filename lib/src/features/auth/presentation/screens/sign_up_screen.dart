
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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _signUpPending = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_signUpPending) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.closeKeyboard();

    setState(() => _signUpPending = true);

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        if (!_signUpPending) return false;

        return previous.actionStatus != current.actionStatus ||
            previous.successMessage != current.successMessage ||
            previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (!_signUpPending) return;

        if (state.actionStatus == AuthActionStatus.failure) {
          setState(() => _signUpPending = false);

          context.showSnackBarMessage(
            state.errorMessage ?? context.loc.signUpFailure,
            isError: true,
          );
          return;
        }

        final registrationSucceeded =
            state.actionStatus == AuthActionStatus.success &&
            state.successMessage == context.loc.signUpSuccess;

        if (!registrationSucceeded) return;

        setState(() => _signUpPending = false);

        final user = state.user;

        if (user == null) {
          context.showSnackBarMessage(
            'Không thể lấy thông tin tài khoản.',
            isError: true,
          );
          return;
        }

        if (user.isEmailVerified) {
          context.go(AppRoute.home);
          return;
        }

        context.read<AuthBloc>().add(
          const AuthEmailVerificationRequested(),
        );

        context.go(AppRoute.verifyEmail);
      },
      builder: (context, state) {
        final isLoading = _signUpPending;

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

                        SizedBox(height: 32.h),

                        // EMAIL
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

                        // PASSWORD
                        Text(
                          context.loc.commonPassword,
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),

                        InputField.password(
                          controller: _passwordController,
                          hintText: context.loc.signUpPasswordHint,
                          prefixIcon:
                              const Icon(Icons.lock_outline),
                          enabled: !isLoading,
                        ),

                        SizedBox(height: 20.h),

                        // CONFIRM PASSWORD
                        Text(
                          context.loc.commonConfirmPassword,
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),

                        InputField.confirmPassword(
                          controller: _confirmPasswordController,
                          passwordController: _passwordController,
                          hintText: context.loc.signUpConfirmPasswordHint,
                          prefixIcon: const Icon(
                            Icons.verified_user_outlined,
                          ),
                          enabled: !isLoading,
                          onFieldSubmitted: (_) {
                            if (!isLoading) _signUp();
                          },
                        ),

                        SizedBox(height: 32.h),

                        FilledButton(
                          onPressed: isLoading ? null : _signUp,
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
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.loc.signUpButton),
                        ),

                        SizedBox(height: 20.h),

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
                                  : () => context.go(
                                        AppRoute.signIn,
                                      ),
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
          width: 76.r,
          height: 76.r,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius:
                BorderRadius.circular(22.r),
          ),
          child: Icon(
            Icons.person_add_alt_1_rounded,
            size: 38.r,
            color: colors.onPrimaryContainer,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Create account',
          textAlign: TextAlign.center,
          style:
              context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Join Tickly and start organizing your day.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
