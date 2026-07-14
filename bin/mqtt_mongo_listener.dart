// import 'dart:convert';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// void main() async {
//   // 1. Establish connection to local or cloud MongoDB instances
//   final db = await Db.create("mongodb://localhost:27017/MachineLogsDB");
//   await db.open();
//   print("Connected to MongoDB!");
//   final collection = db.collection("metrics");

//   // 2. Setup MQTT Listener Client
//   final client = MqttServerClient('broker.hivemq.com', 'dart_mongo_subscriber');
//   client.port = 1883;
//   client.keepAlivePeriod = 20;

//   try {
//     print('MQTT Listener connecting to broker...');
//     await client.connect();
//   } catch (e) {
//     print('Exception: $e');
//     client.disconnect();
//     return;
//   }

//   print('MQTT Listener Connected! Listening for changes...');
//   const topic = 'machine/metrics';
//   client.subscribe(topic, MqttQos.atLeastOnce);

//   // 3. Stream Listener to capture arriving data packets
//   client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
//     final recMessage = c![0].payload as MqttPublishMessage;
//     final payloadString = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

//     print('Received payload via MQTT: $payloadString');

//     try {
//       // Decode raw message structure back into JSON map dynamic properties
//       final Map<String, dynamic> documentData = jsonDecode(payloadString);
      
//       // Save data straight into MongoDB collection 
//       await collection.insertOne(documentData);
//       print('Document successfully synchronized into MongoDB collection.');
//     } catch (e) {
//       print('Failed to process message or commit transaction into MongoDB: $e');
//     }
//   });
// }



import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() async {
  // 1. Open Connection connection to local or cloud MongoDB instances
  final db = await Db.create("mongodb://localhost:27017/MachineLogsDB");
  await db.open();
  print("Connected to MongoDB database engine!");
  final collection = db.collection("metrics");

  // 2. Build MQTT subscriber engine linked up to global broker network
  final client = MqttServerClient('broker.hivemq.com', 'dart_mongo_subscriber_node');
  client.port = 1883;
  client.keepAlivePeriod = 20;

  try {
    print('MQTT Ingestion service connecting to broker...');
    await client.connect();
  } catch (e) {
    print('Exception connecting client: $e');
    client.disconnect();
    return;
  }

  print('MQTT Subscriber online! Watching metrics stream...');
  const topic = 'machine/metrics';
  client.subscribe(topic, MqttQos.atLeastOnce);

  // 3. Keep loop open listening continuously to stream changes
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
    final recMessage = c![0].payload as MqttPublishMessage;
    final payloadString = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

    print('\n[MQTT CONSUMER] Captured packet payload string: $payloadString');

    try {
      final Map<String, dynamic> documentData = jsonDecode(payloadString);
      
      // Inject row straight into un-structured collection layer 
      await collection.insertOne(documentData);
      print('[MONGO SUCCESS] Record synchronized into MongoDB collection logs.');
    } catch (e) {
      print('[MONGO INSERT ERROR] Failed to drop structure packet: $e');
    }
  });
}