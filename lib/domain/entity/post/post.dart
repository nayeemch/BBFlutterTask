import 'wp_author.dart';

class Post {
  int? id;
  String? date;
  String? dateGmt;
  String? modified;
  String? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  String? title;
  String? content;
  String? excerpt;
  int? author;
  int? featuredMedia;
  String? commentStatus;
  String? pingStatus;
  bool? sticky;
  String? template;
  String? format;
  List<int>? categories;
  List<int>? tags;
  int? commentsCount;
  WpAuthor? authorDetails;

  // Legacy fields for backward compatibility
  int? userId;
  String? body;

  Post({
    this.id,
    this.date,
    this.dateGmt,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.categories,
    this.tags,
    this.commentsCount,
    this.authorDetails,
    this.userId,
    this.body,
  });

  factory Post.fromMap(Map<String, dynamic> json) {
    // Extract title
    String? title;
    if (json['title'] != null) {
      if (json['title'] is Map) {
        title = json['title']['rendered'];
      } else {
        title = json['title'].toString();
      }
    }

    // Extract content
    String? content;
    if (json['content'] != null) {
      if (json['content'] is Map) {
        content = json['content']['rendered'];
      } else {
        content = json['content'].toString();
      }
    }

    // Extract excerpt
    String? excerpt;
    if (json['excerpt'] != null) {
      if (json['excerpt'] is Map) {
        excerpt = json['excerpt']['rendered'];
      } else {
        excerpt = json['excerpt'].toString();
      }
    }

    // Extract author details from _embedded
    WpAuthor? authorDetails;
    if (json['_embedded'] != null && json['_embedded']['author'] != null) {
      final authorList = json['_embedded']['author'] as List;
      if (authorList.isNotEmpty) {
        authorDetails = WpAuthor.fromMap(authorList[0]);
      }
    }

    return Post(
      id: json['id'],
      date: json['date'],
      dateGmt: json['date_gmt'],
      modified: json['modified'],
      modifiedGmt: json['modified_gmt'],
      slug: json['slug'],
      status: json['status'],
      type: json['type'],
      link: json['link'],
      title: title,
      content: content,
      excerpt: excerpt,
      author: json['author'],
      featuredMedia: json['featured_media'],
      commentStatus: json['comment_status'],
      pingStatus: json['ping_status'],
      sticky: json['sticky'],
      template: json['template'],
      format: json['format'],
      categories: json['categories'] != null
          ? List<int>.from(json['categories'])
          : null,
      tags: json['tags'] != null ? List<int>.from(json['tags']) : null,
      commentsCount: json['comments_count'],
      authorDetails: authorDetails,
      // Legacy compatibility
      userId: json['userId'] ?? json['author'],
      body: json['body'] ?? content,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'date_gmt': dateGmt,
        'modified': modified,
        'modified_gmt': modifiedGmt,
        'slug': slug,
        'status': status,
        'type': type,
        'link': link,
        'title': {'rendered': title},
        'content': {'rendered': content},
        'excerpt': {'rendered': excerpt},
        'author': author,
        'featured_media': featuredMedia,
        'comment_status': commentStatus,
        'ping_status': pingStatus,
        'sticky': sticky,
        'template': template,
        'format': format,
        'categories': categories,
        'tags': tags,
        'comments_count': commentsCount,
        // Legacy compatibility
        'userId': userId,
        'body': body,
      };
}
