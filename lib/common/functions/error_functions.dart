import 'package:too_many_tasks/common/typedefs/json.dart';

Never badTransition(Object? state, String transition) {
  throw "Bad transition detected! Transition of '$transition' happened when "
    "the state was '$state'!";
}

String jsonErrorMessage(
  String type,
  Json json,
  [Object? cause]
) {
  final message = "Failed to deserialize into `$type`; Json: $json;";
  if (cause != null) {
    return "$message; Cause: $cause";
  }
  return message;
}