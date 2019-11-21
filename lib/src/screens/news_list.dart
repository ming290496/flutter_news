import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_news/src/blocs/stories_provider.dart';
import 'package:flutter_news/src/widgets/news_list_tile.dart';
import 'package:flutter_news/src/widgets/refresh.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    //THIS IS BAD
//    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(
                itemId: snapshot.data[index],
              );
            },
          ),
        );
      },
    );
  }
//  Widget buildList() {
//    return ListView.builder(
//      itemCount: 1000,
//      itemBuilder: (context, int index) {
//        return FutureBuilder(
//          future: getFuture(),
//          builder: (context, snapshot) {
//            return Container(
//              height: 80.0,
//              child: snapshot.hasData
//                  ? Text('Im visible $index')
//                  : Text('I havent fetched data yet  $index'),
//            );
//          },
//        );
//      },
//    );
//  }
//
//  getFuture() {
//    return Future.delayed(
//      Duration(seconds: 2),
//      () => 'hi',
//    );
//  }
}
