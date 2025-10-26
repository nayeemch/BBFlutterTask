class Endpoints {
  Endpoints._(); // Prevent instantiation

  // Base URL
  static const String baseUrl = "https://st2-nayeem.hz2.developbb.dev";

  // Timeouts (in milliseconds)
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 30000;

  // WordPress REST API endpoints
  static const String getPosts =
      "$baseUrl/wp-json/wp/v2/posts?per_page=20&page=1&order=desc&orderby=date&_embed=true";

  // BuddyBoss JWT Authentication endpoint
  static const String jwtLogin =
      "$baseUrl/wp-json/buddyboss-app/auth/v2/jwt/login";
}
