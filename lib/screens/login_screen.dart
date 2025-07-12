import 'package:firefly_chat_mobile/components/custom_button.dart';
import 'package:firefly_chat_mobile/components/custom_text_field.dart';
import 'package:firefly_chat_mobile/components/password_text_field.dart';
import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  CustomTextField(
                    hintText: 'E-mail',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  PasswordTextField(hintText: 'Senha'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(label: 'Entrar', onPressed: () {}),
                      ),
                    ],
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
