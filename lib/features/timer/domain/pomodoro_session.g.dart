// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'pomodoro_session.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class PomodoroSessionAdapter extends TypeAdapter<PomodoroSession> {
//   @override
//   final int typeId = 1;

//   @override
//   PomodoroSession read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return PomodoroSession(
//       timestamp: fields[0] as DateTime,
//       completedRounds: fields[1] as int,
//       totalBreakTimeMinutes: fields[2] as int,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, PomodoroSession obj) {
//     writer
//       ..writeByte(3)
//       ..writeByte(0)
//       ..write(obj.timestamp)
//       ..writeByte(1)
//       ..write(obj.completedRounds)
//       ..writeByte(2)
//       ..write(obj.totalBreakTimeMinutes);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is PomodoroSessionAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
