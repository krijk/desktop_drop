import 'package:cross_file/cross_file.dart';

class Data {
  static final List<XFile> list = <XFile>[];

  static
  void append( XFile path){
    list.add(path);
  }

  static
  String getFilePath( int idx){
    return list[ idx].path;
  }

}