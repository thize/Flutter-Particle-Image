import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

import 'examples/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  ParticleController controller = ParticleController();

  // CurvePoints get _curvePoints {
  //   return CurvePoints(const [
  //     CurvePoint(force: 20, y: 1),
  //     CurvePoint(force: 80, y: 0),
  //   ]);
  // }

  Map<String, Widget> get _examples => {
        'Attracting Moving': AttractionExample(
          controller: controller,
          key: UniqueKey(),
          moving: true,
        ),
        'Coin Attraction': CoinAttractionExample(controller: controller),
        // 'Confetti Burst': ConfettiBurstExample(controller: controller),
        // 'Shine': ShineExample(controller: controller),
        // 'Confetti Full Screen':
        //     ConfettiFullScreenExample(controller: controller),
        // 'Uniform Emitter': UniformEmitterExample(controller: controller),
        // 'Triangle': TriangleExample(controller: controller),
        // 'Attracting Static': AttractionExample(
        //   controller: controller,
        //   key: UniqueKey(),
        //   moving: false,
        // ),

        // 'Test': TestExample(controller: controller),
        // 'Curve Viewer': CurveViewer(toUseCurve: _curvePoints),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _examples.values.elementAt(_index)),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    bool atEnd = _index == _examples.length - 1;
    if (atEnd) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              controller.start();
            },
            child: const Text('Start'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              controller.stop();
            },
            child: const Text('Stop'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              controller.kill();
            },
            child: const Text('Kill'),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Column _topBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _changeIndex(-1);
              },
            ),
            Text('Particle Image Example ${_index + 1} of ${_examples.length}'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _changeIndex(1);
              },
            ),
          ],
        ),
        Text(
          _examples.keys.elementAt(_index),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _changeIndex(int add) {
    // ignore: invalid_use_of_visible_for_testing_member
    _index = (_index + add) % _examples.length;
    setState(() {});
  }
}
