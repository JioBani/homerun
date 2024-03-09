import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';


class FirestorePagination {
  final CollectionReference collectionReference;
  final Duration _pagingInterval;
  final String _pagingField;
  final DateTime _start;
  late final bool _descending;
  final Query? _query;

  final List<PagingUnit> _pagingUnits = [];

  FirestorePagination({
    required DateTime start,
    required this.collectionReference,
    required String pagingField,
    required Duration pagingInterval,
    Query? query,
    bool descending = false,
  })  : _descending = descending,
        _start = start,
        _pagingField = pagingField,
        _pagingInterval = descending ? -pagingInterval : pagingInterval,
        _query = query;

  Future<List<DocumentSnapshot>?> get(int n) async {
    List<DocumentSnapshot> result = [];

    if(_pagingUnits.isEmpty){
      _pagingUnits.add(_getNextUnit(null));
    }

    PagingUnit? cursor = _pagingUnits[0];

    //#. 현재 가지고 있는 페이지에 대해서
    while(cursor != null){
      if(cursor.isStreamActive){
        if(cursor.lastSnapshot == null){
          throw Exception('lastSnapshot is null');
        }
        else{
          result.addAll(cursor.lastSnapshot!.docs);
        }
      }
      else{
        QuerySnapshot snapshot = await cursor.attachListenerAndWait();
        result.addAll(snapshot.docs);
      }

      if (result.length >= n) return result.sublist(0, n);

      cursor = cursor.next;
    }

    //#. 페이지 추가 및 데이터 가져오기
    PagingUnit before = _pagingUnits.last;

    while (result.length < n) {
      PagingUnit newUnit = _getNextUnit(before);
      QuerySnapshot snapshot = await newUnit.attachListenerAndWait();

      if(snapshot.size != 0) {
        result.addAll(snapshot.docs);
        _pagingUnits.add(newUnit);
        before.setNext(newUnit);
      }
      else{
        PagingUnit? skipUnit = await _getSkipUnit(_pagingUnits.lastOrNull);
        if(skipUnit == null){
          return result;
        }
        else{
          QuerySnapshot skipSnapshot = await skipUnit.attachListenerAndWait();
          result.addAll(skipSnapshot.docs);
          _pagingUnits.add(skipUnit);
          before.setNext(skipUnit);
        }
      }

      if (result.length >= n) return result.sublist(0, n);

      before = _pagingUnits.last;
    }
    return null;
  }


  Future<List<DocumentSnapshot>> getAfter(int n , DocumentSnapshot startAfter) async {

    //#. 1 시작점 찾기
    QuerySnapshot startSnapshot;

    if(_query == null){
      startSnapshot = await collectionReference
          .orderBy(_pagingField , descending: _descending)
          .startAfterDocument(startAfter)
          .limit(1)
          .get();
    }
    else{
      startSnapshot = await _query!
          .orderBy(_pagingField , descending: _descending)
          .startAfterDocument(startAfter)
          .limit(1)
          .get();
    }

    DocumentSnapshot start;

    if(startSnapshot.size == 0){
      return [];
    }
    else{
      start = startSnapshot.docs[0];
    }


    //#.2 시작점을 포함하는 Unit까지 로드
    DateTime time = (start.get(_pagingField) as Timestamp).toDate();
    PagingUnit? startUnit;

    try{
      startUnit = _pagingUnits.firstWhere((element){
        StaticLogger.logger.i("[로드한 유닛들 순회] $time : ${element.startAfter.toDate()} ~ ${element.end.toDate()} : ${element.isInRange(time)}");
        return element.isInRange(time);
      });
    }catch(e){
      startUnit = null;
    }

    if(startUnit == null){
      PagingUnit? before = _pagingUnits.lastOrNull;
      while(true){
        PagingUnit newPage = _getNextUnit(_pagingUnits.lastOrNull);
        _pagingUnits.add(newPage);

        if(before != null){
          before.setNext(newPage);
        }

        StaticLogger.logger.i("$time : ${newPage.startAfter.toDate()} ~ ${newPage.end.toDate()}");

        if(newPage.isInRange(time)){
          startUnit = newPage;
          break;
        }
        else if(newPage.isOver(time)){
          throw Exception('is over');
        }
        else{
          before = newPage;
        }
      }
    }


    //#.3 가져오기

    List<DocumentSnapshot> result = [];

    PagingUnit? curser = startUnit;

    if(!startUnit.isStreamActive){
      QuerySnapshot snapshot = await startUnit.attachListenerAndWait();
      result.addAll(snapshot.docs);
    }
    else{
      result.addAll(startUnit.lastSnapshot!.docs);
    }

    StaticLogger.logger.i(result.map((e) => (e.get(_pagingField) as Timestamp).toDate()));

    int startIndex = -1;

    for (int i = 0; i < result.length; i++) {
      if(result[i].id == start.id){
        startIndex = i;
        break;
      }
    }


    if(startIndex == -1){
      throw Exception('시작점이 포함되어 있지 않음');
    }
    else{
      result = result.sublist(startIndex);
    }

    curser = curser.next;

    //#. 현재 가지고 있는 페이지에 대해서
    while(curser != null){
      if(curser.isStreamActive){
        if(curser.lastSnapshot == null){
          throw Exception('lastSnapshot is null');
        }
        else{
          result.addAll(curser.lastSnapshot!.docs);
        }
      }
      else{
        QuerySnapshot snapshot = await curser.attachListenerAndWait();
        result.addAll(snapshot.docs);
      }

      if (result.length >= n) return result.sublist(0, n);

      curser = curser.next;
    }

    //#. 페이지 추가 및 데이터 가져오기
    PagingUnit before = _pagingUnits.last;

    while (true) {
      PagingUnit newUnit = _getNextUnit(before);
      QuerySnapshot snapshot = await newUnit.attachListenerAndWait();

      if(snapshot.size != 0) {
        result.addAll(snapshot.docs);
        _pagingUnits.add(newUnit);
        before.setNext(newUnit);
      }
      else{
        PagingUnit? skipUnit = await _getSkipUnit(_pagingUnits.lastOrNull);
        if(skipUnit == null){
          return result;
        }
        else{
          QuerySnapshot skipSnapshot = await skipUnit.attachListenerAndWait();
          result.addAll(skipSnapshot.docs);
          _pagingUnits.add(skipUnit);
          before.setNext(skipUnit);
        }
      }

      if (result.length >= n) return result.sublist(0, n);

      before = _pagingUnits.last;
    }
  }

