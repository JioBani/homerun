import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homerun/Service/FirebaseStorageCacheService.dart';

class FireStorageImage extends StatefulWidget {
  const FireStorageImage({
    super.key,
    required this.path,
    this.fit,
    this.width,
    this.height,
    this.loadingWidget
  });
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? loadingWidget;

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
                future: FirebaseStorageCacheService.getImage(widget.path),
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
                    return const Text("이미지를 불러 올 수 없습니다.");
                  }
                  else{
                    return widget.loadingWidget ?? const CupertinoActivityIndicator();
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
                    return const Text("이미지를 불러 올 수 없습니다.");
                  }
                  else{
                    return widget.loadingWidget ??  const CupertinoActivityIndicator();
                  }
                }
            );
          }

        }
    );
  }
}
