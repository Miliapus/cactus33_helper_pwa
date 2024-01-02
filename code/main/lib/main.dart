import 'package:flutter/material.dart';
import '../logic/points_info.dart';
import '../view/keyboard.dart';
import '../view/number_map_widget.dart';
import 'package:prepare_widget/prepare_widget.dart';

import 'logic/logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final NumberMapController mapController = NumberMapController((controller) {
    final points = controller.info;
    controller.nextLine = chooseCache.nextLineSmartOf(points);
    controller.nextPosition =
        controller.nextLine != null || points.knownCount == 0
            ? null
            : chooseCache.positions[controller.info.hashCode]?.position;
  });

  MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  NumberMapController get mapController => widget.mapController;

  int? get selected => mapController.selected;

  PointsInfo get info => mapController.info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("仙人彩经"),
        ),
        body: PrepareWidget(
          loading: const Center(
              child: Text("loading", selectionColor: Colors.black)),
          builder: (BuildContext context) async {
            await load();
            return StatefulBuilder(builder: realBody);
          },
        ));
  }

  Widget realBody(BuildContext context, StateSetter setState) {
    final knownCount = info.knownCount,
        keyBoardAbsorbing = selected == null,
        forbid = selected != null &&
                knownCount == 4 &&
                info[selected!] == unKnownNumber
            ? info.numbersUnknown.toSet()
            : <int>{};
    const clearStyle = TextStyle(
      fontSize: 20,
    );
    return Center(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: NumberMapWidget(mapController, () => setState(() {})),
            ),
          ),
          Card(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => mapController.clear()),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "全部重置",
                        style: clearStyle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => mapController.update(unKnownNumber)),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "重置",
                        style: clearStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: KeyBoard(
                    absorbing: keyBoardAbsorbing,
                    onNumberTap: (number) {
                      mapController.update(number);
                      mapController.selected = mapController.nextPosition;
                    },
                    forbid: forbid,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
