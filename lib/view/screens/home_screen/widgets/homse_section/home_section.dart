import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/ViewModels/view_models.dart';
import '../../../../../repositories/repo_fake_implementaion/fake_repositories.dart';
import '../../../../../bloc/blocs.dart';
import 'widgets/widgets.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeSectionBloc(
            categoryRepository: context.read<FakeCategoryRepository>(),
          )..add(
              HomeSectionInitializeEvent(
                  pagingOptionsVm: PagingOptionsVm(offset: 0, limit: 10)),
            ),
        ),
      ],
      child: BlocConsumer<HomeSectionBloc, HomeSectionState>(
        listenWhen: (previous, current) =>
            current is HomeSectionInitializationSuccessfullState,
        listener: (context, state) {
          if (state is HomeSectionInitializationSuccessfullState) {
            //initialize _tabController with categories length
            _tabController =
                TabController(length: state.categories.length + 1, vsync: this);
          }
        },
        buildWhen: (previous, current) =>
            current is HomeSectionInitializationHasErrorState ||
            current is HomeSectionInitializationSuccessfullState ||
            current is HomeSectionInitializingState,
        builder: (context, state) {
          if (state is HomeSectionInitializationHasErrorState) {
            //show error content
            return Center(
              child: Text(state.error.message),
            );
          }
          //everything is ok so we show fetched Data
          if (state is HomeSectionInitializationSuccessfullState) {
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
                            category:
                                index == 0 ? null : state.categories[index - 1],
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
