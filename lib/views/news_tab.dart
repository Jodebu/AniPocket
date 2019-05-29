import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';
import 'package:jikan_dart/jikan_dart.dart';

class NewsTab extends StatelessWidget {
  NewsTab({Key key, @required this.title, @required this.news})
      : super(key: key);

  final String title;
  final List<Article> news;

  void _openLink(String url) {

  }

  Widget _getPicture(Article article) {
    return article.imageUrl == null
      ? Container(width: 0, height: 0)
      : SizedBox(
        width: double.infinity,
        height: 200,
        child: CachedNetworkImage(
          imageUrl: article.imageUrl,
          placeholder: Center(child: CircularProgressIndicator()),
          errorWidget: Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ); 
  }

  Widget _getNewsList() {
    return news.isEmpty
      ? Center(child: Text(UI_NO_NEWS, textAlign: TextAlign.center,),)
      : ListView.builder(
        itemCount: news == null ? 0 : news.length,
        itemBuilder: (context, i) => InkWell(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                news[i] == null
                  ? Center(child: CircularProgressIndicator())
                  : _getPicture(news[i]),
                ListTile(
                  title: Text(news[i].title),
                  subtitle: Text(news[i].intro),
                ),
              ],
            ),
          ),
          onTap: () => _openLink(news[i].url),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return news == null
        ? Center(child: CircularProgressIndicator())
        : _getNewsList();
  }
}