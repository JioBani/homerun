import 'package:firebase_storage/firebase_storage.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService{

  static FirebaseStorageService? _instance;

  FirebaseStorageService._();

  static FirebaseStorageService get instance {
    _instance ??= FirebaseStorageService._();
    return _instance!;
  }

  Future<Result<XFile>> downloadAssetAsXFile(String imageUrl){
    return Result.handleFuture(
        action: () async {
          //#. 이미지 레퍼런스
          Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);

          //#. 로컬 파일 경로
          final Directory tempDir = await getTemporaryDirectory();
          final String filePath = path.join(tempDir.path, ref.name);
          final File file = File(filePath);

          //#. 이미지 다운로드
          await ref.writeToFile(file);

          //#. XFile로 변환
          XFile xFile = XFile(filePath);
          return xFile;
        }
    );
  }

  Future<Map<String, Result<XFile>>> downloadAllAssetsAsXFiles(String folderPath) async {
    ListResult listResult = await FirebaseStorage.instance.ref(folderPath).listAll();

    Map<String, Future<Result<XFile>>> futures = {};

    for (Reference ref in listResult.items) {
      String fileName = ref.name;
      Future<Result<XFile>> future = ref.getDownloadURL().then((fileUrl) => downloadAssetAsXFile(fileUrl));
      futures[fileName] = future;
    }

    Map<String, Result<XFile>> results = {};
    for (var entry in futures.entries) {
      results[entry.key] = await entry.value;
    }

    return results;
  }

  Future<Result<ListResult>> getFolderListResult(String folderPath) {
    return Result.handleFuture<ListResult>(action: FirebaseStorage.instance.ref(folderPath).listAll);
  }
}