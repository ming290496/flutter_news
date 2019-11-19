import 'package:rxdart/rxdart.dart';
import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemFetcher = PublishSubject<int>();

//  Observable<Map<int, Future<ItemModel>>> items;

  //Getters to Streams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Getters to Sinks
  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc() {
    _itemFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
//    items = _items.stream.transform(_itemsTransformer());
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, index) {
      print('index $index');
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemFetcher.close();
  }
}

//PublishSubject = StreamController
//Observable = Stream
