import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Service/FirebaseStorageCacheService.dart';
import 'package:homerun/View/SaleInfomation/PresaleInfo/SurveyWidget.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PresaleInfoPage extends StatelessWidget {
  const PresaleInfoPage({super.key, required this.preSaleData});
  final PreSaleData preSaleData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseStorageCacheService.getAsset("pdfs/test3.pdf"),
          builder: (context , snapshot) {
            if(snapshot.hasData){
              return PdfDocumentLoader.openData(
                  snapshot.data!,
                  documentBuilder: (context, pdfDocument, pageCount){
                    List<Widget> elements = [];
                    for(int i = 1; i < pageCount + 1; i++){
                      elements.add(
                          Container(
                              color: Colors.black12,
                              child: PdfPageView(
                                pdfDocument: pdfDocument,
                                pageNumber: i,
                              )
                          )
                      );
                    }

                    elements.add(SizedBox(height: 15.h,));
                    elements.add(SurveyListWidget(surveyData: preSaleData.surveyData,));

                    return ListView(
                      children: elements,
                    );
                  }

              );
            }
            else if(snapshot.hasError){
              return Text("데이터를 가져 올 수 없습니다.");
            }
            else{
              return const CupertinoActivityIndicator();
            }

          }
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
