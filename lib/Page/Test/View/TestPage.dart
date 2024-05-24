import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/HousingSaleNoticesPage.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: (){
                    Get.to(HousingSaleNoticesPage());
                  },
                  child: Text("분양공고 페이지")
              )
            ],
          ),
        ),
      ),
    );
  }
}
