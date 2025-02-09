
import 'package:flutter/foundation.dart';
import 'package:lista_facil/data/services/i_database_service.dart';
import 'package:lista_facil/data/services/local_db/shared/shared_service.dart';
import 'package:lista_facil/data/services/local_db/sqlite/sqlite_service.dart';

class AppDatabaseFactory {
  static IDatabaseService getDatabaseService(){
    if(kIsWeb){
      return SharedPreferencesService();
    }else{
      return SqliteService();
    }
  }
}