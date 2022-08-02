// ignore_for_file: depend_on_referenced_packages

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/blocs.dart';
import '../../../../infrastructure/callback_functions.dart';
import '../../../../models/entities/entities.dart';
import '../../../../models/repositories/repo_fake_implementaion/fake_post_repository.dart';
import '../../../widgets/widgest.dart';

class PostCarouselWithIndicator extends StatefulWidget {
  final List<Post> items;
  final double height;
  final double cauroselLeftPadding;
  final double cauroselRightPadding;
  final double borderRadious;
  final CustomeValueSetterCallback<String, bool>? onTogglePostBookmark;
  const PostCarouselWithIndicator({
    Key? key,
    required this.items,
    required this.height,
    required this.borderRadious,
    required this.cauroselLeftPadding,
    required this.cauroselRightPadding,
    this.onTogglePostBookmark,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<PostCarouselWithIndicator> {
  int _current = 0;
  late CarouselController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostBloc(postRepository: context.read<FakePostReposiory>()),
      child: BlocListener<PostBloc, PostState>(
        listenWhen: (previous, current) =>
            current is PostTogglingPostBookmarkSuccessfullState,
        listener: (context, state) => togglePostBookmarkStatus(
            (state as PostTogglingPostBookmarkSuccessfullState).postId),
        child: Column(children: [
          CarouselSlider.builder(
            carouselController: _controller,
            options: CarouselOptions(
                height: widget.height,
                autoPlay: false,
                enableInfiniteScroll: false,
                reverse: false,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                initialPage: 0,
                padEnds: true,
                viewportFraction:
                    (100.0 - widget.cauroselLeftPadding / 2) / 100,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            itemCount: 5,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Padding(
              padding: pageViewIndex != _current
                  ? const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0)
                  : const EdgeInsets.all(0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadious),
                  child: Stack(
                    children: [
                      Image.network(
                          fit: BoxFit.fill,
                          width: double.infinity,
                          widget.items[itemIndex].imagesUrls!.first),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 22.0,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '2 hours ago',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                      BlocBuilder<PostBloc, PostState>(
                                        buildWhen: (previous, current) =>
                                            current
                                                is PostTogglingBookmarkState ||
                                            current
                                                is PostTogglingPostBookmarkSuccessfullState ||
                                            current
                                                is PostTogglingPostBookmarkHasErrorState,
                                        builder: (context, state) {
                                          if (state
                                              is! PostTogglingBookmarkState) {
                                            return PostBookmarkButton(
                                                onPressed: () => context
                                                    .read<PostBloc>()
                                                    .add(
                                                        PostToggleBookmarkEvent(
                                                            postId: widget
                                                                .items[
                                                                    itemIndex]
                                                                .id)),
                                                unBookmarkedColor: Colors.white,
                                                bookmarkedColor: Colors.orange,
                                                isBookmarking: false,
                                                isBookmarked: widget
                                                    .items[itemIndex]
                                                    .isBookmarked);
                                          }

                                          //PostTogglingBookmarkState
                                          return PostBookmarkButton(
                                              onPressed: () => context
                                                  .read<PostBloc>()
                                                  .add(PostToggleBookmarkEvent(
                                                      postId: widget
                                                          .items[itemIndex]
                                                          .id)),
                                              unBookmarkedColor: Colors.white,
                                              bookmarkedColor: Colors.orange,
                                              isBookmarking:
                                                  widget.items[itemIndex].id ==
                                                      state.postId,
                                              isBookmarked: widget
                                                  .items[itemIndex]
                                                  .isBookmarked);
                                        },
                                      ),
                                    ]),
                              ),
                              Text(
                                widget.items[itemIndex].title,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16.0,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: _current == entry.key ? 8.5 : 6.0,
                  height: _current == entry.key ? 8.5 : 6.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      border: _current == entry.key
                          ? Border.all(width: 1.5, color: Colors.orange)
                          : null,
                      shape: BoxShape.circle,
                      color: Colors.orange
                          .withOpacity(_current == entry.key ? 0 : 1)),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  void togglePostBookmarkStatus(String postId) {
    widget.items.firstWhere((p) => p.id == postId).isBookmarked
        ? widget.items.firstWhere((p) => p.id == postId).isBookmarked = false
        : widget.items.firstWhere((p) => p.id == postId).isBookmarked = true;

    widget.onTogglePostBookmark != null
        ? widget.onTogglePostBookmark!(
            postId,
            widget.items.firstWhere((p) => p.id == postId).isBookmarked,
          )
        : null;
  }
}
