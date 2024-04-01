part of particle_image;

enum ParticleState {
  running,
  ended,
  killed,
}

class ParticleController {
  ParticleState state = ParticleState.killed;
  final bool newParticlesAtTop;
  static bool withDebug = kDebugMode;

  final List<VoidCallback?> _listeners =
      List<VoidCallback?>.empty(growable: true);

  ParticleController({
    bool autoStart = true,
    this.newParticlesAtTop = true,
  }) {
    if (autoStart) start();
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
