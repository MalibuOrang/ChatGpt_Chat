import 'package:hive/hive.dart';
part 'models_model.g.dart';

@HiveType(typeId: 1)
class ModelsModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int created;
  @HiveField(2)
  final String root;
  ModelsModel({
    required this.id,
    required this.created,
    required this.root,
  });
  factory ModelsModel.fromJson(Map<String, dynamic> json) => ModelsModel(
        id: json["id"],
        created: json["created"],
        root: json["root"],
      );
  static List<ModelsModel> modelFromsSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}
