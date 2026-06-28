class StringTextHelper {
  static String capitalizeFirstEnglishLetter(String text) {
    if (text.isEmpty) return text;

    final firstChar = text[0];

    if (RegExp(r'[a-zA-Z]').hasMatch(firstChar)) {
      return firstChar.toUpperCase() + text.substring(1);
    }

    return text;
  }
}
