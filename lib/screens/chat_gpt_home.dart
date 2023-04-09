import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chargpt_chat/constants/constants.dart';
import 'package:flutter_chargpt_chat/providers/chat_provider.dart';
import 'package:flutter_chargpt_chat/services/assets_manager_services.dart';
import 'package:flutter_chargpt_chat/services/services.dart';
import 'package:flutter_chargpt_chat/services/voice_handler_services.dart';
import 'package:flutter_chargpt_chat/widgets/chat_message_widget.dart';
import 'package:flutter_chargpt_chat/widgets/delete_mes_button.dart';
import 'package:flutter_chargpt_chat/widgets/mic_button_widget.dart';
import 'package:flutter_chargpt_chat/widgets/send_button_widget.dart';
import 'package:flutter_chargpt_chat/widgets/text_field_widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/hive_boxes_provider.dart';
import '../providers/models_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  late ChatProvider chatProvider;
  late HiveBoxesProvider hiveProvider;
  late ModelsProvider modelsProvider;
  late bool isKeyboardVisible;
  final VoiceHandler voiceHandler = VoiceHandler();
  @override
  initState() {
    voiceHandler.initSpeech();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() async {
    textEditingController.dispose();
    chatProvider.dispose();
    focusNode.dispose();
    await hiveProvider.closeAllBox(hiveProvider.chatBox, hiveProvider.modelBox);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    modelsProvider = Provider.of<ModelsProvider>(context);
    chatProvider = Provider.of<ChatProvider>(context);
    hiveProvider = Provider.of<HiveBoxesProvider>(context);
    isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    chatProvider.initScrollController();
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiImage),
          ),
          title: const Text("ChatGPT"),
          actions: [
            DeleteButtonWidget(
              onDeleteMes: () {
                hiveProvider.clearHive(hiveProvider.chatBox);
                Navigator.pop(context);
              },
              iconBut: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              labelMes: "Ви дійсно хочете видалити всі повідомлення?",
            ),
            IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(Icons.more),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    controller: chatProvider.listScrollController,
                    itemCount: hiveProvider.chatBox.length,
                    itemBuilder: (context, index) {
                      chatProvider.chatValue =
                          hiveProvider.chatBox.getAt(index)!;
                      chatProvider.isNewMes = true;
                      return ChatMessageWidget(
                        msg: chatProvider.chatValue.msg,
                        chatIndex: chatProvider.chatValue.chatIndex,
                        indexOfElement: index,
                      );
                    }),
              ),
              if (chatProvider.isWriting) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              const SizedBox(
                height: 15,
              ),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      TextFieldWidget(
                          voiceHandler: voiceHandler,
                          focusNode: focusNode,
                          textEditingController: textEditingController,
                          isKeyboardVisible: isKeyboardVisible,
                          onSubmitted: (p0) async {
                            await chatProvider.sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider,
                                textEditingController: textEditingController,
                                focusNode: focusNode,
                                isKeyboardVisible: isKeyboardVisible,
                                voiceHandler: voiceHandler,
                                hiveProvider: hiveProvider,
                                context: context);
                          }),
                      isKeyboardVisible
                          ? SendButtonWidget(onSended: () async {
                              await chatProvider.sendMessageFCT(
                                  modelsProvider: modelsProvider,
                                  chatProvider: chatProvider,
                                  textEditingController: textEditingController,
                                  focusNode: focusNode,
                                  isKeyboardVisible: isKeyboardVisible,
                                  voiceHandler: voiceHandler,
                                  hiveProvider: hiveProvider,
                                  context: context);
                            })
                          : AvatarGlow(
                              endRadius: 32.0,
                              animate: chatProvider.buttonAnimation,
                              duration: const Duration(milliseconds: 2000),
                              glowColor: Colors.red,
                              repeat: true,
                              repeatPauseDuration:
                                  const Duration(microseconds: 100),
                              showTwoGlows: true,
                              child: MicroButton(
                                onLongPressed: () async {
                                  chatProvider.onButtonAnimation();
                                  await voiceHandler.sendVoiceMessage();
                                  await chatProvider.sendMessageFCT(
                                      modelsProvider: modelsProvider,
                                      chatProvider: chatProvider,
                                      textEditingController:
                                          textEditingController,
                                      focusNode: focusNode,
                                      isKeyboardVisible: isKeyboardVisible,
                                      voiceHandler: voiceHandler,
                                      hiveProvider: hiveProvider,
                                      context: context);
                                },
                                isButtonAnimated: chatProvider.buttonAnimation,
                                onLongPressedEnd: () async {
                                  await voiceHandler.stopListening();
                                  chatProvider.offButtonAnimation();
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
