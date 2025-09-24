import 'package:hive_flutter/adapters.dart';

import '../data_cache_service.dart';



///通过hive实现本地数据的缓存,多用户时需要使用用户的账号来做boxString
class XDDataCacheServiceImplementByHive implements DataCacheService {
  final  String  hiveAppBoxString;
  late Box box;
  XDDataCacheServiceImplementByHive({this.hiveAppBoxString="XDHiveAppBox"}){
    init();
  }
  @override
  Future<void> deleteDataByDataName(key) async {
    // var box= await Hive.openBox(hiveAppBoxString);
    await box.delete(key);
  }

  @override
  Future<void> deleteDataOfKeys(Iterable<dynamic> keys) async {
    // var box= await Hive.openBox(hiveAppBoxString);

    await box.deleteAll(keys);

  }

  @override
  T? getDataByDataName<T>(String dataName)  {

    // var box= await Hive.openBox(hiveAppBoxString);
    return box.get(dataName);

  }

  @override
  Future<void> init() async {
    // const secureStorage = FlutterSecureStorage();
    // var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
    // if (!containsEncryptionKey) {
    //   var key = Hive.generateSecureKey();
    //   await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    // }
    // var encryptionKey =
    //     base64Url.decode((await secureStorage.read(key: 'key'))!);
    //
    await Hive.initFlutter();
    await Hive.openBox(hiveAppBoxString);
     box=  Hive.box(hiveAppBoxString);

  }

  @override
  Future<void> saveData(String dataName, dataObject) async {
   return  box.put(dataName, dataObject);
  }
}
