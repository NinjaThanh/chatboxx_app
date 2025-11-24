// ignore_for_file: unused_import

// Có lerpDouble, ImageFilter, File nếu sau này cần animation, blur, gửi file, v.v.
import 'dart:ui' show lerpDouble, ImageFilter;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:chatboxapp/widgets/GoogleMap.dart';
import 'package:chatboxapp/widgets/record_button.dart';
import 'package:chatboxapp/widgets/callCameraApi.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

/// ===================== HELPER: CHECK FRIENDS =====================
/// Giả sử cấu trúc friends: /users/{uid}/friends/{friendId}
Future<bool> _areFriends(String myUid, String peerUid) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('friends')
        .doc(peerUid)
        .get();

    return doc.exists; // tồn tại doc => đã là bạn
  } catch (_) {
    return false;
  }
}

/// ===================== MESSAGES PAGE =====================

class MessagesPage extends StatefulWidget {
  final User user;
  const MessagesPage({super.key, required this.user});

  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  int currentPageIndex = 0;

  Stream<DocumentSnapshot<Map<String, dynamic>>> _myStatusStream(User user) {
    return FirebaseFirestore.instance
        .collection('statuses')
        .doc(user.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _conversationsStream(User user) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .where('members', arrayContains: user.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

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

  /// Avatar cho item conversation:
  /// - 1-1: lấy avatar từ users/{peerId} => luôn là avatar của đối phương
  /// - Group: dùng avatarUrl của group + icon nhóm
  Widget _buildConversationAvatar({
    required bool isGroup,
    required String? peerId,
    required String? avatarUrl,
  }) {
    // GROUP
    if (isGroup) {
      final ImageProvider groupImage =
      (avatarUrl != null && avatarUrl.isNotEmpty)
          ? NetworkImage(avatarUrl)
          : const AssetImage('assets/images/AlexLinderson.png')
      as ImageProvider;

      return Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: groupImage,
          ),
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
      );
    }

    // 1-1: nếu không có peerId thì fallback
    if (peerId == null) {
      return const CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/images/AlexLinderson.png'),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
      FirebaseFirestore.instance.collection('users').doc(peerId).snapshots(),
      builder: (context, snap) {
        String? photoUrl;
        bool isOnline = false;

        if (snap.hasData && snap.data!.data() != null) {
          final uData = snap.data!.data()!;
          photoUrl = uData['photoURL'] as String?;
          isOnline = (uData['isOnline'] ?? false) as bool;
        }

        final ImageProvider imageProvider =
        (photoUrl != null && photoUrl.isNotEmpty)
            ? NetworkImage(photoUrl)
            : const AssetImage('assets/images/AlexLinderson.png')
        as ImageProvider;

        return Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: imageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? Colors.green : Colors.grey,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Mở / tạo cuộc trò chuyện 1-1
  /// ĐÃ THÊM CHECK: nếu chưa là bạn => không cho nhắn
  Future<void> _openChatWithUser(
      User currentUser,
      String peerId,
      String peerName,
      String? avatarUrl,
      ) async {
    try {
      // ====== CHECK ĐÃ LÀ BẠN CHƯA ======
      final isFriend = await _areFriends(currentUser.uid, peerId);
      if (!isFriend) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hai bạn chưa kết bạn nên chưa thể nhắn tin.'),
          ),
        );
        return;
      }

      final convsSnap = await FirebaseFirestore.instance
          .collection('conversations')
          .where('isGroup', isEqualTo: false)
          .where('members', arrayContains: currentUser.uid)
          .get();

      DocumentSnapshot<Map<String, dynamic>>? existing;
      for (final doc in convsSnap.docs) {
        final data = doc.data();
        final members =
        (data['members'] as List).map((e) => e.toString()).toList();
        if (members.contains(peerId)) {
          existing = doc;
          break;
        }
      }

      String conversationId;
      if (existing != null) {
        conversationId = existing.id;
      } else {
        final newConvRef =
        await FirebaseFirestore.instance.collection('conversations').add({
          'name': peerName,
          'isGroup': false,
          // avatarUrl không dùng cho 1-1, để trống cũng được
          'avatarUrl': avatarUrl ?? '',
          'members': [currentUser.uid, peerId],
          'lastMessage': '',
          'unreadCount': 0,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': currentUser.uid,
          'lastSenderId': null,
        });
        conversationId = newConvRef.id;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailPage(
            currentUser: currentUser,
            conversationId: conversationId,
            conversationName: peerName,
            isGroup: false,
            peerId: peerId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi mở cuộc trò chuyện: $e')),
      );
    }
  }

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
              backgroundImage: (user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage("assets/images/MyStatus.png"))
              as ImageProvider,
            ),
          ),
        ],
      ),
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

                // ======== MY STATUS ========
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _myStatusStream(user),
                  builder: (context, snapshot) {
                    final hasStatus =
                        snapshot.hasData && snapshot.data!.exists;
                    final data = snapshot.data?.data();

                    final String? statusImageUrl =
                    data?['imageUrl'] as String?;
                    final String? caption = data?['caption'] as String?;

                    return GestureDetector(
                      onTap: () {
                        if (hasStatus) {
                          // TODO: mở xem status của mình
                        } else {
                          // TODO: tạo status mới
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
                                backgroundImage: (statusImageUrl != null
                                    ? NetworkImage(statusImageUrl)
                                    : (user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : const AssetImage(
                                    "assets/images/MyStatus.png")))
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
                          Text(
                            user.displayName ?? 'My status',
                            style: const TextStyle(
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

                // ======== LIST USER STATUS ========
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _usersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final docs =
                    snapshot.data!.docs.where((d) => d.id != user.uid).toList();

                    return Row(
                      children: docs.map((doc) {
                        final data = doc.data();
                        final name = (data['displayName'] ??
                            data['name'] ??
                            'Unknown') as String;
                        final photoUrl = data['photoURL'] as String?;
                        final bool isOnline =
                        (data['isOnline'] ?? false) as bool;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _openChatWithUser(
                                    user,
                                    doc.id,
                                    name,
                                    photoUrl,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                      (photoUrl != null && photoUrl.isNotEmpty
                                          ? NetworkImage(photoUrl)
                                          : const AssetImage(
                                          'assets/images/Alex.png'))
                                      as ImageProvider,
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    color: Color(0xFFFFFFFF),
                                  ),
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

          // ======== LIST CONVERSATIONS ========
          Expanded(
            child: ClipRRect(
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
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                        horizontal: 16.0,
                      ),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
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

                        final String? lastSenderId =
                        data['lastSenderId'] as String?;
                        final bool hasUnreadForMe =
                            (unreadCount != null && unreadCount > 0) &&
                                lastSenderId != user.uid;

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

                        final String? peerId = isGroup
                            ? (data['createdBy'] as String?)
                            : _getPeerId(
                          data,
                          user.uid,
                        );

                        return Slidable(
                          key: ValueKey(doc.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.45,
                            children: [
                              SlidableAction(
                                onPressed: (c) {
                                  _showMoreOptions(doc);
                                },
                                backgroundColor: Colors.grey.shade600,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
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
                              leading: _buildConversationAvatar(
                                isGroup: isGroup,
                                peerId: peerId,
                                avatarUrl: avatarUrl,
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
                                  if (hasUnreadForMe)
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                      const Color(0xFFE74C3C),
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

/// ================== ARC PAINTER ==================

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

/// ===================== CREATE GROUP PAGE =====================

class CreateGroupPage extends StatefulWidget {
  final User currentUser;
  const CreateGroupPage({super.key, required this.currentUser});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _creating = false;
  final Set<String> _selectedUserIds = {};

  Future<void> _createGroup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tên nhóm')),
      );
      return;
    }

    if (_selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chọn ít nhất 1 thành viên')),
      );
      return;
    }

    setState(() {
      _creating = true;
    });

    try {
      final members = <String>{
        widget.currentUser.uid,
        ..._selectedUserIds,
      }.toList();

      await FirebaseFirestore.instance.collection('conversations').add({
        'name': name,
        'isGroup': true,
        'avatarUrl': '',
        'members': members,
        'lastMessage': '',
        'unreadCount': 0,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': widget.currentUser.uid,
        'lastSenderId': null,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo nhóm thành công')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _creating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tạo nhóm: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = widget.currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo nhóm mới'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên nhóm',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Chọn thành viên:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _usersStream(),
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
                      'Lỗi tải users: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Chưa có user nào'),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final uid = doc.id;

                    final isCurrent = uid == currentUid;

                    final name = (data['displayName'] ??
                        data['name'] ??
                        'Unknown') as String;
                    final photoUrl = data['photoURL'] as String?;
                    final bool isOnline =
                    (data['isOnline'] ?? false) as bool;

                    final selected = _selectedUserIds.contains(uid);

                    return CheckboxListTile(
                      secondary: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: (photoUrl != null &&
                                photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : const AssetImage(
                                'assets/images/AlexLinderson.png'))
                            as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isOnline
                                    ? Colors.green
                                    : Colors.grey,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        isCurrent ? '$name (Bạn)' : name,
                      ),
                      value: isCurrent ? true : selected,
                      onChanged: isCurrent
                          ? null
                          : (val) {
                        setState(() {
                          if (val == true) {
                            _selectedUserIds.add(uid);
                          } else {
                            _selectedUserIds.remove(uid);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _creating ? null : _createGroup,
                  icon: _creating
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check),
                  label: Text(
                    _creating ? 'Đang tạo nhóm...' : 'Tạo nhóm',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================== CHAT DETAIL PAGE =====================

class ChatDetailPage extends StatefulWidget {
  final User currentUser;
  final String conversationId;
  final String conversationName;
  final bool isGroup;
  final String? peerId;

  const ChatDetailPage({
    super.key,
    required this.currentUser,
    required this.conversationId,
    required this.conversationName,
    required this.isGroup,
    this.peerId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _sending = false;

  CollectionReference<Map<String, dynamic>> get _messagesCol =>
      FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId)
          .collection('messages');

  // ================== PICK & UPLOAD DOCUMENT ==================
  Future<void> _pickAndUploadDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withReadStream: true,
    );
    if (result == null) return;

    final file = result.files.single;

    try {
      final uri = Uri.parse('https://your-api.com/upload'); // API demo
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile(
            'file',
            file.readStream!,
            file.size,
            filename: file.name,
          ),
        )
        ..fields['conversationId'] = widget.conversationId
        ..fields['senderId'] = widget.currentUser.uid;

      final response = await request.send();

      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload tài liệu thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload thất bại: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi upload: $e')),
      );
    }
  }

  // ================== PICK & SEND MEDIA (IMAGE / VIDEO) ==================
  Future<void> _pickAndSendMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );
      if (result == null) return;

      final picked = result.files.single;
      final path = picked.path;
      if (path == null) return;

      final lowerPath = path.toLowerCase();
      final isVideo = lowerPath.endsWith('.mp4') ||
          lowerPath.endsWith('.mov') ||
          lowerPath.endsWith('.avi') ||
          lowerPath.endsWith('.mkv') ||
          lowerPath.endsWith('.3gp') ||
          lowerPath.endsWith('.wmv');

      final folder = isVideo ? 'chat_videos' : 'chat_images';
      final ext = lowerPath.contains('.') ? lowerPath.split('.').last : '';
      final fileName =
          '${widget.conversationId}_${DateTime.now().millisecondsSinceEpoch}.${ext.isNotEmpty ? ext : "dat"}';

      final ref =
      FirebaseStorage.instance.ref().child(folder).child(fileName);

      final file = File(path);
      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();

      await _sendMediaMessage(
        url: url,
        mediaType: isVideo ? 'video' : 'image',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isVideo ? 'Đã gửi video thành công' : 'Đã gửi ảnh thành công',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi gửi media: $e')),
      );
    }
  }

  Future<void> _sendMediaMessage({
    required String url,
    required String mediaType, // 'image' | 'video'
  }) async {
    try {
      final now = FieldValue.serverTimestamp();
      final user = widget.currentUser;

      await _messagesCol.add({
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Unknown',
        'text': '',
        'type': mediaType,
        'fileUrl': url,
        'createdAt': now,
      });

      final convRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId);

      final lastMsg = mediaType == 'video' ? '[Video]' : '[Image]';

      await convRef.update({
        'lastMessage': lastMsg,
        'updatedAt': now,
        'lastSenderId': user.uid,
        'unreadCount': FieldValue.increment(1),
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi lưu tin nhắn media: $e')),
      );
    }
  }

  // ================== LẤY VỊ TRÍ HIỆN TẠI (GEOLocator) ==================
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Kiểm tra GPS đã bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Vui lòng bật GPS / Location trên thiết bị';
    }

    // 2. Kiểm tra quyền truy cập
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Bạn đã từ chối quyền truy cập vị trí';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Quyền vị trí đã bị từ chối vĩnh viễn. Vào Settings để bật lại.';
    }

    // 3. Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ================== SHARE LOCATION (GỬI TIN NHẮN KIỂU location) ==================
  Future<void> _shareLocation() async {
    try {
      final position = await _getCurrentLocation();
      final lat = position.latitude;
      final lng = position.longitude;

      final now = FieldValue.serverTimestamp();
      final user = widget.currentUser;

      await _messagesCol.add({
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Unknown',
        'type': 'location',
        'text': '',
        'lat': lat,
        'lng': lng,
        'createdAt': now,
      });

      final convRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId);

      await convRef.update({
        'lastMessage': '[Location]',
        'updatedAt': now,
        'lastSenderId': user.uid,
        'unreadCount': FieldValue.increment(1),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã chia sẻ vị trí của bạn')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chia sẻ vị trí: $e')),
      );
    }
  }

  // ================== SEND TEXT MESSAGE ==================
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
    });

    try {
      final now = FieldValue.serverTimestamp();
      final user = widget.currentUser;

      await _messagesCol.add({
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Unknown',
        'text': text,
        'type': 'text',
        'createdAt': now,
      });

      final convRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId);

      await convRef.update({
        'lastMessage': text,
        'updatedAt': now,
        'lastSenderId': user.uid,
        'unreadCount': FieldValue.increment(1),
      });

      _messageController.clear();

      await Future.delayed(const Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi gửi tin nhắn: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  // ================== MARK READ ==================
  Future<void> _markRead() async {
    try {
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId)
          .update({'unreadCount': 0});
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markRead();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ================== APPBAR (1-1 / GROUP) ==================
  PreferredSizeWidget _buildAppBar() {
    // ---- 1-1 CHAT ----
    if (!widget.isGroup && widget.peerId != null) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.peerId)
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            final name = (data?['displayName'] ??
                data?['name'] ??
                widget.conversationName) as String;
            final photoUrl = data?['photoURL'] as String?;
            final isOnline = (data?['isOnline'] ?? false) as bool;

            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : const AssetImage(
                      'assets/images/AlexLinderson.png'))
                  as ImageProvider,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isOnline
                                ? const Color(0xFF0A7C66)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOnline ? 'Active now' : 'Offline',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9C9C9C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          // CALL sử dụng dữ liệu từ Firestore
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/Call.svg",
              width: 24,
              height: 24,
              colorFilter:
              const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
            onPressed: () async {
              if (widget.peerId == null) return;
              try {
                final snap = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.peerId)
                    .get();
                final data = snap.data();

                final name = (data?['displayName'] ??
                    data?['name'] ??
                    widget.conversationName) as String;
                final photoUrl = data?['photoURL'] as String?;

                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IncomingCallPage(
                      callerId: widget.peerId!,
                      callerName: name,
                      callerPhotoUrl: photoUrl,
                    ),
                  ),
                );
              } catch (_) {
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IncomingCallPage(
                      callerId: widget.peerId!,
                      callerName: widget.conversationName,
                      callerPhotoUrl: null,
                    ),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      );
    }

    // ---- GROUP CHAT ----
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .doc(widget.conversationId)
            .snapshots(),
        builder: (context, convSnap) {
          final convData = convSnap.data?.data();
          final name =
          (convData?['name'] ?? widget.conversationName) as String;
          final List<dynamic> memberListDyn =
          (convData?['members'] ?? []) as List<dynamic>;
          final List<String> memberIds =
          memberListDyn.map((e) => e.toString()).toList();
          final int memberCount = memberIds.length;

          if (memberIds.isEmpty) {
            return Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  AssetImage('assets/images/AlexLinderson.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '$memberCount members',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9C9C9C),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          final List<String> whereInIds =
          memberIds.length > 10 ? memberIds.sublist(0, 10) : memberIds;

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: whereInIds)
                .snapshots(),
            builder: (context, usersSnap) {
              int onlineCount = 0;
              if (usersSnap.hasData) {
                for (final d in usersSnap.data!.docs) {
                  final data = d.data();
                  if (data['isOnline'] == true) onlineCount++;
                }
              }

              return Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    AssetImage('assets/images/AlexLinderson.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '$memberCount members, $onlineCount online',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9C9C9C),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            try {
              final convSnap = await FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(widget.conversationId)
                  .get();
              final convData = convSnap.data();
              final name =
              (convData?['name'] ?? widget.conversationName) as String;
              final avatarUrl = convData?['avatarUrl'] as String?;

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IncomingCallPage(
                    callerId: null,
                    callerName: name,
                    callerPhotoUrl: avatarUrl,
                  ),
                ),
              );
            } catch (_) {}
          },
          child: SvgPicture.asset(
            "assets/icons/Call.svg",
            width: 24,
            height: 24,
            colorFilter:
            const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            "assets/icons/Cam.svg",
            width: 24,
            height: 24,
            colorFilter:
            const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _openShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Share Content',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                buildShareItem(
                  iconWidget: SvgPicture.asset("assets/icons/camera.svg"),
                  title: "Camera",
                  subtitle: "Capture a photo",
                  onTap: () {
                    Navigator.pop(context);
                    callCameraApi(
                      context: context,
                      currentUser: widget.currentUser,
                      conversationId: widget.conversationId,
                    );
                  },
                ),
                buildShareItem(
                  iconWidget: SvgPicture.asset(
                    "assets/icons/doc.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF8E8E93),
                      BlendMode.srcIn,
                    ),
                  ),
                  title: "Documents",
                  subtitle: "Share your files",
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickAndUploadDocument(context);
                  },
                ),
                buildShareItem(
                  iconWidget: SvgPicture.asset("assets/icons/Chart.svg"),
                  title: "Create a poll",
                  subtitle: "Create a poll for any query",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                buildShareItem(
                  iconWidget: SvgPicture.asset("assets/icons/media.svg"),
                  title: "Media",
                  subtitle: "Share photos and videos",
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickAndSendMedia();
                  },
                ),
                buildShareItem(
                  iconWidget: SvgPicture.asset("assets/icons/user.svg"),
                  title: "Contact",
                  subtitle: "Share your contacts",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShareContactPage(
                          currentUser: widget.currentUser,
                          conversationId: widget.conversationId,
                        ),
                      ),
                    );
                  },
                ),
                buildShareItem(
                  iconWidget: SvgPicture.asset("assets/icons/Group.svg"),
                  title: "Location",
                  subtitle: "Share your location",
                  onTap: () async {
                    Navigator.pop(context);
                    await _shareLocation();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildShareItem({
    required Widget iconWidget,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: const Color(0xFFF0F2F5),
        child: iconWidget,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF8E8E93),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildMessage({
    required bool isMe,
    required String text,
    required String timeText,
    String? senderName,
    String? type,
    String? fileUrl,
    String? contactName,
    String? contactPhoto,
    double? lat,
    double? lng,
  }) {
    final bubbleColor = isMe ? const Color(0xFF0A7C66) : Colors.white;
    final textColor = isMe ? Colors.white : Colors.black87;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 18),
    );

    Widget content;

    // MEDIA
    if ((type == 'image' || type == 'video') && fileUrl != null) {
      content = Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (widget.isGroup && !isMe && (senderName?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                senderName ?? '',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                  isMe ? Colors.white70 : const Color(0xFF4E4E4E),
                ),
              ),
            ),
          if (text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
          if (type == 'image')
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fileUrl,
                width: 220,
                fit: BoxFit.cover,
              ),
            )
          else if (type == 'video')
            GestureDetector(
              onTap: () async {
                try {
                  final uri = Uri.parse(fileUrl);
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                } catch (_) {}
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withOpacity(0.1)
                      : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.play_circle_fill_outlined,
                      size: 28,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Video đính kèm (nhấn để xem)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    } else if (type == 'contact') {
      content = Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (widget.isGroup && !isMe && (senderName?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                senderName ?? '',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                  isMe ? Colors.white70 : const Color(0xFF4E4E4E),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: (contactPhoto != null &&
                      contactPhoto.isNotEmpty)
                      ? NetworkImage(contactPhoto)
                      : const AssetImage(
                    'assets/images/Alex.png',
                  ) as ImageProvider,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactName ?? 'Shared contact',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Contact shared',
                      style: TextStyle(
                        fontSize: 12,
                        color: isMe
                            ? Colors.white70
                            : const Color(0xFF4E4E4E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else if (type == 'location' && lat != null && lng != null) {
      content = Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (widget.isGroup && !isMe && (senderName?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                senderName ?? '',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                  isMe ? Colors.white70 : const Color(0xFF4E4E4E),
                ),
              ),
            ),
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
              try {
                final ok = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (!ok && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Không mở được Google Maps'),
                    ),
                  );
                }
              } catch (_) {}
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 24,
                    color: Color(0xFF0A7C66),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shared location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to open in Google Maps',
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe
                              ? Colors.white70
                              : const Color(0xFF4E4E4E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    // TEXT
    else {
      content = Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (widget.isGroup && !isMe && (senderName?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                senderName ?? '',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                  isMe ? Colors.white70 : const Color(0xFF4E4E4E),
                ),
              ),
            ),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ],
      );
    }

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: radius,
        boxShadow: isMe
            ? []
            : [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),
      child: content,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
            isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: bubble,
          ),
          const SizedBox(height: 3),
          Text(
            timeText,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFB0B0B0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _messagesCol
                    .orderBy('createdAt', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi tải tin nhắn: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Hãy bắt đầu cuộc trò chuyện ',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msgDoc = messages[index];
                      final data = msgDoc.data();
                      final isMe = data['senderId'] == user.uid;
                      final text = (data['text'] ?? '') as String;
                      final senderName =
                      (data['senderName'] ?? 'Unknown') as String;
                      final type =
                      (data['type'] ?? 'text') as String;
                      final fileUrl = data['fileUrl'] as String?;
                      final contactName = data['contactName'] as String?;
                      final contactPhoto =
                      data['contactPhoto'] as String?;
                      final double? lat =
                      (data['lat'] as num?)?.toDouble();
                      final double? lng =
                      (data['lng'] as num?)?.toDouble();
                      final ts = data['createdAt'] as Timestamp?;
                      String timeText = '';
                      if (ts != null) {
                        final dt = ts.toDate();
                        final hour =
                        dt.hour.toString().padLeft(2, '0');
                        final minute =
                        dt.minute.toString().padLeft(2, '0');
                        timeText = '$hour:$minute';
                      }

                      return _buildMessage(
                        isMe: isMe,
                        text: text,
                        timeText: timeText,
                        senderName: senderName,
                        type: type,
                        fileUrl: fileUrl,
                        contactName: contactName,
                        contactPhoto: contactPhoto,
                        lat: lat,
                        lng: lng,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top:
                  BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _openShare(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/Path.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8E8E93),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await callCameraApi(
                        context: context,
                        currentUser: user,
                        conversationId: widget.conversationId,
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/camera.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8E8E93),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        style:
                        const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write your message',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  RecordButton(
                    currentUser: user,
                    conversationId: widget.conversationId,
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: _sending ? null : _sendMessage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF0A7C66),
                      child: _sending
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
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

/// ===================== INCOMING CALL PAGE =====================

class IncomingCallPage extends StatelessWidget {
  final String callerName;
  final String? callerPhotoUrl;
  final String? callerId; // uid trong collection users (nếu là 1-1)

  const IncomingCallPage({
    super.key,
    required this.callerName,
    this.callerPhotoUrl,
    this.callerId,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu có callerId -> lấy realtime từ Firestore để cập nhật tên + avatar
    if (callerId != null) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(callerId)
            .snapshots(),
        builder: (context, snapshot) {
          String displayName = callerName;
          String? photoUrl = callerPhotoUrl;

          if (snapshot.hasData && snapshot.data!.data() != null) {
            final data = snapshot.data!.data()!;
            displayName = (data['displayName'] ??
                data['name'] ??
                callerName) as String;
            final dbPhoto = data['photoURL'] as String?;
            if (dbPhoto != null && dbPhoto.isNotEmpty) {
              photoUrl = dbPhoto;
            }
          }

          final ImageProvider avatar = (photoUrl != null &&
              photoUrl.isNotEmpty)
              ? NetworkImage(photoUrl)
              : const AssetImage('assets/images/AlexLinderson.png')
          as ImageProvider;

          return _IncomingCallScaffold(
            callerName: displayName,
            avatar: avatar,
          );
        },
      );
    }

    // Không có callerId => dùng tạm dữ liệu truyền vào
    final ImageProvider avatar = (callerPhotoUrl != null &&
        callerPhotoUrl!.isNotEmpty)
        ? NetworkImage(callerPhotoUrl!)
        : const AssetImage('assets/images/AlexLinderson.png')
    as ImageProvider;

    return _IncomingCallScaffold(
      callerName: callerName,
      avatar: avatar,
    );
  }
}

/// Layout chính của màn hình gọi
class _IncomingCallScaffold extends StatelessWidget {
  final String callerName;
  final ImageProvider avatar;

  const _IncomingCallScaffold({
    required this.callerName,
    required this.avatar,
  });

  void _acceptCall(BuildContext context) {
    // Demo: nhận cuộc gọi -> đóng màn + thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã nhận cuộc gọi (demo)')),
    );
    Navigator.pop(context);
  }

  void _remindLater(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nhắc sau (demo – tự thêm logic reminder)'),
      ),
    );
  }

  void _goToMessage(BuildContext context) {
    // Demo: quay lại màn trước (ví dụ ChatDetailPage)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background mờ từ avatar
          Image(
            image: avatar,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                // Avatar + tên + trạng thái
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: avatar,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      callerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Incoming call',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Các action phía dưới
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _IncomingCallAction(
                            icon: Icons.access_time,
                            label: 'Remind me',
                            onTap: () => _remindLater(context),
                          ),
                          _IncomingCallAction(
                            icon: Icons.message,
                            label: 'Message',
                            onTap: () => _goToMessage(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // "slide to answer" – hiện tại cho phép TAP để nhận
                      GestureDetector(
                        onTap: () => _acceptCall(context),
                        child: Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF30D158),
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'slide to answer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomingCallAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _IncomingCallAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================== SHARE CONTACT PAGE =====================

class ShareContactPage extends StatelessWidget {
  final User currentUser;
  final String conversationId;
  const ShareContactPage({
    super.key,
    required this.currentUser,
    required this.conversationId,
  });
  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Future<void> _sendContact(
      BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) async {
    final data = doc.data();
    if (data == null) return;
    final contactId = doc.id;
    final contactName =
    (data['displayName'] ?? data['name'] ?? 'Unknown') as String;
    final contactPhoto = (data['photoURL'] ?? '') as String;
    try {
      final isFriend = await _areFriends(currentUser.uid, contactId);
      if (!isFriend) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
            Text('Bạn chỉ có thể chia sẻ liên hệ là bạn bè của mình.'),
          ),
        );
        return;
      }
      final now = FieldValue.serverTimestamp();
      final messagesCol = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages');
      await messagesCol.add({
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? 'Unknown',
        'type': 'contact',
        'text': '',
        'contactId': contactId,
        'contactName': contactName,
        'contactPhoto': contactPhoto,
        'createdAt': now,
      });
      final convRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId);
      await convRef.update({
        'lastMessage': '[Contact] $contactName',
        'updatedAt': now,
        'lastSenderId': currentUser.uid,
        'unreadCount': FieldValue.increment(1),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã chia sẻ liên hệ $contactName')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chia sẻ liên hệ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chia sẻ liên hệ'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _usersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải users: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Chưa có user nào'));
          }
          final docs = snapshot.data!.docs
              .where((d) => d.id != currentUid)
              .toList();
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final name = (data['displayName'] ??
                  data['name'] ??
                  'Unknown') as String;
              final photoUrl = data['photoURL'] as String?;
              final bool isOnline =
              (data['isOnline'] ?? false) as bool;
              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: (photoUrl != null &&
                          photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : const AssetImage('assets/images/Alex.png'))
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          isOnline ? Colors.green : Colors.grey,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(name),
                trailing: const Icon(Icons.send_rounded),
                onTap: () => _sendContact(context, doc),
              );
            },
          );
        },
      ),
    );
  }
}

