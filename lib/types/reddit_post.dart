import 'package:bluejay/utils/strings.dart';
import 'package:bluejay/reddit_library/reddit.dart';

enum FlairTypes { richtext, text, unmapped }

enum PostType {
  /// 'self' or null value, go figure
  text,
  image,
  link,

  /// 'hosted:video'
  video,
  gallery,
}

PostType mapPostType(String? value) {
  switch (value) {
    case 'image':
      return PostType.image;
    case 'hosted:video':
      return PostType.video;
    case 'link':
      return PostType.link;
    default:
      return PostType.text;
  }
}

FlairTypes mapFlairType(String? value) {
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

class PostImage {
  String preview;
  String source;

  PostImage(this.preview, this.source);
}

class Post {
  Reddit api;
  VoteDir upvoteDir;
  String id;
  String subreddit;
  String subredditShort;
  String subredditId;
  String title;
  String author;
  int score;
  double upvoteRatio;
  bool clicked;
  bool over18;
  String name;
  bool hideScore;
  bool spoiler;
  int createdAt;
  String url;
  PostType postType;
  bool isVideo;
  String permalink;
  String? thumbnail;

  /// !!! can be empty
  String? selftext;

  /// if its image gallery
  bool isGallery;
  List<PostImage> images;

  /// flair on post
  FlairTypes linkFlairType;
  String? linkFlairText;
  String? linkFlairBackgroundColor;
  int? commentsAmount;

  Post({
    required this.upvoteDir,
    required this.api,
    required this.commentsAmount,
    required this.permalink,
    required this.id,
    required this.subreddit,
    required this.subredditShort,
    required this.subredditId,
    required this.score,
    required this.upvoteRatio,
    required this.over18,
    required this.author,
    required this.isVideo,
    required this.hideScore,
    required this.spoiler,
    required this.linkFlairType,
    required this.createdAt,
    required this.url,
    required this.postType,
    required this.title,
    required this.clicked,
    required this.images,
    required this.isGallery,
    required this.name,
    this.selftext,
    this.linkFlairText,
    this.linkFlairBackgroundColor,
    this.thumbnail,
  });

  factory Post.fromJson(Map<String, dynamic> json, Reddit api) {
    String? selfText;
    String? selfHtml = json['selftext_html'];

    /// thanks for your own markdown implementation reddit
    /// but I'm good
    if (selfHtml != '' && selfHtml != null) {
      selfText = unescapeHtml(selfHtml);
    }

    /// yeah idk either
    String? thumbnailLink =
        json['thumbnail'] != null ? safeThumbnail(json['thumbnail']) : null;

    /// this is getting out of hand
    /// I couldn't find svg lib for their custom emotes ok?
    String? safeFlairText =
        json['link_flair_text']?.replaceAll(RegExp(r':snoo_([^:]+):'), '');

    PostType type = mapPostType(json['post_hint']);
    List<PostImage> images = [];
    if (type == PostType.image) {
      // bool isRedditMedia = json['is_reddit_media_domain'];
      // String domain = json['domain'];
      List<dynamic> links = json['preview']['images'];
      for (var link in links) {
        List<dynamic> resolutions = link['resolutions'];
        var preview = resolutions.firstWhere(
            (preview) => preview['width'] >= 320,
            orElse: () => resolutions[0]);
        var sourceUrl = safeThumbnail(link['source']['url']);
        var previewUrl = safeThumbnail(preview['url']);
        images.add(PostImage(previewUrl!, sourceUrl!));
      }
    }
    bool isGallery = json['is_gallery'] ?? false;
    List<PostImage> galleryImages = [];
    if (isGallery) {
      var mediaMeta = json['media_metadata'];
      for (var media in json['gallery_data']['items']) {
        var postMedia = mediaMeta[media['media_id']];
        if (postMedia != null) {
          var link = safeThumbnail(postMedia['s']['u']);
          galleryImages.add(PostImage(link!, link));
        }
      }
    }

    return Post(
      api: api,
      commentsAmount: json['num_comments'],
      id: json['id'],
      name: json['name'],
      subreddit: json['subreddit_name_prefixed'],
      isGallery: isGallery,
      upvoteDir: voteState(json['likes']),

      /// without r/
      subredditShort: json['subreddit'],
      subredditId: json['subreddit_id'],
      title: json['title'],
      selftext: selfText,
      thumbnail: thumbnailLink,
      url: json['url'],
      permalink: json['permalink'],
      postType: isGallery ? PostType.gallery : type,
      images: isGallery ? galleryImages : images,

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
      linkFlairText: safeFlairText,
      linkFlairType: mapFlairType(json['link_flair_type']),
      linkFlairBackgroundColor: json['link_flair_background_color'],
      createdAt: json['created_utc'].toInt(),
    );
  }

  Future<bool> vote(VoteDir dir) async {
    var result = await api.vote(name, dir);
    if (result == true) {
      upvoteDir = dir;
    }
    return result;
  }
}

VoteDir voteState(dynamic likes) {
  switch (likes) {
    case true:
      return VoteDir.up;
    case false:
      return VoteDir.down;
    case null:
    default:
      return VoteDir.neutral;
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
/// gallery_data - List with gallery item
///    media_id -> media id to get info from map below
///    id -> int to grab file? idk
/// media_metadata - Map<imageId, Map> with images description
///    status - valid|invalid ?
///    e -> type? 'Image'
///    m -> meta 'image/jpg'
///    p -> preview Map ->  ???
