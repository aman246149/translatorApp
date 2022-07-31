class TranslationModel {
  final String? text;
  // final List<String>? to;

  TranslationModel({required this.text});

  factory TranslationModel.fromJson(Map<String, dynamic> map) {
    return TranslationModel(text: map["text"]);
  }

  static Map<String, dynamic> toMap(TranslationModel model) {
    return {
      "text":model.text,
      
    };
  }
}
