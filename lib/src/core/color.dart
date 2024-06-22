part of particle_image;

abstract class PD_Color extends PD_Progress<PD_Color, Color> {
  const PD_Color();
}

class PD_ColorSingle extends PD_Color {
  final Color color;

  @override
  Color value(double progress) => color;

  const PD_ColorSingle([this.color = Colors.white]);

  @override
  PD_Color clone() {
    return PD_ColorSingle(color);
  }
}

class PD_ColorRandomBetweenTwo extends PD_Color {
  final Color color1;
  final Color color2;
  Color _result = Colors.white;

  PD_ColorRandomBetweenTwo(this.color1, this.color2) {
    _result = _getRandomColor();
  }

  @override
  Color value(double progress) => _result;

  Color _getRandomColor() {
    Random random = Random();
    double r = random.nextDouble();
    int red = (color1.red * r + color2.red * (1 - r)).round();
    int green = (color1.green * r + color2.green * (1 - r)).round();
    int blue = (color1.blue * r + color2.blue * (1 - r)).round();
    int alpha = (color1.alpha * r + color2.alpha * (1 - r)).round();
    return Color.fromARGB(alpha, red, green, blue);
  }

  @override
  PD_Color clone() {
    return PD_ColorRandomBetweenTwo(color1, color2);
  }
}

class PD_ColorRandom extends PD_Color {
  final List<Color> colors;

  Color _result = Colors.white;

  PD_ColorRandom(this.colors) {
    _result = colors[Random().nextInt(colors.length)];
  }

  @override
  Color value(double progress) => _result;

  @override
  PD_Color clone() {
    return PD_ColorRandom(colors);
  }
}

class PD_ColorProgress extends PD_Color {
  final List<Color> colors;
  final Curve curve;

  PD_ColorProgress({
    required this.colors,
    this.curve = Curves.linear,
  });

  @override
  Color value(double progress) {
    // Apply the curve to the progress
    double curvedProgress = curve.transform(progress);

    // Calculate the interval
    int segmentCount = colors.length - 1;
    double segmentLength = 1.0 / segmentCount;

    // Determine which segment we are in
    int segmentIndex = (curvedProgress / segmentLength).floor();
    if (segmentIndex >= segmentCount) {
      segmentIndex = segmentCount - 1;
    }

    // Calculate the local progress within the segment
    double localProgress =
        (curvedProgress - segmentIndex * segmentLength) / segmentLength;

    // Interpolate between the two colors in the segment
    return Color.lerp(
            colors[segmentIndex], colors[segmentIndex + 1], localProgress) ??
        colors[segmentIndex];
  }

  @override
  PD_Color clone() {
    return PD_ColorProgress(
      colors: colors,
      curve: curve,
    );
  }
}
