class Gif {
  String url;

  Gif.fromJson(Map<String, dynamic> json) {
    url = json['data']['image_url'];
  }
}