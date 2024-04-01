part of particle_image;

class ParticleUtils {
  static double toRadians(double degrees) => degrees * (pi / 180.0);

  static double randomBetween(double min, double max) {
    return Random().nextDouble() * (max - min) + min;
  }

  static int randomBetweenInt(int min, int max) {
    return Random().nextInt(max - min) + min;
  }

  static Offset normalized(Offset offset) {
    double length = sqrt(offset.dx * offset.dx + offset.dy * offset.dy);
    if (length == 0) {
      return Offset.zero;
    }
    return offset / length;
  }

  static Offset lerpUnclamped(Offset a, Offset b, double t) {
    double x = a.dx + (b.dx - a.dx) * t;
    double y = a.dy + (b.dy - a.dy) * t;
    return Offset(x, y);
  }

  static (Offset, Size) fromKey(GlobalKey key, BuildContext context) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset position = renderBox.localToGlobal(Offset.zero);
      return (position, renderBox.size);
    }
    return (const Offset(-1, -1), Size.zero);
  }

  static Offset rotatePointArroundCenter(Offset point, double angle) {
    final double x = point.dx;
    final double y = point.dy;
    final double radians = toRadians(angle);
    final double cosTheta = cos(radians);
    final double sinTheta = sin(radians);
    final double xRotated = x * cosTheta - y * sinTheta;
    final double yRotated = x * sinTheta + y * cosTheta;
    return Offset(xRotated, yRotated);
  }
}
