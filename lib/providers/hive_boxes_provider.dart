import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/chat_model.dart';
import '../models/models_model.dart';
import '../services/api_service.dart';

class HiveBoxesProvider extends ChangeNotifier {
  static late Box<ChatModel> _chatBox;
  static late Box<ModelsModel> _modelBox;

  Future<void> initFlutterHive() async {
    await Hive.initFlutter();
  }

// Initialize and open the 'chatBox' variable
  Future<void> initMsgBox(String name) async {
    Hive.registerAdapter(ChatModelAdapter());
    final boxMsg = await Hive.openBox<ChatModel>(name);
    _chatBox = boxMsg;
  }

  Future<void> initModelBox(String name) async {
    Hive.registerAdapter(
      ModelsModelAdapter(),
    );
    final boxModel = await Hive.openBox<ModelsModel>(name);
    _modelBox = boxModel;
  }

  Future<void> closeAllBox(Box msgBox, Box modelBox) async {
    await msgBox.close();
    await modelBox.close();
  }

  Future<void> clearHive(Box dataBox) async {
    await dataBox.clear();
    notifyListeners();
  }

  Future<void> deleteOneItemFromHive(int index, Box dataBox) async {
    await dataBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> addDataInHive<T>(
      {required List<T> hiveList, required Box dataBox}) async {
    await dataBox.addAll(hiveList);
    notifyListeners();
  }

  void addUserMessage({required String msg, required Box dataBox}) async {
    dataBox.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<Box<ModelsModel>> getAllModels(List<ModelsModel> models) async {
    if (modelBox.isEmpty) {
      models = await ApiService.getModels();
      await addDataInHive(hiveList: models, dataBox: modelBox);
    }
    return modelBox;
  }

  Box<ChatModel> get chatBox => _chatBox;
  Box<ModelsModel> get modelBox => _modelBox;
}
