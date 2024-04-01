part of particle_image;

abstract class PD_Progress<CLASS, VALUE> {
  VALUE value(double progress);

  const PD_Progress();

  CLASS clone();
}
