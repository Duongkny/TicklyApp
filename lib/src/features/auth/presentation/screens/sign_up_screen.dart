
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:tickly/src/core/extensions/context.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:tickly/src/router/route.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.closeKeyboard();

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
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus ||
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.actionStatus == AuthActionStatus.failure) {
          context.showSnackBarMessage(
            state.errorMessage ?? 'Đăng ký thất bại',
            isError: true,
          );
        }

        if (state.actionStatus == AuthActionStatus.success &&
            state.successMessage == 'Đăng ký thành công') {
          context.showSnackBarMessage('Đăng ký thành công');

          // Nếu yêu cầu xác minh email:
          // context.go(AppRoute.verifyEmail);
          //
          // Sau này Auth-aware GoRouter sẽ chịu trách nhiệm
          // điều hướng theo phiên đăng nhập.
        }
      },
      builder: (context, state) {
        final isLoading =
            state.actionStatus == AuthActionStatus.loading;

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
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),

                        SizedBox(height: 32.h),

                        Text(
                          'Email',
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            hintText: 'name@example.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'Vui lòng nhập email';
                            }

                            if (!RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            ).hasMatch(email)) {
                              return 'Email không hợp lệ';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          'Password',
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            hintText: 'At least 8 characters',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: isLoading
                                  ? null
                                  : () => setState(() {
                                      _obscurePassword =
                                          !_obscurePassword;
                                    }),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final password = value ?? '';

                            if (password.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }

                            if (password.length < 8) {
                              return 'Mật khẩu phải có ít nhất 8 ký tự';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          'Confirm Password',
                          style: context.textTheme.titleSmall,
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            hintText: 'Re-enter your password',
                            prefixIcon:
                                const Icon(Icons.verified_user_outlined),
                            suffixIcon: IconButton(
                              onPressed: isLoading
                                  ? null
                                  : () => setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    }),
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng xác nhận mật khẩu';
                            }

                            if (value != _passwordController.text) {
                              return 'Mật khẩu xác nhận không khớp';
                            }

                            return null;
                          },
                          onFieldSubmitted: (_) {
                            if (!isLoading) _signUp();
                          },
                        ),

                        SizedBox(height: 32.h),

                        FilledButton(
                          onPressed: isLoading ? null : _signUp,
                          style: FilledButton.styleFrom(
                            minimumSize: Size(double.infinity, 52.h),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Create Account'),
                        ),

                        SizedBox(height: 20.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text('Already have an account?'),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.go(AppRoute.signIn),
                              child: const Text('Sign In'),
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
            borderRadius: BorderRadius.circular(22.r),
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
          style: context.textTheme.headlineMedium?.copyWith(
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
