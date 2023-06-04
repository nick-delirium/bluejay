import 'package:flutter_test/flutter_test.dart';
import 'package:bluejay/types/reddit_post.dart';

void main() {
  group('Post', () {
    late Post post;

    setUp(() {
      // Create a sample Post object for testing
      post = Post.fromJson({
        'permalink': 'r/test',
        'id': '123',
        'subreddit_name_prefixed': 'r/flutter',
        'subreddit': 'flutter',
        'subreddit_id': '456',
        'score': 100,
        'upvote_ratio': 0.8,
        'clicked': false,
        'over_18': false,
        'author': 'john_doe',
        'is_video': false,
        'hide_score': false,
        'spoiler': false,
        'link_flair_type': 'richtext',
        'created_utc': 1622012400,
        'url': 'https://example.com/post',
        'post_hint': 'text',
        'title': 'Sample Post',
        'thumbnail': 'https://example.com/thumbnail.jpg',
        'selftext_html': '',
        'link_flair_text': 'Flair',
        'link_flair_background_color': '#FF0000',
      });
    });

    test('fromJson() should create a valid Post object', () {
      expect(post.id, '123');
      expect(post.subreddit, 'r/flutter');
      expect(post.subredditShort, 'flutter');
      expect(post.subredditId, '456');
      expect(post.score, 100);
      expect(post.upvoteRatio, 0.8);
      expect(post.clicked, false);
      expect(post.over18, false);
      expect(post.author, 'john_doe');
      expect(post.isVideo, false);
      expect(post.hideScore, false);
      expect(post.spoiler, false);
      expect(post.linkFlairType, FlairTypes.richtext);
      expect(post.createdAt, 1622012400);
      expect(post.url, 'https://example.com/post');
      expect(post.postType, PostType.text);
      expect(post.title, 'Sample Post');
      expect(post.images.length, 0);
      expect(post.selftext, isNull);
      expect(post.isGallery, false);
      expect(post.linkFlairText, 'Flair');
      expect(post.linkFlairBackgroundColor, '#FF0000');
      expect(post.thumbnail, 'https://example.com/thumbnail.jpg');
    });
  });
}
