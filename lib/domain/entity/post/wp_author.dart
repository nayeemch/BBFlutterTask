class WpAuthor {
  final int? id;
  final String? name;
  final String? url;
  final String? description;
  final String? link;
  final String? slug;
  final Map<String, String>? avatarUrls;

  WpAuthor({
    this.id,
    this.name,
    this.url,
    this.description,
    this.link,
    this.slug,
    this.avatarUrls,
  });

  factory WpAuthor.fromMap(Map<String, dynamic> json) {
    Map<String, String>? avatarUrls;
    if (json['avatar_urls'] != null) {
      avatarUrls = Map<String, String>.from(json['avatar_urls']);
    }

    return WpAuthor(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      description: json['description'],
      link: json['link'],
      slug: json['slug'],
      avatarUrls: avatarUrls,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'url': url,
        'description': description,
        'link': link,
        'slug': slug,
        'avatar_urls': avatarUrls,
      };
}
