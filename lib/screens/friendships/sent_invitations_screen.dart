import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';
import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';
import 'package:firefly_chat_mobile/components/error_alert_dialog.dart';
import 'package:firefly_chat_mobile/providers/friendship-provider.dart';
import 'package:firefly_chat_mobile/models/value-objects/invitation_with_receiver.dart';

class SentInvitationsScreen extends StatefulWidget {
  const SentInvitationsScreen({super.key});

  @override
  State<SentInvitationsScreen> createState() => _SentInvitationsScreenState();
}

class _SentInvitationsScreenState extends State<SentInvitationsScreen> {
  List<InvitationWithReceiver> _sentInvitations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserSentInvitations();
  }

  Future<void> _loadUserSentInvitations() async {
    setState(() => _isLoading = true);

    try {
      final friendshipProvider = Provider.of<FriendshipProvider>(
        context,
        listen: false,
      );

      final sentInvitations = await friendshipProvider
          .fetchUserSentInvitations();

      setState(() {
        _sentInvitations = sentInvitations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading sent invitations: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> handleDeleteInvitation(String invitationId) async {
    setState(() => _isLoading = true);

    try {
      final friendshipProvider = Provider.of<FriendshipProvider>(
        context,
        listen: false,
      );

      await friendshipProvider.deleteInvitation(invitationId);

      await _loadUserSentInvitations();
    } on ApiExceptions catch (error) {
      ErrorAlertDialog.showDialogError(
        context: context,
        title: 'Erro ao tentar remover convite',
        code: error.code,
        message: error.message,
      );
      throw Exception('Failed to delete invitation: ${error.message}');
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
      appBar: CustomAppBar(title: 'Convites enviados', showAvatar: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    const Text('Carregando convites enviados...'),
                  ],
                ),
              )
            : _sentInvitations.isEmpty
            ? const Text(
                'Não há convites enviados',
                textAlign: TextAlign.center,
              )
            : ListView.builder(
                itemCount: _sentInvitations.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.neutral800,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          _sentInvitations[index].receiver.avatarUrl ??
                              'https://api.dicebear.com/9.x/thumbs/png?seed=${_sentInvitations[index].receiver.name}',
                        ),
                        radius: 30,
                      ),
                      title: Text(_sentInvitations[index].receiver.name),
                      subtitle: Text(
                        "@${_sentInvitations[index].receiver.username}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              PhosphorIcons.trash(),
                              color: AppColors.danger,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: AppColors.neutral800,
                                  contentTextStyle: TextStyle(
                                    color: AppColors.foreground,
                                  ),
                                  title: Text(
                                    'Remover convite',
                                    style: TextStyle(
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                  content: const Text(
                                    ''
                                    'Você tem certeza que deseja remover este convite?',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        await handleDeleteInvitation(
                                          _sentInvitations[index].id,
                                        );

                                        Navigator.pop(context, true);
                                      },
                                      child: const Text(
                                        'Remover',
                                        style: TextStyle(
                                          color: AppColors.danger,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text(
                                        'Fechar',
                                        style: TextStyle(
                                          color: AppColors.foreground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
