import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';

class StreamTest extends StatefulWidget {
  const StreamTest({super.key});

  @override
  State<StreamTest> createState() => _StreamTestState();
}

class _StreamTestState extends State<StreamTest> {

  var controller = Get.find<SaleInformationPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*StreamBuilder<QuerySnapshot>(
          stream:  controller.loadStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

           *//* saleInformationController.preSaleDatas.assignAll(snapshot.data!.docs.map((DocumentSnapshot document){
              return PreSaleData.fromDocumentSnapshot(document);
            }).toList());

            return GetX<SaleInformationPageController>(
              builder: (controller){
                return ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.preSaleDatas.length,
                    itemBuilder:(context , index) {
                      return InformationProfileRowWidget(index: [index * 2, index * 2 + 1]);
                    }
                );
              },
            );*//*


            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['full_name']),
                  subtitle: Text(data['company']),
                );
              })
                  .toList()
                  .cast(),
            );
          },
        ),
        TextButton(
          onPressed: () async {
            var list = await controller.loadStream();
            StaticLogger.logger.i("onPressed");
            for (var value in list) {
              value.Print();
            }
          },
          child: Text("데이터 불러오기")
        ),*/
      ],
    );
  }
}
