import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'story_model.dart';
import 'dart:async';
import 'comments_views.dart';
import 'endless_scroll_view.dart';
import 'comment_provider.dart';
import 'story_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'top_stories_provider.dart';

class CommentsFeedView extends ConsumerStatefulWidget {
  const CommentsFeedView({super.key, required this.story});

  static const routeName = '/comments';
  final Story story;

  @override
  ConsumerState<CommentsFeedView> createState() => _CommentsFeedViewState();
}

class _CommentsFeedViewState extends ConsumerState<CommentsFeedView> {
  bool hideReadComments = false;
  Set<int> hiddenComments = {};

  void toggleHideReadComments() {
    HapticFeedback.mediumImpact();
    setState(() {
      hideReadComments = !hideReadComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = CommentsProvider(widget.story);
    final commentState = ref.watch(commentsProvider);
    final commentsNotifier = ref.read(commentsProvider.notifier);
    final bookmarkedStories =
        ref.watch(topStoriesProvider(StoryListEndpoint.bookmarks)).value;
    final bookmarkedStoriesNotifier =
        ref.watch(topStoriesProvider(StoryListEndpoint.bookmarks).notifier);

    void onPressedBookmark({required int storyId, required String title}) {
      bookmarkedStoriesNotifier.addBookmarkedStory(
          storyId: storyId, title: title);
    }

    // Function to open the link
    void openStoryUrl() async {
      if (widget.story.url != null) {
        final storyUrlParsed = Uri.parse(widget.story.url!);

        if (await canLaunchUrl(storyUrlParsed)) {
          await launchUrl(
              storyUrlParsed); // Open the link using fwfh_url_launcher
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  hiddenComments = {};
                });

                HapticFeedback.mediumImpact();
                ref.invalidate(commentsProvider);
                commentsNotifier.fetchStories();
              },
              icon: const Icon(Icons.refresh_rounded)),
          IconButton(
              onPressed: toggleHideReadComments,
              icon: Icon(
                hideReadComments
                    ? Icons.comments_disabled_rounded
                    : Icons.comments_disabled_rounded,
                color: hideReadComments
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
              ))
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: EndlessScrollView(
            key: ValueKey(widget.story.id),
            cacheExtent: 6000,
            storiesState: commentState,
            dataFetcher: () => commentsNotifier.fetchStories(),
            refreshCallback: () {
              setState(() {
                hiddenComments = {};
              });
              return Future.delayed(const Duration(milliseconds: 100),
                  () => ref.refresh(commentsProvider));
            },
            topOfListWidgets: [
              GestureDetector(
                onTap: () {
                  openStoryUrl();
                },
                child: StoryView(
                  onPressedBookmark: onPressedBookmark,
                  story: widget.story,
                  isBookmarked:
                      bookmarkedStories?.storyIds.contains(widget.story.id) ??
                          false,
                ),
              )
            ],
            itemBuilder: (index, commentsState) {
              if (commentsState.stories[index].text != null &&
                  !hiddenComments.contains(index)) {
                return SingleCommentsView(
                    key: ValueKey(index),
                    comment: commentsState.stories[index],
                    storyId: widget.story.id,
                    hideReadComments: hideReadComments,
                    setHiddenComments: (bool isHidden) => {
                          setState(() {
                            final nChildren =
                                commentsState.stories[index]?.nChildren ?? 0;
                            final hiddenChildrenIndeces = List.generate(
                                nChildren,
                                (listIndex) => listIndex + index + 1);
                            isHidden
                                ? hiddenComments.addAll(hiddenChildrenIndeces)
                                : hiddenComments
                                    .removeAll(hiddenChildrenIndeces);
                          })
                        });
              } else {
                return Container(
                  height: 0,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