  PagingUnit _getNextUnit(PagingUnit? last) {
    DateTime newStart;

    if (last == null) {
      newStart = _start;
    } else {
      newStart = last.end.toDate();
    }

    return PagingUnit(
      collectionReference: collectionReference,
      query: _query,
      pagingInterval: _pagingInterval,
      startAfter: newStart,
      end: newStart.add(_pagingInterval),
      pagingField: _pagingField,
      descending: _descending,
    );
  }

  Future<PagingUnit?> _getSkipUnit(PagingUnit? last) async {
    DateTime newStart;

    if (last == null) {
      newStart = _start;
    } else {
      newStart = last.end.toDate();
    }

    DocumentSnapshot? nextDoc = await _getNextDocument(newStart);

    if (nextDoc == null) {
      return null;
    } else {
      DateTime endTime = (nextDoc.get(_pagingField) as Timestamp).toDate().add(_pagingInterval);

      PagingUnit skipUnit = PagingUnit(
        collectionReference: collectionReference,
        query: _query,
        pagingInterval: _pagingInterval,
        startAfter: newStart,
        end: endTime,
        pagingField: _pagingField,
        descending: _descending,
      );

      return skipUnit;
    }
  }

  Future<DocumentSnapshot?> _getNextDocument(DateTime? start) async {
    try {
      QuerySnapshot querySnapshot;
      if (start == null) {
        if(_query == null){
          querySnapshot = await collectionReference.orderBy(_pagingField , descending: _descending).limit(1).get();
        }
        else{
          querySnapshot = await _query!.orderBy(_pagingField , descending: _descending).limit(1).get();
        }
      } else {
        if(_query == null){
          querySnapshot = await collectionReference
              .orderBy(_pagingField , descending: _descending)
              .startAfter([Timestamp.fromDate(start)])
              .limit(1)
              .get();
        }
        else{
          querySnapshot = await _query
          !.orderBy(_pagingField , descending: _descending)
              .startAfter([Timestamp.fromDate(start)])
              .limit(1)
              .get();
        }
      }

      if (querySnapshot.size != 0) {
        return querySnapshot.docs[0];
      } else {
        return null;
      }
    } catch (e) {
      StaticLogger.logger.e('Failed to get next document: $e');
      return null;
    }
  }

  String checkUnits() {
    String msg = "유닛 테스트";
    msg += "\n총 유닛 : ${_pagingUnits.length}\n";

    for (int i = 0; i < _pagingUnits.length; i++) {
      msg += "[${_pagingUnits[i].isStreamActive ? 'O' : 'X' }] ";
      msg += "${_pagingUnits[i].startAfter.toDate()} ~ ${_pagingUnits[i].end.toDate()} : ${_pagingUnits[i].lastSnapshot?.size}\n";
    }

    return msg;
  }

