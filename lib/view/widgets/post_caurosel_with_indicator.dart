// ignore_for_file: depend_on_referenced_packages

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../infrastructure/callback_functions.dart';
import '../../../../models/entities/entities.dart';
import './widgest.dart';

class PostCarouselWithIndicator extends StatefulWidget {
  final double height;
  final double cauroselLeftPadding;
  final double cauroselRightPadding;
  final double borderRadious;
  final List<Post> items;

  final CustomeValueSetterCallback<String, bool>? onPostBookmarkPressed;

  final CustomeValueSetterCallback<String, bool>? onPostBookMarkUpdated;

  const PostCarouselWithIndicator({
    Key? key,
    this.onPostBookmarkPressed,
    this.onPostBookMarkUpdated,
    required this.items,
    required this.height,
    required this.borderRadious,
    required this.cauroselLeftPadding,
    required this.cauroselRightPadding,
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
    return Column(children: [
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
            viewportFraction: (100.0 - widget.cauroselLeftPadding / 2) / 100,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
        itemCount: 5,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            Padding(
          padding: pageViewIndex != _current
              ? const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0)
              : const EdgeInsets.all(0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadious),
              child: InkWell(
                child: GridTile(
                  footer: Container(
                    color: Colors.black54.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 34.0,
                            child: Text(
                              widget.items[itemIndex].title,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            height: 20.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '2 hours ago',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12.0),
                                ),
                                PostBookmarkSection(
                                  bookmarkedColor: Colors.orange,
                                  unBookmarkedColor: Colors.white70,
                                  initialBookmarkStatus:
                                      widget.items[itemIndex].isBookmarked,
                                  postID: widget.items[itemIndex].id,
                                  onPostBookmarkUpdated: (postId,
                                          newBookmarkValue) =>
                                      onPostBookmarkUpdated(
                                          itemIndex, postId, newBookmarkValue),
                                  onnBookmarkButtonPressed:
                                      (postId, newBookmarkValueToSet) =>
                                          onPostBookMarkPressed(
                                              postId, newBookmarkValueToSet),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  child: Image.network(
                      fit: BoxFit.fill,
                      width: double.infinity,
                      widget.items[itemIndex].imagesUrls!.first),
                ),
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
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  border: _current == entry.key
                      ? Border.all(width: 1.5, color: Colors.orange)
                      : null,
                  shape: BoxShape.circle,
                  color:
                      Colors.orange.withOpacity(_current == entry.key ? 0 : 1)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  //we use this fuction to update post's bookmark value locally
  //if onPostBookMarkUpdated CallBack is provided the the post's bookmark will be updated in the parent widegt's post lists too.
  void onPostBookmarkUpdated(int index, String postId, bool newBookmarkStatus) {
    //update local list
    widget.items[index].isBookmarked = newBookmarkStatus;

    //update parent widget's list
    if (widget.onPostBookMarkUpdated != null) {
      widget.onPostBookMarkUpdated!(postId, newBookmarkStatus);
    }
  }

  // we use this function to do stuff when bookmark button is pressed
  //if widget.onPostBookmarkPressed is provided , parent widget's demands as function will be call
  void onPostBookMarkPressed(String postId, bool newBookmarkStatusToSet) {
    widget.onPostBookmarkPressed != null
        ? () => widget.onPostBookmarkPressed!(postId, newBookmarkStatusToSet)
        : null;
  }
}
