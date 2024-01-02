import 'dart:developer';

import 'choose.dart';
import 'pb/model.pb.dart';
import 'package:flutter/services.dart' show rootBundle;

late Map<int, int> positionChoose;
late Map<int, int> lineChoose;

Future<void> load() async {
  log("receive start");
  chooseCache = await rootBundle.loadStructuredBinaryData(
      'data.bin', (data) => ChooseCache.fromBuffer(data.buffer.asUint8List()));
  log("receive finish");
  log("${chooseCache.lines.length} ${chooseCache.positions.length}");
}
