import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Style/PDFs.dart';
import 'package:pdfx/pdfx.dart';

class PdfImage extends StatelessWidget {
  const PdfImage({super.key});

  Future<List<PdfPageImage?>> getImage() async {
    final document = await PdfDocument.openAsset(PDFs.temp2);


    List<PdfPageImage?> images = [];

    for(int i = 1; i< document.pagesCount; i++){
      try{
        StaticLogger.logger.i(i);
        final page = await document.getPage(i);

        final image = await page.render(
          width: page.width * 2, //decrement for less quality
          height: page.height * 2,
          format: PdfPageImageFormat.jpeg,
          backgroundColor: '#ffffff',

          // Crop rect in image for render
          //cropRect: Rect.fromLTRB(left, top, right, bottom),
        );

        images.add(image);
      }catch(e , s){
        StaticLogger.logger.e("${e}\n${s}");
      }
    }

    return images;
  }

  Future<List<PdfPageImage?>> getImage2() async {
    final document = await PdfDocument.openAsset(PDFs.temp2);


    List<PdfPageImage?> images = [];
    List<PdfPage> pdfPages = [];


    try{

      for(int i = 1; i< document.pagesCount; i++){
        final page = await document.getPage(i);
        pdfPages.add(page);
      }

      for(int i = 1; i< pdfPages.length; i++){
        final image = await pdfPages[i].render(
          width: pdfPages[i].width * 2, //decrement for less quality
          height: pdfPages[i].height * 2,
          format: PdfPageImageFormat.jpeg,
          backgroundColor: '#ffffff',

          // Crop rect in image for render
          //cropRect: Rect.fromLTRB(left, top, right, bottom),
        );
        images.add(image);
      }


    }catch(e , s){
      StaticLogger.logger.e("${e}\n${s}");
    }finally{
      document.close();
    }

    return images;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getImage2(), //<- created image
            builder: (context, AsyncSnapshot<List<PdfPageImage?>> snapshot) {

              // data is ready
              if(snapshot.hasData) {

                return ListView(children: snapshot.data!.map((image) => Image.memory(image!.bytes)).toList(),);

                // loading
              } else if(snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()),);
              } else{
                return const Center(child: CircularProgressIndicator(),);
              }

            }
        ),
      ),
    );
  }
}
