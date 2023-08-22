import 'dart:convert';

import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/typedefs/json.dart';

Result<Object?> tryJsonDecode(String source) {
  try {
    return Ok(jsonDecode(source));
  } catch (e) {
    return Err(e);
  }
}

Result<String> tryJsonEncode(Json json) {
  try {
    return Ok(jsonEncode(json));
  } catch (e) {
    return Err(e);
  }
}