import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tab_content.dart';
import '../../../../posts_category/application/post_category_service.dart';
import '../../../../posts_category/data/repositories/post_category_repositories.dart';
import '../../../../posts_category/presentation/blocs/post_category_cubit.dart';
import 'tab_bar_cubit/tab_bar_cubit.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TabBarCubit()..hideTabBar()),
        BlocProvider(
          create: (context) => PostCategoryCubit(
            postCategoryService: PostCategoryService(
                postCategoryRepository:
                    context.read<FakePostCategoryRepository>()),
            homwManyFetchEachTime: 10,
          )..fetch(),
        ),
      ],
      child: BlocConsumer<PostCategoryCubit, PostCategoryState>(
        //listen only for first fetch
        listenWhen: (previous, current) =>
            current is PostCategoryFetchedSuccessfully &&
            current.newLoadedPagingOptionsDTO.offset == 0,
        listener: (context, state) {
          if (state is PostCategoryFetchedSuccessfully) {
            //initialize _tabController with categories length
            _tabController = TabController(
                length: context
                        .read<PostCategoryCubit>()
                        .allDownloadedPostCategorieS(state)
                        .length +
                    1,
                vsync: this);
          }
        },
        buildWhen: (previous, current) =>
            (current is PostCategoryFetchingHasError &&
                current.previousLoadedPagingOptions == null) ||
            (current is PostCategoryFetchedSuccessfully &&
                current.previousLoadedPagingOptionsDTO == null) ||
            (current is PostCategoryFethcing &&
                current.previousLoadedPagingOptions == null),

        builder: (context, state) {
          if (state is PostCategoryFetchingHasError) {
            //show error content
            return Center(
              child: Text(state.error.message),
            );
          }
          //everything is ok so we show fetched Data
          if (state is PostCategoryFetchedSuccessfully) {
            //First tab is 'All News'
            //Then we map each item in state.categories to a Tab in Tabbar
            //We add 'All News' as the first category to the Tabbar so --> tabs[index:0] = 'All News'
            //tabs[index:1] == category[index -1] , tabs[index:2] == state.categories[index -1] and so on ...
            //For index == 0 :: tabs[index:0] == 'All News'  and  For index >= 1 :: tabs[index] == state.categories[index -1]
            return Scaffold(
              appBar: AppBar(
                leading: context.watch<TabBarCubit>().state is TabBarShow
                    ? const Icon(Icons.logo_dev)
                    : null,
                title: context.watch<TabBarCubit>().state is! TabBarShow
                    ? const Text('Home')
                    : null,
                bottom: context.watch<TabBarCubit>().state is TabBarShow
                    ? TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: List<Widget>.generate(
                            context
                                    .read<PostCategoryCubit>()
                                    .allDownloadedPostCategorieS(state)
                                    .length +
                                1,
                            (index) => Tab(
                                text: index == 0
                                    ? 'All News'
                                    : context
                                        .read<PostCategoryCubit>()
                                        .allDownloadedPostCategorieS(state)
                                        .elementAt(index - 1)
                                        .title)),
                      )
                    : const PreferredSize(
                        preferredSize: Size.fromHeight(0.0),
                        child: SizedBox(height: 0.0),
                      ),
              ),
              body: TabBarView(
                  controller: _tabController,
                  children: List<Widget>.generate(
                      context
                              .read<PostCategoryCubit>()
                              .allDownloadedPostCategorieS(state)
                              .length +
                          1,
                      (index) => TabContent(
                            categoryIndex: index,
                            category: index == 0
                                ? null
                                : context
                                    .read<PostCategoryCubit>()
                                    .allDownloadedPostCategorieS(
                                        state)[index - 1],
                          ))),
            );
          }

          // Initializing State
          return const Center(
            child: Text(
              'Loading...',
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
