import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/guide_page_controller.dart';
import 'package:homerun/Model/TestData.dart';
import 'package:homerun/View/GuideImagePage/guide_image_page.dart';

import '../../Style/Palette.dart';

class ItemBoxWidget extends StatelessWidget {
  const ItemBoxWidget({super.key , required this.productData , required this.controller});
  final GuidePageController controller;
  final ProductData productData;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>{Get.to(GuideImagePage())},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(64, 0, 0, 0),
                offset: Offset(0,3),
                blurRadius : 0.2,
              )
            ]
        ),
        margin: EdgeInsets.only(top: 20.w),
        height: 200.w,
        child: Column(
            children: [
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: controller.getImageUrl(productData),
                  builder: (context, snapshot) {
                    return Container(
                      width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r) , topRight: Radius.circular(10.r))
                        ),
                      child: Builder(
                          builder: (context) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CardLoading(height: double.infinity);
                            }
                            else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            else if (snapshot.hasData) {
                              return CachedNetworkImage(
                                imageUrl: snapshot.data!,
                                placeholder: (context, url) => const CardLoading(height: double.infinity),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                fit: BoxFit.fill,
                              );
                            } else {
                              return Text('No Image URL');
                            }
                          },
                    )
              );
                  }
                ),
              ),
              Expanded(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        productData.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
              )
            ],
        ),
      ),
    );
  }
}
