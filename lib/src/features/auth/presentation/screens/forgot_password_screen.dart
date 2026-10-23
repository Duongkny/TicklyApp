
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:tickly/src/core/extensions/context.dart';
import 'package:tickly/src/core/presentation/widget/input_field.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _requestPending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetEmail() {
    if (_requestPending) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.closeKeyboard();

    setState(() => _requestPending = true);

    context.read<AuthBloc>().add(
      AuthPasswordResetRequested(
        _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        if (!_requestPending) return false;

        return previous.actionStatus != current.actionStatus &&
            current.actionStatus != AuthActionStatus.loading;
      },
      listener: (context, state) {
        if (!_requestPending) return;

        setState(() => _requestPending = false);

        if (state.actionStatus == AuthActionStatus.success) {
          context.showSnackBarMessage(
            context.loc.forgotPasswordSuccess,
          );
          return;
        }

        if (state.actionStatus == AuthActionStatus.failure) {
          context.showSnackBarMessage(
            state.errorMessage ??
                context.loc.forgotPasswordFailure,
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: Text(context.loc.forgotPasswordTitle),
        ),
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
                      Center(
                        child: Container(
                          height: 100.r,
                          width: 100.r,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(28.r),
                          ),
                          child: Icon(
                            Icons.lock_reset_rounded,
                            color: colors.onPrimaryContainer,
                            size: 52.r,
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      Text(
                        context.loc.forgotPasswordHeading,
                        style: context.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        context.loc.forgotPasswordDescription,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 32.h),

                      Text(
                        context.loc.forgotPasswordEmailLabel,
                        style: context.textTheme.titleSmall,
                      ),

                      SizedBox(height: 8.h),

                      InputField.email(
                        controller: _emailController,
                        hintText: context.loc.forgotPasswordEmailHint,
                        prefixIcon:
                            const Icon(Icons.email_outlined),
                        textInputAction: TextInputAction.done,
                        enabled: !_requestPending,
                      ),

                      SizedBox(height: 32.h),

                      FilledButton(
                        onPressed: _requestPending
                            ? null
                            : _sendResetEmail,
                        style: FilledButton.styleFrom(
                          minimumSize:
                              Size(double.infinity, 52.h),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14.r),
                          ),
                        ),
                        child: _requestPending
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(context.loc.forgotPasswordSendButton),
                      ),

                      SizedBox(height: 16.h),

                      TextButton.icon(
                        onPressed: _requestPending
                            ? null
                            : () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: Text(context.loc.forgotPasswordBackToSignIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
