import 'dart:async';

import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_cubit.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/login_state.dart';
import 'package:bloodline_mobile/app/features/identity/presentation/cubit/session_cubit.dart';
import 'package:bloodline_mobile/core/networking/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  String _messageFor(ApiFailureType type) {
    return switch (type) {
      ApiFailureType.unauthorized => 'E-mail ou senha inválidos',
      ApiFailureType.connection => 'Não foi possível conectar ao servidor',
      ApiFailureType.timeout =>
        'A conexão demorou demais, tente novamente mais tarde',
      ApiFailureType.server => 'O servidor não está disponível no momento',
      _ => 'Não foi possível realizar o login',
    };
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;

    await context.read<LoginCubit>().login(
      email: emailEC.text.trim(),
      password: passwordEC.text.trim(),
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _messageFor(state.failure.type),
          ),
        ),
      );
    }

    if (state is LoginSuccess) {
      unawaited(context.read<SessionCubit>().startSession(state.session));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: _onStateChanged,
              builder: (context, state) {
                final isLoading = state is LoginLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Entre nas sombras',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          key: const ValueKey('login_email'),
                          controller: emailEC,
                          enabled: !isLoading,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira seu e-mail';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('login_password'),
                          controller: passwordEC,
                          enabled: !isLoading,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                          ),
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira sua senha';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),
                        FilledButton(
                          key: const ValueKey('login_button'),
                          onPressed: isLoading ? null : _submit,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text('Entrar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailEC.dispose();
    passwordEC.dispose();
  }
}
