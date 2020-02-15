import 'package:meta/meta.dart';

class ResponseModel {
  bool success;
  int responseTime = DateTime.now().millisecondsSinceEpoch;
  Object data;

  ResponseModel({
    @required this.success,
    @required this.responseTime,
    @required this.data,
  });

  factory ResponseModel.create(bool success, Object data) => ResponseModel(
    success: success,
    responseTime: DateTime.now().millisecondsSinceEpoch,
    data: data,
  );

  Map<String, dynamic> toJson() => {
    'success': success == null ? null : success,
    'responseTime': responseTime,
    'data': data == null ? null : data,
  };
}
