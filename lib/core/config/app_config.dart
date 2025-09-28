class AppConfig {
  static const String appName = 'Инвест-Аналитик Pro';
  static const String version = '1.0.0';
  static const String buildNumber = '1';

  // API Configuration
  static const String baseUrl = 'https://api.invest-analyst.pro';
  static const int apiTimeout = 30000;

  // Telegram Bots for logging
  static const String userActionsBotToken =
      '8279330006:AAEaxyxAtHxS-SbDBPdMf-7zHNwAPfpyGFI';
  static const String errorMonitoringBotToken =
      '8473067126:AAH69SkavUgYZFzccYoYl5-92A7eySJStgo';
  static const String userActionsChatId = '667074300';
  static const String errorMonitoringChatId = '667074300';

  // Feature Flags
  static const bool enableMlPredictions = true;
  static const bool enableSocialFeatures = true;
  static const bool enableAdvancedAnalytics = true;

  // Subscription Plans
  static const List<String> basicPlanTickers = [
    'GAZP',
    'SNGS',
    'SBER',
    'TATN',
    'AGRO'
  ];

  static bool get isDebug {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    return isDebug;
  }
}
