import 'package:markdown/markdown.dart';

String parseMd(String source) {
  return markdownToHtml(source);
}

String unescapeHtml(String html) {
  return html
      .replaceAll(RegExp(r'&lt;'), '<')
      .replaceAll(RegExp(r'&gt;'), '>')
      .replaceAll(RegExp(r'&amp;'), "&");
}

String? safeThumbnail(String input) {
  return !input.startsWith('http')
      ? null
      : input.replaceAll(RegExp(r'amp;'), '');
}
