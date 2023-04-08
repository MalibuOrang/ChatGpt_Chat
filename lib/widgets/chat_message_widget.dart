import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chargpt_chat/constants/constants.dart';
import 'package:flutter_chargpt_chat/services/assets_manager_services.dart';
import 'package:flutter_chargpt_chat/widgets/text_message_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/chat_providers.dart';
import '../providers/hive_boxes_provider.dart';
import 'alert_dialog_delete_widget.dart';

class ChatMessageWidget extends StatefulWidget {
  const ChatMessageWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      required this.indexOfElement});
  final String msg;
  final int chatIndex;
  final int indexOfElement;

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final HiveBoxesProvider hiveProvider =
        Provider.of<HiveBoxesProvider>(context);
    final int index = widget.indexOfElement;
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.gptImage,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: widget.chatIndex == 0
                      ? TextMessageWidget(
                          lable: widget.msg,
                        )
                      : widget.msg.isNotEmpty
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                onNextBeforePause: (p0, p1) {
                                  chatProvider.scrollListGoEnd();
                                },
                                onTap: () {
                                  chatProvider.scrollListGoEnd();
                                },
                                animatedTexts: [
                                  TyperAnimatedText(widget.msg.trim()),
                                ],
                              ),
                            )
                          : TextMessageWidget(
                              lable: widget.msg,
                            ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        chatProvider.copyTextToClipboard(widget.msg);
                        Fluttertoast.showToast(
                          msg: 'Повідомлення скопійовано!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
                      },
                      icon: const Icon(
                        Icons.copy_all,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialogDeleteWidget(
                                labelMessage:
                                    "Ви дійсно хочете видалити це повідомлення?",
                                labelYes: "Так",
                                labelNo: "Ні",
                                onPressed: () {
                                  Navigator.pop(context);
                                  hiveProvider.deleteOneItemFromHive(
                                      index, hiveProvider.chatBox);
                                },
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
