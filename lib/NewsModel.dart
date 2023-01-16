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
