import 'package:flutter/material.dart';
import 'package:flutter_chargpt_chat/constants/constants.dart';
import 'package:flutter_chargpt_chat/providers/chat_provider.dart';
import 'package:flutter_chargpt_chat/providers/hive_boxes_provider.dart';
import 'package:flutter_chargpt_chat/providers/models_provider.dart';
import 'package:flutter_chargpt_chat/screens/chat_gpt_home.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxesProvider().initFlutterHive();
  await HiveBoxesProvider().initMsgBox('messages');
  await HiveBoxesProvider().initFlutterHive();
  await HiveBoxesProvider().initModelBox('models');
  runApp(
    ChangeNotifierProvider(
      create: (_) => HiveBoxesProvider(),
      child: const ChatGptApp(),
    ),
  );
}

class ChatGptApp extends StatelessWidget {
  const ChatGptApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Chat GPT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(color: cardColor),
        ),
        home: const KeyboardVisibilityProvider(child: ChatPage()),
      ),
    );
  }
}
