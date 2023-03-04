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
    this.itemLeftMargin,
    this.itemRightMargin,
    this.itemTopMargin,
  }) : super(key: key);

  final double? itemHeight;
  final double? spaceBetweenItems;
  final double? itemLeftMargin;
  final double? itemRightMargin;
  final double? itemTopMargin;
  final List<T> items;
  final Axis? scrollDirection;
  final ListItemLayoutBuilder<T> itemLayoutBuilder;
  final ListRemoveItemBuilder<T>? removeItemBuilder;
  final Widget loadingLayout;
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
              child: widget.itemLayoutBuilder(_items[index], index),
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
