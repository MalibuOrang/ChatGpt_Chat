import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import '../widgets/toast_widget.dart';

class VoiceHandler {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  late String _result;

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  Future<String> startListening() async {
    final completer = Completer<String>();
    try {
      _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
      );
    } catch (e) {
      ToastWidget.showToast(message: "$e");
    }
    return completer.future;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<String> sendVoiceMessage() async {
    try {
      if (_speechToText.isListening) {
        await stopListening();
      } else {
        _result = await startListening();
      }
    } catch (e) {
      ToastWidget.showToast(message: "$e");
    }
    return _result;
  }

  SpeechToText get speechToText => _speechToText;
  bool get isEnabled => _speechEnabled;
  String get speachResult => _result;
}
