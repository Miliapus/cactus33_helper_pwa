import 'dart:io';

import 'package:process_run/process_run.dart';

const target = "../../docs";
const repository = "cactus33_helper_pwa";
void main(List<String> arguments) async {
  delete();
  await build();
  await modify();
}

void delete() {
  final old = Directory(target);
  if (old.existsSync()) {
    old.deleteSync(recursive: true);
  }
}

Future<void> build() async {
  final cmd =
      "flutter build web --base-href  /$repository/ --web-renderer canvaskit -o $target --dart-define=\"buildDate=${DateTime.now().millisecondsSinceEpoch}\"";
  var shell = Shell(workingDirectory: "../main");
  await shell.run(cmd);
}

Future<void> modify() async {
  final filePath = "$target/flutter_service_worker.js";
  final file = File(filePath);
  var content = file.readAsStringSync();
  content = content.replaceFirst(
      "if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {",
      "if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '' || key == \"${"$repository/"}\") {");
  content = content.replaceFirst('''
if (!RESOURCES[key]) {
''', '''var resKey = key.replace("${"$repository/"}", "");
if (!RESOURCES[resKey]) {
''');
  file.writeAsStringSync(content);
}
