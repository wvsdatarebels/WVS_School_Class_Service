import 'dart:mirrors';

class EnumFromString<T> {
  T get(String value) {
    var enumParse;
    try {
      enumParse = (reflectType(T) as ClassMirror).getField(#values)
          .reflectee
          .firstWhere((e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
    } catch (e) {
      enumParse = null;
    }

    return enumParse;
  }
}
