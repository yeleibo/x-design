
import 'package:latlong2/latlong.dart';
import 'package:hive/hive.dart';
class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final int typeId = 7;

  @override
  LatLng read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatLng(
       fields[0] as double,
        fields[1] as double
    );
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LatLngAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}