class Country {
  final String name;
  final String code;

  Country(this.name, this.code);

  String get flag => String.fromCharCodes([
        0x1F1E6 - 65 + code.codeUnitAt(0),
        0x1F1E6 - 65 + code.codeUnitAt(1),
      ]);
}
