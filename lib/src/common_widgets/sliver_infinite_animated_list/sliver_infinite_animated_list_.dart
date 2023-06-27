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
    required this.firstItemWithoutTopPadding,
    required this.lastItemWithoutBottomPadding,
    this.itemBottomPadding,
    this.showDividerAfterLastItem,
  }) : super(key: key);
  final bool firstItemWithoutTopPadding;
  final bool lastItemWithoutBottomPadding;
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
  final bool? showDividerAfterLastItem;
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
          SliverAnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) => FadeTransition(
              opacity: animation,
              child: Column(
                children: [
                  Padding(
                    //padding
                    padding: EdgeInsets.fromLTRB(
                        widget.itemLeftPadding ?? 0,
                        widget.itemTopPadding != null
                            ? (index == 0 && widget.firstItemWithoutTopPadding)
                                ? 0
                                : widget.itemTopPadding!
                            : 0,
                        widget.itemRightPadding ?? 0,
                        widget.itemBottomPadding != null
                            ? (index == _items.length - 1 &&
                                    widget.lastItemWithoutBottomPadding)
                                ? 0
                                : widget.itemBottomPadding!
                            : 0),
                    //Item Layout Builder
                    child: widget.itemLayoutBuilder(_items[index], index),
                  ),
                  //Divider
                  widget.showDivider != null && widget.showDivider!
                      ? (index == _items.length - 1 &&
                              (widget.showDividerAfterLastItem == null ||
                                  !widget.showDividerAfterLastItem!))
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
            ),
          ),
          BlocBuilder<ListNotifireCubit<S>, ListNotifireCubitState>(
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: state is ListNotifireCubitShowLoading
                    ? widget.loadingLayout
                    : const SizedBox(
                        height: 0,
                      ),
              );
            },
          )
        ],
      ),
    );
  }

  void _insertSingleItem(S item, bool insertToTheTop) {
    //add the item to the start of the list or end of the list based on the insertTotheTop value
    int insertIndex = insertToTheTop ? 0 : _items.length;
    _items.insert(insertIndex, item);
    _listKey.currentState
        ?.insertItem(insertIndex, duration: const Duration(milliseconds: 500));
  }

  void _insertMultipleItems(List<S> newItems, bool insertToTheTop) {
    //add the items to the start of the list or end of the list based on the insertTotheTop value
    int insertIndex = insertToTheTop ? 0 : _items.length;
    _items = insertToTheTop ? newItems + _items : _items + newItems;
    // This is a bit of a hack because currentState doesn't have
    // an insertAll() method.
    for (int offset = 0; offset < newItems.length; offset++) {
      _listKey.currentState?.insertItem(insertIndex + offset,
          duration: const Duration(seconds: 1));
    }
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
