import 'package:serverpod/serverpod.dart';
import 'package:reservation_billet_cinema_server/src/endpoints/example_endpoint.dart';

void run(List<String> args) async {
  final pod = runPod(args);

  pod.registerEndpoint(ExampleEndpoint());

  await pod.start();
}
