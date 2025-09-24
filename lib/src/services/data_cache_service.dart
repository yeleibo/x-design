
import 'package:get_it/get_it.dart';

var dataCacheService=GetIt.instance<DataCacheService>();

///数据缓存的接口
abstract class DataCacheService {
  ///初始化
  Future<void> init();

  ///保存数据
  Future<void> saveData(String dataName, dynamic dataObject);

  ///获取数据,采用同步获取的方式避免不必要的麻烦
  T? getDataByDataName<T>(String dataName);

  ///删除数据
  Future<void> deleteDataByDataName(dynamic key);

  ///删除多个数据
  Future<void> deleteDataOfKeys(Iterable<dynamic> keys);
}
