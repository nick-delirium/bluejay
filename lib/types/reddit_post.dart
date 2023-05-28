enum FlairTypes { richtext, text, unmapped }

FlairTypes mapFlairType(String value) {
  switch (value) {
    case 'richtext':
      return FlairTypes.richtext;
    case 'text':
      return FlairTypes.text;
    default:
      // throw ArgumentError('Invalid FlairType value: $value'); in future!
      return FlairTypes.unmapped;
  }
}

class Post {
  String subreddit;
  String title;
  String author;
  int score;
  double upvoteRatio;
  bool clicked;
  bool over18;
  bool isVideo;
  bool hideScore;
  bool spoiler;
  int createdAt;

  /// flair on post
  FlairTypes linkFlairType;
  String? linkFlairText;
  String? linkFlairBackgroundColor;

  Post({
    required this.clicked,
    required this.subreddit,
    required this.title,
    required this.score,
    required this.upvoteRatio,
    required this.over18,
    required this.author,
    required this.isVideo,
    required this.hideScore,
    required this.spoiler,
    required this.linkFlairType,
    required this.createdAt,
    this.linkFlairText,
    this.linkFlairBackgroundColor,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      /// can use subreddit instead to get just the name
      subreddit: json['subreddit_name_prefixed'],
      title: json['title'],

      /// downs --- int rating - can be 0 for some reason
      /// ups - int rating+
      score: json['score'],
      upvoteRatio: json['upvote_ratio'],

      /// visited - bool ?
      clicked: json['clicked'],
      over18: json['over_18'],
      author: json['author'],
      isVideo: json['is_video'],
      hideScore: json['hide_score'],
      spoiler: json['spoiler'],
      linkFlairText: json['link_flair_text'],
      linkFlairType: mapFlairType(json['link_flair_type']),
      linkFlairBackgroundColor: json['link_flair_background_color'],
      createdAt: json['created_utc'].toInt(),
    );
  }
}

/// useful info keys for future?
/// selftext big dump of text with md format
/// selftext_html same but html ig
/// link_flair_richtext - []
/// author_fullname - looks like id? t2
/// saved - bool
/// mod_reason_title ?
/// gilded --- int
/// hidden - bool
/// thumbnail_height - int - 0 if no img
/// top_awarded_type - ?
/// name - ? t3
/// score - int rating
/// total_awards_received - int
/// media_embed - {}
/// is_original_content - bool
/// secure_media - ?
/// link_flair_text -- :emoji: text
/// thumbnail - link to small img
/// edited - bool
/// gildings - {}
/// created - timestamp int
/// domain - self.AskReddit ?
/// all_awardings - []
/// locked - bool
/// subreddit_id - ? t5 string id
/// id - ? string
/// num_comments - int
/// send_replies - bool
/// url - string link
/// permalink - same but no reddit.com ?
/// stickied - bool
/// crossposts - int
/// media ? null
/// author_flair_text - string
/// author_flair_richtext - [{ things }]
/// author_flair_background_color hex code str
