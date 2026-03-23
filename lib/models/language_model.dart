class Language {
  final String name;
  final String code;
  final String countryCode;

  const Language({
    required this.name,
    required this.code,
    required this.countryCode,
  });

  static List<Language> languageList = [
    Language(name: "English (US)", code: "en", countryCode: "US"),
    Language(name: "한국어 (Korean)", code: "ko", countryCode: "KR"),
    Language(name: "Polski (Polish)", code: "pl", countryCode: "PL"),
    Language(name: "Українська (Ukrainian)", code: "uk", countryCode: "UA"),
    Language(name: "Deutsch (German)", code: "de", countryCode: "DE")
  ];
}
