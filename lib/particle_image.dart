library particle_image;

import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

export 'package:vector_math/vector_math_64.dart' hide Colors;

part 'src/core/color.dart';
part 'src/core/duration.dart';
part 'src/core/number.dart';
part 'src/core/offset.dart';
part 'src/core/progress.dart';
part 'src/core/range.dart';
part 'src/core/size.dart';
part 'src/core/vector3.dart';
part 'src/particle.dart';
part 'src/particle_controller.dart';
part 'src/particle_data/particle_data.dart';
part 'src/particle_data/src/pd_emission/pd_emission.dart';
part 'src/particle_data/src/pd_emission/pd_emission_shape.dart';
part 'src/particle_data/src/pd_events.dart';
part 'src/particle_data/src/pd_movement.dart';
part 'src/particle_data/src/pd_particle/pd_shape.dart';
part 'src/particle_data/src/pd_particle/pd_tile.dart';
part 'src/particle_data/src/pd_particle/pd_trail.dart';
part 'src/particle_data/src/pd_settings.dart';
part 'src/particle_emitter.dart';
part 'src/particle_image_widget.dart';
part 'src/particle_painter.dart';
part 'src/utils/bundle_extensions.dart';
part 'src/utils/curve_points.dart';
part 'src/utils/utils.dart';
