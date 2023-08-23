import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'CategoryButtonWidget.dart';

class CategoryButtonTableWidget extends StatelessWidget {
  const CategoryButtonTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Wrap(
        spacing: 20.w,
        children: [
          const CategoryButtonWidget(),
          const CategoryButtonWidget(),
          const CategoryButtonWidget(),
          const CategoryButtonWidget(),
          const CategoryButtonWidget(),
          const CategoryButtonWidget(),
          const CategoryButtonWidget(),
        ],
      ),
    );
  }
}
