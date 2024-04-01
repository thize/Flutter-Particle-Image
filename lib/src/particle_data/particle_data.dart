part of particle_image;

class ParticleData {
  final PD_Settings settings;
  final PD_Emission emission;
  final PD_Movement movement;
  final PD_Events events;
  final Widget Function(BuildContext, Widget)? _transform;

  const ParticleData({
    this.settings = const PD_Settings(),
    this.emission = const PD_Emission(),
    this.movement = const PD_Movement(),
    this.events = const PD_Events(),
    Widget Function(BuildContext, Widget)? transform,
  }) : _transform = transform;

  Widget build({
    required BuildContext context,
    required Widget child,
  }) {
    return _transform?.call(context, child) ?? child;
  }

  ParticleData clone() {
    return ParticleData(
      settings: settings.clone(),
      emission: emission,
      movement: movement,
      events: events,
    );
  }
}
