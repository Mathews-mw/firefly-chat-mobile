import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firefly_chat_mobile/components/custom_button.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';
import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';
import 'package:firefly_chat_mobile/components/custom_text_field.dart';
import 'package:firefly_chat_mobile/components/error_alert_dialog.dart';
import 'package:firefly_chat_mobile/providers/friendship_provider.dart';
import 'package:firefly_chat_mobile/@mixins/form_validations_mixin.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen>
    with FormValidationsMixin {
  bool _isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  Future<void> handleSendInvitation() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      setState(() => _isLoading = false);
      return;
    }

    formKey.currentState?.save();

    try {
      final friendshipProvider = Provider.of<FriendshipProvider>(
        context,
        listen: false,
      );

      final Map<String, dynamic> data = {'username': formData['username']};

      await friendshipProvider.sendFriendshipRequest(data);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitação de amizade enviada com sucesso!'),
          ),
        );

        Navigator.of(context).pop();
      }
    } on ApiExceptions catch (error) {
      print('Login error: $error');

      if (context.mounted) {
        ErrorAlertDialog.showDialogError(
          context: context,
          title: 'Erro ao tentar enviar solicitação',
          code: error.code,
          message: error.message,
        );
      }
    } catch (error) {
      print('Unexpected Invitation error: $error');

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
    return Scaffold(
      appBar: CustomAppBar(title: 'Adicionar amigo', showAvatar: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adicionar um amigo através do seu nome de usuário',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                const Text('Quem você quer adicionar?'),
                const SizedBox(height: 5),
                Form(
                  key: formKey,
                  child: CustomTextField(
                    hintText: 'Nome do usuário',
                    enabled: !_isLoading,
                    textInputAction: TextInputAction.done,
                    validator: (value) => combine([() => isNotEmpty(value)]),
                    onSaved: (value) {
                      formData['username'] = value ?? '';
                    },
                  ),
                ),
              ],
            ),
            CustomButton(
              label: 'Enviar solicitação',
              isLoading: _isLoading,
              disabled: _isLoading,
              onPressed: () => handleSendInvitation(),
            ),
          ],
        ),
      ),
    );
  }
}
