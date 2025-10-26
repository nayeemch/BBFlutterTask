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
  String? featuredImageUrl;

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
    this.featuredImageUrl,
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

    // Extract featured image URL from _embedded
    String? featuredImageUrl;
    if (json['_embedded'] != null &&
        json['_embedded']['wp:featuredmedia'] != null) {
      final mediaList = json['_embedded']['wp:featuredmedia'] as List;
      if (mediaList.isNotEmpty) {
        final media = mediaList[0] as Map<String, dynamic>;
        // Try to get the source_url (full size image)
        featuredImageUrl = media['source_url'] as String?;

        // Fallback: try to get a medium or large size if available
        if (featuredImageUrl == null && media['media_details'] != null) {
          final mediaDetails = media['media_details'] as Map<String, dynamic>;
          if (mediaDetails['sizes'] != null) {
            final sizes = mediaDetails['sizes'] as Map<String, dynamic>;
            // Try medium first, then large, then thumbnail
            if (sizes['medium'] != null) {
              featuredImageUrl = sizes['medium']['source_url'] as String?;
            } else if (sizes['large'] != null) {
              featuredImageUrl = sizes['large']['source_url'] as String?;
            } else if (sizes['thumbnail'] != null) {
              featuredImageUrl = sizes['thumbnail']['source_url'] as String?;
            }
          }
        }
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
      featuredImageUrl: featuredImageUrl,
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
        'featured_image_url': featuredImageUrl,
        // Legacy compatibility
        'userId': userId,
        'body': body,
      };
}
