part of particle_image;

/// The `ParticleImage` widget is a custom widget that renders particles on the screen.
/// It utilizes a `ParticleController` to manage the particles' lifecycle and animation.
/// The widget is responsible for creating a `ParticleEmitter` and a `ParticleImagePainter` to draw the particles on the screen.
/// The `ParticleImage` widget is a stateful widget that listens to changes in the `ParticleEmitter` and updates the screen accordingly.
/// The widget is also responsible for creating a `Ticker` to update the particles' state based on elapsed time.
class ParticleImage extends StatefulWidget {
  final List<ParticleData> particlesData;
  final ParticleController? controller;

  static bool withDebug = kDebugMode;

  const ParticleImage({
    super.key,
    required this.particlesData,
    this.controller,
  });

  @override
  State<ParticleImage> createState() => _ParticleImageState();
}

class _ParticleImageState extends State<ParticleImage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _particleImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: _particleImageKey,
      isComplex: true,
      painter: ParticleImagePainter(emitter: _emitter),
      child: const SizedBox.expand(),
    );
  }

  late ParticleController _controller;
  ParticleEmitter? _emitter;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ParticleController();
    _controller.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final (Offset _offset, Size _size) =
          ParticleUtils.getOffsetAndSizefromKey(_particleImageKey, context);
      _emitter = ParticleEmitter(
        controller: _controller,
        particlesData: widget.particlesData,
        position: _offset,
        size: _size,
      );
      _emitter!.notifier.addListener(_emitterListener);
      _ticker = createTicker(_emitter!.onTick);
      _applyTickerByController();
      setState(() {});
    });
    _controller.addListener(_controllerListener);
  }

  void _emitterListener() {
    setState(() {});
  }

  void _controllerListener() {
    _applyTickerByController();
  }

  void _applyTickerByController() {
    if (_controller.state == ParticleState.killed) {
      if (_ticker.isActive) {
        _ticker.stop();
        _emitter?.kill();
      }
    } else if (_controller.state == ParticleState.running) {
      if (!_ticker.isActive) {
        _emitter?.init();
        _ticker.start();
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _emitter?.notifier.removeListener(_emitterListener);
    _controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(ParticleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.particlesData != oldWidget.particlesData) {
      _emitter?.onChangeParticlesData(widget.particlesData);
    }
  }
}
