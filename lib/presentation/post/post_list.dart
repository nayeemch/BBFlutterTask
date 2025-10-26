import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/core/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/presentation/post/store/post_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  //stores:---------------------------------------------------------------------
  final PostStore _postStore = getIt<PostStore>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) => _buildBody();

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _postStore.loading
            ? const CustomProgressIndicatorWidget()
            : _buildListView();
      },
    );
  }

  // Widget _buildListView() {
  //   return _postStore.postList != null
  //       ? ListView.separated(
  //           itemCount: _postStore.postList!.posts!.length,
  //           separatorBuilder: (context, position) {
  //             return SizedBox();
  //           },
  //           itemBuilder: (context, position) {
  //             return _buildListItem(position);
  //           },
  //         )
  //       : Center(
  //           child: Text(
  //             AppLocalizations.of(context).translate('home_tv_no_post_found'),
  //           ),
  //         );
  // }

  Widget _buildListView() {
    return _postStore.postList != null
        ? RefreshIndicator(
            onRefresh: () async {
              await _postStore.refreshPosts();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _postStore.postList!.posts!.length,
              separatorBuilder: (_, __) => const SizedBox(),
              itemBuilder: (_, position) => _buildListItem(position),
            ),
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position) {
    final post = _postStore.postList?.posts?[position];
    final authorName = post?.authorDetails?.name ?? 'Unknown Author';
    final authorAvatar = post?.authorDetails?.avatarUrls?['48'];
    final featuredImageUrl = post?.featuredImageUrl;

    return Card(
      elevation: 2,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Featured Image on the Left
            if (featuredImageUrl != null && featuredImageUrl.isNotEmpty)
              Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                  child: Image.network(
                    featuredImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              // Placeholder when no image
              Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Content Section on the Right
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          post?.title ?? 'No Title',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 6),

                        // Excerpt
                        Text(
                          _stripHtmlTags(post?.excerpt ?? post?.content ?? ''),
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.grey[700],
                                    height: 1.3,
                                    fontSize: 13,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Author and Date Info
                    Row(
                      children: [
                        // Author Avatar
                        authorAvatar != null
                            ? CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(authorAvatar),
                                onBackgroundImageError: (_, __) {},
                              )
                            : const CircleAvatar(
                                radius: 12,
                                child: Icon(Icons.person, size: 12),
                              ),
                        const SizedBox(width: 6),

                        // Author Name
                        Expanded(
                          child: Text(
                            authorName,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Date
                        const Icon(Icons.access_time,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(post?.date ?? ''),
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stripHtmlTags(String htmlText) {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').trim();
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }

  // error handler

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        final message = _postStore.errorStore.errorMessage;

        if (message.isNotEmpty) {
          return _showErrorMessage(message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  Widget _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    });

    return const SizedBox.shrink();
  }
}
