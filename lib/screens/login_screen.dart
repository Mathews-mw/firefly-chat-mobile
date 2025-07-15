import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:firefly_chat_mobile/app_routes.dart';
import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/services/auth_service.dart';
import 'package:firefly_chat_mobile/services/http_service.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';
import 'package:firefly_chat_mobile/components/custom_button.dart';
import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';
import 'package:firefly_chat_mobile/components/custom_text_field.dart';
import 'package:firefly_chat_mobile/components/error_alert_dialog.dart';
import 'package:firefly_chat_mobile/components/password_text_field.dart';
import 'package:firefly_chat_mobile/@mixins/form_validations_mixin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormValidationsMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool _isLoading = false;

  Future<void> handleLogin() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      setState(() => _isLoading = false);
      return;
    }

    formKey.currentState?.save();

    try {
      final httpService = HttpService();
      final authService = AuthService();

      print('form data: $formData');

      final response = await httpService.post(
        endpoint: 'auth/signin/credentials',
        data: {'email': formData['email'], 'password': formData['password']},
      );

      authService.saveToken(response['token']);

      if (context.mounted) {
        await Provider.of<UserProvider>(context, listen: false).loadUserData();

        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } on ApiExceptions catch (error) {
      print('Login error: $error');

      if (context.mounted) {
        ErrorAlertDialog.showDialogError(
          context: context,
          title: 'Erro de autenticação',
          code: error.code,
          message: error.message,
          description:
              'Credenciais inválidas! Por favor, verifique seu e-mail e senha e tente novamente.',
        );
      }
    } catch (error) {
      print('Unexpected Login error: $error');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aconteceu um erro inesperado. Tente novamente'),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height - mediaQuery.viewPadding.vertical;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.neutral900,
        extendBody: true,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/firefly_brand.png',
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'E-mail',
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => combine([
                            () => isNotEmpty(value),
                            () => isEmail(
                              value,
                              'Por favor, informe um e-mail válido.',
                            ),
                          ]),
                          onSaved: (value) {
                            formData['email'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
                        PasswordTextField(
                          hintText: 'Senha',
                          enabled: !_isLoading,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['password'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                label: 'Entrar',
                                isLoading: _isLoading,
                                disabled: _isLoading,
                                onPressed: () => handleLogin(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Ou escolha um provedor social',
                    style: TextStyle(color: AppColors.foreground),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      CustomButton(
                        variant: Variant.muted,
                        onPressed: () {},
                        label: 'Entrar com Google',
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          height: 32,
                          width: 32,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        variant: Variant.muted,
                        onPressed: () {},
                        label: 'Entrar com Github',
                        icon: Image.asset(
                          'assets/images/github_logo.png',
                          height: 32,
                          width: 32,
                        ),
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
