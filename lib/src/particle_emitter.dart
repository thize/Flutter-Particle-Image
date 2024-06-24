part of particle_image;

/*
TODO: Particle Emitter
Work with Loop
*/

class ParticleDraw {
  final ui.Image image;
  final List<ParticleTransform> transforms = [];
  final List<ParticleColor> colors = [];
  final List<ParticleRect> rectangles = [];

  ParticleDraw({required this.image});

  void clear() {
    transforms.clear();
    colors.clear();
    rectangles.clear();
  }
}

/// The `ParticleEmitter` class is responsible for managing the emission and lifecycle of particles in an animation.
/// It works in conjunction with the `ParticleController` to handle particle states and update the animation based on elapsed time.
/// The `ParticleEmitter` class contains a list of `ParticleData` objects that define the properties of the particles in the animation.
/// It also maintains a collection of running particles, dead particles, and particle textures to render the animation on the screen.
class ParticleEmitter {
  static final Map<int, ui.Image> particlesTextures = {};

  final ParticleController controller;
  final List<ParticleData> particlesData;
  final Offset position;
  final Size size;

  ParticleEmitter({
    required this.controller,
    required this.particlesData,
    required this.position,
    required this.size,
  });

  ChangeNotifier notifier = ChangeNotifier();

  final Map<ParticleData, int> _durationsWithDelayInMilliseconds = {};
  final Map<ParticleData, List<Particle>> particles = {};
  final Map<ParticleData, ParticleDraw> particlesDraw = {};
  final Map<ParticleData, bool> _isFirstEmitter = {};
  final Map<ParticleData, int> _emittedOverDuration = {};
  final Map<ParticleData, List<Particle>> deadParticles = {};
  final Map<ParticleData, bool> _finishedFirstParticle = {};
  final Map<ParticleData, int> _loopElapsedInMilliseconds = {};

  static Future preloadTextures(List<String> paths) async {
    for (final path in paths) {
      final image = await rootBundle.loadImage(path);
      particlesTextures[path.hashCode] = image;
    }
  }

  int _totalElapsedInMilliseconds = 0;

  void onTick(Duration elapsed) {
    int diff = elapsed.inMilliseconds - _totalElapsedInMilliseconds;
    _totalElapsedInMilliseconds += diff;
    for (final particleData in particlesData) {
      _loopElapsedInMilliseconds[particleData] =
          _loopElapsedInMilliseconds[particleData]! + diff;
    }
    _updateRunningParticles();
    _emitNewParticles();
    _checkIfDone();
    _notifyListeners();
  }

  void init() {
    _totalElapsedInMilliseconds = 0;
    for (final particleData in particlesData) {
      _durationsWithDelayInMilliseconds[particleData] =
          particleData.settings.time.duration.inMilliseconds +
              particleData.settings.time.startDelay.inMilliseconds;
      particles.putIfAbsent(particleData, () => []);
      deadParticles.putIfAbsent(particleData, () => []);
      _finishedFirstParticle[particleData] = false;
      _isFirstEmitter[particleData] = true;
      _emittedOverDuration[particleData] = 0;
      _loopElapsedInMilliseconds[particleData] = 0;
      if (particlesTextures[particleData.settings.shape.hash] == null) {
        rootBundle
            .loadImage(particleData.settings.shape.shapePath)
            .then((image) {
          particlesTextures[particleData.settings.shape.hash] = image;
          _setDraw(particleData);
        });
      } else {
        _setDraw(particleData);
      }
    }
  }

  void _setDraw(ParticleData particleData) {
    if (particlesDraw[particleData] == null) {
      particlesDraw[particleData] = ParticleDraw(
        image: particlesTextures[particleData.settings.shape.hash]!,
      );
    } else {
      ParticleDraw particleDraw = particlesDraw[particleData]!;
      particleDraw.transforms.clear();
      particleDraw.colors.clear();
      particleDraw.rectangles.clear();
    }
  }

  void kill() {
    for (final particles in particles.values) {
      for (final Particle particle in particles) {
        particle.kill();
      }
    }
  }

  void _updateRunningParticles() {
    for (final particles in particles.values) {
      for (final Particle particle in particles) {
        particle.update(_totalElapsedInMilliseconds);
      }
    }
  }

  void _emitNewParticles() {
    if (!_isRunning) return;
    for (final particleData in particlesData) {
      if (!_isTexturesLoaded(particleData)) {
        continue;
      }
      bool isElapsed = _loopElapsedInMilliseconds[particleData]! >
          _durationsWithDelayInMilliseconds[particleData]!;
      if (isElapsed) continue;
      bool onDelay = _loopElapsedInMilliseconds[particleData]! <
          particleData.settings.time.startDelay.inMilliseconds;
      if (onDelay) continue;
      bool isFirstEmitter = _isFirstEmitter[particleData]!;
      if (isFirstEmitter) {
        _isFirstEmitter[particleData] = false;
        _emitBurstedParticles(particleData);
      }
      _emitRateOverDurationParticles(particleData);
      _emitRatePerSecondParticles(particleData);
    }
  }

