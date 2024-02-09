import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DataStoreService{

  static Logger logger = Logger();


  static Future<String> _getFilePath(String filePath)async{
    final directory = await getApplicationDocumentsDirectory();
    // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
    return '${directory.path}/$filePath';
  }

  // 파일 경로를 생성하는 함수
  static Future<File> _getFile(String fileName) async {
    // 앱의 디렉토리 경로를 가져옴
    final directory = await getApplicationDocumentsDirectory();
    // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
    return File('${directory.path}/$fileName');
  }

  static Future<bool> _isPathExist(String filePath)async{
    final path = await _getFilePath(filePath);
    // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
    return await Directory(path).exists();
  }

  static Future<(Object? , StackTrace?)> save(String path , String content) async{
    try{
      final file = await _getFile(path);
      await file.writeAsString(content);
      logger.i("[DataStoreService._save()] 저장 완료");
      return (null , null);
    }catch(e , s){
      logger.e("[DataStoreService._save()] $e");
      logger.e("[DataStoreService._save()] $s");
      return (e , s);
    }
  }

  static Future<(String? content , Object? , StackTrace?)> read(String path) async{
    try{
      final file = await _getFile(path);
      final contents = await file.readAsString();
      logger.i("[DataStoreService.read()] 읽기 완료");
      return (contents , null , null);
    }catch(e , s){
      logger.e("[DataStoreService.read()] $e");
      logger.e("[DataStoreService.read()] $s");
      return (null ,e , s);
    }
  }

  static Future<void> _makeDirectory(String path) async{
    try{
      await Directory(await _getFilePath(path)).create(recursive: true);
    }catch(e){
      logger.e("[DataStoreService._makeDirectory()] 디렉토리 생성 실패 : $e");
      rethrow;
    }
  }

  static Future<bool> _ensureDirectory(String path) async{
    try{

      bool isExist = await _isPathExist(path);

      if(!isExist){
        logger.i("[DataStoreService._ensureDirectory()] 존재하지않음 : $path");
        await _makeDirectory(path);
        logger.i("[DataStoreService._ensureDirectory()] 디렉토리생성 : $path");
      }

      return true;
    }catch(e){
      logger.e("[DataStoreService.ensureMatchDtoDirectory()] $e");
      return false;
    }

  }


  static Future<bool> removeAllData() async{
    try{
      String matchPath = await _getFilePath("");
      final dir = Directory(matchPath);
      dir.deleteSync(recursive: true);
      logger.i("[DataStoreService.removeAllData()] 데이터 전부 삭제 완료");
      return true;

    }catch(e){
      logger.e("[DataStoreService.removeAllData()] $e");
      return false;
    }
  }

  static Future<(Object? , StackTrace?)> removeFile(String path) async{
    try{
      final file = await _getFile(path);
      await file.delete();
      logger.i("[DataStoreService.removeFile()] 파일 삭제 완료");
      return (null , null);
    }catch(e , s){
      logger.e("[DataStoreService.removeFile()] $e");
      logger.e("[DataStoreService.removeFile()] $s");
      return (e , s);
    }
  }


}