  String checkLinks() {
    String msg = "링크 테스트";
    msg += "\n총 유닛 : ${_pagingUnits.length}\n";

    for (int i = 0; i < _pagingUnits.length; i++) {
      msg += "${_pagingUnits[i].startAfter.toDate()} ~ ${_pagingUnits[i].end.toDate()} : ${_pagingUnits[i].lastSnapshot?.size}";
      msg += " -> ${_pagingUnits[i].next?.startAfter.toDate()} ~ ${_pagingUnits[i].next?.end.toDate()} : ${_pagingUnits[i].next?.lastSnapshot?.size}\n";
    }

    return msg;
  }
}

class PagingUnit {
  final CollectionReference _collectionReference;
  late final Stream<QuerySnapshot> _snapshotStream;
  QuerySnapshot? lastSnapshot;

  late final Timestamp _startAfter;
  Timestamp get  startAfter => _startAfter;

  late final Timestamp _end;
  Timestamp get end => _end;

  final String _pagingField;
  final bool _descending;
  late final Query _pagingQuery;

  bool _isStreamActive = false;
  bool get isStreamActive => _isStreamActive;

  PagingUnit? _next;
  PagingUnit? get next => _next;

  PagingUnit({
    required CollectionReference<Object?> collectionReference,
    required Duration pagingInterval,
    required DateTime startAfter,
    required DateTime end,
    required String pagingField,
    required bool descending,
    Query? query,
  }) :
        _descending = descending,
        _pagingField = pagingField,
        _collectionReference = collectionReference
  {
    _startAfter = Timestamp.fromDate(startAfter);
    _end = Timestamp.fromDate(end);


    if(query == null) {
      _pagingQuery = _descending ?
      collectionReference
          .orderBy(_pagingField, descending: true)
          .where(_pagingField, isLessThan: _startAfter)
          .where(_pagingField, isGreaterThanOrEqualTo: _end) :
      collectionReference
          .orderBy(_pagingField, descending: false)
          .where(_pagingField, isGreaterThan: _startAfter)
          .where(_pagingField, isLessThanOrEqualTo: _end);
    } else {
      _pagingQuery = _descending ?
      query
          .orderBy(_pagingField, descending: true)
          .where(_pagingField, isLessThan: _startAfter)
          .where(_pagingField, isGreaterThanOrEqualTo: _end) :
      query
          .orderBy(_pagingField, descending: false)
          .where(_pagingField, isGreaterThan: _startAfter)
          .where(_pagingField, isLessThanOrEqualTo: _end);
    }

    _snapshotStream = _pagingQuery.snapshots();
  }

  Future<QuerySnapshot> attachListenerAndWait() async {
    try {
      _pagingQuery.snapshots();

      _snapshotStream.listen((event) {
        lastSnapshot = event;
      });

      _isStreamActive = true;

      return _snapshotStream.first;
    } catch (e) {
      StaticLogger.logger.e('Failed to attach listener: $e');
      throw Exception('Failed to attach listener');
    }
  }

  String print(String field) {
    return lastSnapshot?.docs.map((e) => "${e.get(field)}").toString() ?? '스냅샷 없음';
  }

  String printNext(){
    return "${startAfter.toDate()} ~ ${end.toDate()} -> ${next?.startAfter.toDate()} ~ ${next?.end.toDate()}";
  }

  bool? isNextIsContinuous(){
    if(_next == null) {
      return null;
    } else{
      return _end == _next!.startAfter;
    }
  }

  bool isInRange(DateTime time){
    if(!_descending){
      return (startAfter.toDate().microsecondsSinceEpoch < time.microsecondsSinceEpoch
          &&
          time.microsecondsSinceEpoch <= end.toDate().microsecondsSinceEpoch
      );
    }
    else{
      return (end.toDate().microsecondsSinceEpoch <= time.microsecondsSinceEpoch
          &&
          time.microsecondsSinceEpoch < startAfter.toDate().microsecondsSinceEpoch
      );
    }
  }

  bool isOver(DateTime time){
    if(!_descending){
      return end.toDate().microsecondsSinceEpoch > time.microsecondsSinceEpoch;
    }
    else{
      return end.toDate().microsecondsSinceEpoch < time.microsecondsSinceEpoch;
    }
  }

  void setNext(PagingUnit unit){
    _next = unit;
    StaticLogger.logger.i(printNext());
  }
}