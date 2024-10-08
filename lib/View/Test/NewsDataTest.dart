import 'package:flutter/material.dart';

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                dividerColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    text: 'Flights',
                    icon: Icon(Icons.flight),
                  ),
                  Tab(
                    text: 'Trips',
                    icon: Icon(Icons.luggage),
                  ),
                  Tab(
                    text: 'Explore',
                    icon: Icon(Icons.explore),
                  ),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: <Widget>[
                    NestedTabBar('Flights'),
                    NestedTabBar('Trips'),
                    NestedTabBar('Explore'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: '서울'),
            Tab(text: '경기'),
            Tab(text: '부산'),
            Tab(text: '대전'),
            Tab(text: '대구'),
            Tab(text: '광주'),
            Tab(text: '제주'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                    child: Text('${widget.outerTab}: Specifications tab')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}