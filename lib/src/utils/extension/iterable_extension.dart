extension IterableNullAbleExtension<T> on Iterable<T>? {
   T? singleOrDefault(bool Function(T element) test){
      if(this!=null &&  this!.any(test)){
         return this!.singleWhere(test);
      }else{
         return null;
      }
   }
   ///数组中第一个或者null
   T? firstOrDefault(){
      if(this!=null && this!.isNotEmpty){
         return this!.first;
      }
      return null;
   }
}

extension IterableExtension<T> on Iterable<T> {
   Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
      Map<K, List<T>> result = {};
      for (var element in this) {
         final key = keySelector(element);
         result.putIfAbsent(key, () => []).add(element);
      }
      return result;
   }
}