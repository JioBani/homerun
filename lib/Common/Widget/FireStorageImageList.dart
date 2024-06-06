import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';

/// **FireStorageImageList**
///
/// Firebase Storage의 특정 경로에 저장된 이미지들을 [FireStorageImage]들의 Colum으로 출력해주는 위젯.
///
/// [path] : 이 경로는 Firebase Storage에서 이미지가 위치한 폴더를 지정합니다.
class FireStorageImageColum extends StatefulWidget {
  const FireStorageImageColum({super.key, required this.path});
  final String path;

  @override
  State<FireStorageImageColum> createState() => _FireStorageImageColumState();
}

class _FireStorageImageColumState extends State<FireStorageImageColum> {
  ListResult? listResult;

  @override
  void initState() {
    _loadImagesPath();
    super.initState();
  }

  /// 지정된 Firebase Storage 경로아래의 이미지 경로들을 가져옵니다.
  Future<void> _loadImagesPath() async {
    final storageRef = FirebaseStorage.instance.ref().child(widget.path);
    listResult = await storageRef.listAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: listResult?.items.map((e) => FireStorageImage(path: e.fullPath)).toList() ?? [],
    );
  }
}
