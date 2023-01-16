// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_exam/NewsApi.dart';
import 'package:flutter_exam/NewsModel.dart';

class CategoryNewsScreen extends StatefulWidget {
  static const routeName = '/second';
  @override
  _CategoryNewsScreen createState() => _CategoryNewsScreen();
}

class _CategoryNewsScreen extends State<CategoryNewsScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as String;
    final String categoryTitle = routeArgs;
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: Color.fromARGB(255, 18, 18, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: FutureBuilder(
                future: NewsApi.getDataByQuery(q: categoryTitle),
                builder: (context, AsyncSnapshot<List<NewsModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final news = snapshot.data![index];
                        return Card(
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(news.imageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Image.network(news.imageUrl!)),
                            Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 18, 18, 1),
                                ),
                                child: Column(
                                  children: [
                                    Text(news.title!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          news.creator!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          news.pubDate!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                child: Text(news.description!)),
                            Container(
                                margin: EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                child: Text(news.content!)),
                          ]),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
