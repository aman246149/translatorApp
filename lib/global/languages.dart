List<String> chooseLanguage(String language) {
  List<String> lang = [];

  switch (language) {
    case "Spanish":
      lang.add("es");
      break;
    case "French":
      lang.add("fr");
      break;
    case "Japanese":
      lang.add("ja");
      break;
    case "Chinese":
      lang.add("zh");
      break;
    case "Korean":
      lang.add("ko");
      break;
    default:
  }

  return lang;
}
