import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/common_widgets/common_widgest.dart';
import 'package:sliver_tools/sliver_tools.dart';

export './list_notifire_cubit/list_notifire_cubit.dart';

typedef ListItemLayout<E> = Widget Function(E item, int index);

class SliverInfiniteAnimatedList<T> extends StatefulWidget {
  const SliverInfiniteAnimatedList({
    Key? key,
    required this.items,
    required this.itemLayout,
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
  final ListItemLayout<T> itemLayout;
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
          _insertMultipleItems(state.newItems);
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
            initialItemCount: widget.items.length,
            itemBuilder: (context, index, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: const Offset(0, 0),
              ).animate(animation),
              child: widget.itemLayout(_items[index], index),
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

  void _insertSingleItem(S item) {
    int insertIndex = _items.length;
    _items.insert(insertIndex, item);
    _listKey.currentState
        ?.insertItem(insertIndex, duration: const Duration(milliseconds: 500));
  }

  void _insertMultipleItems(List<S> newItems) {
    int insertIndex = _items.length;
    _items = _items + newItems;
    // This is a bit of a hack because currentState doesn't have
    // an insertAll() method.
    for (int offset = 0; offset < newItems.length; offset++) {
      _listKey.currentState?.insertItem(insertIndex + offset,
          duration: const Duration(seconds: 1));
    }
  }

  void insertItem(List<S> newPosts) {
    int insertIndex = _items.length - 1;
    for (int offset = 0; offset < _items.length + newPosts.length; offset++) {
      _listKey.currentState?.insertItem(insertIndex + offset,
          duration: const Duration(milliseconds: 500));
      _items = _items + newPosts;
    }
  }

  void _removeItem(S item) {
    _listKey.currentState?.removeItem(
        _items.indexOf(item),
        (_, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: const Offset(0, 0),
            ).animate(animation),
            child: widget.itemLayout(item, _items.indexOf(item))),
        duration: const Duration(milliseconds: 500));
    _items.remove(item);
  }
}
