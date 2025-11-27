// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../model/resume_data.dart';

class GetResumeContentTool extends AiTool<JsonMap> {
  GetResumeContentTool()
    : super(
        name: 'getResumeContent',
        description: 'Retrieves the full text content of the user\'s resume.',
        parameters: S.object(),
      );

  @override
  Future<JsonMap> invoke(JsonMap args) async {
    return {'content': resumeContent};
  }
}
