import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/common_widgets/common_widgest.dart';
import 'package:sliver_tools/sliver_tools.dart';

export './list_notifire_cubit/list_notifire_cubit.dart';

typedef ListItemLayoutBuilder<E> = Widget Function(E item, int index);
typedef ListRemoveItemBuilder<E> = Widget Function(E item, int index);

class SliverInfiniteAnimatedList<T> extends StatefulWidget {
  const SliverInfiniteAnimatedList({
    Key? key,
    required this.items,
    required this.itemLayoutBuilder,
    this.removeItemBuilder,
    required this.loadingLayout,
    this.scrollDirection,
    this.itemHeight,
    this.spaceBetweenItems,
    this.itemLeftPadding,
    this.itemRightPadding,
    this.itemTopPadding,
    this.showDivider,
    this.firstItemWithoutTopPadding,
    this.lastItemWithoutBottomPadding,
    this.itemBottomPadding,
    this.hideDividerAfterLastItem,
    this.firstItemWithoutBottomPadding,
    this.onItemsAreInserted,
    this.revers,
  }) : super(key: key);
  final bool? firstItemWithoutTopPadding;
  final bool? lastItemWithoutBottomPadding;
  final bool? showDivider;
  final double? itemHeight;
  final double? spaceBetweenItems;
  final double? itemLeftPadding;
  final double? itemRightPadding;
  final double? itemTopPadding;
  final double? itemBottomPadding;
  final List<T> items;
  final Axis? scrollDirection;
  final ListItemLayoutBuilder<T> itemLayoutBuilder;
  final ListRemoveItemBuilder<T>? removeItemBuilder;
  final Widget loadingLayout;
  final bool? hideDividerAfterLastItem;
  final bool? firstItemWithoutBottomPadding;
  final bool? revers;
  final VoidCallback? onItemsAreInserted;
  @override
  State<SliverInfiniteAnimatedList<T>> createState() =>
      SliverInfiniteAnimatedListState<T>();
}

