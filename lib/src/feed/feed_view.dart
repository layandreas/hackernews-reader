import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stories_provider.dart';
import 'story_model.dart';
import 'dart:async';
import 'comments_views.dart';
import 'top_stories_provider.dart';
import 'endless_scroll_view.dart';

class FeedView extends ConsumerStatefulWidget {
  const FeedView({super.key});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  final scrollController = ScrollController();
  Timer? initialStoryFetchesTimer;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);

    final storiesNotifier = ref.read(storiesProvider.notifier);
    storiesNotifier.fetchStories();
    initialStoryFetchesTimer =
        Timer.periodic(const Duration(milliseconds: 500), initialStoryFetches);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    initialStoryFetchesTimer?.cancel();
  }

  void initialStoryFetches(Timer timer) {
    final storiesState = ref.read(storiesProvider);
    final storiesNotifier = ref.read(storiesProvider.notifier);

    if (!storiesState.isLoading && !storiesState.reachedEnd) {
      storiesNotifier.fetchStories();
    }

    if (storiesState.reachedEnd ||
        scrollController.position.maxScrollExtent > 0) {
      timer.cancel();
    }
  }

  void scrollListener() {
    final storiesState = ref.read(storiesProvider);
    final storiesNotifier = ref.read(storiesProvider.notifier);

    if (!storiesState.isLoading &&
        !storiesState.reachedEnd &&
        scrollController.offset >= scrollController.position.maxScrollExtent) {
      storiesNotifier.fetchStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Top Stories')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            initialStoryFetchesTimer = Timer.periodic(
                const Duration(milliseconds: 1000), initialStoryFetches);

            return ref.refresh(topStoriesProvider.future);
          },
          child: ListView(
              // Show messages from bottom to top
              controller: scrollController,
              children: [
                for (Story story in stories.stories)
                  Card(
                      child: ListTile(
                    title: Text(story.title),
                    onTap: () {
                      Navigator.restorablePushNamed(
                          context, CommentsView.routeName,
                          arguments: story.toJson());
                    },
                  )),
                if (stories.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
              ]),
        ),
      ),
    );
  }
}

class FeedView2 extends ConsumerWidget {
  const FeedView2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesState = ref.watch(storiesProvider);
    final storiesNotifier = ref.read(storiesProvider.notifier);

    return EndlessScrollView(
      storiesState: storiesState,
      dataFetcher: () => storiesNotifier.fetchStories(),
      refreshCallback: () => ref.refresh(topStoriesProvider.future),
      itemBuilder: (index, storiesState) {
        return Card(
            child: ListTile(
          title: Text(storiesState.stories[index].title),
          onTap: () {
            Navigator.restorablePushNamed(context, CommentsView.routeName,
                arguments: storiesState.stories[index].toJson());
          },
        ));
      },
    );
  }
}
