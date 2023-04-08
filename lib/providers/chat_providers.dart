import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chargpt_chat/models/chat_model.dart';
import 'package:flutter_chargpt_chat/providers/hive_boxes_provider.dart';
import '../services/api_service.dart';
import '../services/voice_handler_services.dart';
import 'models_providet.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  late ChatModel chatValue;
  bool buttonAnimation = false;
  bool _isWriting = false;
  bool get isWriting => _isWriting;
  late ScrollController listScrollController;

  ScrollController initScrollController() {
    listScrollController = ScrollController();
    return listScrollController;
  }

  void copyTextToClipboard(String message) {
    Clipboard.setData(ClipboardData(text: message));
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  void scrollListGoEnd() {
    listScrollController.animateTo(
        listScrollController.position.viewportDimension,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut);
  }

  bool onButtonAnimation() {
    buttonAnimation = true;
    notifyListeners();
    return buttonAnimation;
  }

  bool offButtonAnimation() {
    buttonAnimation = false;
    notifyListeners();
    return buttonAnimation;
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModel}) async {
    if (chosenModel.toLowerCase().startsWith("gpt")) {
      chatList.addAll(
        await ApiService.sendMessageTurboGPT(
            message: msg, modelId: chosenModel),
      );
    } else {
      chatList.addAll(
        await ApiService.sendMessage(message: msg, modelId: chosenModel),
      );
    }
    notifyListeners();
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required bool isKeyboardVisible,
    required VoiceHandler voiceHandler,
    required HiveBoxesProvider hiveProvider,
    required BuildContext context,
  }) async {
    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (_isWriting) {
      showSnackBar("You cant send multiple messages at a time");
      return;
    }
    if (textEditingController.text.isEmpty && isKeyboardVisible) {
      showSnackBar("Please type a message!");
      return;
    }
    try {
      String msgController = textEditingController.text;
      _isWriting = true;
      hiveProvider.addUserMessage(
          msg: isKeyboardVisible ? msgController : voiceHandler.speachResult,
          dataBox: hiveProvider.chatBox);
      textEditingController.clear();
      focusNode.unfocus();
      await chatProvider.sendMessageAndGetAnswers(
          msg: isKeyboardVisible ? msgController : voiceHandler.speachResult,
          chosenModel: modelsProvider.currentModel);
      await hiveProvider.addDataInHive(
        hiveList: chatProvider.chatList,
        dataBox: hiveProvider.chatBox,
      );
      chatProvider.chatList.clear();
      notifyListeners();
    } catch (error) {
      showSnackBar(error.toString());
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }
}