class SliverInfiniteAnimatedListState<S>
    extends State<SliverInfiniteAnimatedList<S>> {
  /// Will used to access the Animated list
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  /// This holds the items
  late List<S> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListNotifireCubit<S>, ListNotifireCubitState>(
      listener: (context, state) {
        if (state is ListNotifireCubitInsertNewItems<S>) {
          //Insert new items
          _insertMultipleItems(state.newItems, state.insertToTheTop);
          return;
        }

        if (state is ListNotifireCubitRemoveItem<S>) {
          _removeItem(state.itemToRemove);
          return;
        }
        if (state is ListNotifireCubitItemModified<S>) {
          if (state.updateListState) {
            setState(() {
              _items[state.index] = state.modifiedItem;
            });
          } else {
            _items[state.index] = state.modifiedItem;
          }
        }
        return;
      },
      child: MultiSliver(
        pushPinnedChildren: false,
        children: [
          //show loading indicator in the first of the list
          //if showLoadingIndicatorOnTop flag is true
          (widget.revers ?? false)
              ? BlocBuilder<ListNotifireCubit<S>, ListNotifireCubitState>(
                  builder: (context, state) {
                    return SliverToBoxAdapter(
                      child: state is ListNotifireCubitShowLoading
                          ? widget.loadingLayout
                          : const SizedBox(
                              height: 10.0,
                            ),
                    );
                  },
                )
              : const SizedBox(
                  height: 0,
                ),
          SliverAnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                //use reversIndex when revers flag is true
                if (widget.revers ?? false) {
                  index = _items.length - index - 1;
                }
                return FadeTransition(
                  opacity: animation,
                  child: Column(
                    children: [
                      Padding(
                        //padding
                        padding: EdgeInsets.fromLTRB(
                            widget.itemLeftPadding ?? 0,
                            widget.itemTopPadding != null
                                ? (index == 0 &&
                                        widget.firstItemWithoutTopPadding !=
                                            null &&
                                        widget.firstItemWithoutTopPadding!)
                                    ? 0
                                    : widget.itemTopPadding!
                                : 0,
                            widget.itemRightPadding ?? 0,
                            widget.itemBottomPadding != null
                                ? (index == _items.length - 1 &&
                                        widget.lastItemWithoutBottomPadding !=
                                            null &&
                                        widget.lastItemWithoutBottomPadding!)
                                    ? 0
                                    : widget.itemBottomPadding!
                                : 0),
                        //Item Layout Builder
                        child: widget.itemLayoutBuilder(_items[index], index),
                      ),
                      //Divider
                      widget.showDivider != null && widget.showDivider!
                          ? (index == _items.length - 1 &&
                                  (widget.hideDividerAfterLastItem ?? false))
                              ? const SizedBox(
                                  height: 0,
                                )
                              : const Divider(
                                  thickness: 2.0,
                                )
                          : const SizedBox(
                              height: 0,
                            )
                    ],
                  ),
                );
              }),
          //show loading indicator in the end of the list
          !(widget.revers ?? false)
              ? BlocBuilder<ListNotifireCubit<S>, ListNotifireCubitState>(
                  builder: (context, state) {
                    return SliverToBoxAdapter(
                      child: state is ListNotifireCubitShowLoading
                          ? widget.loadingLayout
                          : const SizedBox(
                              height: 10.0,
                            ),
                    );
                  },
                )
              : const SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }

  void _insertSingleItem(S item, bool insertToTheTop) {
    //add the item to the start of the list or end of the list based on the insertTotheTop value
    int insertIndex = insertToTheTop ? 0 : _items.length;
    _items.insert(insertIndex, item);

    //note that if the revers flag is true, we must replace start index with lastIndex after
    //the item is inserted in the list
    insertIndex = (widget.revers ?? false)
        ? insertToTheTop
            ? _items.length - 1
            : 0
        : insertToTheTop
            ? 0
            : _items.length - 1;
    _listKey.currentState
        ?.insertItem(insertIndex, duration: const Duration(seconds: 1));
  }

  void _insertMultipleItems(List<S> newItems, bool insertToTheTop) {
    //add the items to the start of the list or end of the list based on the insertTotheTop value
    int insertIndex = insertToTheTop ? 0 : _items.length;
    _items = insertToTheTop ? newItems + _items : _items + newItems;
    //note that if the revers flag is true, we must replace start index with lastIndex after
    //the item is inserted in the list
    insertIndex = (widget.revers ?? false)
        ? insertToTheTop
            ? _items.length - newItems.length
            : 0
        : insertToTheTop
            ? 0
            : _items.length - newItems.length;

    // This is a bit of a hack because currentState doesn't have
    // an insertAll() method.
    if (widget.revers ?? false) {
      for (int offset = 0; offset < newItems.length; offset++) {
        _listKey.currentState?.insertItem(offset + insertIndex,
            duration: const Duration(seconds: 0));
      }
    } else {
      for (int offset = 0; offset < newItems.length; offset++) {
        _listKey.currentState?.insertItem(offset + insertIndex,
            duration: const Duration(seconds: 1));
      }
    }

    widget.onItemsAreInserted != null ? widget.onItemsAreInserted!() : null;
  }

  void insertItem(List<S> newPosts) {
    int insertIndex = _items.length;
    for (int offset = 0; offset < _items.length + newPosts.length; offset++) {
      _listKey.currentState?.insertItem(insertIndex + offset,
          duration: const Duration(milliseconds: 500));
      _items = _items + newPosts;
    }
  }

  void _removeItem(S item) {
    int removeIndex = _items.indexOf(item);

    if (removeIndex == -1) return;

    _items.removeAt(removeIndex);
    _listKey.currentState?.removeItem(
        removeIndex,
        (_, animation) => FadeTransition(
            opacity: animation,
            child: widget.removeItemBuilder != null
                ? widget.removeItemBuilder!(item, removeIndex)
                : const SizedBox(
                    height: 0,
                  )),
        duration: const Duration(milliseconds: 500));
  }
}
