
import 'dart:io';

import 'package:lista_facil/data/services/i_database_service.dart';
import 'package:lista_facil/data/services/local_db/hive/hive_service.dart';
import 'package:lista_facil/data/services/local_db/sqlite/sqlite_service.dart';

class DatabaseFactory {
  static IDatabaseService getDatabaseService(){
    if(Platform.isAndroid || Platform.isIOS){
      return SqliteService();
    }else{
      return HiveService();
    }
  }
}