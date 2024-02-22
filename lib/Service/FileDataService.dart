import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileDataService{

  static final Logger _logger = Logger();


  static Future<String> _getFilePath(String filePath)async{
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
      return '${directory.path}/$filePath';
    }
    else{
      return filePath;
    }
  }

  // 파일 경로를 생성하는 함수
  static Future<File> _getFile(String fileName) async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
      return File('${directory.path}/$fileName');
    }
    else{
      return File(fileName);
    }
  }

  static Future<bool> _isPathExist(String filePath)async{
    final path = await _getFilePath(filePath);
    // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
    return await Directory(path).exists();
  }

  static Future<(Object? , StackTrace?)> saveAsString(String path , String content) async{
    try{

      final targetFile = await _getFile(path);

      bool exist = await targetFile.exists();

      if(!exist){
        await targetFile.create(recursive: true);
      }

      await targetFile.writeAsString(content);
      _logger.i("[DataStoreService.saveAsString()] 저장 완료");
      return (null , null);
    }catch(e , s){
      _logger.e("[DataStoreService.saveAsString()] $e");
      _logger.e("[DataStoreService.saveAsString()] $s");
      return (e , s);
    }
  }

  static Future<(String? content , Object? , StackTrace?)> readAsString(String path) async{
    try{
      final file = await _getFile(path);
      final contents = await file.readAsString();
      _logger.i("[DataStoreService.readAsString()] 읽기 완료");
      return (contents , null , null);
    }catch(e , s){
      _logger.e("[DataStoreService.readAsString()] $e");
      _logger.e("[DataStoreService.readAsString()] $s");
      return (null ,e , s);
    }
  }

  static Future<(Object? , StackTrace?)> saveAsFile(String path , Uint8List content) async{
    try{
      final targetFile = await _getFile(path);
      bool exist = await targetFile.exists();
      if(!exist){
        await targetFile.create(recursive: true);
      }
      await targetFile.writeAsBytes(content);
      _logger.i("[DataStoreService.saveAsFile()] 저장 완료");
      return (null , null);
    }catch(e , s){
      _logger.e("[DataStoreService.saveAsFile()] $e");
      _logger.e("[DataStoreService.saveAsFile()] $s");
      return (e , s);
    }
  }

  static Future<(File? content , Object? , StackTrace?)> readAsFile(String path) async{
    try{
      final file = await _getFile(path);
      _logger.i("[DataStoreService.readAsFile()] 읽기 완료");
      return (file , null , null);
    }catch(e , s){
      _logger.e("[DataStoreService.readAsFile()] $e");
      _logger.e("[DataStoreService.readAsFile()] $s");
      return (null ,e , s);
    }
  }

  static Future<void> _makeDirectory(String path) async{
    try{
      String filePath = await _getFilePath(path);
      await Directory(filePath).create(recursive: true);
      _logger.i("[DataStoreService._makeDirectory()] 디렉토리 생성 성공 : $filePath");
    }catch(e){
      _logger.e("[DataStoreService._makeDirectory()] 디렉토리 생성 실패 : $e");
      rethrow;
    }
  }

  static Future<bool> _ensureDirectory(String path) async{
    try{

      bool isExist = await _isPathExist(path);

      if(!isExist){
        _logger.i("[DataStoreService._ensureDirectory()] 존재하지않음 : $path");
        await _makeDirectory(path);
        _logger.i("[DataStoreService._ensureDirectory()] 디렉토리생성 : $path");
      }

      return true;
    }catch(e){
      _logger.e("[DataStoreService.ensureMatchDtoDirectory()] $e");
      return false;
    }

  }


  static Future<bool> removeAllData() async{
    try{
      String matchPath = await _getFilePath("");
      final dir = Directory(matchPath);
      dir.deleteSync(recursive: true);
      _logger.i("[DataStoreService.removeAllData()] 데이터 전부 삭제 완료");
      return true;

    }catch(e){
      _logger.e("[DataStoreService.removeAllData()] $e");
      return false;
    }
  }

  static Future<bool> removeRecursive(String path) async{
    try{
      String appPath = await _getFilePath(path);
      final dir = Directory(appPath);
      dir.deleteSync(recursive: true);
      _logger.i("[DataStoreService.removeRecursive()] 데이터 전부 삭제 완료");
      return true;

    }catch(e){
      _logger.e("[DataStoreService.removeRecursive()] $e");
      return false;
    }
  }

  static Future<(Object? , StackTrace?)> removeFile(String path) async{
    try{
      final file = await _getFile(path);
      await file.delete();
      _logger.i("[DataStoreService.removeFile()] 파일 삭제 완료");
      return (null , null);
    }catch(e , s){
      _logger.e("[DataStoreService.removeFile()] $e");
      _logger.e("[DataStoreService.removeFile()] $s");
      return (e , s);
    }
  }


}