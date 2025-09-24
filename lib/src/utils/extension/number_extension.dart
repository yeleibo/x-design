import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

extension NumberExtension on num? {
  ///数字转为财务数字，decimalDigits代表小数的位数，isFill表示不足位数时是否需要补全
  String toFinanceString({int decimalDigits=8,bool isFill = false}){
    if(!isFill){
      var numberString=toString();
      //获取小数点后面的位数
      if(numberString.indexOf('.')<=0){
        decimalDigits=0;
      }else{
        int decimalPlaces = numberString.length - numberString.indexOf('.') - 1;
        decimalDigits=decimalPlaces>decimalDigits?decimalDigits:decimalPlaces;
      }
    }
    NumberFormat formatter = NumberFormat.currency( decimalDigits: decimalDigits,symbol: '');
    String financeFormattedValue = formatter.format(this);
    return financeFormattedValue;
  }

  Decimal toDecimal(){
    return Decimal.parse(toString());
  }

  double changeDecimalDigits(int fractionDigits){

    return double.parse(this!.toStringAsFixed(fractionDigits));
  }

}

