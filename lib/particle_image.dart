library particle_image;

import 'dart:async';
import 'dart:math';
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
part 'src/curve_viwer.dart';
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
part 'src/particle_painter.dart';
part 'src/utils/bundle_extensions.dart';
part 'src/utils/curve_points.dart';
part 'src/utils/utils.dart';

class ParticleImage extends StatefulWidget {
  final ParticleData particle;
  final ParticleController? controller;
  final List<ParticleData> subParticles;

  const ParticleImage({
    super.key,
    required this.particle,
    this.controller,
    this.subParticles = const [],
  });

  @override
  State<ParticleImage> createState() => _ParticleImageState();
}

class _ParticleImageState extends State<ParticleImage>
    with SingleTickerProviderStateMixin {
  late ParticleController _controller;
  final _activeParticles = List<ParticleEmitter>.empty(growable: true);
  int _lastElapsedMillis = 0;
  int _lastElapsedMillisTemp = 0;
  late Ticker _ticker;
  Size _totalSize = Size.zero;
  final GlobalKey _particleImageKey = GlobalKey();

  Future<List<ui.Image?>> get imagesFuture {
    return Future.wait([
      widget.particle.settings.shape.buildShape(),
      for (var subParticle in widget.subParticles)
        subParticle.settings.shape.buildShape(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _particleImageKey,
      future: imagesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<ui.Image?>> snapshot) {
        return RepaintBoundary(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _totalSize = constraints.biggest;
              if (!snapshot.hasData || _activeParticles.isEmpty) {
                if (ParticleController.withDebug) {
                  return _debug(constraints);
                }
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );
              }
              List<Widget> paintList = [];
              for (var i = 0; i < _activeParticles.length; i++) {
                var emitter = _activeParticles[i];
                if (i > snapshot.data!.length - 1) break;
                paintList.add(_PaintParticle(
                  emitter: emitter,
                  image: snapshot.data![i]!,
                  constraints: constraints,
                ));
              }
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    ...paintList,
                    if (ParticleController.withDebug) _debug(constraints),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  CustomPaint _debug(BoxConstraints constraints) {
    return CustomPaint(
      willChange: true,
      size: constraints.biggest,
      painter: EmissionDebugPainter(
        particle: widget.particle,
        totalSize: _totalSize,
      ),
    );
  }

  void _onFrameUpdate(Duration elapsed) {
    _cleanDeadEmitters();
    _updateActiveEmitters(elapsed);
  }

  void _cleanDeadEmitters() {
    _activeParticles
        .removeWhere((emitter) => emitter.state == ParticleState.killed);
  }

  void _updateActiveEmitters(Duration elapsed) {
    _lastElapsedMillisTemp = elapsed.inMilliseconds;
    if (_activeParticles.isNotEmpty) {
      for (var element in _activeParticles) {
        element.forward(
          elapsed.inMilliseconds - _lastElapsedMillis,
          _totalSize,
          _particleImageKey,
          context,
        );
      }
      _lastElapsedMillis = _lastElapsedMillisTemp;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ParticleController();
    _setupEffectsFromWidget();
    _ticker = createTicker(_onFrameUpdate);
    _ticker.start();
    _controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    try {
      setState(() {});
      // ignore: empty_catches
    } catch (e) {}
    _lastElapsedMillis = _lastElapsedMillisTemp;
    _setupEffectsFromWidget();
  }

  @override
  void dispose() {
    _ticker.stop(canceled: true);
    _ticker.dispose();
    _controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(ParticleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.particle != widget.particle) {
      _setupEffectsFromWidget();
    }
  }

  void _setupEffectsFromWidget() {
    if (_activeParticles.isEmpty) {
      _activeParticles.add(ParticleEmitter(
        data: widget.particle,
        controller: _controller,
      ));
      for (var i = 0; i < widget.subParticles.length; i++) {
        _activeParticles.add(ParticleEmitter(
          data: widget.subParticles[i],
          controller: _controller,
        ));
      }
    } else {
      _activeParticles[0].setData(widget.particle);
      for (var i = 0; i < widget.subParticles.length; i++) {
        if (i < _activeParticles.length - 1) {
          _activeParticles[i + 1].setData(widget.subParticles[i]);
        } else {
          _activeParticles.add(ParticleEmitter(
            data: widget.subParticles[i],
            controller: _controller,
          ));
        }
      }
      if (widget.subParticles.length < _activeParticles.length - 1) {
        _activeParticles.removeRange(
          widget.subParticles.length + 1,
          _activeParticles.length,
        );
      }
    }
  }
}

class _PaintParticle extends StatelessWidget {
  const _PaintParticle({
    required this.emitter,
    required this.image,
    required this.constraints,
  });

  final ParticleEmitter emitter;
  final ui.Image image;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return emitter.data.build(
      context: context,
      child: CustomPaint(
        willChange: true,
        size: constraints.biggest,
        painter: ParticleImagePainter(
          shapesSpriteSheet: image,
          particles: emitter.particles,
        ),
      ),
    );
  }
}
