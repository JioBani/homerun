
import 'package:flutter/material.dart';
import 'package:homerun/Style/PDFs.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfTest2 extends StatelessWidget {
  const PdfTest2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: const Text('Pdf_render example app'),
        ),
        backgroundColor: Colors.grey,
        body: Center(
            child: PdfDocumentLoader.openAsset(
              PDFs.temp2,
              documentBuilder: (context, pdfDocument, pageCount) => LayoutBuilder(
                  builder: (context, constraints) => ListView.builder(
                      itemCount: pageCount + 1,
                      itemBuilder: (context, index){
                        if(index < pageCount){
                          return Container(
                              color: Colors.black12,
                              child: PdfPageView(
                                pdfDocument: pdfDocument,
                                pageNumber: index + 1,
                              )
                          );
                        }
                        else{
                          return Text("gd");
                        }
                      }
                  )
              ),
            )
        )
    );
  }
}
