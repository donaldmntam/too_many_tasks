import 'dart:convert';

import 'package:too_many_tasks/common/monads/result.dart';

Result<Object?> tryJsonDecode(String source) {
  try {
    return Ok(jsonDecode(source));
  } on TypeError catch (e) {
    return Err(e);
  }
}