  void _emitBurstedParticles(ParticleData particleData) {
    for (var burst in particleData.emission.bursts) {
      Future.delayed(Duration(milliseconds: burst.time.inMilliseconds), () {
        if (!_isRunning) return;
        for (var i = 0; i < burst.count; i++) {
          _addParticle(particleData);
        }
        if (burst.count > 0) _notifyListeners();
      });
    }
  }

  void _emitRatePerSecondParticles(ParticleData particleData) {
    final ratePerSecond = particleData.emission.ratePerSecond;
    if (ratePerSecond > 0) {
      double progressInSeconds =
          (_loopElapsedInMilliseconds[particleData]! / 1000).toDouble();
      int expectedTotalParticles = (ratePerSecond * progressInSeconds).round();

      int emittedSoFar = _emittedOverDuration[particleData]!;

      int particlesToEmit = expectedTotalParticles - emittedSoFar;

      if (particlesToEmit > 0) {
        for (int i = 0; i < particlesToEmit; i++) {
          _addParticle(particleData);
        }
        _emittedOverDuration[particleData] = emittedSoFar + particlesToEmit;
      }
    }
  }

  void _emitRateOverDurationParticles(ParticleData particleData) {
    final rateOverDuration = particleData.emission.rateOverDuration;
    int emittedOverDuration = _emittedOverDuration[particleData] ?? 0;
    if (rateOverDuration > 0) {
      int durationWithDelay = _durationsWithDelayInMilliseconds[particleData]!;
      double expectedProgress =
          _loopElapsedInMilliseconds[particleData]! / durationWithDelay;
      int expectedParticles = (rateOverDuration * expectedProgress).round();
      int particlesToEmit = expectedParticles - emittedOverDuration;
      for (int i = 0; i < particlesToEmit; i++) {
        if (emittedOverDuration >= rateOverDuration) break;
        _addParticle(particleData);
        _emittedOverDuration[particleData] = emittedOverDuration + 1;
      }
    }
  }

  void _addParticle(ParticleData particleData) {
    late Particle particle;
    if (deadParticles[particleData]!.isNotEmpty) {
      particle = deadParticles[particleData]!.removeLast();
    } else {
      particle = Particle(
        data: particleData,
        emitter: this,
        onDead: () {
          deadParticles[particleData]!.add(particle);
          particleData.events.onEachParticleFinished?.call();
          if (_finishedFirstParticle[particleData] == false) {
            _finishedFirstParticle[particleData] = true;
            particleData.events.onFirstParticleFinished?.call();
          }
        },
      );
      particles[particleData]!.add(particle);
      particlesDraw.putIfAbsent(
        particleData,
        () => ParticleDraw(
          image: particlesTextures[particleData.settings.shape.hash]!,
        ),
      );
      _addDraw(particle);
    }
    particle.setInitialData(
      totalElapsedMillis: _totalElapsedInMilliseconds,
    );
    particleData.events.onEachParticleStart?.call();
  }

  void _addDraw(Particle particle) {
    ParticleDraw particleDraw = particlesDraw[particle.data]!;
    particleDraw.transforms.add(particle.transform);
    particleDraw.colors.add(particle.color);
    particleDraw.rectangles.add(particle.rect);
  }

  void _checkIfDone() {
    if (_isRunning) {
      for (final particleData in particlesData) {
        if (particleData.settings.time.loop) {
          bool isLoopElapsed = _loopElapsedInMilliseconds[particleData]! >
              particleData.settings.time.duration.inMilliseconds;
          if (isLoopElapsed) {
            _loopElapsedInMilliseconds[particleData] = 0;
            _emittedOverDuration[particleData] = 0;
            _isFirstEmitter[particleData] = true;
          }
        }
      }

      bool isAllElapsed = particlesData.every((particleData) {
        if (particleData.settings.time.loop) return false;
        return _totalElapsedInMilliseconds >
            _durationsWithDelayInMilliseconds[particleData]!;
      });
      if (isAllElapsed) {
        controller.stop();
      }
    }
    if (_isEnded && !_hasRunningParticles) {
      controller.kill();
      for (final particleData in particlesData) {
        particleData.events.onLastParticleFinished?.call();
      }
    }
  }

  void _notifyListeners() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifier.notifyListeners();
  }

  //! Utils

  bool get _isRunning => controller.state == ParticleState.running;
  bool get _isEnded => controller.state == ParticleState.ended;
  bool get isKilled => controller.state == ParticleState.killed;
  bool get _hasRunningParticles => particles.values
      .any((particles) => particles.any((particle) => !particle.isDone));
  bool _isTexturesLoaded(ParticleData particleData) =>
      particlesTextures[particleData.settings.shape.hash] != null;
}
