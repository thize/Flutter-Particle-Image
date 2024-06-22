part of particle_image;

class ParticleData {
  final PD_Settings settings;
  final PD_Emission emission;
  final PD_Movement movement;
  final PD_Events events;

  ParticleData({
    PD_Settings? settings,
    this.emission = const PD_Emission(),
    this.movement = const PD_Movement(),
    this.events = const PD_Events(),
  }) : settings = settings ?? PD_Settings();

  ParticleData clone() {
    return ParticleData(
      settings: settings.clone(),
      emission: emission,
      movement: movement,
      events: events,
    );
  }
}
