import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/View/DubleTapExitWidget.dart';
import 'package:homerun/View/Test/CacheTest.dart';
import 'package:homerun/View/Test/PdfTest2.dart';
import 'package:homerun/View/buttom_nav.dart';

class DataDevPage extends StatefulWidget {
  const DataDevPage({super.key});

  @override
  State<DataDevPage> createState() => _DataDevPageState();
}

class _DataDevPageState extends State<DataDevPage> {

  List<DocumentSnapshot> documentList = [];

  @override
  Widget build(BuildContext context) {
    return DoubleTapExitWidget(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: (){
                    FirebaseFirestoreService.instance.addPreSaleData();
                  },
                  child: Text("데이터 추가")
                ),
                TextButton(
                    onPressed: () async {
                      if(documentList.length == 0){
                        documentList.addAll(await FirebaseFirestoreService.instance.getNextNDocuments(null, 5));
                      }
                      else{
                        documentList.addAll(await FirebaseFirestoreService.instance.getNextNDocuments(documentList[documentList.length - 1], 5));
                      }
                      setState(() {

                      });
                    },
                    child: Text("데이터 가져오기")
                ),
                TextButton(
                    onPressed: () async {
                      //Get.to(PdfImage());
                    },
                    child: Text("pdf 테스트")
                ),
                TextButton(
                    onPressed: () async {
                      Get.to(PdfTest2());
                    },
                    child: Text("pdf 테스트2")
                ),
                TextButton(
                    onPressed: () async {
                      Get.to(CacheTest());
                    },
                    child: Text("캐쉬 테스트")
                ),
                /*StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestoreService.instance.getDataStream(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // 데이터가 도착하면 화면에 표시
                    final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    documents.map((document) => PreSaleData.fromDocumentSnapshot(document));
                    return StreamList(documents: documents);
                  },
                ),*/
                /*Expanded(
                  child: SmartRefresher(
                    onLoading: _onLoading,
                    enablePullUp: true,
                    footer: CustomFooter(
                      builder: (BuildContext context,LoadStatus? mode){
                        Widget body ;
                        if(mode==LoadStatus.idle){
                          body =  Text("pull up load");
                        }
                        else if(mode==LoadStatus.loading){
                          body =  CupertinoActivityIndicator();
                        }
                        else if(mode == LoadStatus.failed){
                          body = Text("Load Failed!Click retry!");
                        }
                        else if(mode == LoadStatus.canLoading){
                          body = Text("release to load more");
                        }
                        else{
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child:body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    child: ListView.builder(
                      itemCount: documentList.length,
                      itemBuilder: (context , index){
                        final document = documentList[index];
                        Timestamp timestamp = document['generate'];
                        DateTime dateTime = timestamp.toDate();
                        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                        return Container(
                          child: ListTile(
                            title: Text(document['name']),
                            subtitle: Text(formattedDate),
                          ),
                        );
                      }
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
/*

class StreamList extends StatefulWidget {
  const StreamList({super.key, required this.documents});
  final List<QueryDocumentSnapshot> documents;

  @override
  State<StreamList> createState() => _StreamListState();
}

class _StreamListState extends State<StreamList> {


  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int limit = 10;

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    if(limit >= widget.documents.length){
      setState(() {

      });
      _refreshController.loadNoData();
    }
    else{
      limit += 10;
      if(limit >  widget.documents.length){
        limit = widget.documents.length;
      }
      setState(() {

      });
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onLoading: _onLoading,
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus? mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        child: ListView.builder(
          itemCount: limit,
          itemBuilder: (BuildContext context, int index) {
            var data = PreSaleData.fromDocumentSnapshot(widget.documents[index]);
            return InformationProfileRowWidget();
          },
        ),
      ),
    );
  }
}

*/
