part of '_restaurant.dart';

@freezed
class WeeklySchedule with _$WeeklySchedule {
  const factory WeeklySchedule({
    required List<DailySchedule> dailySchedules,
  }) = _WeeklySchedule;

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) =>
      _$WeeklyScheduleFromJson(json);
}

@freezed
class DailySchedule with _$DailySchedule {
  const factory DailySchedule({
    required Day day,
    required DateTime openTime,
    required DateTime closeTime,
  }) = _DailySchedule;

  factory DailySchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyScheduleFromJson(json);
}

// use short names for days of the week as keys but full name as jsonvalues
enum Day {
  @JsonValue('Monday')
  mon,
  @JsonValue('Tuesday')
  tue,
  @JsonValue('Wednesday')
  wed,
  @JsonValue('Thursday')
  thu,
  @JsonValue('Friday')
  fri,
  @JsonValue('Saturday')
  sat,
  @JsonValue('Sunday')
  sun,
}
