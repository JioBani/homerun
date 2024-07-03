import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homerun/Service/FirebaseStorageCacheService.dart';
import 'package:shimmer/shimmer.dart';

/// [onlySaveMemory] : 웹에서는 값에 상관없이 항상 [CachedNetworkImage]를 사용
class FireStorageImage extends StatefulWidget {
  const FireStorageImage({
    super.key,
    required this.path,
    this.fit,
    this.width,
    this.height,
    this.loadingWidget,
    this.onlySaveMemory = false,
    this.timeOut = const Duration(seconds: 10),
    this.shimmer = true
  });
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? loadingWidget;
  final bool onlySaveMemory; ///웹에서는 값에 상관없이 항상 [CachedNetworkImage]를 사용
  final Duration timeOut;
  final bool shimmer;

  @override
  State<FireStorageImage> createState() => _FireStorageImageState();
}

class _FireStorageImageState extends State<FireStorageImage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          if(!kIsWeb){
            return FutureBuilder(
                future: FirebaseStorageCacheService.getImage(
                    widget.path , onlySaveMemory: widget.onlySaveMemory
                ).timeout(widget.timeOut),
                builder: (context , snapshot){
                  if(snapshot.hasData){
                    return Image(
                      image: snapshot.data!,
                      fit: widget.fit,
                      width: widget.width,
                      height: widget.height,
                    );
                  }
                  else if(snapshot.hasError){
                    if(widget.shimmer){
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.grey,
                          width: widget.width,
                          height: widget.height,
                        ),
                      );
                    }
                    else{
                      return const Text("이미지를 불러 올 수 없습니다.");
                    }
                  }
                  else{
                    if(widget.shimmer){
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.grey,
                          width: widget.width,
                          height: widget.height,
                        ),
                      );
                    }
                    else{
                      return widget.loadingWidget ??  const CupertinoActivityIndicator();
                    }
                  }
                }
            );
          }
          else{
            return FutureBuilder(
                future: FirebaseStorage.instance.ref().child(widget.path).getDownloadURL(),
                builder: (context , snapshot){
                  if(snapshot.hasData){
                    return CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      width: widget.width,
                      height: widget.height,
                    );
                  }
                  else if(snapshot.hasError){
                    if(widget.shimmer){
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.grey,
                          width: widget.width,
                          height: widget.height,
                        ),
                      );
                    }
                    else{
                      return const Text("이미지를 불러 올 수 없습니다.");
                    }
                  }
                  else{
                    if(widget.shimmer){
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.grey,
                          width: widget.width,
                          height: widget.height,
                        ),
                      );
                    }
                    else{
                      return widget.loadingWidget ??  const CupertinoActivityIndicator();
                    }
                  }
                }
            );
          }

        }
    );
  }
}
