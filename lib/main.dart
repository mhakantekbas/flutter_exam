import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_exam/NewsDetail.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePAge(),
      routes: {
        'HomePage': (context) => const MyHomePAge(),
        '/second': (context) => CategoryNewsScreen(),
      },
    );
  }
}

class MyHomePAge extends StatelessWidget {
  const MyHomePAge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 1),
          title: Text('News Categories'),
          leading: Icon(Icons.newspaper)),
      body: const NewsCategoryScreen(),
    );
  }
}

class NewsCategoryScreen extends StatelessWidget {
  const NewsCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: DUMMY_CATEGORIES
            .map((catData) => CategoryItem(
                  category: catData,
                ))
            .toList(),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});
  final Category category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/second', arguments: category.title);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.7),
              category.color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(category.title,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}

class Category {
  final String id;
  final String title;
  final Color color;
  Category({required this.id, required this.title, this.color = Colors.orange});
}

class Book {
  final String id;
  final List<String> categories;
  final String title;

  Book({required this.id, required this.categories, required this.title});
}

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
                                              overflow: TextOverflow.ellipsis),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          news.pubDate!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis),
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

class NewsApi {
  static Future<List<NewsModel>> getDataByQuery({String q = "top"}) async {
    List<NewsModel> books = [];
    var url =
        'https://newsdata.io/api/1/news?apikey=pub_15697089ded362b62228ab60237f45d1ed997&country=gb&category=$q ';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    print('api started');

    if (books is List) {
      books = results.map((e) => NewsModel.fromMap(e)).toList();
    } else {
      return [];
    }
    return books;
  }
}

class NewsModel {
  String? title;
  String? creator;
  String? description;
  String? imageUrl;
  String? content;
  String? pubDate;
  String? category;
  NewsModel({
    this.title,
    this.creator,
    this.description,
    this.imageUrl,
    this.content,
    this.pubDate,
    this.category,
  });
  factory NewsModel.fromMap(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] != null ? json['title']! : 'Loading...',
      creator: json['creator'] != null ? json['creator'][0]! : 'anonymous',
      description:
          json['description'] != null ? json['description']! : 'No Data...',
      imageUrl: json['image_url'] != null
          ? json['image_url']!
          : 'https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png',
      content: json['content'] != null ? json['content']! : 'No Data...',
      pubDate: json['pubDate'] != null ? json['pubDate']! : 'No Data...',
      category: json['category'] != null ? json['category'][0]! : 'No Data...',
    );
  }
}

var DUMMY_CATEGORIES = [
  Category(
    id: 'c1',
    title: 'Top',
    color: Colors.purple,
  ),
  Category(
    id: 'c2',
    title: 'Health',
    color: Colors.red,
  ),
  Category(
    id: 'c3',
    title: 'Politics',
    color: Colors.orange,
  ),
  Category(
    id: 'c4',
    title: 'Science',
    color: Colors.amber,
  ),
  Category(
    id: 'c5',
    title: 'Sports',
    color: Colors.blue,
  ),
  Category(
    id: 'c6',
    title: 'Technology',
    color: Colors.green,
  ),
  Category(
    id: 'c7',
    title: 'Top',
    color: Colors.lightBlue,
  ),
  Category(
    id: 'c8',
    title: 'World',
    color: Colors.lightGreen,
  ),
];
