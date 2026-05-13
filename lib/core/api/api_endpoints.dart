class ApiEndpoints {
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String profile = '/auth/profile';

  // Future endpoints can be added here
  static const String services = '/services';
  // static const String salons = '/salons';
  static const String stylists = '/stylists';
  static const String availableDates = '/time-slots/available-dates';
  static const String availableSlots = '/time-slots/available';
  static const String appointments = '/appointments';
  static const String customers = '/customers';
}
