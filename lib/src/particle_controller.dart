part of particle_image;

enum ParticleState {
  running,
  ended,
  killed,
}

/// The `ParticleController` class is part of the particle_image library and is used to manage the state of particle animations.
/// It allows for controlling the state of particles, whether they are running, ended, or killed.
/// This class also supports the addition and removal of listeners that respond to state changes.
class ParticleController {
  ParticleState state = ParticleState.killed;
  final bool newParticlesAtTop;
  final bool _autoStart;

  final List<VoidCallback?> _listeners =
      List<VoidCallback?>.empty(growable: true);

  ParticleController({
    bool autoStart = true,
    this.newParticlesAtTop = true,
  }) : _autoStart = autoStart;

  void onInit() {
    if (_autoStart) start();
  }

  void start() {
    _changeState(ParticleState.running);
  }

  void stop() {
    _changeState(ParticleState.ended);
  }

  void kill() {
    _changeState(ParticleState.killed);
  }

  void _changeState(ParticleState newState) {
    if (state == newState) return;
    state = newState;
    for (var listener in _listeners) {
      listener?.call();
    }
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
