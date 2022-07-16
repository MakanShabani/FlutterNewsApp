import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/blocs.dart';
import '../../../../models/repositories/repo_fake_implementaion/fake_category_repository.dart';
import '../../../../models/repositories/repositories.dart';

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
    _tabController = TabController(length: 4, vsync: this);
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
        RepositoryProvider(create: (context) => FakeCategoryRepository())
      ],
      child: BlocProvider(
        create: (context) => HomeSectionBloc(
            categoryRepository: context.read<CategoryRepository>()),
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.logo_dev),
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(text: 'All News'),
              Tab(text: 'Business'),
              Tab(text: 'Politics'),
              Tab(text: 'Tech'),
            ]),
          ),
          body: Container(),
        ),
      ),
    );
  }
}
