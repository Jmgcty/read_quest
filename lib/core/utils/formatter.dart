String formatStringToCapitalFirstLetter(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

String formatNameToGivenNameOnly(String name) {
  return name.split(' ')[0];
}
