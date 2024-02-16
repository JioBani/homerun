import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/FileDataService.dart';
import 'package:homerun/Service/FirebaseStorageCacheService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class CacheTest extends StatefulWidget {
  CacheTest({super.key});

  @override
  State<CacheTest> createState() => _CacheTestState();
}

class _CacheTestState extends State<CacheTest> {
  final storageRef = FirebaseStorage.instance.ref();

  Future<File> getPdf() async {
    return await DefaultCacheManager().getSingleFile(
        'https://firebasestorage.googleapis.com/v0/b/homerun-3e122.appspot.com/o/pdfs%2F%EB%AA%A9%EC%B0%A8.pdf?alt=media&token=3a767683-c015-4a2d-999e-78f7e7cd7cc2');
  }

  Future<void> getFile()async{
    final imagesRef = storageRef.child("images");
    final spaceRef = storageRef.child("images/아파트01.png");
    var metaData = await spaceRef.getMetadata();
    StaticLogger.logger.i("${metaData.name} : ${metaData.updated}");
  }

  File? imageFile;
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            /*children: [
              Expanded(
                child: FutureBuilder(
                  future: getPdf(),
                  builder: (context , snapshot) {
                    if(snapshot.hasData){
                      return Center(
                          child: PdfDocumentLoader.openAsset(
                            snapshot.data!.path,
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
                      );
                    }
                    else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  }
                ),
              )
            ],*/
          children: [
            TextButton(
                onPressed: (){
                  //FirebaseStorageCacheService().saveTempFile();
                },
                child: Text("이미지 저장하기")
            ),
            TextButton(
                onPressed: () async {
                  /*File? file =  await FirebaseStorageCacheService().loadTempFile();
                  if(file != null){
                    imageFile = file;
                    setState(() {

                    });
                  }*/
                },
                child: Text("이미지 불러오기")
            ),
            TextButton(
                onPressed: (){
                  FileDataService.removeAllData();
                },
                child: Text("데이터 전부 삭제")
            ),
            TextButton(
                onPressed: () async {
                  final spaceRef = storageRef.child("images/아파트01.png");
                  final fileData = await spaceRef.getData();
                },
                child: Text("캐쉬 저장")
            ),
            TextButton(
                onPressed: (){
                  //FirebaseStorageCacheService().checkCache("images/아파트01.png", DateTime.now());
                },
                child: Text("캐쉬 읽기")
            ),
            TextButton(
                onPressed: () async {
                  final fileData = await FirebaseStorageCacheService.getAsset("images/아파트01.png");
                  if(fileData != null){
                    imageBytes = fileData;
                    setState(() {

                    });
                  }
                  else{
                    StaticLogger.logger.e("데이터 불러오기 실패");
                  }
                },
                child: Text("이미지 가져오기")
            ),
            Expanded(
              child: ListView(
                children: [
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
                  ImageWidget(),
              
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseStorageCacheService.getImage("images/아파트01.png"),
        builder: (context , snapshot){
          if(snapshot.hasData){
            return Image(
              image: snapshot.data!,
            );
          }
          else if(snapshot.hasError){
            return Text("Error");
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
  }
}


