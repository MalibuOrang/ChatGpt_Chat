import 'package:flutter/material.dart';
import 'package:flutter_chargpt_chat/constants/constants.dart';
import 'package:flutter_chargpt_chat/models/models_model.dart';
import 'package:flutter_chargpt_chat/providers/hive_boxes_provider.dart';
import 'package:flutter_chargpt_chat/providers/models_provider.dart';
import 'package:flutter_chargpt_chat/widgets/text_message_widget.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({super.key});

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final hiveProvider = Provider.of<HiveBoxesProvider>(context);
    currentModel = modelsProvider.currentModel;
    return FutureBuilder<Box<ModelsModel>>(
        future: hiveProvider.getAllModels(modelsProvider.modelsList),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextMessageWidget(lable: snapshot.error.toString()),
            );
          }
          return snapshot.data == null ||
                  snapshot.data!.isEmpty ||
                  hiveProvider.modelBox.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                      hiveProvider.modelBox.length,
                      (index) => DropdownMenuItem(
                        value: hiveProvider.modelBox.getAt(index)?.id,
                        child: TextMessageWidget(
                            lable: hiveProvider.modelBox.getAt(index)!.id,
                            fontSize: 15),
                      ),
                    ),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      modelsProvider.setCurrentModel(
                        value.toString(),
                      );
                    },
                  ),
                );
        });
  }
}
