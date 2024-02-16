import 'package:flutter/material.dart';
import 'package:homerun/Model/PresaleDataReferenceData.dart';
import 'LocationTabBarViewPageWidget.dart';
import 'LocationTabBarWidget.dart';

class CategoryTabBarViewPageWidget extends StatelessWidget {

  const CategoryTabBarViewPageWidget({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: PresaleDataReferenceData.locations.length,
      child: Column(
        children: [
          const LocationTabBarWidget(),
          Expanded(
            child: TabBarView(
              children: PresaleDataReferenceData.locations.map((location) =>
                  Center(child: LocationTabBarViewPageWidget(category: category, region: location,)),
              ).toList()
            ),
          ),
        ],
      ),
    );
  }
}



