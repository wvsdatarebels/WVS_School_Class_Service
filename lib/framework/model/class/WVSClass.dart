import 'package:meta/meta.dart';

class WvsClass {
  String wvsClassClass;
  String url;

  WvsClass({
    @required this.wvsClassClass,
    @required this.url,
  });

  factory WvsClass.create(String class_name, String url) => WvsClass(
    wvsClassClass: class_name,
    url: url,
  );

  Map<String, dynamic> toJson() => {
    'class': wvsClassClass == null ? null : wvsClassClass,
    'url': url == null ? null : url,
  };
}