/// ===================== SELECT GROUP FOR CONTACT PAGE =====================

Future<void> sendContactToConversation({
  required BuildContext context,
  required User currentUser,
  required String conversationId,
  required String contactUserId,
}) async {
  try {
    final contactDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(contactUserId)
        .get();
    final data = contactDoc.data();
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy liên hệ')),
      );
      return;
    }
    final contactName =
    (data['displayName'] ?? data['name'] ?? 'Unknown') as String;
    final contactPhoto = (data['photoURL'] ?? '') as String;
    final isFriend = await _areFriends(currentUser.uid, contactUserId);
    if (!isFriend) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('Bạn chỉ có thể chia sẻ liên hệ là bạn bè của mình.'),
        ),
      );
      return;
    }
    final now = FieldValue.serverTimestamp();
    final messagesCol = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    await messagesCol.add({
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName ?? 'Unknown',
      'type': 'contact',
      'text': '',
      'contactId': contactUserId,
      'contactName': contactName,
      'contactPhoto': contactPhoto,
      'createdAt': now,
    });
    final convRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId);
    await convRef.update({
      'lastMessage': '[Contact] $contactName',
      'updatedAt': now,
      'lastSenderId': currentUser.uid,
      'unreadCount': FieldValue.increment(1),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chia sẻ liên hệ $contactName')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi chia sẻ liên hệ: $e')),
    );
  }
}

class SelectGroupForContactPage extends StatelessWidget {
  final User currentUser;
  final String contactUserId;

  const SelectGroupForContactPage({
    super.key,
    required this.currentUser,
    required this.contactUserId,
  });
  Stream<QuerySnapshot<Map<String, dynamic>>> _groupsStream() {
    return FirebaseFirestore.instance
        .collection('conversations')
        .where('isGroup', isEqualTo: true)
        .where('members', arrayContains: currentUser.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn group để chia sẻ'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _groupsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải group: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Bạn chưa có group nào'),
            );
          }
          final groups = snapshot.data!.docs;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final doc = groups[index];
              final data = doc.data();
              final name =
              (data['name'] ?? 'Unnamed group') as String;
              final avatarUrl = data['avatarUrl'] as String?;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (avatarUrl != null &&
                      avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/Alex.png'))
                  as ImageProvider,
                ),
                title: Text(name),
                subtitle: const Text(
                    'Chạm để chia sẻ contact vào group này'),
                onTap: () async {
                  await sendContactToConversation(
                    context: context,
                    currentUser: currentUser,
                    conversationId: doc.id,
                    contactUserId: contactUserId,
                  );
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
