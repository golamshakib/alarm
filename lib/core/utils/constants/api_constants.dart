class AppUrls {
  AppUrls._();

  static const String _baseUrl = 'https://api.myalarmsound.com/api/v1';
  // static const String _baseUrl = 'http://10.0.20.19:5019/api/v1';
  static const String getAllBackgrounds = '$_baseUrl/posts';
  static const String storeFcmToken = '$_baseUrl/users/save-fcm-token';


}
