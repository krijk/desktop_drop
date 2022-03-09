import 'package:cross_file/cross_file.dart';

class Data {
  static List<XFile> list = <XFile>[];

  static
  void append( XFile file){
    if (_isExist(file)) {
      return;
    }
    list.add(file);
  }

  static bool _isExist(XFile file) {
    for (final XFile data in list) {
      if (data.path == file.path) {
        return true;
      }
    }
    return false;
  }
  static
  String getFilePath( int idx){
    return list[ idx].path;
  }

  static
  void clear(){
    list = <XFile>[];
  }
}