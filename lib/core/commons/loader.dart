import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  SpinKitWave smallLoader()
  {
    return const SpinKitWave(
      color: Colors.black,
      size: 15,
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitSpinningLines(
        color: Colors.black,
      ),
    );
  }
}