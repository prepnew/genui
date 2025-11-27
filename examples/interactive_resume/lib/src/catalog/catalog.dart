// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:genui/genui.dart';

import 'feedback_card.dart';
import 'question_card.dart';
import 'resume_highlight.dart';

final Catalog resumeCatalog = CoreCatalogItems.asCatalog()
    .copyWithout([
      // Remove items we don't need to keep the prompt smaller
      CoreCatalogItems.audioPlayer,
      CoreCatalogItems.video,
      CoreCatalogItems.slider,
      CoreCatalogItems.dateTimeInput,
    ])
    .copyWith([questionCard, feedbackCard, resumeHighlight]);
