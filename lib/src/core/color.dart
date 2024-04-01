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
  final List<int> stops;

  PD_ColorProgress(this.colors, this.stops)
      : assert(colors.length == stops.length);

  @override
  Color value(double progress) {
    if (progress <= 0) {
      return colors.first;
    }
    if (progress >= 1) {
      return colors.last;
    }

    for (int i = 0; i < stops.length - 1; i++) {
      final start = stops[i];
      final end = stops[i + 1];

      if (progress >= start && progress <= end) {
        final segmentFraction = (progress - start) / (end - start);
        return Color.lerp(colors[i], colors[i + 1], segmentFraction)!;
      }
    }
    return colors.last;
  }

  @override
  PD_Color clone() {
    return PD_ColorProgress(colors, stops);
  }
}
