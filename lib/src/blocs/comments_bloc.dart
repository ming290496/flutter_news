import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentFetcher = PublishSubject<int>();
  final _commentOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //Streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentOutput.stream;

  //Sink
  Function(int) get fetchItemWithComment => _commentFetcher.sink.add;

  CommentsBloc() {
    _commentFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentOutput);
  }

  _commentsTransformer(){
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index){
          print(index);
          cache[id] = _repository.fetchItem(id);
          cache[id].then((ItemModel item){
            item.kids.forEach((kidId) => fetchItemWithComment(kidId));
          });
          return cache;
        },
      <int, Future<ItemModel>>{}
    );
  }

  dispose() {
    _commentFetcher.close();
    _commentOutput.close();
  }
}
