// lib/home/messages_page.dart
// ignore: unused_import
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatboxapp/home/Mes/CreateGroupPage.dart';
import 'package:chatboxapp/home/Mes/Chat.dart';

class MessagesPage extends StatefulWidget {
  final User user;
  const MessagesPage({super.key, required this.user});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  int currentPageIndex = 0;

  // ====== FIRESTORE STREAMS ======

  // Stream đọc status của chính user từ Firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> _myStatusStream(User user) {
    return FirebaseFirestore.instance
        .collection('statuses')
        .doc(user.uid)
        .snapshots();
  }

  // Stream đọc danh sách conversation của user
  Stream<QuerySnapshot<Map<String, dynamic>>> _conversationsStream(User user) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .where('members', arrayContains: user.uid)
        .snapshots();
  }

  // Stream đọc danh sách user để hiển thị avatar ngang (status)
  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  // ====== HÀM XỬ LÝ MORE / DELETE ======

  Future<void> _deleteConversation(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    try {
      await doc.reference.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xoá cuộc trò chuyện')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi xoá cuộc trò chuyện: $e')),
      );
    }
  }

  Future<void> _markConversationRead(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    try {
      await doc.reference.update({'unreadCount': 0});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đánh dấu đã đọc')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật: $e')),
      );
    }
  }

  void _showMoreOptions(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final bool isGroup = (data?['isGroup'] ?? false) == true;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.mark_chat_read_outlined),
                title: const Text('Đánh dấu đã đọc'),
                onTap: () async {
                  Navigator.pop(context);
                  await _markConversationRead(doc);
                },
              ),
              if (isGroup)
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Thông tin nhóm (demo)'),
                  subtitle: const Text('Sau này mở màn info group'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: điều hướng sang màn thông tin nhóm
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Đóng'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // Lấy uid người còn lại trong cuộc chat 1-1
  String? _getPeerId(Map<String, dynamic> data, String currentUid) {
    final membersDynamic = data['members'];
    if (membersDynamic is! List) return null;
    final members = membersDynamic.map((e) => e.toString()).toList();
    try {
      return members.firstWhere((id) => id != currentUid);
    } catch (_) {
      return null;
    }
  }

  // ================== BUILD ==================

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0800),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.search,
            color: Color(0xFFFFFFFF),
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage("assets/images/MyStatus.png")
              as ImageProvider,
            ),
          ),
        ],
      ),

      // Nút tạo Group
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A4CF0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateGroupPage(currentUser: user),
            ),
          );
        },
        child: const Icon(Icons.group_add),
      ),

      body: Column(
        children: [
          // ======== THANH STATUS NGANG ========
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),

                // ======== MY STATUS (LẤY TỪ FIRESTORE) ========
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _myStatusStream(user),
                  builder: (context, snapshot) {
                    final hasStatus =
                        snapshot.hasData && snapshot.data!.exists;
                    final data = snapshot.data?.data();

                    final String? statusImageUrl =
                    data?['imageUrl'] as String?;
                    final String? caption =
                    data?['caption'] as String?;

                    return GestureDetector(
                      onTap: () {
                        if (hasStatus) {
                          // TODO: mở màn xem status của chính mình
                        } else {
                          // TODO: mở màn tạo status mới
                        }
                      },
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: statusImageUrl != null
                                    ? NetworkImage(statusImageUrl)
                                    : (user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : const AssetImage(
                                    "assets/images/MyStatus.png"))
                                as ImageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                              if (hasStatus) ...[
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: ArcPainter(
                                      startAngle: -0.3,
                                      sweepAngle: 2.3,
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: ArcPainter(
                                      startAngle: 3.8,
                                      sweepAngle: 1.9,
                                      color: const Color(0xFF797C7B),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              ],
                              if (!hasStatus)
                                Positioned(
                                  bottom: -3,
                                  right: -3,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black87,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "My status",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          if (hasStatus &&
                              caption != null &&
                              caption.isNotEmpty)
                            SizedBox(
                              width: 70,
                              child: Text(
                                caption,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(width: 10),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _usersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final docs = snapshot.data!.docs
                        .where((d) => d.id != user.uid) // bỏ chính mình
                        .toList();

                    return Row(
                      children: docs.map((doc) {
                        final data = doc.data();
                        final name = (data['displayName'] ??
                            data['name'] ??
                            'Unknown')
                        as String;
                        final photoUrl = data['photoURL'] as String?;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // TODO: mở màn xem status của user này
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: photoUrl != null &&
                                      photoUrl.isNotEmpty
                                      ? NetworkImage(photoUrl)
                                      : const AssetImage(
                                      'assets/images/AlexLinderson.png')
                                  as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      color: Color(0xFFFFFFFF)),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          // ======== DANH SÁCH CHAT (LẤY TỪ FIRESTORE) ========
          Expanded(
            child: ClipRRect(
              // bo góc + clip luôn Slidable bên trong
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: Container(
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _conversationsStream(user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Lỗi tải dữ liệu: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Chưa có cuộc trò chuyện nào',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    final docs = snapshot.data!.docs.toList();
                    docs.sort((a, b) {
                      final da = a.data();
                      final db = b.data();

                      final ta = da['updatedAt'];
                      final tb = db['updatedAt'];

                      if (ta is! Timestamp || tb is! Timestamp) {
                        return 0;
                      }
                      return tb.toDate().compareTo(ta.toDate());
                    });
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0, // lùi list vào trong
                      ),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data();

                        final bool isGroup =
                            (data['isGroup'] ?? false) == true;

                        final name =
                        (data['name'] ?? 'Unknown') as String;
                        final lastMessage =
                        (data['lastMessage'] ?? '') as String;
                        final avatarUrl =
                        data['avatarUrl'] as String?;
                        final unreadCount =
                        (data['unreadCount'] ?? 0) as int?;
                        final timestamp = data['updatedAt'];

                        String timeText = '';
                        if (timestamp is Timestamp) {
                          final dt = timestamp.toDate();
                          final now = DateTime.now();
                          final diff = now.difference(dt).inMinutes;
                          if (diff < 1) {
                            timeText = 'Just now';
                          } else if (diff < 60) {
                            timeText = '$diff min ago';
                          } else {
                            final hours = now.difference(dt).inHours;
                            if (hours < 24) {
                              timeText = '$hours h ago';
                            } else {
                              timeText = '${dt.day}/${dt.month}';
                            }
                          }
                        }

                        // Xác định uid để lấy online-status
                        final String? peerId = isGroup
                            ? (data['createdBy'] as String?)
                            : _getPeerId(data, user.uid);

                        return Slidable(
                          key: ValueKey(doc.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.45,
                            children: [
                              // MORE
                              SlidableAction(
                                onPressed: (c) {
                                  _showMoreOptions(doc);
                                },
                                backgroundColor: Colors.grey.shade600,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              // DELETE
                              SlidableAction(
                                onPressed: (c) {
                                  _deleteConversation(doc);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  ///////// hâhhahhahahaahahahhaahhahaahhhahahahahahah
                                  MaterialPageRoute(
                                    builder: (_) => ChatDetailPage(
                                      currentUser: user,
                                      conversationId: doc.id,
                                      conversationName: name,
                                      isGroup: isGroup,
                                      peerId: peerId,
                                    ),
                                  ),
                                );
                              },
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: avatarUrl != null &&
                                        avatarUrl.isNotEmpty
                                        ? NetworkImage(avatarUrl)
                                        : const AssetImage(
                                        'assets/images/AlexLinderson.png')
                                    as ImageProvider,
                                  ),

                                  // ===== CHẤM ONLINE / OFFLINE =====
                                  if (peerId != null)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(peerId)
                                            .snapshots(),
                                        builder: (context, snap) {
                                          final isOnline = snap.data
                                              ?.data()?['isOnline'] ==
                                              true;
                                          return Container(
                                            width: 13,
                                            height: 13,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isOnline
                                                  ? Colors.green
                                                  : Colors.grey,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  // ===== ICON NHÓM =====
                                  if (isGroup)
                                    const Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: CircleAvatar(
                                        radius: 9,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.group,
                                          size: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              title: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                lastMessage.isNotEmpty
                                    ? lastMessage
                                    : (isGroup
                                    ? 'Nhóm mới được tạo'
                                    : 'No messages yet'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    timeText,
                                    style: const TextStyle(
                                      color: Color(0xFF797C7B),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (unreadCount != null &&
                                      unreadCount > 0)
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                      const Color(0xFF4A4CF0),
                                      child: Text(
                                        unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== ARC PAINTER ==================
class ArcPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final Color color;
  final double strokeWidth;
  ArcPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    required this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect.deflate(3),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
