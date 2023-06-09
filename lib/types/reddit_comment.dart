import 'reddit_post.dart';
import 'package:bluejay/utils/strings.dart';
import 'package:bluejay/reddit_library/reddit.dart';

class Comment extends Post {
  List<Comment> replies = [];
  int? hiddenReplies;
  dynamic bannedAtUtc;
  String parentId;

  /// yeah its a t2_id instead of name
  String? authorFullname;

  /// t1_id
  String body;
  int depth;

  Comment({
    required this.replies,
    required this.bannedAtUtc,
    required this.parentId,
    required this.body,
    required name,
    required this.depth,
    required id,
    required subreddit,
    required subredditShort,
    required subredditId,
    required score,
    required over18,
    required author,
    required isVideo,
    required hideScore,
    required spoiler,
    required createdAt,
    required url,
    required postType,
    required linkFlairType,
    required permalink,
    required Reddit api,
    this.authorFullname,
    this.hiddenReplies,
    required VoteDir upvoteDir,
    title,
    clicked,
    selftext,
    linkFlairText,
    linkFlairBackgroundColor,
  }) : super(
          name: name,
          upvoteDir: upvoteDir,
          api: api,
          isGallery: false,
          commentsAmount: 0,
          permalink: permalink,
          images: [],
          id: id,
          clicked: false,
          subreddit: subreddit,
          subredditId: subredditId,
          subredditShort: subredditShort,
          title: '',
          score: score,
          upvoteRatio: 0,
          over18: false,
          author: author,
          isVideo: false,
          hideScore: false,
          spoiler: false,
          linkFlairType: linkFlairType,
          createdAt: createdAt,
          url: '',
          postType: postType,
          linkFlairBackgroundColor: linkFlairBackgroundColor,
          linkFlairText: linkFlairText,
        );

  factory Comment.fromJson(Map<String, dynamic> json, Reddit api) {
    String? selfText;
    String body;
    String? bodyHtml = json['body_html'];
    String? selfHtml = json['selftext_html'];

    /// thanks for your own markdown implementation reddit
    /// but I'm good
    if (selfHtml != '' && selfHtml != null) {
      selfText = unescapeHtml(selfHtml);
    }
    if (bodyHtml != '' && bodyHtml != null) {
      body = unescapeHtml(bodyHtml);
    } else {
      body = json['body'];
    }

    int? hiddenReplies;
    List<Comment> replies = [];

    /// WHY IT CAN BE MAP OR STRING WHATS WRONG WITH YOU DEVS
    if (json['replies'] is Map<String, dynamic>) {
      for (var subComment in json['replies']['data']['children']) {
        if (subComment['kind'] == 'more') {
          hiddenReplies = subComment['data']['count'];
        }

        /// fixing "awesome" reddit api engineering where reply can have
        /// 6 fields out of 70+ and all will be empty +
        /// id "t3___" (yeah, without actual id).
        /// goot job reddit api devs?
        if (subComment['data']['body'] != null) {
          Comment reply = Comment.fromJson(subComment['data'], api);
          replies.add(reply);
        }
      }
    }

    /// this is getting out of hand
    /// I couldn't find svg lib for their custom emotes ok?
    String? safeFlairText =
        json['link_flair_text']?.replaceAll(RegExp(r':snoo_([^:]+):'), '');
    return Comment(
      api: api,
      body: body,
      upvoteDir: voteState(json['likes']),
      permalink: json['permalink'],
      replies: replies,
      hiddenReplies: hiddenReplies,
      bannedAtUtc: json['banned_at_utc'],
      depth: json['depth'],
      authorFullname: json['author_full_name'],
      name: json['name'],
      parentId: json['parent_id'],
      id: json['id'],
      subreddit: json['subreddit_name_prefixed'],

      /// without r/
      subredditShort: json['subreddit'],
      subredditId: json['subreddit_id'],
      title: json['title'],
      selftext: selfText,
      url: json['url'],
      postType: mapPostType(json['post_hint']),

      /// downs --- int rating - can be 0 for some reason
      /// ups - int rating+
      score: json['score'],

      /// visited - bool ?
      clicked: json['clicked'],
      over18: json['over_18'],
      author: json['author'],
      isVideo: json['is_video'],
      hideScore: json['hide_score'],
      spoiler: json['spoiler'],
      linkFlairText: safeFlairText,
      linkFlairType: mapFlairType(json['link_flair_type']),
      linkFlairBackgroundColor: json['link_flair_background_color'],
      createdAt: json['created_utc'].toInt(),
    );
  }
}
