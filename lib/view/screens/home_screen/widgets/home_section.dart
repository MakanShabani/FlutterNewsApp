import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './widgets.dart';
import '../../../../bloc/blocs.dart';
import '../../../../models/entities/ViewModels/view_models.dart';
import '../../../../models/repositories/repo_fake_implementaion/fake_category_repository.dart';
import '../../../../models/repositories/repo_fake_implementaion/fake_post_repository.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => FakeCategoryRepository()),
        RepositoryProvider(
          create: (context) => FakePostReposiory(),
        )
      ],
      child: BlocProvider(
        create: (context) => CategoryBloc(
          categoryRepository: context.read<FakeCategoryRepository>(),
        )..add(InitializeCategoryEvent(
            pagingOptionsVm: PagingOptionsVm(offset: 0, limit: 15))),
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listenWhen: (previous, current) =>
              current is CategoriesInitializationSuccessfullState,
          listener: (context, state) {
            if (state is CategoriesInitializationSuccessfullState) {
              //initialize _tabController with categories length
              _tabController = TabController(
                  length: state.categories.length + 1, vsync: this);
            }
          },
          buildWhen: (previous, current) =>
              current is CategoriesInitializationHasErrorState ||
              current is CategoriesInitializationSuccessfullState ||
              current is CategoriesInitializingState,
          builder: (context, state) {
            if (state is CategoriesInitializationHasErrorState) {
              //show error content
              return Center(
                child: Text(state.error.message),
              );
            }

            if (state is CategoriesInitializingState) {
              // show loading

              return const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            //everything is ok so we show fetched Data
            if (state is CategoriesInitializationSuccessfullState) {
              //First tab is 'All News'
              //Then we map each item in state.categories to a Tab in Tabbar
              //We add 'All News' as the first category to the Tabbar so --> tabs[index:0] = 'All News'
              //tabs[index:1] == category[index -1] , tabs[index:2] == state.categories[index -1] and so on ...
              //For index == 0 :: tabs[index:0] == 'All News'  and  For index >= 1 :: tabs[index] == state.categories[index -1]
              return Scaffold(
                appBar: AppBar(
                  leading: const Icon(Icons.logo_dev),
                  bottom: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    tabs: List<Widget>.generate(
                        state.categories.length + 1,
                        (index) => Tab(
                            text: index == 0
                                ? 'All News'
                                : state.categories.elementAt(index - 1).title)),
                  ),
                ),
                body: TabBarView(
                    controller: _tabController,
                    children: List<Widget>.generate(
                        state.categories.length + 1,
                        (index) => TabContent(
                              categoryIndex: index,
                              category: index == 0
                                  ? null
                                  : state.categories[index - 1],
                            ))),
              );
            }

            return Container(
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }
}
