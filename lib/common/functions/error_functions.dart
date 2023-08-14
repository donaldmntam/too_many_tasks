import 'package:too_many_tasks/common/typedefs/json.dart';

void require(bool condition, [String? reason]) {
  if (condition == true) return;
  if (reason == null) {
    throw "Requirement not met!";
  } else {
    throw "Requirement not met! The reason was '$reason'";
  }
}

Never illegalState(Object? state, String function) {
  throw "Illegal state detected! Function '$function' was called when "
    "the state was '$state'!";
}

Never todo([String? comment]) {
  if (comment == null) {
    throw "TODO";
  } else {
    throw "TODO: $comment";
  }
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