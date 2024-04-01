part of particle_image;

class PD_Events {
  final Function()? onEachParticleStart;
  final Function()? onFirstParticleFinished;
  final Function()? onEachParticleFinished;
  final Function()? onLastParticleFinished;

  const PD_Events({
    this.onEachParticleStart,
    this.onFirstParticleFinished,
    this.onEachParticleFinished,
    this.onLastParticleFinished,
  });
}
