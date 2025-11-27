// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

String getApiKey() {
  const apiKey = String.fromEnvironment('GOOGLE_AI_STUDIO_API_KEY');
  if (apiKey.isEmpty) {
    throw StateError(
      'GOOGLE_AI_STUDIO_API_KEY environment variable not set. '
      'Please run with --dart-define=GOOGLE_AI_STUDIO_API_KEY=your_key',
    );
  }
  return apiKey;
}
