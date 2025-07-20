import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';
import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';
import 'package:firefly_chat_mobile/components/error_alert_dialog.dart';
import 'package:firefly_chat_mobile/providers/friendship_provider.dart';
import 'package:firefly_chat_mobile/models/value-objects/invitation_with_sender.dart';

class PendingInvitationsScreen extends StatefulWidget {
  const PendingInvitationsScreen({super.key});

  @override
  State<PendingInvitationsScreen> createState() =>
      _PendingInvitationsScreenState();
}

class _PendingInvitationsScreenState extends State<PendingInvitationsScreen> {
  List<InvitationWithSender> _pendingInvitations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserPendingInvitations();
  }

  Future<void> _loadUserPendingInvitations() async {
    setState(() => _isLoading = true);

    try {
      final friendshipProvider = Provider.of<FriendshipProvider>(
        context,
        listen: false,
      );

      final pendingInvitations = await friendshipProvider
          .fetchUserPendingInvitations();

      setState(() {
        _pendingInvitations = pendingInvitations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading pending invitations: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> acceptInvitation(String invitationId, bool isAccept) async {
    setState(() => _isLoading = true);

    try {
      final friendshipProvider = Provider.of<FriendshipProvider>(
        context,
        listen: false,
      );

      if (isAccept) {
        await friendshipProvider.acceptInvitation(invitationId);
      } else {
        await friendshipProvider.rejectInvitation(invitationId);
      }

      await _loadUserPendingInvitations();
    } on ApiExceptions catch (error) {
      print('Accept invitation error: $error');

      if (context.mounted) {
        ErrorAlertDialog.showDialogError(
          context: context,
          title: 'Erro ao tentar responder a solicitação',
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
      appBar: CustomAppBar(title: 'Convites pendentes', showAvatar: false),
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
                    const Text('Carregando convites pendentes...'),
                  ],
                ),
              )
            : _pendingInvitations.isEmpty
            ? const Text(
                'Não há convites pendentes',
                textAlign: TextAlign.center,
              )
            : ListView.builder(
                itemCount: _pendingInvitations.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.neutral800,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          _pendingInvitations[index].sender.avatarUrl ??
                              'https://api.dicebear.com/9.x/thumbs/png?seed=${_pendingInvitations[index].sender.name}',
                        ),
                        radius: 30,
                      ),
                      title: Text(_pendingInvitations[index].sender.name),
                      subtitle: Text(
                        "@${_pendingInvitations[index].sender.username}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => acceptInvitation(
                              _pendingInvitations[index].id,
                              true,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => acceptInvitation(
                              _pendingInvitations[index].id,
                              false,
                            ),
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
