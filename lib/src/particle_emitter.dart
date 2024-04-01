part of particle_image;

class ParticleEmitter {
  late ParticleData data;
  final Duration _durationWithDelay;
  final ParticleController controller;
  double totalElapsed = 0;
  List<Particle> particles = List.empty(growable: true);
  int _emittedOverDuration = 0;
  double _lastEmissionTime = 0;

  ParticleEmitter({
    required this.data,
    required this.controller,
  }) : _durationWithDelay =
            data.settings.time.duration + data.settings.time.startDelay;

  void setData(ParticleData newData) {
    data = newData.clone();
  }

  void forward(int elapsedMillis, Size totalSize, GlobalKey particleImageKey,
      BuildContext context) {
    totalElapsed += elapsedMillis;
    _emitParticles(totalSize, particleImageKey, context);
    _cleanParticles();
    _updateParticles(elapsedMillis);
    _killEmitterWhenOver();
  }

  void _emitParticles(
      Size totalSize, GlobalKey particleImageKey, BuildContext context) {
    if (state != ParticleState.running) return;
    if (totalElapsed < data.settings.time.startDelay.inMilliseconds) return;

    _firstEmitParticles(totalSize, particleImageKey, context);

    if (data.emission.ratePerSecond > 0) {
      double interval = 1000 / data.emission.ratePerSecond;
      while ((totalElapsed - _lastEmissionTime) >= interval) {
        _addParticle(totalSize, particleImageKey, context);
        _lastEmissionTime += interval;
      }
    }

    if (data.emission.rateOverDuration > 0) {
      double expectedProgress =
          totalElapsed / _durationWithDelay.inMilliseconds;
      int expectedParticles =
          (data.emission.rateOverDuration * expectedProgress).round();
      int particlesToEmit = expectedParticles - _emittedOverDuration;

      for (int i = 0; i < particlesToEmit; i++) {
        if (_emittedOverDuration >= data.emission.rateOverDuration) break;
        _addParticle(totalSize, particleImageKey, context);
        _emittedOverDuration++;
      }
    }
  }

  bool _calledFirstEmit = false;

  ParticleState get state => controller.state;

  void _firstEmitParticles(
    Size totalSize,
    GlobalKey particleImageKey,
    BuildContext context,
  ) {
    if (_calledFirstEmit) return;
    _calledFirstEmit = true;
    // Burst
    for (var burst in data.emission.bursts) {
      Timer(burst.time, () {
        if (state == ParticleState.running) {
          for (int i = 0; i < burst.count; i++) {
            _addParticle(totalSize, particleImageKey, context);
          }
        }
      });
    }
  }

  void _addParticle(
    Size totalSize,
    GlobalKey particleImageKey,
    BuildContext context,
  ) {
    final newParticle = Particle(
      data: data.clone(),
      startTime: totalElapsed,
      totalSize: totalSize,
      particleImageKey: particleImageKey,
      context: context,
    );
    if (controller.newParticlesAtTop) {
      particles.add(newParticle);
    } else {
      particles.insert(0, newParticle);
    }
    data.events.onEachParticleStart?.call();
  }

  bool _firstParticleFinished = false;

  void _cleanParticles() {
    particles.removeWhere((particle) {
      final animationOver = particle.animationDuration.inMilliseconds <
          totalElapsed - particle.startTime;
      if (animationOver) {
        data.events.onEachParticleFinished?.call();
        if (!_firstParticleFinished) {
          _firstParticleFinished = true;
          data.events.onFirstParticleFinished?.call();
        }
      }
      return animationOver;
    });
  }

  void _updateParticles(int elapsedMillis) {
    for (var particle in particles) {
      particle.onAnimationUpdate(
        progress: (totalElapsed - particle.startTime) /
            particle.animationDuration.inMilliseconds,
        elapsedMillis: elapsedMillis,
      );
    }
  }

  int _cycles = 1;

  void _killEmitterWhenOver() {
    if (state == ParticleState.running) {
      if (totalElapsed > _durationWithDelay.inMilliseconds * _cycles) {
        if (data.settings.time.loop) {
          if (particles.isEmpty) {
            _calledFirstEmit = false;
            _cycles++;
          }
        } else {
          controller.stop();
        }
      }
    } else if (state == ParticleState.ended && particles.isEmpty) {
      controller.kill();
      data.events.onLastParticleFinished?.call();
    }
  }
}
