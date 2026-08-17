// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const IyikiApp());
}

class IyikiApp extends StatelessWidget {
  const IyikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İyiki',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFD81B60),
        ),
      ),
      home: const RootGate(),
    );
  }
}

class UserAccount {
  final String baseRole;
  final String customUsername;
  String? avatarUrl;
  String currentMood;

  UserAccount({
    required this.baseRole,
    required this.customUsername,
    this.avatarUrl,
    this.currentMood = 'Harika hissediyor! 🌸',
  });

  Map<String, dynamic> toJson() => {
        'baseRole': baseRole,
        'customUsername': customUsername,
        'avatarUrl': avatarUrl,
        'currentMood': currentMood,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        baseRole: json['baseRole'] ?? 'Defne',
        customUsername: json['customUsername'] ?? '',
        avatarUrl: json['avatarUrl'],
        currentMood: json['currentMood'] ?? 'Harika hissediyor! 🌸',
      );
}

class StoryItem {
  final String id;
  final String authorRole;
  final String authorName;
  final String? authorAvatar;
  final String imageUrl;
  final DateTime createdAt;

  StoryItem({
    required this.id,
    required this.authorRole,
    required this.authorName,
    this.authorAvatar,
    required this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorRole': authorRole,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
        'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory StoryItem.fromJson(Map<String, dynamic> json) => StoryItem(
        id: json['id'] ?? '',
        authorRole: json['authorRole'] ?? 'Defne',
        authorName: json['authorName'] ?? '',
        authorAvatar: json['authorAvatar'],
        imageUrl: json['imageUrl'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class BucketItem {
  final String id;
  final String title;
  bool isDone;
  final String addedBy;

  BucketItem({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.addedBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'addedBy': addedBy,
      };

  factory BucketItem.fromJson(Map<String, dynamic> json) => BucketItem(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        isDone: json['isDone'] ?? false,
        addedBy: json['addedBy'] ?? 'Defne',
      );
}

class FeedbackMessage {
  final String id;
  final String sender;
  final String text;
  final String date;
  String? defneReply;
  String? replyDate;

  FeedbackMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.date,
    this.defneReply,
    this.replyDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'text': text,
        'date': date,
        'defneReply': defneReply,
        'replyDate': replyDate,
      };

  factory FeedbackMessage.fromJson(Map<String, dynamic> json) =>
      FeedbackMessage(
        id: json['id'] ?? '',
        sender: json['sender'] ?? '',
        text: json['text'] ?? '',
        date: json['date'] ?? '',
        defneReply: json['defneReply'],
        replyDate: json['replyDate'],
      );
}

class FriendProfile {
  final String name;
  final String role;
  final String bio;
  final String favoriteQuote;
  final Color cardColor;
  final Color textColor;
  final IconData icon;

  FriendProfile({
    required this.name,
    required this.role,
    required this.bio,
    required this.favoriteQuote,
    required this.cardColor,
    required this.textColor,
    required this.icon,
  });
}

class CommentItem {
  final String id;
  final String author;
  final String text;
  final String date;

  CommentItem({
    required this.id,
    required this.author,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'text': text,
        'date': date,
      };

  factory CommentItem.fromJson(Map<String, dynamic> json) => CommentItem(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        author: json['author'] ?? '',
        text: json['text'] ?? '',
        date: json['date'] ?? '',
      );
}

class MemoryItem {
  final String id;
  final String author;
  final String content;
  final DateTime date;
  final String? audioUrl;
  final List<String> imageUrls;
  final List<double> waveHeights;
  final Color themeColor;
  List<String> likedBy;
  List<CommentItem> comments;

  MemoryItem({
    required this.id,
    required this.author,
    required this.content,
    required this.date,
    this.audioUrl,
    required this.imageUrls,
    required this.waveHeights,
    required this.themeColor,
    List<String>? likedBy,
    List<CommentItem>? comments,
  })  : likedBy = likedBy ?? [],
        comments = comments ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'content': content,
        'date': date.toIso8601String(),
        'audioUrl': audioUrl,
        'imageUrls': imageUrls,
        'waveHeights': waveHeights,
        'themeColor': themeColor.toARGB32(),
        'likedBy': likedBy,
        'comments': comments.map((c) => c.toJson()).toList(),
      };

  factory MemoryItem.fromJson(Map<String, dynamic> json) => MemoryItem(
        id: json['id'] ?? '',
        author: json['author'] ?? '',
        content: json['content'] ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        audioUrl: json['audioUrl'],
        imageUrls: List<String>.from(json['imageUrls'] ?? []),
        waveHeights: List<double>.from(
            (json['waveHeights'] ?? []).map((e) => (e as num).toDouble())),
        themeColor: Color(json['themeColor'] ?? 0xFFC2185B),
        likedBy: List<String>.from(json['likedBy'] ?? []),
        comments: (json['comments'] as List<dynamic>?)
                ?.map((e) => CommentItem.fromJson(e))
                .toList() ??
            [],
      );
}

class SpecialDayItem {
  String id;
  String title;
  String description;
  DateTime targetDate;
  IconData icon;
  Color color;

  SpecialDayItem({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'targetDate': targetDate.toIso8601String(),
        'color': color.toARGB32(),
      };

  factory SpecialDayItem.fromJson(Map<String, dynamic> json) => SpecialDayItem(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        targetDate: DateTime.tryParse(json['targetDate'] ?? '') ??
            DateTime.now().add(const Duration(days: 7)),
        icon: Icons.event,
        color: Color(json['color'] ?? 0xFFD81B60),
      );
}

class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> {
  UserAccount? currentUser;
  bool isDefneVisiting = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final rawUser = html.window.localStorage['iyiki_active_user'];
    final rawDefneFlag = html.window.localStorage['iyiki_is_defne_impersonating'];
    isDefneVisiting = rawDefneFlag == 'true';

    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        currentUser = UserAccount.fromJson(jsonDecode(rawUser));
      } catch (_) {}
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onUserRegistered(UserAccount user) {
    _saveRegisteredUserDirectory(user);
    html.window.localStorage['iyiki_active_user'] = jsonEncode(user.toJson());
    html.window.localStorage['iyiki_is_defne_impersonating'] = 'false';
    setState(() {
      currentUser = user;
      isDefneVisiting = false;
    });
  }

  void _saveRegisteredUserDirectory(UserAccount user) {
    try {
      final rawDir = html.window.localStorage['iyiki_user_directory'];
      Map<String, dynamic> dir = rawDir != null ? jsonDecode(rawDir) : {};
      dir[user.baseRole] = user.toJson();
      html.window.localStorage['iyiki_user_directory'] = jsonEncode(dir);
    } catch (_) {}
  }

  void _onUserLogout() {
    html.window.localStorage.remove('iyiki_active_user');
    html.window.localStorage.remove('iyiki_is_defne_impersonating');
    setState(() {
      currentUser = null;
      isDefneVisiting = false;
    });
  }

  void _onUserSwitch(UserAccount targetUser) {
    final willBeVisiting = targetUser.baseRole != 'Defne';
    html.window.localStorage['iyiki_is_defne_impersonating'] = willBeVisiting ? 'true' : 'false';
    html.window.localStorage['iyiki_active_user'] = jsonEncode(targetUser.toJson());
    
    setState(() {
      currentUser = targetUser;
      isDefneVisiting = willBeVisiting;
    });
  }

  void _returnHomeToDefne() {
    try {
      final rawDir = html.window.localStorage['iyiki_user_directory'];
      if (rawDir != null) {
        final Map<String, dynamic> dir = jsonDecode(rawDir);
        if (dir.containsKey('Defne')) {
          final defneAcc = UserAccount.fromJson(dir['Defne']);
          _onUserSwitch(defneAcc);
          return;
        }
      }
    } catch (_) {}

    final defaultDefne = UserAccount(baseRole: 'Defne', customUsername: 'Defne');
    _onUserSwitch(defaultDefne);
  }

  void _onUserUpdated(UserAccount user) {
    _saveRegisteredUserDirectory(user);
    html.window.localStorage['iyiki_active_user'] = jsonEncode(user.toJson());
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentUser == null) {
      return OnboardingScreen(onCompleted: _onUserRegistered);
    }

    return HomeScreen(
      currentUser: currentUser!,
      isDefneVisiting: isDefneVisiting,
      onLogout: _onUserLogout,
      onUserSwitch: _onUserSwitch,
      onReturnHome: _returnHomeToDefne,
      onUserUpdated: _onUserUpdated,
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  final Function(UserAccount) onCompleted;

  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedBaseRole = 'Defne';
  final TextEditingController _nameController = TextEditingController();
  String? pickedAvatarUrl;

  final List<Map<String, dynamic>> roleOptions = [
    {'name': 'Defne', 'role': 'Anı Defteri 🌸', 'color': const Color(0xFFFCE4EC)},
    {'name': 'Laçin', 'role': 'Neşe Kaynağı ✨', 'color': const Color(0xFFE8F5E9)},
    {'name': 'Nisa', 'role': 'Sırdaş ☀️', 'color': const Color(0xFFFFF3E0)},
    {'name': 'Su', 'role': 'Huzur 💧', 'color': const Color(0xFFE1F5FE)},
  ];

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  void _checkExistingUser() {
    try {
      final rawDir = html.window.localStorage['iyiki_user_directory'];
      if (rawDir != null) {
        final Map<String, dynamic> dir = jsonDecode(rawDir);
        if (dir.containsKey(selectedBaseRole)) {
          final existing = UserAccount.fromJson(dir[selectedBaseRole]);
          _nameController.text = existing.customUsername;
          pickedAvatarUrl = existing.avatarUrl;
          return;
        }
      }
    } catch (_) {}
    _nameController.text = selectedBaseRole;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'İyiki 🌸',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD81B60),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Aramıza Hoş Geldin! Profilini Oluştur',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    final uploadInput = html.FileUploadInputElement();
                    uploadInput.accept = 'image/*';
                    uploadInput.click();

                    uploadInput.onChange.listen((e) {
                      final files = uploadInput.files;
                      if (files != null && files.isNotEmpty) {
                        final reader = html.FileReader();
                        reader.readAsDataUrl(files[0]);
                        reader.onLoadEnd.listen((ev) {
                          setState(() {
                            pickedAvatarUrl = reader.result as String;
                          });
                        });
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFFFCE4EC),
                        backgroundImage: pickedAvatarUrl != null
                            ? NetworkImage(pickedAvatarUrl!)
                            : null,
                        child: pickedAvatarUrl == null
                            ? const Icon(Icons.add_a_photo,
                                size: 32, color: Color(0xFFD81B60))
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFD81B60),
                          child: const Icon(Icons.edit,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Profil Fotoğrafı Seç',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sen Kimsin?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: roleOptions.map((opt) {
                    final isSelected = selectedBaseRole == opt['name'];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBaseRole = opt['name'];
                            _checkExistingUser();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: opt['color'],
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD81B60)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                opt['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isSelected
                                      ? const Color(0xFFD81B60)
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adın',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '* Kullanıcı ismi sonradan değiştirilemez',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen bir kullanıcı adı belirle! 🌸'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final newAcc = UserAccount(
                      baseRole: selectedBaseRole,
                      customUsername: _nameController.text.trim(),
                      avatarUrl: pickedAvatarUrl,
                    );
                    widget.onCompleted(newAcc);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD81B60),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'İyiki Dünyasına Başla ✨',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final UserAccount currentUser;
  final bool isDefneVisiting;
  final VoidCallback onLogout;
  final Function(UserAccount) onUserSwitch;
  final VoidCallback onReturnHome;
  final Function(UserAccount) onUserUpdated;

  const HomeScreen({
    super.key,
    required this.currentUser,
    required this.isDefneVisiting,
    required this.onLogout,
    required this.onUserSwitch,
    required this.onReturnHome,
    required this.onUserUpdated,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  int _selectedTabIndex = 0;
  html.AudioElement? _activeAudio;
  String? _currentlyPlayingId;
  String? _highlightedMemoryId;

  final Map<String, GlobalKey> _memoryKeys = {};

  DateTime lastMeetDate = DateTime(2026, 8, 10);

  Map<String, String> friendMoods = {
    'Defne': 'Harika hissediyor! 🌸',
    'Laçin': 'Enerji tavan! ⚡✨',
    'Nisa': 'Biraz kahve molası lazım ☕',
    'Su': 'Huzurlu ve sakin 💧🌿',
  };

  Map<String, String?> friendAvatars = {};

  final List<FriendProfile> friends = [
    FriendProfile(
      name: 'Defne',
      role: 'Anı Defteri 🌸',
      bio: 'Bizim her anımızı saklayan, grubun kalbi ve tasarımcısı.',
      favoriteQuote: 'İyi ki varsınız, her şey sizinle güzel!',
      cardColor: const Color(0xFFFCE4EC),
      textColor: const Color(0xFFC2185B),
      icon: Icons.favorite,
    ),
    FriendProfile(
      name: 'Laçin',
      role: 'Neşe Kaynağı ✨',
      bio: 'Ortamı anında güldüren, enerjisi hiç bitmeyen can dost.',
      favoriteQuote: 'Gülümseyin, hayat dostlarla harika!',
      cardColor: const Color(0xFFE8F5E9),
      textColor: const Color(0xFF2E7D32),
      icon: Icons.spa,
    ),
    FriendProfile(
      name: 'Nisa',
      role: 'Sırdaş ☀️',
      bio: 'Gecenin bir yarısı bile her derdimizi dinleyen güven limanı.',
      favoriteQuote: 'Her fırtınadan sonra güneş yine doğar.',
      cardColor: const Color(0xFFFFF3E0),
      textColor: const Color(0xFFEF6C00),
      icon: Icons.wb_sunny,
    ),
    FriendProfile(
      name: 'Su',
      role: 'Huzur 💧',
      bio: 'Sakinliğiyle hepimizi toparlayan, varlığıyla huzur verenimiz.',
      favoriteQuote: 'Akışına bırak, her şey yolunu bulur.',
      cardColor: const Color(0xFFE1F5FE),
      textColor: const Color(0xFF0277BD),
      icon: Icons.water_drop,
    ),
  ];

  List<SpecialDayItem> specialDays = [];
  List<MemoryItem> memories = [];
  List<FeedbackMessage> feedbackList = [];
  List<BucketItem> bucketList = [];
  List<StoryItem> activeStories = [];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    friendMoods[widget.currentUser.baseRole] = widget.currentUser.currentMood;
    friendAvatars[widget.currentUser.baseRole] = widget.currentUser.avatarUrl;

    _loadDataFromStorage();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _activeAudio?.pause();
    super.dispose();
  }

  void _loadDataFromStorage() {
    try {
      final memoriesJson = html.window.localStorage['iyiki_memories'];
      if (memoriesJson != null && memoriesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(memoriesJson);
        memories = decoded.map((e) => MemoryItem.fromJson(e)).toList();
      }

      final specialDaysJson = html.window.localStorage['iyiki_special_days'];
      if (specialDaysJson != null && specialDaysJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(specialDaysJson);
        specialDays = decoded.map((e) => SpecialDayItem.fromJson(e)).toList();
      } else {
        specialDays = [
          SpecialDayItem(
            id: '1',
            title: 'Eskişehir Gezimiz 🚗✨',
            description: 'Dörtlü yolculuk, bol kahkaha ve yeni anılar!',
            targetDate: DateTime(2026, 9, 12),
            icon: Icons.directions_car,
            color: const Color(0xFFD81B60),
          ),
          SpecialDayItem(
            id: '2',
            title: 'Kızlar Buluşması & Kahve Günü ☕',
            description: 'Haftalık dedikodu ve dertleşme seansı.',
            targetDate: DateTime(2026, 8, 22),
            icon: Icons.coffee,
            color: const Color(0xFFEF6C00),
          ),
        ];
        _saveSpecialDaysToStorage();
      }

      final bucketJson = html.window.localStorage['iyiki_bucket_list'];
      if (bucketJson != null && bucketJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(bucketJson);
        bucketList = decoded.map((e) => BucketItem.fromJson(e)).toList();
      } else {
        bucketList = [
          BucketItem(id: '1', title: 'Eskişehir\'de çiğbörek yiyip Porsuk\'ta tekneye binmek 🛶', addedBy: 'Defne', isDone: false),
          BucketItem(id: '2', title: 'Birlikte göl kenarında çadır kampı yapmak ⛺🔥', addedBy: 'Laçin', isDone: false),
          BucketItem(id: '3', title: 'Sabaha kadar kesintisiz kutu oyunu & dedikodu gecesi 🎲🍿', addedBy: 'Nisa', isDone: true),
          BucketItem(id: '4', title: 'Dörtlü stüdyoda komik konseptli fotoğraf çekimi 📸✨', addedBy: 'Su', isDone: false),
        ];
        _saveBucketListToStorage();
      }

      final storiesJson = html.window.localStorage['iyiki_stories'];
      if (storiesJson != null && storiesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(storiesJson);
        final now = DateTime.now();
        activeStories = decoded
            .map((e) => StoryItem.fromJson(e))
            .where((s) => now.difference(s.createdAt).inHours < 24)
            .toList();
      }

      final fbJson = html.window.localStorage['iyiki_feedbacks'];
      if (fbJson != null && fbJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(fbJson);
        feedbackList = decoded.map((e) => FeedbackMessage.fromJson(e)).toList();
      }

      final moodsJson = html.window.localStorage['iyiki_friend_moods'];
      if (moodsJson != null && moodsJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(moodsJson);
        decoded.forEach((k, v) {
          friendMoods[k] = v.toString();
        });
      }

      final rawDir = html.window.localStorage['iyiki_user_directory'];
      if (rawDir != null) {
        final Map<String, dynamic> decoded = jsonDecode(rawDir);
        decoded.forEach((k, v) {
          final acc = UserAccount.fromJson(v);
          friendAvatars[acc.baseRole] = acc.avatarUrl;
        });
      }

      final lastMeetStr = html.window.localStorage['iyiki_last_meet'];
      if (lastMeetStr != null) {
        lastMeetDate = DateTime.tryParse(lastMeetStr) ?? DateTime(2026, 8, 10);
      }
      setState(() {});
    } catch (_) {}
  }

  void _saveMemoriesToStorage() {
    try {
      final encoded = jsonEncode(memories.map((m) => m.toJson()).toList());
      html.window.localStorage['iyiki_memories'] = encoded;
    } catch (_) {}
  }

  void _saveSpecialDaysToStorage() {
    try {
      final encoded = jsonEncode(specialDays.map((s) => s.toJson()).toList());
      html.window.localStorage['iyiki_special_days'] = encoded;
    } catch (_) {}
  }

  void _saveBucketListToStorage() {
    try {
      final encoded = jsonEncode(bucketList.map((b) => b.toJson()).toList());
      html.window.localStorage['iyiki_bucket_list'] = encoded;
    } catch (_) {}
  }

  void _saveStoriesToStorage() {
    try {
      final encoded = jsonEncode(activeStories.map((s) => s.toJson()).toList());
      html.window.localStorage['iyiki_stories'] = encoded;
    } catch (_) {}
  }

  void _saveFeedbacksToStorage() {
    try {
      final encoded = jsonEncode(feedbackList.map((f) => f.toJson()).toList());
      html.window.localStorage['iyiki_feedbacks'] = encoded;
    } catch (_) {}
  }

  void _saveMoodsToStorage() {
    try {
      html.window.localStorage['iyiki_friend_moods'] = jsonEncode(friendMoods);
    } catch (_) {}
  }

  void _saveLastMeetToStorage() {
    try {
      html.window.localStorage['iyiki_last_meet'] = lastMeetDate.toIso8601String();
    } catch (_) {}
  }

  void _playAudio(String id, String url) {
    if (_currentlyPlayingId == id) {
      _activeAudio?.pause();
      setState(() {
        _currentlyPlayingId = null;
      });
      return;
    }

    _activeAudio?.pause();
    _activeAudio = html.AudioElement(url);
    _activeAudio!.play();

    setState(() {
      _currentlyPlayingId = id;
    });

    _activeAudio!.onEnded.listen((event) {
      setState(() {
        _currentlyPlayingId = null;
      });
    });
  }

  void _toggleLike(MemoryItem memory) {
    setState(() {
      if (memory.likedBy.contains(widget.currentUser.customUsername)) {
        memory.likedBy.remove(widget.currentUser.customUsername);
      } else {
        memory.likedBy.add(widget.currentUser.customUsername);
      }
    });
    _saveMemoriesToStorage();
  }

  void _deleteMemory(String memoryId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Anıyı Sil 🗑️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: const Text('Bu anıyı silmek istediğine emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentlyPlayingId == memoryId) {
                _activeAudio?.pause();
                _currentlyPlayingId = null;
              }
              setState(() {
                memories.removeWhere((m) => m.id == memoryId);
              });
              _saveMemoriesToStorage();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _scrollToMemory(String memoryId) {
    setState(() {
      _selectedTabIndex = 0;
      _highlightedMemoryId = memoryId;
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      final key = _memoryKeys[memoryId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _highlightedMemoryId = null;
        });
      }
    });
  }

  void _showAddStoryDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 16),
            const Text('Hikaye Ekle 📸✨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openWebCameraForStory();
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text('Kamerayı Aç', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD81B60),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      final uploadInput = html.FileUploadInputElement();
                      uploadInput.accept = 'image/*';
                      uploadInput.click();

                      uploadInput.onChange.listen((e) {
                        final files = uploadInput.files;
                        if (files != null && files.isNotEmpty) {
                          final reader = html.FileReader();
                          reader.readAsDataUrl(files[0]);
                          reader.onLoadEnd.listen((ev) {
                            _showStoryPreviewAndConfirm(reader.result as String);
                          });
                        }
                      });
                    },
                    icon: const Icon(Icons.photo_library, color: Color(0xFFD81B60)),
                    label: const Text('Galeriden Seç', style: TextStyle(color: Color(0xFFD81B60))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFF48FB1)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openWebCameraForStory() async {
    try {
      final mediaStream = await html.window.navigator.mediaDevices?.getUserMedia({'video': true});
      if (mediaStream == null) return;

      final videoElement = html.VideoElement()
        ..srcObject = mediaStream
        ..autoplay = true
        ..style.width = '100%'
        ..style.height = 'auto'
        ..style.borderRadius = '16px';

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (cCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Kamerayla Hikaye Çek 📸', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 320,
                height: 240,
                child: HtmlElementView.fromTagName(
                  tagName: 'video',
                  onElementCreated: (element) {
                    final v = element as html.VideoElement;
                    v.srcObject = mediaStream;
                    v.autoplay = true;
                    v.style.width = '100%';
                    v.style.height = '100%';
                    v.style.objectFit = 'cover';
                    v.style.borderRadius = '16px';
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  final canvas = html.CanvasElement(width: 640, height: 480);
                  canvas.context2D.drawImage(videoElement, 0, 0);
                  final dataUrl = canvas.toDataUrl('image/jpeg');

                  mediaStream.getTracks().forEach((track) => track.stop());
                  Navigator.pop(cCtx);
                  _showStoryPreviewAndConfirm(dataUrl);
                },
                icon: const Icon(Icons.camera, color: Colors.white),
                label: const Text('Fotoğrafı Çek ✨', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD81B60),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                mediaStream.getTracks().forEach((track) => track.stop());
                Navigator.pop(cCtx);
              },
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kamera açılamadı: $e')),
      );
    }
  }

  void _showStoryPreviewAndConfirm(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (pCtx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Hikaye Önizleme ✨',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(pCtx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(pCtx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Vazgeç', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(pCtx);
                        _addNewStory(imageUrl);
                      },
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      label: const Text('Paylaş 🌸', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD81B60),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewStory(String imageUrl) {
    final newStory = StoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorRole: widget.currentUser.baseRole,
      authorName: widget.currentUser.customUsername,
      authorAvatar: widget.currentUser.avatarUrl,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    setState(() {
      activeStories.add(newStory);
    });
    _saveStoriesToStorage();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hikayen paylaşıldı! 🌸✨ (24 saat sonra kaybolacak)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openMultiStoryViewer(List<StoryItem> userStories, int initialIndex) {
    showDialog(
      context: context,
      builder: (sCtx) {
        int currentIndex = initialIndex;

        return StatefulBuilder(
          builder: (context, setStoryState) {
            final currentStory = userStories[currentIndex];
            final isAuthor = currentStory.authorName == widget.currentUser.customUsername;

            return Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Center(
                    child: Image.network(currentStory.imageUrl, fit: BoxFit.contain),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (currentIndex > 0) {
                                setStoryState(() {
                                  currentIndex--;
                                });
                              }
                            },
                            child: const SizedBox.expand(),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (currentIndex < userStories.length - 1) {
                                setStoryState(() {
                                  currentIndex++;
                                });
                              } else {
                                Navigator.pop(sCtx);
                              }
                            },
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Row(
                          children: List.generate(userStories.length, (idx) {
                            return Expanded(
                              child: Container(
                                height: 3,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: idx <= currentIndex ? Colors.white : Colors.white38,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFD81B60),
                              backgroundImage: currentStory.authorAvatar != null
                                  ? NetworkImage(currentStory.authorAvatar!)
                                  : null,
                              child: currentStory.authorAvatar == null
                                  ? Text(currentStory.authorName.isNotEmpty ? currentStory.authorName[0] : '🌸',
                                      style: const TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentStory.authorName,
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(
                                  '${DateTime.now().difference(currentStory.createdAt).inHours} saat önce (${currentIndex + 1}/${userStories.length})',
                                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (isAuthor || widget.currentUser.baseRole == 'Defne' || widget.isDefneVisiting) ...[
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onSelected: (val) {
                                  if (val == 'delete') {
                                    setState(() {
                                      activeStories.removeWhere((s) => s.id == currentStory.id);
                                    });
                                    _saveStoriesToStorage();
                                    Navigator.pop(sCtx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Hikaye silindi! 🌸')),
                                    );
                                  } else if (val == 'save_memory') {
                                    final friend = friends.firstWhere(
                                      (f) => f.name == widget.currentUser.baseRole,
                                      orElse: () => friends.first,
                                    );
                                    setState(() {
                                      memories.insert(
                                        0,
                                        MemoryItem(
                                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                                          author: widget.currentUser.customUsername,
                                          content: '📸 Hikayeden Kaydedilen Anı',
                                          date: DateTime.now(),
                                          imageUrls: [currentStory.imageUrl],
                                          waveHeights: [],
                                          themeColor: friend.textColor,
                                        ),
                                      );
                                      memories.sort((a, b) => b.date.compareTo(a.date));
                                    });
                                    _saveMemoriesToStorage();
                                    Navigator.pop(sCtx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Hikaye Anı Duvarına kalıcı olarak kaydedildi! 🌸✨')),
                                    );
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(
                                    value: 'save_memory',
                                    child: Row(
                                      children: [
                                        Icon(Icons.bookmark_add_outlined, color: Color(0xFFD81B60), size: 18),
                                        SizedBox(width: 8),
                                        Text('Anılara Kaydet 🌸',
                                            style: TextStyle(color: Color(0xFFD81B60), fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                        SizedBox(width: 8),
                                        Text('Hikayemi Sil',
                                            style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(sCtx),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateMoodDialog() {
    final moodController = TextEditingController(text: friendMoods[widget.currentUser.baseRole] ?? '');
    final quickMoods = [
      'Harika hissediyor! 🌸',
      'Sınav haftası modunda 📚☕',
      'Enerji tavan! ✨🥳',
      'Biraz kahve & dedikodu lazım ☕💭',
      'Huzurlu ve dingin 💧🌿',
      'Uykulu ama mutlu 😴✨',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bugün Nasıl Hissediyorsun? 🌸💭',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: moodController,
              decoration: InputDecoration(
                labelText: 'Ruh Halin / Durum Yazın',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: quickMoods.map((m) {
                return ActionChip(
                  label: Text(m, style: const TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFFFDFBF7),
                  side: BorderSide(color: Colors.grey.shade200),
                  onPressed: () {
                    moodController.text = m;
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (moodController.text.trim().isNotEmpty) {
                  setState(() {
                    friendMoods[widget.currentUser.baseRole] = moodController.text.trim();
                    widget.currentUser.currentMood = moodController.text.trim();
                  });
                  _saveMoodsToStorage();
                  widget.onUserUpdated(widget.currentUser);
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD81B60),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Durumu Güncelle ✨', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBucketDialog() {
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),
            const Text(
              'Yeni Bir Birlikte Yapılacaklar Hayali 📝✨',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Ne Yapalım? (örn: Birlikte Kapadokya\'ya gitmek)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  setState(() {
                    bucketList.add(
                      BucketItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        addedBy: widget.currentUser.customUsername,
                        isDone: false,
                      ),
                    );
                  });
                  _saveBucketListToStorage();
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D3142),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Listeye Ekle ✨', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyFeedbackDialog(FeedbackMessage fb, StateSetter setParentState) {
    final replyController = TextEditingController(text: fb.defneReply ?? '');

    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('${fb.sender}\'ın Mesajına Cevap Ver 💌',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFDFBF7), borderRadius: BorderRadius.circular(12)),
              child: Text('“${fb.text}”', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: replyController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Cevabını yaz...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                setParentState(() {
                  fb.defneReply = replyController.text.trim();
                  fb.replyDate = DateFormat('dd MMM, HH:mm').format(DateTime.now());
                });
                _saveFeedbacksToStorage();
                setState(() {});
                Navigator.pop(dCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cevabın kaydedildi ve iletildi! 🌸✨'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD81B60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cevabı Gönder', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openDefneUserSwitcherDialog() {
    Map<String, UserAccount> registeredUsers = {};
    try {
      final rawDir = html.window.localStorage['iyiki_user_directory'];
      if (rawDir != null) {
        final Map<String, dynamic> decoded = jsonDecode(rawDir);
        decoded.forEach((k, v) {
          registeredUsers[k] = UserAccount.fromJson(v);
        });
      }
    } catch (_) {}

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kullanıcı Değiştir (Yönetici Paneli) 👑',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Kızların kendi seçtikleri özel kullanıcı adlarıyla tek tıkla giriş yap:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...friends.map((f) {
              final existing = registeredUsers[f.name];
              final displayName = existing != null ? existing.customUsername : f.name;
              final isCurrent = widget.currentUser.baseRole == f.name;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0xFFFCE4EC) : const Color(0xFFFDFBF7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isCurrent ? const Color(0xFFD81B60) : Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: f.cardColor,
                    backgroundImage: existing?.avatarUrl != null ? NetworkImage(existing!.avatarUrl!) : null,
                    child: existing?.avatarUrl == null
                        ? Text(displayName[0].toUpperCase(), style: TextStyle(color: f.textColor, fontWeight: FontWeight.bold))
                        : null,
                  ),
                  title: Text(
                    displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? const Color(0xFFD81B60) : const Color(0xFF2D3142),
                    ),
                  ),
                  subtitle: Text('Rol: ${f.name} (${f.role.split(' ')[0]})', style: const TextStyle(fontSize: 11)),
                  trailing: isCurrent
                      ? const Chip(
                          label: Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 11)),
                          backgroundColor: Color(0xFFD81B60),
                        )
                      : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: isCurrent
                      ? null
                      : () {
                          final targetAcc = existing ??
                              UserAccount(
                                baseRole: f.name,
                                customUsername: f.name,
                                avatarUrl: null,
                              );
                          Navigator.pop(ctx);
                          widget.onUserSwitch(targetAcc);
                        },
                ),
              );
            }),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onLogout();
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent, size: 16),
                label: const Text('Yeni Profil Oluşturma Ekranına Dön', style: TextStyle(color: Colors.redAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openUserProfileDialog() {
    final feedbackController = TextEditingController();
    final isDefne = widget.currentUser.baseRole == 'Defne';
    final myFeedbacks =
        feedbackList.where((f) => f.sender == widget.currentUser.customUsername).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setProfileState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        final uploadInput = html.FileUploadInputElement();
                        uploadInput.accept = 'image/*';
                        uploadInput.click();

                        uploadInput.onChange.listen((e) {
                          final files = uploadInput.files;
                          if (files != null && files.isNotEmpty) {
                            final reader = html.FileReader();
                            reader.readAsDataUrl(files[0]);
                            reader.onLoadEnd.listen((ev) {
                              setProfileState(() {
                                widget.currentUser.avatarUrl = reader.result as String;
                              });
                              friendAvatars[widget.currentUser.baseRole] = reader.result as String;
                              widget.onUserUpdated(widget.currentUser);
                              setState(() {});
                            });
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: const Color(0xFFFCE4EC),
                            backgroundImage: widget.currentUser.avatarUrl != null
                                ? NetworkImage(widget.currentUser.avatarUrl!)
                                : null,
                            child: widget.currentUser.avatarUrl == null
                                ? Text(
                                    widget.currentUser.customUsername[0],
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFD81B60)),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: const Color(0xFFD81B60),
                              child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.currentUser.customUsername,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                    ),
                    Text(
                      'Gruptaki Rol: ${widget.currentUser.baseRole}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showUpdateMoodDialog();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mood, size: 16, color: Color(0xFFD81B60)),
                            const SizedBox(width: 6),
                            Text(
                              friendMoods[widget.currentUser.baseRole] ?? 'Durum Ekle',
                              style: const TextStyle(color: Color(0xFFD81B60), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.edit, size: 12, color: Color(0xFFD81B60)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    if (isDefne) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.inbox, color: Color(0xFFD81B60), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Kızlardan Gelen Geri Bildirimler (${feedbackList.length})',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D3142)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (feedbackList.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: const Color(0xFFFDFBF7), borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                            child: Text('Henüz bir şikayet veya geliştirme isteği yok 🌸',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: feedbackList.length,
                          itemBuilder: (context, idx) {
                            final fb = feedbackList[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC).withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFF48FB1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        fb.sender,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD81B60),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(fb.date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          setProfileState(() {
                                            feedbackList.removeAt(idx);
                                          });
                                          _saveFeedbacksToStorage();
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(fb.text, style: const TextStyle(fontSize: 13, color: Color(0xFF37474F))),
                                  if (fb.defneReply != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFFF48FB1)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('🌸 ', style: TextStyle(fontSize: 12)),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Senin Cevabın (${fb.replyDate ?? ""}):',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFD81B60))),
                                                Text(fb.defneReply!, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showReplyFeedbackDialog(fb, setProfileState),
                                      icon: const Icon(Icons.reply, size: 14, color: Color(0xFFD81B60)),
                                      label: Text(
                                        fb.defneReply == null ? 'Cevap Yaz' : 'Cevabı Düzenle',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFFD81B60)),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFF48FB1)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ] else ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.mail_outline, color: Color(0xFFD81B60), size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Defne\'ye Şikayet & İstek İlet 💌',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D3142)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Uygulamada bir hata veya yeni eklenmesini istediğin bir özellik varsa doğrudan Defne\'ye yaz!',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: feedbackController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Defne şurayı şöyle yapsak daha tatlı olur...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (feedbackController.text.trim().isNotEmpty) {
                            final newFeedback = FeedbackMessage(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              sender: widget.currentUser.customUsername,
                              text: feedbackController.text.trim(),
                              date: DateFormat('dd MMM, HH:mm').format(DateTime.now()),
                            );
                            feedbackList.insert(0, newFeedback);
                            _saveFeedbacksToStorage();
                            feedbackController.clear();
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mesajın doğrudan Defne\'ye iletildi! 🌸✨'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.send, size: 16, color: Colors.white),
                        label: const Text('Defne\'ye Gönder', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD81B60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      if (myFeedbacks.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Gönderdiğin Mesajlar & Defne\'nin Cevapları:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2D3142))),
                        ),
                        const SizedBox(height: 8),
                        ...myFeedbacks.map((fb) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFBF7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Sen:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    const Spacer(),
                                    Text(fb.date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                                Text(fb.text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                if (fb.defneReply != null) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCE4EC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('🌸 ', style: TextStyle(fontSize: 12)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Defne\'nin Cevabı (${fb.replyDate ?? ""}):',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFD81B60))),
                                              Text(fb.defneReply!, style: const TextStyle(fontSize: 12, color: Color(0xFF880E4F))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                    if (isDefne) ...[
                      const SizedBox(height: 30),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openDefneUserSwitcherDialog();
                        },
                        icon: const Icon(Icons.switch_account, size: 16, color: Color(0xFFD81B60)),
                        label: const Text('Kullanıcı Değiştir (Yönetici Paneli)',
                            style: TextStyle(color: Color(0xFFD81B60))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD81B60)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLastMeetDialog() {
    final difference = DateTime.now().difference(lastMeetDate).inDays;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('⏳ ', style: TextStyle(fontSize: 22)),
            Text('Hasret Sayacı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2D3142))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text('$difference GÜN',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFFD81B60))),
                  const SizedBox(height: 4),
                  const Text('En son buluşmamızın üstünden geçti!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF880E4F), fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              difference == 0 ? 'Bugün beraberdiniz, ne güzel! ✨' : 'Çok özleştik, hemen yeni bir plan yapalım! 🌸',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: lastMeetDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    lastMeetDate = picked;
                  });
                  _saveLastMeetToStorage();
                  Navigator.pop(ctx);
                  _showLastMeetDialog();
                }
              },
              icon: const Icon(Icons.edit_calendar, size: 16, color: Color(0xFFD81B60)),
              label: const Text('Buluşma Tarihini Güncelle', style: TextStyle(color: Color(0xFFD81B60), fontSize: 12)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF48FB1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kapat', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showPlanDialog({SpecialDayItem? existingPlan}) {
    final isEditing = existingPlan != null;
    final titleController = TextEditingController(text: isEditing ? existingPlan.title : '');
    final descController = TextEditingController(text: isEditing ? existingPlan.description : '');
    DateTime selectedTargetDate =
        isEditing ? existingPlan.targetDate : DateTime.now().add(const Duration(days: 7));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isEditing ? 'Planı Düzenle ✏️' : 'Yeni Bir Özel Gün & Geri Sayım 🚗📅',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Planın İsmi *',
                        hintText: 'örn: Eskişehir Gezisi, Doğum Günü Buluşması',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Açıklama / Not',
                        hintText: 'Buluşma detayı veya hatırlatma...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBF7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Color(0xFFD81B60), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd MMMM yyyy').format(selectedTargetDate),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedTargetDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  selectedTargetDate = picked;
                                });
                              }
                            },
                            child: const Text('Tarihi Değiştir',
                                style: TextStyle(color: Color(0xFFD81B60), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (isEditing) ...[
                          IconButton(
                            tooltip: 'Planı Sil',
                            onPressed: () {
                              setState(() {
                                specialDays.removeWhere((p) => p.id == existingPlan.id);
                              });
                              _saveSpecialDaysToStorage();
                              Navigator.pop(ctx);
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lütfen plana bir isim ver! 🌸'),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                if (isEditing) {
                                  existingPlan.title = titleController.text.trim();
                                  existingPlan.description = descController.text.trim().isEmpty
                                      ? 'Geri sayım devam ediyor!'
                                      : descController.text.trim();
                                  existingPlan.targetDate = selectedTargetDate;
                                } else {
                                  specialDays.add(
                                    SpecialDayItem(
                                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                                      title: titleController.text.trim(),
                                      description: descController.text.trim().isEmpty
                                          ? 'Geri sayım başladı!'
                                          : descController.text.trim(),
                                      targetDate: selectedTargetDate,
                                      icon: Icons.event,
                                      color: const Color(0xFFD81B60),
                                    ),
                                  );
                                }
                                specialDays.sort((a, b) => a.targetDate.compareTo(b.targetDate));
                              });
                              _saveSpecialDaysToStorage();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D3142),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              isEditing ? 'Değişiklikleri Kaydet ✨' : 'Geri Sayımı Başlat ✨',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openCommentsDialog(MemoryItem memory) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setCommentState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Yorumlar 💬',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                      ),
                      const Spacer(),
                      Text(
                        'Sen: ${widget.currentUser.customUsername}',
                        style: TextStyle(fontSize: 12, color: memory.themeColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: memory.comments.isEmpty
                        ? const Center(
                            child: Text('İlk yorumu sen bırak! ✨', style: TextStyle(color: Colors.grey)),
                          )
                        : ListView.builder(
                            itemCount: memory.comments.length,
                            itemBuilder: (context, idx) {
                              final comment = memory.comments[idx];
                              final isAuthor = comment.author == widget.currentUser.customUsername;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: const Color(0xFFF48FB1).withValues(alpha: 0.2),
                                      child: Text(
                                        comment.author.isNotEmpty ? comment.author[0] : '🌸',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD81B60),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFDFBF7),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  comment.author,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                ),
                                                const Spacer(),
                                                Text(comment.date,
                                                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                                if (isAuthor || widget.isDefneVisiting) ...[
                                                  const SizedBox(width: 4),
                                                  PopupMenuButton<String>(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(Icons.more_vert, size: 16, color: Colors.grey),
                                                    onSelected: (val) {
                                                      if (val == 'delete') {
                                                        setCommentState(() {
                                                          memory.comments.removeAt(idx);
                                                        });
                                                        _saveMemoriesToStorage();
                                                        setState(() {});
                                                      }
                                                    },
                                                    itemBuilder: (ctx) => [
                                                      const PopupMenuItem(
                                                        value: 'delete',
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.delete_outline,
                                                                color: Colors.redAccent, size: 16),
                                                            SizedBox(width: 6),
                                                            Text('Yorumu Sil',
                                                                style: TextStyle(
                                                                    color: Colors.redAccent, fontSize: 12)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              comment.text,
                                              style: const TextStyle(fontSize: 13, color: Color(0xFF37474F)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Bir şeyler yaz...',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            final newComment = CommentItem(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              author: widget.currentUser.customUsername,
                              text: commentController.text.trim(),
                              date: DateFormat('HH:mm').format(DateTime.now()),
                            );
                            setCommentState(() {
                              memory.comments.add(newComment);
                            });
                            _saveMemoriesToStorage();
                            setState(() {});
                            commentController.clear();
                          }
                        },
                        icon: const Icon(Icons.send_rounded, color: Color(0xFFD81B60)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openFullScreenGallery(List<String> images, int initialIndex) {
    final PageController pageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      builder: (ctx) {
        int currentIndex = initialIndex;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: images.length,
                    onPageChanged: (idx) {
                      setDialogState(() {
                        currentIndex = idx;
                      });
                    },
                    itemBuilder: (context, idx) {
                      return InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.8,
                        maxScale: 3.5,
                        child: Center(
                          child: Image.network(images[idx], fit: BoxFit.contain),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 30,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),
                        const SizedBox(width: 14),
                        if (images.length > 1)
                          Text(
                            '${currentIndex + 1} / ${images.length}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            final anchor = html.AnchorElement(href: images[currentIndex])
                              ..target = 'blank'
                              ..download = 'iyiki_fotograf_${DateTime.now().millisecondsSinceEpoch}.png';
                            anchor.click();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fotoğraf indiriliyor... 📸✨'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, color: Colors.white, size: 18),
                          label: const Text('İndir', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD81B60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFriendDetails(FriendProfile friend) {
    final friendMemories = memories.where((m) => m.author.startsWith(friend.name)).toList();
    final friendMood = friendMoods[friend.name] ?? 'Mutlu ve huzurlu 🌸';
    final friendAvatar = friendAvatars[friend.name];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 36,
                backgroundColor: friend.cardColor,
                backgroundImage: friendAvatar != null ? NetworkImage(friendAvatar) : null,
                child: friendAvatar == null ? Icon(friend.icon, color: friend.textColor, size: 36) : null,
              ),
              const SizedBox(height: 10),
              Text(
                friend.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: friend.textColor),
              ),
              Text(friend.role, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: friend.cardColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('💭 Durum: $friendMood',
                    style: TextStyle(fontSize: 12, color: friend.textColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${friend.name} Tarafından Paylaşılanlar (${friendMemories.length}) - Gitmek için tıkla 👇',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2D3142)),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: friendMemories.isEmpty
                    ? Center(
                        child: Text('Henüz ${friend.name} bir anı bırakmadı 🌸',
                            style: const TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        itemCount: friendMemories.length,
                        itemBuilder: (context, idx) {
                          final m = friendMemories[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            color: friend.cardColor.withValues(alpha: 0.25),
                            elevation: 0,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(ctx);
                                _scrollToMemory(m.id);
                              },
                              title: Text(
                                m.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(DateFormat('dd MMMM yyyy').format(m.date),
                                  style: const TextStyle(fontSize: 11)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMemoryDialog() {
    final textController = TextEditingController();
    DateTime selectedMemoryDate = DateTime.now();

    html.MediaRecorder? mediaRecorder;
    List<html.Blob> audioChunks = [];
    String? recordedAudioUrl;
    List<String> pickedImageUrls = [];
    bool isRecording = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Yeni Anı Bırak ✨',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedMemoryDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setModalState(() {
                                selectedMemoryDate = picked;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE4EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.history, size: 14, color: Color(0xFFD81B60)),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd MMM yyyy').format(selectedMemoryDate),
                                  style: const TextStyle(
                                      color: Color(0xFFD81B60), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: textController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: selectedMemoryDate.year < DateTime.now().year
                            ? 'O eski günden aklında kalanlar, hissettiklerin...'
                            : 'Bugünden aklında ne kaldı? Ya da bir his...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (pickedImageUrls.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pickedImageUrls.length,
                          itemBuilder: (context, idx) {
                            return Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                      image: NetworkImage(pickedImageUrls[idx]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 14,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        pickedImageUrls.removeAt(idx);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 11,
                                      backgroundColor: Colors.black54,
                                      child: Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    if (pickedImageUrls.isNotEmpty) const SizedBox(height: 14),
                    if (isRecording)
                      Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            const Text('Ses Kaydediliyor...',
                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            AnimatedBuilder(
                              animation: _waveController,
                              builder: (context, child) {
                                return Row(
                                  children: List.generate(8, (index) {
                                    final height = 8 + (sin(_waveController.value * pi + index) * 16).abs();
                                    return Container(
                                      width: 3.5,
                                      height: height,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (!isRecording) {
                              try {
                                final stream = await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
                                if (stream != null) {
                                  audioChunks = [];
                                  mediaRecorder = html.MediaRecorder(stream);

                                  mediaRecorder!.addEventListener('dataavailable', (event) {
                                    final blobEvent = event as html.BlobEvent;
                                    if (blobEvent.data != null) {
                                      audioChunks.add(blobEvent.data!);
                                    }
                                  });

                                  mediaRecorder!.addEventListener('stop', (event) {
                                    final blob = html.Blob(audioChunks, 'audio/webm');
                                    final reader = html.FileReader();
                                    reader.readAsDataUrl(blob);
                                    reader.onLoadEnd.listen((e) {
                                      recordedAudioUrl = reader.result as String?;
                                      setModalState(() {
                                        isRecording = false;
                                      });
                                    });
                                  });

                                  mediaRecorder!.start();
                                  setModalState(() {
                                    isRecording = true;
                                  });
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Mikrofon izni alınamadı: $e')),
                                );
                              }
                            } else {
                              mediaRecorder?.stop();
                            }
                          },
                          icon: Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 18),
                          label: Text(
                            isRecording ? 'Durdur' : (recordedAudioUrl != null ? 'Ses ✓' : 'Ses'),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRecording
                                ? Colors.redAccent
                                : (recordedAudioUrl != null ? const Color(0xFF2E7D32) : const Color(0xFFF48FB1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            final uploadInput = html.FileUploadInputElement();
                            uploadInput.accept = 'image/*';
                            uploadInput.multiple = true;
                            uploadInput.click();

                            uploadInput.onChange.listen((e) {
                              final files = uploadInput.files;
                              if (files != null && files.isNotEmpty) {
                                for (var file in files) {
                                  final reader = html.FileReader();
                                  reader.readAsDataUrl(file);
                                  reader.onLoadEnd.listen((ev) {
                                    setModalState(() {
                                      pickedImageUrls.add(reader.result as String);
                                    });
                                  });
                                }
                              }
                            });
                          },
                          icon: const Icon(Icons.add_photo_alternate, size: 18, color: Color(0xFFD81B60)),
                          label: Text(
                            pickedImageUrls.isNotEmpty ? '+ Foto (${pickedImageUrls.length})' : 'Fotoğraf',
                            style: const TextStyle(color: Color(0xFFD81B60), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFF48FB1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (textController.text.trim().isNotEmpty ||
                                recordedAudioUrl != null ||
                                pickedImageUrls.isNotEmpty) {
                              final friend = friends.firstWhere(
                                (f) => f.name == widget.currentUser.baseRole,
                                orElse: () => friends.first,
                              );

                              final randomWave = List.generate(16, (i) => (10 + (Random().nextDouble() * 26)));

                              setState(() {
                                memories.insert(
                                  0,
                                  MemoryItem(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    author: widget.currentUser.customUsername,
                                    content: textController.text.trim().isEmpty
                                        ? (recordedAudioUrl != null ? '🎙️ Sesli Not' : '📸 Fotoğraflar')
                                        : textController.text.trim(),
                                    date: selectedMemoryDate,
                                    audioUrl: recordedAudioUrl,
                                    imageUrls: List.from(pickedImageUrls),
                                    waveHeights: recordedAudioUrl != null ? randomWave : [],
                                    themeColor: friend.textColor,
                                  ),
                                );
                                memories.sort((a, b) => b.date.compareTo(a.date));
                              });
                              _saveMemoriesToStorage();
                              Navigator.pop(ctx);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D3142),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Paylaş', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FacebookStylePhotoGrid extends StatelessWidget {
  final List<String> images;
  final Function(int) onTapImage;

  const _FacebookStylePhotoGrid({
    required this.images,
    required this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return GestureDetector(
        onTap: () => onTapImage(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(images[0], height: 220, width: double.infinity, fit: BoxFit.cover),
        ),
      );
    }

    if (images.length == 2) {
      return SizedBox(
        height: 170,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTapImage(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(images[0], height: 170, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: GestureDetector(
                onTap: () => onTapImage(1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(images[1], height: 170, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (images.length == 3) {
      return SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => onTapImage(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(images[0], height: 200, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapImage(1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(images[1], width: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapImage(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(images[2], width: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapImage(0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(images[0], height: double.infinity, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapImage(1),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(images[1], height: double.infinity, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapImage(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(images[2], height: double.infinity, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapImage(3),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(images[3], fit: BoxFit.cover),
                        ),
                        if (images.length > 4)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                '+${images.length - 3}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
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
    );
  }
}