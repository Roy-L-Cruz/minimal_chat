import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../db/database_helper.dart';
import '../models/chat_partner.dart';
import 'chat_screen.dart';
import 'new_chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<ChatPartner> _chatPartners = [];

  @override
  void initState() {
    super.initState();
    _loadChatPartners();
  }

  Future<void> _loadChatPartners() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (userId == null) return;

    final results = await DatabaseHelper.instance.getChatPartners(userId);
    setState(() {
      _chatPartners = results.map((map) => ChatPartner.fromMap(map)).toList();
    });
  }

  Future<void> _deleteChat(ChatPartner partner) async {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (userId == null) return;

    await DatabaseHelper.instance.deleteChat(userId, partner.id);
    await _loadChatPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chatPartners.length,
        itemBuilder: (context, index) {
          final partner = _chatPartners[index];
          return Dismissible(
            key: Key(partner.id.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deleteChat(partner),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(partner.username[0].toUpperCase()),
              ),
              title: Text(partner.username),
              subtitle: Text(
                partner.lastMessage ?? 'No messages yet',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: partner.lastTimestamp != null
                  ? Text(
                      DateTime.parse(partner.lastTimestamp!)
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : null,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(partnerId: partner.id),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewChatScreen()),
          );
          _loadChatPartners();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 