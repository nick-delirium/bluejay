import 'package:flutter_test/flutter_test.dart';
import 'package:bluejay/utils/strings.dart';

void main() {
  group('Markdown Parsing', () {
    test('Parse Markdown to HTML', () {
      // Test case 1: Ensure basic Markdown parsing works correctly
      String source = '# Heading\n\n**Bold** *Italic*';
      expect(parseMd(source),
          '<h1>Heading</h1>\n<p><strong>Bold</strong> <em>Italic</em></p>\n');

      // Test case 2: Ensure empty string returns an empty result
      source = '';
      expect(parseMd(source), '\n');

      // Add more test cases as needed...
    });
  });

  group('HTML Unescaping', () {
    test('Unescape HTML entities', () {
      // Test case 1: Ensure HTML entities are correctly unescaped
      String html = '&lt;div&gt;Hello &amp;world&lt;/div&gt;';
      expect(unescapeHtml(html), '<div>Hello &world</div>');

      // Test case 2: Ensure already unescaped HTML remains unchanged
      html = '<span>Text</span>';
      expect(unescapeHtml(html), '<span>Text</span>');

      // Add more test cases as needed...
    });
  });

  group('Thumbnail Safety', () {
    test('Ensure safe thumbnail URLs', () {
      // Test case 1: Ensure secure URL is returned as is
      String input = 'https://example.com/image.jpg';
      expect(safeThumbnail(input), input);

      // Test case 2: Ensure non-secure URL is converted to null
      input = 'wrongprotocol://example.com/image.jpg';
      expect(safeThumbnail(input), isNull);

      // Test case 3: Ensure URL with 'amp;' is correctly cleaned
      input = 'https://example.com/image.jpg?param=1&amp;size=small';
      expect(safeThumbnail(input),
          'https://example.com/image.jpg?param=1&size=small');

      // Add more test cases as needed...
    });
  });
}
