// ignore_for_file: library_private_types_in_public_api

part of particle_image;

class CurveViewer extends StatelessWidget {
  const CurveViewer({super.key, required this.toUseCurve});

  final Curve toUseCurve;

  static final linearTween = Tween<double>(begin: 0, end: 1);

  @override
  Widget build(BuildContext context) {
    return AnimationAndCurveDemo(
      lable: 'Linear - EaseIn and EaseOut',
      mainCurve: linearTween.chain(CurveTween(curve: toUseCurve)),
      duration: const Duration(seconds: 2),
      size: 200,
    );
  }
}

/// WARNING
/// The code below is used to do the animation demonstration. Feel free to poke
/// around. It is not optimised in any way, purely for demonstration purposes.
enum KindOfAnimation {
  forward,
  repeat,
  repeatAndreverse,
}

class AnimationAndCurveDemo extends StatefulWidget {
  /// NOTE: All tweens ([mainCurve], [compareCurve]) must have an interval
  /// between 0 and 1.
  ///
  /// The [size] is used to determine the size of the graph and animation.
  ///
  /// The interval value is used as a fractional percentage to calculate the
  /// size/position of the animations.
  const AnimationAndCurveDemo({
    super.key,
    required this.mainCurve,
    this.compareCurve,
    this.lable = '',
    this.size = 200,
    this.duration = const Duration(seconds: 1),
    this.kindOfAnim = KindOfAnimation.forward,
  });

  final Animatable<double> mainCurve;
  final Animatable<double>? compareCurve;
  final String lable;
  final double size;
  final Duration duration;
  final KindOfAnimation kindOfAnim;

  @override
  _AnimationAndCurveDemoState createState() => _AnimationAndCurveDemoState();
}

class _AnimationAndCurveDemoState extends State<AnimationAndCurveDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Animatable<double> get _mainCurve => widget.mainCurve;
  Animatable<double>? get _compareCurve => widget.compareCurve;
  String get _label => widget.lable;
  double get _size => widget.size;
  Duration get _duration => widget.duration;
  KindOfAnimation get _kindOfAnim => widget.kindOfAnim;

  /// The shadow path of the animation curve - dotted line
  late Path _shadowPath;

  /// Path to compare the current animation to - only drawn if not null
  Path? _comparePath;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
  }

  Path _buildGraph(Animatable<double> animatable) {
    var val = 0.0;
    var path = Path();
    for (var t = 0.0; t <= 1; t += 0.01) {
      val = -animatable.transform(t) * _size;
      path.lineTo(t * _size, val);
    }
    return path;
  }

  void _playAnimation() {
    if (_controller.isCompleted) {
      _controller.reset();
      return;
    }
    if (_kindOfAnim == KindOfAnimation.forward) {
      _controller.forward();
    } else if (_kindOfAnim == KindOfAnimation.repeat) {
      _controller.repeat();
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _shadowPath = _buildGraph(_mainCurve);
    if (_compareCurve != null) {
      _comparePath = _buildGraph(_compareCurve!);
    }
    var intervalValue = 0.0;
    var followPath = Path();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(_label, style: Theme.of(context).textTheme.headlineMedium),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(
                    lerpDouble(-1, 1, _mainCurve.evaluate(_controller))!,
                    0,
                  ),
                  child: child,
                );
              },
              child: Container(
                color: Colors.white.withOpacity(0.1),
                child: const FlutterLogo(
                  size: 150,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _playAnimation,
            child: const Text('Tween'),
          ),
        ),
        SizedBox(
          height: 300,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              // rest the follow path when the controller is finished
              if (intervalValue >= _controller.value) {
                followPath.reset();
              }
              intervalValue = _controller.value;

              final val = _mainCurve.evaluate(_controller);
              followPath.lineTo(_controller.value * _size, -val * _size);

              return CustomPaint(
                painter: GraphPainter(
                  shadowPath: _shadowPath,
                  followPath: followPath,
                  comparePath: _comparePath,
                  currentPoint: Offset(
                    _controller.value * _size,
                    val * _size,
                  ),
                  graphSize: _size + 20,
                ),
                child: Container(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GraphPainter extends CustomPainter {
  const GraphPainter({
    required this.currentPoint,
    required this.shadowPath,
    required this.followPath,
    this.comparePath,
    required this.graphSize,
  });

  final Offset currentPoint;
  final Path shadowPath;
  final Path followPath;
  final Path? comparePath;
  final double graphSize;

  static final backgroundPaint = Paint()..color = Colors.grey[200]!;
  static final currentPointPaint = Paint()..color = Colors.red;
  static final shadowPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  static final comparePaint = Paint()
    ..color = Colors.green[500]!
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final followPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  static final borderPaint = Paint()
    ..color = Colors.grey[700]!
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    canvas.translate(
        size.width / 2 - graphSize / 2, size.height / 2 - graphSize / 2);
    _drawBorder(canvas, size);
    canvas.translate(0, graphSize);
    if (comparePath != null) {
      canvas.drawPath(comparePath!, comparePaint);
    }
    canvas
      ..drawPath(shadowPath, shadowPaint)
      ..drawPath(followPath, followPaint)
      ..drawCircle(
          Offset(currentPoint.dx, -currentPoint.dy), 4, currentPointPaint);
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
  }

  void _drawBorder(Canvas canvas, Size size) {
    canvas
      ..drawLine(const Offset(0, 0), Offset(0, graphSize), borderPaint)
      ..drawLine(
          Offset(0, graphSize), Offset(graphSize, graphSize), borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
