import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firefly_chat_mobile/theme/app_colors.dart';

class NotificationFilterBar extends StatefulWidget {
  final void Function(bool? isRead) onFilterChanged;

  const NotificationFilterBar({super.key, required this.onFilterChanged});

  @override
  State<NotificationFilterBar> createState() => _NotificationFilterBarState();
}

class _NotificationFilterBarState extends State<NotificationFilterBar>
    with SingleTickerProviderStateMixin {
  bool? _isReadOnly;
  bool? _isUnreadOnly;
  Timer? _debounce;

  void _onFilterTap({bool? isRead}) {
    // Aplica debounce
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onFilterChanged(isRead);
    });
  }

  void _toggleUnread() {
    setState(() {
      _isUnreadOnly = _isUnreadOnly == null ? true : null;
      _isReadOnly = null;
    });
    _onFilterTap(isRead: _isUnreadOnly == true ? false : null);
  }

  void _toggleRead() {
    setState(() {
      _isReadOnly = _isReadOnly == null ? true : null;
      _isUnreadOnly = null;
    });
    _onFilterTap(isRead: _isReadOnly == true ? true : null);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAnimatedButton(
          label: 'Não lidas',
          selected: _isUnreadOnly == true,
          onPressed: _toggleUnread,
        ),
        const SizedBox(width: 8),
        _buildAnimatedButton(
          label: 'Lidas',
          selected: _isReadOnly == true,
          onPressed: _toggleRead,
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected ? AppColors.secondary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? AppColors.secondary : AppColors.neutral400,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? AppColors.foreground : AppColors.neutral400,
            ),
          ),
        ),
      ),
    );
  }
}
