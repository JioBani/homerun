import 'package:flutter/material.dart';
import 'package:homerun/Model/PresaleDataReferenceData.dart';
import 'LocationTabBarViewPageWidget.dart';
import 'LocationTabBarWidget.dart';

class CategoryTabBarViewPageWidget extends StatelessWidget {
  CategoryTabBarViewPageWidget({super.key, required this.category}){
    pages = PresaleDataReferenceData.locations.map((location) =>
        Center(child: LocationTabBarViewPageWidget(category: category, region: location,)),
    ).toList();
  }

  final String category;
  late final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: PresaleDataReferenceData.locations.length,
      child: Column(
        children: [
          const LocationTabBarWidget(),
          Expanded(
            child: TabBarView(
              children: pages
            ),
          ),
        ],
      ),
    );
  }
}



