import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.trText('Chat / Broadcast'),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chats'),
            Tab(text: 'Broadcast'),
          ],
          labelColor: const Color(0xFFFF6B35),
          unselectedLabelColor: Colors.white70,
          indicatorColor: const Color(0xFFFF6B35),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildChats(), _buildBroadcast()],
      ),
    );
  }

  Widget _buildChats() {
    final chats = [
      {
        'name': 'ABC Auto Care',
        'message': 'Order ready for dispatch!',
        'time': '10:45 AM',
        'unread': 2,
      },
      {
        'name': 'Speedy Garage',
        'message': 'When will the parts arrive?',
        'time': '09:30 AM',
        'unread': 0,
      },
      {
        'name': 'XYZ Motors',
        'message': 'Thanks for the delivery',
        'time': 'Yesterday',
        'unread': 0,
      },
      {
        'name': 'Elite Motors',
        'message': 'Need urgent supply',
        'time': 'Yesterday',
        'unread': 1,
      },
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFF6B35).withValues(alpha: 0.1),
            child: Text(
              chat['name'].toString()[0],
              style: const TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            chat['name'].toString(),
            style: GoogleFonts.lato(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            chat['message'].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(fontSize: 12),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat['time'].toString(),
                style: GoogleFonts.lato(fontSize: 10, color: Colors.grey),
              ),
              // if (chat['unread']! > 0)
              //   Container(
              //     margin: const EdgeInsets.only(top: 4),
              //     padding: const EdgeInsets.all(4),
              //     decoration: const BoxDecoration(
              //       color: Color(0xFFFF6B35),
              //       shape: BoxShape.circle,
              //     ),
              //     constraints: const BoxConstraints(
              //       minWidth: 18,
              //       minHeight: 18,
              //     ),
              //     child: Text(
              //       chat['unread'].toString(),
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildBroadcast() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Icon(Icons.campaign, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  context.trText('Broadcast Message'),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.trText('Send message to all garages at once'),
                  style: GoogleFonts.lato(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: context.trText('Type your broadcast message here...'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFFF6B35),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.trText('Send Broadcast'),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
