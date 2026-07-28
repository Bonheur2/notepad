import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/chat_providers.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/widgets/empty_state.dart';
import '../../domain/entities/chat_message.dart';

class ChatThreadScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String? friendDisplayName;

  const ChatThreadScreen({
    super.key,
    required this.chatId,
    this.friendDisplayName,
  });

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _textController = TextEditingController();
  bool _sending = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final repo = ref.read(chatRepositoryProvider);
    if (repo == null) return;

    setState(() => _sending = true);
    _textController.clear();
    try {
      await repo.sendMessage(
        chatId: widget.chatId,
        participants: widget.chatId.split('_'),
        text: text,
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String _dateLabel(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(local.year, local.month, local.day);
    final diff = today.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${local.day}/${local.month}/${local.year}';
  }

  List<Widget> _buildRows(List<ChatMessage> messages, String? myUid) {
    final rows = <Widget>[];
    DateTime? lastDate;
    ChatMessage? previous;

    for (final message in messages) {
      final local = message.sentAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (lastDate == null || day != lastDate) {
        rows.add(_DateSeparator(label: _dateLabel(message.sentAt)));
        lastDate = day;
        previous = null;
      }

      final isMine = message.senderId == myUid;
      final groupedWithPrevious = previous != null && previous.senderId == message.senderId;
      rows.add(_MessageBubble(
        message: message,
        isMine: isMine,
        tight: groupedWithPrevious,
      ));
      previous = message;
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final myUid = ref.watch(authStateProvider).valueOrNull?.uid;
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person, color: colorScheme.onPrimaryContainer, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.friendDisplayName ?? 'Chat',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(color: colorScheme.surfaceContainerLowest),
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
                data: (messages) {
                  if (messages.isEmpty) {
                    return const EmptyState(
                      icon: Icons.waving_hand_outlined,
                      message: 'Say hello!',
                    );
                  }
                  final rows = _buildRows(messages, myUid).reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: rows.length,
                    itemBuilder: (context, index) => rows[index],
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.arrow_upward, size: 20),
                    tooltip: 'Send message',
                    onPressed: (_sending || !_hasText) ? null : _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final String label;

  const _DateSeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final bool tight;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.tight,
  });

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const radius = Radius.circular(16);
    const tightRadius = Radius.circular(4);
    final textColor = isMine ? colorScheme.onPrimary : colorScheme.onSurface;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: tight ? 2 : 8, bottom: 2),
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        decoration: BoxDecoration(
          color: isMine ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: radius,
            topRight: radius,
            bottomLeft: isMine ? radius : tightRadius,
            bottomRight: isMine ? tightRadius : radius,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text, style: TextStyle(color: textColor)),
            const SizedBox(height: 2),
            Text(
              _formatTime(message.sentAt),
              style: TextStyle(
                fontSize: 10.5,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
