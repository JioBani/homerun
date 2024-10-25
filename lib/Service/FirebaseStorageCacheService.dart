import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'FileDataService.dart';
import 'package:http/http.dart' as http;

class FirebaseStorageCacheService{
  static final storageRef = FirebaseStorage.instance.ref();

  static final Map<String, Uint8List> _assetCache = {};
  static final Map<String, DateTime> _assetCacheData = {};

  static int _maxAssetCacheSize = 100 * 1024 * 1024; // 최대 100MB
  static int _currentAssetCacheSize = 0;
  static Duration _cacheLifeTime = const Duration(days: 30);
  static int _requestCount = 0;
  static int get requestCount => _requestCount;

  static void setOption({
    int maxAssetCacheSize = 100 * 1024 * 1024 ,
    Duration? cacheLifeTime
  }){
    _maxAssetCacheSize = maxAssetCacheSize;
    if(cacheLifeTime != null){
      _cacheLifeTime = cacheLifeTime;
    }
  }

  static Future<Uint8List?> _downloadAsset(Reference spaceRef) async {
    _requestCount++;
    try{
      if(kIsWeb){
        String url = await spaceRef.getDownloadURL();
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          return response.bodyBytes;
        } else {
          StaticLogger.logger.e('[FirebaseStorageCacheService._downloadAsset()] Failed to download asset. HTTP status code: ${response.statusCode}');
          return null;
        }
      }
      else{
        return await spaceRef.getData();
      }
    }catch(e , s){
      StaticLogger.logger.e("[FirebaseStorageCacheService._downloadAsset()] $e\n$s");
      return null;
    }

  }

  //TODO get모드
  static Future<Uint8List?> getAsset(String path, {bool onlySaveMemory = false}) async {
    String cachePath = "firebase_storage/$path";

    if (_assetCache.containsKey(cachePath)) {
      StaticLogger.logger.i("[FirebaseStorageCacheService.getAsset()] $path is in memory cache");
      return _assetCache[cachePath];
    }

    //#.1 레퍼런스 연결
    final spaceRef = storageRef.child(path);

    try{
      //#.2 메타데이터 가져오기
      FullMetadata metadata = await spaceRef.getMetadata();

      //#.3 캐쉬 확인
      CacheState cacheState = await _checkCache(cachePath , metadata.updated!);

      //#.4-1 캐쉬가 최신이면
      if(cacheState == CacheState.recent){
        final file = await _readLocalCache(cachePath);
        if(file == null) {
          return null;
        } else{
          final fileBytes = await file.readAsBytes();
          _addAssetMemoryCache(cachePath , fileBytes);
          return fileBytes;
        }
      }

      //#.4-2 캐쉬가 없거나 오래되었으면
      else if(cacheState == CacheState.old || cacheState == CacheState.error){

        final fileData = await _downloadAsset(spaceRef);

        if(fileData == null){
          return null;
        }

        //#. onlySaveMemory
        if(!onlySaveMemory){
          bool success = await _saveCache(cachePath , fileData);
          if(success){
            //StaticLogger.logger.i("[FirebaseStorageCacheService.getAsset()] 캐쉬 저장 성공 : $cachePath");
          }
          else{
            StaticLogger.logger.e("[FirebaseStorageCacheService.getAsset()] 캐쉬 저장 실패 : $cachePath");
          }
        }

        _addAssetMemoryCache(cachePath , fileData);
        return fileData;
      }

    } on FirebaseException catch(e){
      try{
        StaticLogger.logger.e("[FirebaseStorageCacheService.getAsset()] 메타데이터가 없음 : $cachePath");

        final fileData = await _downloadAsset(spaceRef);
        if(fileData == null){
          StaticLogger.logger.e("[FirebaseStorageCacheService.getAsset()] storage 파일에 접근 할 수 없음 없음 : $cachePath");
          return null;
        }
        bool success = await _saveCache(cachePath , fileData);

        if(!success){
          StaticLogger.logger.e("[FirebaseStorageCacheService.getAsset()] 캐쉬 저장 실패 : $cachePath");
        }

        _addAssetMemoryCache(cachePath , fileData);

        return fileData;
      }catch(e , s){
        StaticLogger.logger.i("[FirebaseStorageCacheService.getAsset()] ${e.runtimeType}");
        StaticLogger.logger.i("[FirebaseStorageCacheService.getAsset()] $cachePath\n$e\n$s");
      }
    } catch(e , s){
      StaticLogger.logger.i("[FirebaseStorageCacheService.getAsset()] ${e.runtimeType}");
      StaticLogger.logger.i("[FirebaseStorageCacheService.getAsset()] $cachePath\n$e\n$s");
      return null;
    }
    return null;
  }

  static Future<ImageProvider?> getImage(String path, {bool onlySaveMemory = false}) async {
    StaticLogger.logger.i("[FirebaseStorageCacheService.getImage()] $path");
    Uint8List? memoryData = await getAsset(path , onlySaveMemory: onlySaveMemory);
    if(memoryData != null){
      return Image.memory(memoryData).image;
    }
    else{
      return null;
    }
  } 

  //#. 로컬 캐쉬 이미지 가져오기
  static Future<File?> _readLocalCache(String path)async{
    String cachePath = "firebase_storage/$path";

    final (file , e , s) = await FileDataService.readAsFile(cachePath);

    if(e != null){
      StaticLogger.logger.e("[FirebaseStorageCacheService._readLocalImage()] $e\n$s");
      return null;
    }
    else if(file != null){
      return file;
    }
    else{
      StaticLogger.logger.e("[FirebaseStorageCacheService._readLocalImage()] file 이 null 임");
      return null;
    }
  }

  //#. 캐쉬 저장하기
  static Future<bool> _saveCache(String path , Uint8List fileData)async{
    String cachePath = "firebase_storage/$path";

    final (dataSaveE , dataSaveS)  = await FileDataService.saveAsFile(cachePath, fileData);

    if(dataSaveE != null){
      StaticLogger.logger.e("[FirebaseStorageCacheService.saveTempFile()] $dataSaveE\n$dataSaveS");
      return false;
    }

    final (metaSaveE , metaSaveS)  = await FileDataService.saveAsString("$cachePath.dat", DateTime.now().millisecondsSinceEpoch.toString());

    if(metaSaveE != null){
      StaticLogger.logger.e("[FirebaseStorageCacheService.saveTempFile()] $metaSaveE\n$metaSaveS");
      return false;
    }

    return true;
  }

  //#. 캐쉬 메타데이터 확인하기
  static Future<CacheState> _checkCache(String path , DateTime updateDate) async {
    String cachePath = "firebase_storage/$path";

    final (content , metaSaveE , metaSaveS)  = await FileDataService.readAsString("$cachePath.dat");
    if(metaSaveE != null){
      if(metaSaveE is PathNotFoundException){
        StaticLogger.logger.i("[FirebaseStorageCacheService._checkAssetCache()] $path is not in local cache");
      }
      else{
        StaticLogger.logger.e("[FirebaseStorageCacheService._checkAssetCache()] $metaSaveE\n$metaSaveS");
      }
      return CacheState.error;
    }
    else{
      try{
        int cacheSaveTime = int.parse(content!);
        if(cacheSaveTime < updateDate.millisecondsSinceEpoch){
          return CacheState.old;
        }
        else if((DateTime.now().millisecondsSinceEpoch - cacheSaveTime) > _cacheLifeTime.inMilliseconds){
          return CacheState.old;
        }
        else{
          return CacheState.recent;
        }
      }catch(e){
        StaticLogger.logger.i("[FirebaseStorageCacheService._checkAssetCache()] $content");
        return CacheState.error;
      }
    }
  }

  //#. 메모리 캐쉬 추가 또는 업데이트 하기
  static void _addAssetMemoryCache(String key, Uint8List cache){
    final int imageSize = cache.lengthInBytes;

    //#. 캐시가 새로 들어오는 경우에 용량 추가
    if(!_assetCache.containsKey(key)){
      _currentAssetCacheSize += imageSize;
    }

    _assetCache[key] = cache;
    _assetCacheData[key] = DateTime.now(); //#. 메모리 캐쉬 추가 시간 추적

    //#. 크기를 넘었으면 삭제
    while (_currentAssetCacheSize > _maxAssetCacheSize) {
      final String oldestKey = _assetCache.keys.first;
      final Uint8List? oldestImage = _assetCache.remove(oldestKey);
      _assetCacheData.remove(oldestKey);

      StaticLogger.logger.i("[FirebaseStorageCacheService._addAssetMemoryCache()] remove $oldestKey, now $_currentAssetCacheSize/$_maxAssetCacheSize");
      _currentAssetCacheSize -= oldestImage?.lengthInBytes ?? 0;
    }
  }

  /// 특정 메모리 캐시를 업데이트 하는 함수
  /// 만약 캐시에 있는 데이터가 최신이 아니라면 업데이트 합니다.
  /// 참고 : 이 함수가 실행되더라도 local에 저장되는 캐시는 업데이트 되지 않습니다.
  static Future<void> updateMemoryCache(String path) async {
    String cachePath = "firebase_storage/$path";
    final spaceRef = storageRef.child(path);

    Result<bool?> isUpToDate = await _isMemoryCacheUpToDate(cachePath , spaceRef);
    
    if(!isUpToDate.isSuccess){ //#. 메타데이터 가져오기에 실패한 경우
      StaticLogger.logger.e("[FirebaseStorageCacheService.checkMemoryCacheIsResent()] ${isUpToDate.exception}\n${isUpToDate.stackTrace}");
      return;
    }
    else if(isUpToDate.content == null){ //#. 캐쉬 자체가 없는 경우
      StaticLogger.logger.e("[FirebaseStorageCacheService.checkMemoryCacheIsResent()] $path is not exist");
      return;
    }
    else if(isUpToDate.content!){ //#. 최신인 경우
      return;
    }

    final fileData = await _downloadAsset(spaceRef);

    if(fileData == null){
      StaticLogger.logger.e("[FirebaseStorageCacheService.checkMemoryCacheIsResent()] $path download asset is not exist");
      return;
    }

    StaticLogger.logger.i("[FirebaseStorageCacheService.checkMemoryCacheIsResent()] 메모리 캐시 업데이트 : $path");

     _addAssetMemoryCache(cachePath , fileData);
  }

  /// 메모리 캐시가 최신인지 확인하는 함수
  /// [returns] 캐시가 존재하지 않는다면 Result.content = null을 반환합니다.
  static Future<Result<bool?>> _isMemoryCacheUpToDate(String cachePath, Reference spaceRef) async {
    return Result.handleFuture(action: ()async{

      if(!_assetCache.containsKey(cachePath) || !_assetCacheData.containsKey(cachePath)){
        return null;
      }

      //#.2 메타데이터 가져오기
      FullMetadata metadata = await spaceRef.getMetadata();

      return metadata.updated!.isBefore(_assetCacheData[cachePath]!);
    });
  }

  static void _removeAllCache(){
    FileDataService.removeRecursive("firebase_storage");
  }
}

enum CacheState{
  none,
  recent,
  old,
  error
}