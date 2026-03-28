class ApiEndpoints {
  ApiEndpoints._();

  static const String skinLesionBase =
      'https://dhrruvchotai-efficientnetb0-skin-lesion-classifier.hf.space';

  static const String skinLesionPredict = '$skinLesionBase/predict';

  static const String chestXRayBase =
      'https://dhrruvchotai-densenet161-chest-xray-disease-classifier.hf.space';

  static const String chestXRayPredict = '$chestXRayBase/predict';

  // Placeholder for future endpoints
  static const String chatBase = 'https://api.medicalgpt.ai';
  static const String chatSend = '$chatBase/chat';
}
