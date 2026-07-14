// // // // // // // // // // // // // import 'dart:convert';

// // // // // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // // // // // // // // // // // // late Connection conn;

// // // // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // // // //   conn = await Connection.open(
// // // // // // // // // // // // //     Endpoint(
// // // // // // // // // // // // //       host: 'localhost',
// // // // // // // // // // // // //       port: 5432,
// // // // // // // // // // // // //       database: 'Input_Logs',
// // // // // // // // // // // // //       username: 'postgres',
// // // // // // // // // // // // //       password: 'postgres123',
// // // // // // // // // // // // //     ),
// // // // // // // // // // // // //     settings: ConnectionSettings(
// // // // // // // // // // // // //       sslMode: SslMode.disable,
// // // // // // // // // // // // //     ),
// // // // // // // // // // // // //   );

// // // // // // // // // // // // //   print("Connected to PostgreSQL");
// // // // // // // // // // // // // }

// // // // // // // // // // // // // Future<Map<String, dynamic>> loginUser(
// // // // // // // // // // // // //   String username,
// // // // // // // // // // // // //   String password,
// // // // // // // // // // // // // ) async {
// // // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // // //       '''
// // // // // // // // // // // // //       SELECT *
// // // // // // // // // // // // //       FROM users
// // // // // // // // // // // // //       WHERE username=@username
// // // // // // // // // // // // //       ''',
// // // // // // // // // // // // //     ),
// // // // // // // // // // // // //     parameters: {
// // // // // // // // // // // // //       'username': username.trim(),
// // // // // // // // // // // // //     },
// // // // // // // // // // // // //   );

// // // // // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // // // // //     final row = result.first;

// // // // // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // // // // //       return {
// // // // // // // // // // // // //         "success": true,
// // // // // // // // // // // // //         "message": "Login successful",
// // // // // // // // // // // // //         "username": username,
// // // // // // // // // // // // //       };
// // // // // // // // // // // // //     }
// // // // // // // // // // // // //   }

// // // // // // // // // // // // //   return {
// // // // // // // // // // // // //     "success": false,
// // // // // // // // // // // // //     "message": "Invalid username or password",
// // // // // // // // // // // // //   };
// // // // // // // // // // // // // }

// // // // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // // // //   String motorType,
// // // // // // // // // // // // //   String machineId,
// // // // // // // // // // // // //   String testId,
// // // // // // // // // // // // //   String operationName,
// // // // // // // // // // // // // ) async {
// // // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // // //       '''
// // // // // // // // // // // // //       INSERT INTO machine_data
// // // // // // // // // // // // //       (
// // // // // // // // // // // // //         motor_type,
// // // // // // // // // // // // //         machine_id,
// // // // // // // // // // // // //         test_id,
// // // // // // // // // // // // //         operation_name
// // // // // // // // // // // // //       )
// // // // // // // // // // // // //       VALUES
// // // // // // // // // // // // //       (
// // // // // // // // // // // // //         @motor_type,
// // // // // // // // // // // // //         @machine_id,
// // // // // // // // // // // // //         @test_id,
// // // // // // // // // // // // //         @operation_name
// // // // // // // // // // // // //       )
// // // // // // // // // // // // //       RETURNING *
// // // // // // // // // // // // //       '''
// // // // // // // // // // // // //     ),
// // // // // // // // // // // // //     parameters: {
// // // // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // // // // //     },
// // // // // // // // // // // // //   );

// // // // // // // // // // // // //   return {
// // // // // // // // // // // // //     "success": true,
// // // // // // // // // // // // //     "record": result.first.toString(),
// // // // // // // // // // // // //   };
// // // // // // // // // // // // // }

// // // // // // // // // // // // // Future<void> main() async {
// // // // // // // // // // // // //   await connectDB();

// // // // // // // // // // // // //   final router = Router();

// // // // // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // // // // //     try {
// // // // // // // // // // // // //       final body =
// // // // // // // // // // // // //           jsonDecode(await request.readAsString());

// // // // // // // // // // // // //       String username =
// // // // // // // // // // // // //           body['username']?.toString() ?? '';

// // // // // // // // // // // // //       String password =
// // // // // // // // // // // // //           body['password']?.toString() ?? '';

// // // // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // // // //         return Response(
// // // // // // // // // // // // //           400,
// // // // // // // // // // // // //           body: jsonEncode({
// // // // // // // // // // // // //             "message":
// // // // // // // // // // // // //                 "Username and Password required"
// // // // // // // // // // // // //           }),
// // // // // // // // // // // // //           headers: {
// // // // // // // // // // // // //             "Content-Type": "application/json"
// // // // // // // // // // // // //           },
// // // // // // // // // // // // //         );
// // // // // // // // // // // // //       }

// // // // // // // // // // // // //       final result =
// // // // // // // // // // // // //           await loginUser(username, password);

// // // // // // // // // // // // //       if (result["success"]) {
// // // // // // // // // // // // //         return Response.ok(
// // // // // // // // // // // // //           jsonEncode(result),
// // // // // // // // // // // // //           headers: {
// // // // // // // // // // // // //             "Content-Type": "application/json"
// // // // // // // // // // // // //           },
// // // // // // // // // // // // //         );
// // // // // // // // // // // // //       }

// // // // // // // // // // // // //       return Response(
// // // // // // // // // // // // //         401,
// // // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // // //         headers: {
// // // // // // // // // // // // //           "Content-Type": "application/json"
// // // // // // // // // // // // //         },
// // // // // // // // // // // // //       );
// // // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // // //         body: jsonEncode({
// // // // // // // // // // // // //           "message": e.toString()
// // // // // // // // // // // // //         }),
// // // // // // // // // // // // //       );
// // // // // // // // // // // // //     }
// // // // // // // // // // // // //   });

// // // // // // // // // // // // //   router.post('/add-machine-data',
// // // // // // // // // // // // //       (Request request) async {
// // // // // // // // // // // // //     try {
// // // // // // // // // // // // //       final body =
// // // // // // // // // // // // //           jsonDecode(await request.readAsString());

// // // // // // // // // // // // //       String motorType =
// // // // // // // // // // // // //           body['motor_type']?.toString() ?? '';

// // // // // // // // // // // // //       String machineId =
// // // // // // // // // // // // //           body['machine_id']?.toString() ?? '';

// // // // // // // // // // // // //       String testId =
// // // // // // // // // // // // //           body['test_id']?.toString() ?? '';

// // // // // // // // // // // // //       String operationName =
// // // // // // // // // // // // //           body['operation_name']?.toString() ?? '';

// // // // // // // // // // // // //       if (motorType.isEmpty ||
// // // // // // // // // // // // //           machineId.isEmpty ||
// // // // // // // // // // // // //           testId.isEmpty ||
// // // // // // // // // // // // //           operationName.isEmpty) {
// // // // // // // // // // // // //         return Response(
// // // // // // // // // // // // //           400,
// // // // // // // // // // // // //           body: jsonEncode({
// // // // // // // // // // // // //             "message":
// // // // // // // // // // // // //                 "All fields are required"
// // // // // // // // // // // // //           }),
// // // // // // // // // // // // //           headers: {
// // // // // // // // // // // // //             "Content-Type": "application/json"
// // // // // // // // // // // // //           },
// // // // // // // // // // // // //         );
// // // // // // // // // // // // //       }

// // // // // // // // // // // // //       final result = await insertMachineData(
// // // // // // // // // // // // //         motorType,
// // // // // // // // // // // // //         machineId,
// // // // // // // // // // // // //         testId,
// // // // // // // // // // // // //         operationName,
// // // // // // // // // // // // //       );

// // // // // // // // // // // // //       return Response(
// // // // // // // // // // // // //         201,
// // // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // // //         headers: {
// // // // // // // // // // // // //           "Content-Type": "application/json"
// // // // // // // // // // // // //         },
// // // // // // // // // // // // //       );
// // // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // // //         body: jsonEncode({
// // // // // // // // // // // // //           "message": e.toString()
// // // // // // // // // // // // //         }),
// // // // // // // // // // // // //       );
// // // // // // // // // // // // //     }
// // // // // // // // // // // // //   });

// // // // // // // // // // // // //   final handler = Pipeline()
// // // // // // // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // // // // // // //       .addMiddleware(logRequests())
// // // // // // // // // // // // //       .addHandler(router.call);

// // // // // // // // // // // // //   await io.serve(
// // // // // // // // // // // // //     handler,
// // // // // // // // // // // // //     '0.0.0.0',
// // // // // // // // // // // // //     3000,
// // // // // // // // // // // // //   );

// // // // // // // // // // // // //   print(
// // // // // // // // // // // // //     "Server running on http://localhost:3000",
// // // // // // // // // // // // //   );
// // // // // // // // // // // // // }




// // // // // // // // // // // // import 'dart:convert';

// // // // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // // // // // // // // // // // late Connection conn;

// // // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // // //   conn = await Connection.open(
// // // // // // // // // // // //     Endpoint(
// // // // // // // // // // // //       host: 'localhost',
// // // // // // // // // // // //       port: 5432,
// // // // // // // // // // // //       database: 'Input_Logs',
// // // // // // // // // // // //       username: 'postgres',
// // // // // // // // // // // //       password: 'postgres123',
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     settings: ConnectionSettings(
// // // // // // // // // // // //       sslMode: SslMode.disable,
// // // // // // // // // // // //     ),
// // // // // // // // // // // //   );

// // // // // // // // // // // //   print("Connected to PostgreSQL");
// // // // // // // // // // // // }

// // // // // // // // // // // // Future<Map<String, dynamic>> loginUser(
// // // // // // // // // // // //   String username,
// // // // // // // // // // // //   String password,
// // // // // // // // // // // // ) async {
// // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // //       '''
// // // // // // // // // // // //       SELECT *
// // // // // // // // // // // //       FROM users
// // // // // // // // // // // //       WHERE username=@username
// // // // // // // // // // // //       ''',
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     parameters: {
// // // // // // // // // // // //       'username': username.trim(),
// // // // // // // // // // // //     },
// // // // // // // // // // // //   );

// // // // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // // // //     final row = result.first;

// // // // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // // // //       return {
// // // // // // // // // // // //         "success": true,
// // // // // // // // // // // //         "message": "Login successful",
// // // // // // // // // // // //         "username": username,
// // // // // // // // // // // //       };
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }

// // // // // // // // // // // //   return {
// // // // // // // // // // // //     "success": false,
// // // // // // // // // // // //     "message": "Invalid username or password",
// // // // // // // // // // // //   };
// // // // // // // // // // // // }

// // // // // // // // // // // // // Updated handler function signature to accept field1 and field2 parameters
// // // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // // //   String motorType,
// // // // // // // // // // // //   String machineId,
// // // // // // // // // // // //   String testId,
// // // // // // // // // // // //   String operationName,
// // // // // // // // // // // //   String field1,
// // // // // // // // // // // //   String field2,
// // // // // // // // // // // // ) async {
// // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // //       '''
// // // // // // // // // // // //       INSERT INTO machine_data
// // // // // // // // // // // //       (
// // // // // // // // // // // //         motor_type,
// // // // // // // // // // // //         machine_id,
// // // // // // // // // // // //         test_id,
// // // // // // // // // // // //         operation_name,
// // // // // // // // // // // //         field_1,
// // // // // // // // // // // //         field_2
// // // // // // // // // // // //       )
// // // // // // // // // // // //       VALUES
// // // // // // // // // // // //       (
// // // // // // // // // // // //         @motor_type,
// // // // // // // // // // // //         @machine_id,
// // // // // // // // // // // //         @test_id,
// // // // // // // // // // // //         @operation_name,
// // // // // // // // // // // //         @field_1,
// // // // // // // // // // // //         @field_2
// // // // // // // // // // // //       )
// // // // // // // // // // // //       RETURNING *
// // // // // // // // // // // //       '''
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     parameters: {
// // // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // // // //       "field_1": field1,
// // // // // // // // // // // //       "field_2": field2,
// // // // // // // // // // // //     },
// // // // // // // // // // // //   );

// // // // // // // // // // // //   return {
// // // // // // // // // // // //     "success": true,
// // // // // // // // // // // //     "record": result.first.toString(),
// // // // // // // // // // // //   };
// // // // // // // // // // // // }

// // // // // // // // // // // // Future<void> main() async {
// // // // // // // // // // // //   await connectDB();

// // // // // // // // // // // //   final router = Router();

// // // // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // // //         return Response(
// // // // // // // // // // // //           400,
// // // // // // // // // // // //           body: jsonEncode({"message": "Username and Password required"}),
// // // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       final result = await loginUser(username, password);

// // // // // // // // // // // //       if (result["success"]) {
// // // // // // // // // // // //         return Response.ok(
// // // // // // // // // // // //           jsonEncode(result),
// // // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       return Response(
// // // // // // // // // // // //         401,
// // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //       );
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // // //       );
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });

// // // // // // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // // // // // //       String field1 = body['field_1']?.toString() ?? ''; // Captured Field 1
// // // // // // // // // // // //       String field2 = body['field_2']?.toString() ?? ''; // Captured Field 2

// // // // // // // // // // // //       if (motorType.isEmpty ||
// // // // // // // // // // // //           machineId.isEmpty ||
// // // // // // // // // // // //           testId.isEmpty ||
// // // // // // // // // // // //           operationName.isEmpty ||
// // // // // // // // // // // //           field1.isEmpty ||
// // // // // // // // // // // //           field2.isEmpty) {
// // // // // // // // // // // //         return Response(
// // // // // // // // // // // //           400,
// // // // // // // // // // // //           body: jsonEncode({"message": "All fields are required"}),
// // // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       final result = await insertMachineData(
// // // // // // // // // // // //         motorType,
// // // // // // // // // // // //         machineId,
// // // // // // // // // // // //         testId,
// // // // // // // // // // // //         operationName,
// // // // // // // // // // // //         field1,
// // // // // // // // // // // //         field2,
// // // // // // // // // // // //       );

// // // // // // // // // // // //       return Response(
// // // // // // // // // // // //         201,
// // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //       );
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // // //       );
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });

// // // // // // // // // // // //   final handler = Pipeline()
// // // // // // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // // // // // //       .addMiddleware(logRequests())
// // // // // // // // // // // //       .addHandler(router.call);

// // // // // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);

// // // // // // // // // // // //   print("Server running on http://localhost:3000");
// // // // // // // // // // // // }





// // // // // // // // // // // // direct mqtt

// // // // // // // // // // // // import 'dart:convert';
// // // // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // // // // // late Connection conn;
// // // // // // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // // // // // ==========================================
// // // // // // // // // // // // // 1. POSTGRESQL CONNECTION & OPERATIONS
// // // // // // // // // // // // // ==========================================
// // // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // // //   conn = await Connection.open(
// // // // // // // // // // // //     Endpoint(
// // // // // // // // // // // //       host: 'localhost',
// // // // // // // // // // // //       port: 5432,
// // // // // // // // // // // //       database: 'Input_Logs',
// // // // // // // // // // // //       username: 'postgres',
// // // // // // // // // // // //       password: 'postgres123',
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     settings: ConnectionSettings(
// // // // // // // // // // // //       sslMode: SslMode.disable,
// // // // // // // // // // // //     ),
// // // // // // // // // // // //   );

// // // // // // // // // // // //   print("Connected to PostgreSQL");
// // // // // // // // // // // // }

// // // // // // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // //       '''
// // // // // // // // // // // //       SELECT *
// // // // // // // // // // // //       FROM users
// // // // // // // // // // // //       WHERE username=@username
// // // // // // // // // // // //       ''',
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     parameters: {
// // // // // // // // // // // //       'username': username.trim(),
// // // // // // // // // // // //     },
// // // // // // // // // // // //   );

// // // // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // // // //     final row = result.first;
// // // // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // // // //       return {
// // // // // // // // // // // //         "success": true,
// // // // // // // // // // // //         "message": "Login successful",
// // // // // // // // // // // //         "username": username,
// // // // // // // // // // // //       };
// // // // // // // // // // // //     }
// // // // // // // // // // // //   }

// // // // // // // // // // // //   return {
// // // // // // // // // // // //     "success": false,
// // // // // // // // // // // //     "message": "Invalid username or password",
// // // // // // // // // // // //   };
// // // // // // // // // // // // }

// // // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // // //   String motorType,
// // // // // // // // // // // //   String machineId,
// // // // // // // // // // // //   String testId,
// // // // // // // // // // // //   String operationName,
// // // // // // // // // // // //   String field1,
// // // // // // // // // // // //   String field2,
// // // // // // // // // // // // ) async {
// // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // //       '''
// // // // // // // // // // // //       INSERT INTO machine_data
// // // // // // // // // // // //       (
// // // // // // // // // // // //         motor_type,
// // // // // // // // // // // //         machine_id,
// // // // // // // // // // // //         test_id,
// // // // // // // // // // // //         operation_name,
// // // // // // // // // // // //         field_1,
// // // // // // // // // // // //         field_2
// // // // // // // // // // // //       )
// // // // // // // // // // // //       VALUES
// // // // // // // // // // // //       (
// // // // // // // // // // // //         @motor_type,
// // // // // // // // // // // //         @machine_id,
// // // // // // // // // // // //         @test_id,
// // // // // // // // // // // //         @operation_name,
// // // // // // // // // // // //         @field_1,
// // // // // // // // // // // //         @field_2
// // // // // // // // // // // //       )
// // // // // // // // // // // //       RETURNING *
// // // // // // // // // // // //       '''
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     parameters: {
// // // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // // // //       "field_1": field1,
// // // // // // // // // // // //       "field_2": field2,
// // // // // // // // // // // //     },
// // // // // // // // // // // //   );

// // // // // // // // // // // //   return {
// // // // // // // // // // // //     "success": true,
// // // // // // // // // // // //     "record": result.first.toString(),
// // // // // // // // // // // //   };
// // // // // // // // // // // // }

// // // // // // // // // // // // // ==========================================
// // // // // // // // // // // // // 2. MQTT BROKER PUBLISHER CONNECTION
// // // // // // // // // // // // // ==========================================
// // // // // // // // // // // // Future<void> connectMQTT() async {
// // // // // // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'dart_backend_publisher');
// // // // // // // // // // // //   mqttClient.port = 1883;
// // // // // // // // // // // //   mqttClient.logging(on: false);
// // // // // // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // // // // // //   try {
// // // // // // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // // // // // //     await mqttClient.connect();
// // // // // // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // // // // // //   } catch (e) {
// // // // // // // // // // // //     print('MQTT Connection exception: $e');
// // // // // // // // // // // //     mqttClient.disconnect();
// // // // // // // // // // // //   }
// // // // // // // // // // // // }

// // // // // // // // // // // // void publishMachineData(Map<String, dynamic> data) {
// // // // // // // // // // // //   const String topic = 'machine/metrics';
// // // // // // // // // // // //   final builder = MqttClientPayloadBuilder();
// // // // // // // // // // // //   builder.addString(jsonEncode(data));

// // // // // // // // // // // //   if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // // // // //     mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // // // // //     print('Published data to MQTT topic: $topic');
// // // // // // // // // // // //   } else {
// // // // // // // // // // // //     print('MQTT client not connected, skipping publish.');
// // // // // // // // // // // //   }
// // // // // // // // // // // // }

// // // // // // // // // // // // // ==========================================
// // // // // // // // // // // // // 3. MAIN SERVER ROUTING ENTRYPOINT
// // // // // // // // // // // // // ==========================================
// // // // // // // // // // // // Future<void> main() async {
// // // // // // // // // // // //   await connectDB();   // This will now resolve perfectly
// // // // // // // // // // // //   await connectMQTT(); // This will now resolve perfectly

// // // // // // // // // // // //   final router = Router();

// // // // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // // //         return Response(
// // // // // // // // // // // //           400,
// // // // // // // // // // // //           body: jsonEncode({"message": "Username and Password required"}),
// // // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       final result = await loginUser(username, password);

// // // // // // // // // // // //       if (result["success"]) {
// // // // // // // // // // // //         return Response.ok(
// // // // // // // // // // // //           jsonEncode(result),
// // // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       return Response(
// // // // // // // // // // // //         401,
// // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //       );
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // // //       );
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });

// // // // // // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // // // // // //       String field1 = body['field_1']?.toString() ?? ''; 
// // // // // // // // // // // //       String field2 = body['field_2']?.toString() ?? ''; 

// // // // // // // // // // // //       if (motorType.isEmpty ||
// // // // // // // // // // // //           machineId.isEmpty ||
// // // // // // // // // // // //           testId.isEmpty ||
// // // // // // // // // // // //           operationName.isEmpty ||
// // // // // // // // // // // //           field1.isEmpty ||
// // // // // // // // // // // //           field2.isEmpty) {
// // // // // // // // // // // //         return Response(
// // // // // // // // // // // //           400,
// // // // // // // // // // // //           body: jsonEncode({"message": "All fields are required"}),
// // // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       // 1. Insert directly into Postgres 
// // // // // // // // // // // //       final result = await insertMachineData(
// // // // // // // // // // // //         motorType,
// // // // // // // // // // // //         machineId,
// // // // // // // // // // // //         testId,
// // // // // // // // // // // //         operationName,
// // // // // // // // // // // //         field1,
// // // // // // // // // // // //         field2,
// // // // // // // // // // // //       );

// // // // // // // // // // // //       // 2. Publish to MQTT Broker for MongoDB Ingestion
// // // // // // // // // // // //       publishMachineData({
// // // // // // // // // // // //         "motor_type": motorType,
// // // // // // // // // // // //         "machine_id": machineId,
// // // // // // // // // // // //         "test_id": testId,
// // // // // // // // // // // //         "operation_name": operationName,
// // // // // // // // // // // //         "field_1": field1,
// // // // // // // // // // // //         "field_2": field2,
// // // // // // // // // // // //         "timestamp": DateTime.now().toIso8601String()
// // // // // // // // // // // //       });

// // // // // // // // // // // //       return Response(
// // // // // // // // // // // //         201,
// // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // // //       );
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // // //       );
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });

// // // // // // // // // // // //   final handler = Pipeline()
// // // // // // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // // // // // //       .addMiddleware(logRequests())
// // // // // // // // // // // //       .addHandler(router.call);

// // // // // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);

// // // // // // // // // // // //   print("Server running on http://localhost:3000");
// // // // // // // // // // // // }





// // // // // // // // // // // import 'dart:convert';
// // // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // // // // late Connection conn;
// // // // // // // // // // // late Connection listenConn; // Separate connection dedicated solely to LISTEN
// // // // // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // //   // final endpoint = Endpoint(
// // // // // // // // // // //   //   host: 'localhost',
// // // // // // // // // // //   //   port: 5432,
// // // // // // // // // // //   //   database: 'Input_Logs',
// // // // // // // // // // //   //   username: 'postgres',
// // // // // // // // // // //   //   password: 'postgres123',
// // // // // // // // // // //   // );
  
// // // // // // // // // // //   final endpoint = Endpoint(
// // // // // // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // // // //   port: 5432,
// // // // // // // // // // //   database: 'neondb',
// // // // // // // // // // //   username: 'neondb_owner',
// // // // // // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // // // // // );

// // // // // // // // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // // //   // Connection for executing normal queries
// // // // // // // // // // //   conn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // // //   print("Connected to PostgreSQL (Query Client)");

// // // // // // // // // // //   // Persistent connection dedicated to receiving LISTEN events
// // // // // // // // // // //   listenConn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // // // // }

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> connectMQTT() async {
// // // // // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // // // // //   mqttClient.port = 1883;
// // // // // // // // // // //   mqttClient.logging(on: false);
// // // // // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // // // // //   try {
// // // // // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // // // // //     await mqttClient.connect();
// // // // // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // // // // //   } catch (e) {
// // // // // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // // // // //     mqttClient.disconnect();
// // // // // // // // // // //   }
// // // // // // // // // // // }

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // // // // // //   // Instruct Postgres to begin listening on our custom channel
// // // // // // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // // // // // //   // Stream listener that captures broadcasts continuously
// // // // // // // // // // // //   listenConn.channels['machine_channel'].listen((notification) {
// // // // // // // // // // // //     final String? payload = notification.payload;
    
// // // // // // // // // // // //     if (payload != null) {
// // // // // // // // // // // //       print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // // // // // //       // Forward directly over MQTT
// // // // // // // // // // // //       if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // // // // //         final builder = MqttClientPayloadBuilder();
// // // // // // // // // // // //         builder.addString(payload);

// // // // // // // // // // // //         mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // // // // //         print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // // // // // //       } else {
// // // // // // // // // // // //         print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // // // // // //       }
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });
// // // // // // // // // // // // }


// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // // // // //   // Instruct Postgres to begin listening on our custom channel
// // // // // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // // // // //   // In postgres v3+, the notification stream yields String directly
// // // // // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // // // // //     // Forward directly over MQTT
// // // // // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // // // // //       builder.addString(payload);

// // // // // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // // // // //     } else {
// // // // // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // // // // //     }
// // // // // // // // // // //   });
// // // // // // // // // // // }

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // // // // //   );

// // // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // // //     final row = result.first;
// // // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // // // // //     }
// // // // // // // // // // //   }
// // // // // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // // // // }

// // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // // // // // ) async {
// // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // //     Sql.named('''
// // // // // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // // // // // //       RETURNING *
// // // // // // // // // // //     '''),
// // // // // // // // // // //     parameters: {
// // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // // //       "field_1": field1,
// // // // // // // // // // //       "field_2": field2,
// // // // // // // // // // //     },
// // // // // // // // // // //   );

// // // // // // // // // // //   return {"success": true, "record": result.first.toString()};
// // // // // // // // // // // }

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> main() async {
// // // // // // // // // // //   await connectDB();
// // // // // // // // // // //   await connectMQTT();
  
// // // // // // // // // // //   // Launch the asynchronous Listen -> Publish loop runner
// // // // // // // // // // //   startPostgresListenBridge(); 

// // // // // // // // // // //   final router = Router();

// // // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // // // //       }

// // // // // // // // // // //       final result = await loginUser(username, password);
// // // // // // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // // // //     }
// // // // // // // // // // //   });

// // // // // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // // // // // //       String field2 = body['field_2']?.toString() ?? '';

// // // // // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // // // //       }

// // // // // // // // // // //       // Perform standard SQL insert. The DB trigger executes the broadcast pipeline.
// // // // // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);

// // // // // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // // // //     }
// // // // // // // // // // //   });

// // // // // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // // // // // }



// // // // // // // // // // import 'dart:convert';
// // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // // // late Connection conn;
// // // // // // // // // // late Connection listenConn; 
// // // // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // //   final endpoint = Endpoint(
// // // // // // // // // // //     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // // // //     port: 5432,
// // // // // // // // // // //     database: 'neondb',
// // // // // // // // // // //     username: 'neondb_owner',
// // // // // // // // // // //     password: 'npg_mT9C4KeOaJVN',
// // // // // // // // // // //   );

// // // // // // // // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // // //   conn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // // //   print("Connected to PostgreSQL (Query Client)");

// // // // // // // // // // //   listenConn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // // // // }

// // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // //   final endpoint = Endpoint(
// // // // // // // // // //     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // // //     port: 5432,
// // // // // // // // // //     database: 'neondb',
// // // // // // // // // //     username: 'neondb_owner',
// // // // // // // // // //     password: 'npg_mT9C4KeOaJVN',
// // // // // // // // // //   );

// // // // // // // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // //   bool connected = false;
// // // // // // // // // //   while (!connected) {
// // // // // // // // // //     try {
// // // // // // // // // //       conn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // //       listenConn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // //       print("Connected to PostgreSQL");
// // // // // // // // // //       connected = true;
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // // // //     }
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<void> connectMQTT() async {
// // // // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // // // //   mqttClient.port = 1883;
// // // // // // // // // //   mqttClient.logging(on: false);
// // // // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // // // //   try {
// // // // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // // // //     await mqttClient.connect();
// // // // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // // // //   } catch (e) {
// // // // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // // // //     mqttClient.disconnect();
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // // // //       builder.addString(payload);

// // // // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // // // //     } else {
// // // // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // // // //     }
// // // // // // // // // //   });
// // // // // // // // // // }

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // // // //   );

// // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // //     final row = result.first;
// // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // // // //     }
// // // // // // // // // //   }
// // // // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // // // }

// // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // // // // ) async {
// // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // //     Sql.named('''
// // // // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // // // // //       RETURNING *
// // // // // // // // // //     '''),
// // // // // // // // // //     parameters: {
// // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // //       "test_id": testId,
// // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // //       "field_1": double.tryParse(field1) ?? 0.0,
// // // // // // // // // //       "field_2": double.tryParse(field2) ?? 0.0,
// // // // // // // // // //     },
// // // // // // // // // //   );

// // // // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // // // }

// // // // // // // // // // // Query Function to select all logs from target table data_lsit
// // // // // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM data_lsit ORDER BY id ASC'
// // // // // // // // // //   );
  
// // // // // // // // // //   return result.map((row) {
// // // // // // // // // //     final map = row.toColumnMap();
// // // // // // // // // //     return {
// // // // // // // // // //       "id": map["id"],
// // // // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // // // //       "test_id": map["test_id"],
// // // // // // // // // //       "operation_name": map["operation_name"],
// // // // // // // // // //       "field_1": map["field_1"],
// // // // // // // // // //       "field_2": map["field_2"],
// // // // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // // // //     };
// // // // // // // // // //   }).toList();
// // // // // // // // // // }

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<void> main() async {
// // // // // // // // // //   await connectDB();
// // // // // // // // // //   await connectMQTT();
  
// // // // // // // // // //   startPostgresListenBridge(); 

// // // // // // // // // //   final router = Router();

// // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // //     try {
// // // // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // // //       }

// // // // // // // // // //       final result = await loginUser(username, password);
// // // // // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // // //     }
// // // // // // // // // //   });

// // // // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // // // //     try {
// // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // // // // //       String field2 = body['field_2']?.toString() ?? '';

// // // // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // // //       }

// // // // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
// // // // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // // //     }
// // // // // // // // // //   });

// // // // // // // // // //   // GET Endpoint targeting data_lsit 
// // // // // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // // // // //     try {
// // // // // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // // //     }
// // // // // // // // // //   });

// // // // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // // // // }


// // // // // // // // // import 'dart:convert';
// // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // // late Connection conn;
// // // // // // // // // late Connection listenConn; 
// // // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // // ==========================================
// // // // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // // // ==========================================
// // // // // // // // // final _pgEndpoint = Endpoint(
// // // // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // //   port: 5432,
// // // // // // // // //   database: 'neondb',
// // // // // // // // //   username: 'neondb_owner',
// // // // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // // // );

// // // // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // // // Neon's free-tier compute auto-suspends after a period of inactivity,
// // // // // // // // // // which silently drops any open connection — this helper is what lets
// // // // // // // // // // us open a fresh one again on demand, instead of only at server startup.
// // // // // // // // // Future<Connection> _openConnection() async {
// // // // // // // // //   while (true) {
// // // // // // // // //     try {
// // // // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // // // //     } catch (e) {
// // // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // // }

// // // // // // // // // Future<void> connectDB() async {
// // // // // // // // //   conn = await _openConnection();
// // // // // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // // // // //   listenConn = await _openConnection();
// // // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // // }

// // // // // // // // // // Runs a query; if it fails because the connection has gone stale
// // // // // // // // // // (e.g. Neon suspended the compute and dropped it), reopens just the
// // // // // // // // // // query connection and retries the action once before giving up.
// // // // // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // // // // //   try {
// // // // // // // // //     return await action();
// // // // // // // // //   } catch (e) {
// // // // // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // // // // //     conn = await _openConnection();
// // // // // // // // //     return await action();
// // // // // // // // //   }
// // // // // // // // // }

// // // // // // // // // // ==========================================
// // // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // // ==========================================
// // // // // // // // // Future<void> connectMQTT() async {
// // // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // // //   mqttClient.port = 1883;
// // // // // // // // //   mqttClient.logging(on: false);
// // // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // // //   try {
// // // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // // //     await mqttClient.connect();
// // // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // // //   } catch (e) {
// // // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // // //     mqttClient.disconnect();
// // // // // // // // //   }
// // // // // // // // // }

// // // // // // // // // // ==========================================
// // // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // // ==========================================
// // // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // // //       builder.addString(payload);

// // // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // // //     } else {
// // // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // // //     }
// // // // // // // // //   });
// // // // // // // // // }

// // // // // // // // // // ==========================================
// // // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // // ==========================================
// // // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // // //   ));

// // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // //     final row = result.first;
// // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // //     if (dbPassword == password) {
// // // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // // }

// // // // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // // // ) async {
// // // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // // //     Sql.named('''
// // // // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // // // //       RETURNING *
// // // // // // // // //     '''),
// // // // // // // // //     parameters: {
// // // // // // // // //       "motor_type": motorType,
// // // // // // // // //       "machine_id": machineId,
// // // // // // // // //       "test_id": testId,
// // // // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // // // //     },
// // // // // // // // //   ));

// // // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // // }

// // // // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // // // //   ));
  
// // // // // // // // //   return result.map((row) {
// // // // // // // // //     final map = row.toColumnMap();
// // // // // // // // //     return {
// // // // // // // // //       "id": map["id"],
// // // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // // //       "test_id": map["test_id"],
// // // // // // // // //       "temprature1": map["temprature1"],
// // // // // // // // //       "temprature2": map["temprature2"],
// // // // // // // // //       "temprature3": map["temprature3"],
// // // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // // //     };
// // // // // // // // //   }).toList();
// // // // // // // // // }

// // // // // // // // // // ==========================================
// // // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // // ==========================================
// // // // // // // // // Future<void> main() async {
// // // // // // // // //   await connectDB();
// // // // // // // // //   await connectMQTT();
  
// // // // // // // // //   startPostgresListenBridge(); 

// // // // // // // // //   final router = Router();

// // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // //     try {
// // // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // //       }

// // // // // // // // //       final result = await loginUser(username, password);
// // // // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // //     }
// // // // // // // // //   });

// // // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // // //     try {
// // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // //       }

// // // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // //     }
// // // // // // // // //   });

// // // // // // // // //   // GET Endpoint targeting data_list
// // // // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // // // //     try {
// // // // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // //     }
// // // // // // // // //   });

// // // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // // // }



// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // late Connection conn;
// // // // // // // // late Connection listenConn;
// // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // ==========================================
// // // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // // ==========================================
// // // // // // // // final _pgEndpoint = Endpoint(
// // // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // //   port: 5432,
// // // // // // // //   database: 'neondb',
// // // // // // // //   username: 'neondb_owner',
// // // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // // );

// // // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // Future<Connection> _openConnection() async {
// // // // // // // //   while (true) {
// // // // // // // //     try {
// // // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // // //     } catch (e) {
// // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // Future<void> connectDB() async {
// // // // // // // //   conn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // // // //   listenConn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // }

// // // // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // // // //   try {
// // // // // // // //     return await action();
// // // // // // // //   } catch (e) {
// // // // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // // // //     conn = await _openConnection();
// // // // // // // //     return await action();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> connectMQTT() async {
// // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // //   mqttClient.port = 1883;
// // // // // // // //   mqttClient.logging(on: false);
// // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // //   try {
// // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // //     await mqttClient.connect();
// // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // //   } catch (e) {
// // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // //     mqttClient.disconnect();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // //       builder.addString(payload);

// // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // //     } else {
// // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // //     }
// // // // // // // //   });
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // ==========================================
// // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // //   ));

// // // // // // // //   if (result.isNotEmpty) {
// // // // // // // //     final row = result.first;
// // // // // // // //     String dbPassword = row[2].toString();
// // // // // // // //     if (dbPassword == password) {
// // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // }

// // // // // // // // // Inserts a new row into machine_data
// // // // // // // // // Columns: motor_type, machine_id, test_id, operation_name, field_1, field_2
// // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // //   String motorType,
// // // // // // // //   String machineId,
// // // // // // // //   String testId,
// // // // // // // //   String operationName,
// // // // // // // //   double field1,
// // // // // // // //   double field2,
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "operation_name": operationName,
// // // // // // // //       "field_1": field1,
// // // // // // // //       "field_2": field2,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query all logs from machine_data
// // // // // // // // Future<List<Map<String, dynamic>>> fetchMachineData() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC',
// // // // // // // //   ));

// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "operation_name": map["operation_name"],
// // // // // // // //       "field_1": map["field_1"],
// // // // // // // //       "field_2": map["field_2"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // ==========================================
// // // // // // // // Future<void> main() async {
// // // // // // // //   await connectDB();
// // // // // // // //   await connectMQTT();

// // // // // // // //   startPostgresListenBridge();

// // // // // // // //   final router = Router();

// // // // // // // //   // POST /login
// // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // //         return Response(400,
// // // // // // // //             body: jsonEncode({"message": "Username/Password required"}),
// // // // // // // //             headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await loginUser(username, password);
// // // // // // // //       return Response(result["success"] ? 200 : 401,
// // // // // // // //           body: jsonEncode(result),
// // // // // // // //           headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // POST /add-machine-data — inserts into machine_data table
// // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType     = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId     = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId        = body['test_id']?.toString() ?? '';
// // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // //       double field1        = double.tryParse(body['field_1']?.toString() ?? '') ?? 0.0;
// // // // // // // //       double field2        = double.tryParse(body['field_2']?.toString() ?? '') ?? 0.0;

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty) {
// // // // // // // //         return Response(400,
// // // // // // // //             body: jsonEncode({"message": "motor_type, machine_id, test_id, and operation_name are required"}),
// // // // // // // //             headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
// // // // // // // //       return Response(201,
// // // // // // // //           body: jsonEncode(result),
// // // // // // // //           headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET /get-machine-data — fetches all rows from machine_data
// // // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchMachineData();
// // // // // // // //       return Response.ok(jsonEncode(logs),
// // // // // // // //           headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   final handler = Pipeline()
// // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // //       .addMiddleware(logRequests())
// // // // // // // //       .addHandler(router.call);

// // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // // }









// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // late Connection conn;
// // // // // // // // late Connection listenConn;  
// // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // ==========================================
// // // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // // ==========================================
// // // // // // // // final _pgEndpoint = Endpoint(
// // // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // //   port: 5432,
// // // // // // // //   database: 'neondb',
// // // // // // // //   username: 'neondb_owner',
// // // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // // );

// // // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // // Neon's free-tier compute auto-suspends after a period of inactivity,
// // // // // // // // // which silently drops any open connection — this helper is what lets
// // // // // // // // // us open a fresh one again on demand, instead of only at server startup.
// // // // // // // // Future<Connection> _openConnection() async {
// // // // // // // //   while (true) {
// // // // // // // //     try {
// // // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // // //     } catch (e) {
// // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // Future<void> connectDB() async {
// // // // // // // //   conn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // // // //   listenConn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // }

// // // // // // // // // Runs a query; if it fails because the connection has gone stale
// // // // // // // // // (e.g. Neon suspended the compute and dropped it), reopens just the
// // // // // // // // // query connection and retries the action once before giving up.
// // // // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // // // //   try {
// // // // // // // //     return await action();
// // // // // // // //   } catch (e) {
// // // // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // // // //     conn = await _openConnection();
// // // // // // // //     return await action();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> connectMQTT() async {
// // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // //   mqttClient.port = 1883;
// // // // // // // //   mqttClient.logging(on: false);
// // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // //   try {
// // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // //     await mqttClient.connect();
// // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // //   } catch (e) {
// // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // //     mqttClient.disconnect();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // //       builder.addString(payload);

// // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // //     } else {
// // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // //     }
// // // // // // // //   });
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // ==========================================
// // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // //   ));

// // // // // // // //   if (result.isNotEmpty) {
// // // // // // // //     final row = result.first;
// // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // //     if (dbPassword == password) {
// // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // }

// // // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // // //   ));
  
// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "temprature1": map["temprature1"],
// // // // // // // //       "temprature2": map["temprature2"],
// // // // // // // //       "temprature3": map["temprature3"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ------------------------------------------
// // // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // // This is a completely independent table/endpoint pair from data_list above —
// // // // // // // // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // // // // // // // ------------------------------------------

// // // // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "operation_name": operationName,
// // // // // // // //       "field_1": field1,
// // // // // // // //       "field_2": field2,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query Function to select all rows from target table machine_data
// // // // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC'
// // // // // // // //   ));

// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "operation_name": map["operation_name"],
// // // // // // // //       "field_1": map["field_1"],
// // // // // // // //       "field_2": map["field_2"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // ==========================================
// // // // // // // // Future<void> main() async {
// // // // // // // //   await connectDB();
// // // // // // // //   await connectMQTT();
  
// // // // // // // //   startPostgresListenBridge(); 

// // // // // // // //   final router = Router();

// // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await loginUser(username, password);
// // // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET Endpoint targeting data_list
// // // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // ------------------------------------------
// // // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // // //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
// // // // // // // //   // ------------------------------------------
// // // // // // // //   router.post('/add-machine-record', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // // //       String field2 = body['field_2']?.toString() ?? '';

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2);
// // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET Endpoint targeting machine_data
// // // // // // // //   router.get('/get-machine-records', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchMachineRecordsFromDB();
// // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // // }



// // // // // // // // import 'dart:async';
// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // late Connection conn;
// // // // // // // // late Connection listenConn; 
// // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // ==========================================
// // // // // // // // // 1. DATABASE CONNECTIVITY (fully local — no cloud)
// // // // // // // // // ==========================================
// // // // // // // // final _pgEndpoint = Endpoint(
// // // // // // // //   host: '192.168.50.167',
// // // // // // // //   port: 5432,
// // // // // // // //   database: 'Railway',
// // // // // // // //   username: 'postgres',
// // // // // // // //   password: 'postgres123',
// // // // // // // // );

// // // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.disable, connectTimeout: const Duration(seconds: 5));

// // // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // // On localhost the most common reason this fails is simply that the
// // // // // // // // // PostgreSQL Windows service hasn't started yet — this keeps retrying
// // // // // // // // // until it's up, so you don't have to manually restart the Dart server.
// // // // // // // // Future<Connection> _openConnection() async {
// // // // // // // //   while (true) {
// // // // // // // //     try {
// // // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // // //     } catch (e) {
// // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // //       print("  (Is the local PostgreSQL service running? Check services.msc → postgresql-x64-...)");
// // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // Future<void> connectDB() async {
// // // // // // // //   conn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // // // //   listenConn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // }

// // // // // // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // // // // // reopens just the query connection and retries the action once before giving up.
// // // // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // // // //   try {
// // // // // // // //     return await action();
// // // // // // // //   } catch (e) {
// // // // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // // // //     conn = await _openConnection();
// // // // // // // //     return await action();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> connectMQTT() async {
// // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // //   mqttClient.port = 1883;
// // // // // // // //   mqttClient.logging(on: false);
// // // // // // // //   mqttClient.keepAlivePeriod = 20;
// // // // // // // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // // // // // // //   try {
// // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // //     await mqttClient.connect();
// // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // //   } catch (e) {
// // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // //     mqttClient.disconnect();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // //       builder.addString(payload);

// // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // //     } else {
// // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // //     }
// // // // // // // //   });
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // ==========================================
// // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // //   ));

// // // // // // // //   if (result.isNotEmpty) {
// // // // // // // //     final row = result.first;
// // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // //     if (dbPassword == password) {
// // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // }

// // // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // // //   ));
  
// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "temprature1": map["temprature1"],
// // // // // // // //       "temprature2": map["temprature2"],
// // // // // // // //       "temprature3": map["temprature3"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ------------------------------------------
// // // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // // This is a completely independent table/endpoint pair from data_list above —
// // // // // // // // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // // // // // // // ------------------------------------------

// // // // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "operation_name": operationName,
// // // // // // // //       "field_1": field1,
// // // // // // // //       "field_2": field2,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query Function to select all rows from target table machine_data
// // // // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC'
// // // // // // // //   ));

// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "operation_name": map["operation_name"],
// // // // // // // //       "field_1": map["field_1"],
// // // // // // // //       "field_2": map["field_2"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // ==========================================
// // // // // // // // Future<void> main() async {
// // // // // // // //   // Only Postgres is required for login/dashboard/form routes to work,
// // // // // // // //   // so that's the only thing we block server startup on.
// // // // // // // //   await connectDB();

// // // // // // // //   final router = Router();

// // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await loginUser(username, password);
// // // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET Endpoint targeting data_list
// // // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // ------------------------------------------
// // // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // // //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
// // // // // // // //   // ------------------------------------------
// // // // // // // //   router.post('/add-machine-record', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // // //       String field2 = body['field_2']?.toString() ?? '';

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2);
// // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET Endpoint targeting machine_data
// // // // // // // //   router.get('/get-machine-records', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchMachineRecordsFromDB();
// // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // //   print("Server engine operational on http://localhost:3000");

// // // // // // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // // // // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // // // // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // // // // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // // // // // }

// // // // // // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // // // // // //   try {
// // // // // // // //     await connectMQTT();
// // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // //       await startPostgresListenBridge();
// // // // // // // //     } else {
// // // // // // // //       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
// // // // // // // //     }
// // // // // // // //   } catch (e) {
// // // // // // // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // // // // // // //   }
// // // // // // // // }




// // // // // // // // import 'dart:async';
// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // late Connection conn;
// // // // // // // // late Connection listenConn; 
// // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // ==========================================
// // // // // // // // // 1. DATABASE CONNECTIVITY (Neon — cloud Postgres)
// // // // // // // // // ==========================================
// // // // // // // // final _pgEndpoint = Endpoint(
// // // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // //   port: 5432,
// // // // // // // //   database: 'neondb',
// // // // // // // //   username: 'neondb_owner',
// // // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // // );

// // // // // // // // // Neon requires SSL — connections without it are rejected outright, unlike
// // // // // // // // // the local setup this replaces.
// // // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require, connectTimeout: const Duration(seconds: 10));

// // // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // // Neon's free tier auto-suspends the database after a period of
// // // // // // // // // inactivity — the first connection after a quiet spell can take a few
// // // // // // // // // seconds while it wakes back up, so this keeps retrying instead of
// // // // // // // // // giving up after one failed attempt.
// // // // // // // // Future<Connection> _openConnection() async {
// // // // // // // //   while (true) {
// // // // // // // //     try {
// // // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // // //     } catch (e) {
// // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // //       print("  (If this persists, check your internet connection and the project status on the Neon dashboard.)");
// // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // Future<void> connectDB() async {
// // // // // // // //   conn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // // // //   listenConn = await _openConnection();
// // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // }

// // // // // // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // // // // // reopens just the query connection and retries the action once before giving up.
// // // // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // // // //   try {
// // // // // // // //     return await action();
// // // // // // // //   } catch (e) {
// // // // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // // // //     conn = await _openConnection();
// // // // // // // //     return await action();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> connectMQTT() async {
// // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // // //   mqttClient.port = 1883;
// // // // // // // //   mqttClient.logging(on: false);
// // // // // // // //   mqttClient.keepAlivePeriod = 20;
// // // // // // // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // // // // // // //   try {
// // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // //     await mqttClient.connect();
// // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // //   } catch (e) {
// // // // // // // //     print('MQTT Connection failure: $e');
// // // // // // // //     mqttClient.disconnect();
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // ==========================================
// // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // // //       builder.addString(payload);

// // // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // //     } else {
// // // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // //     }
// // // // // // // //   });
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // // ==========================================
// // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // //   ));

// // // // // // // //   if (result.isNotEmpty) {
// // // // // // // //     final row = result.first;
// // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // //     if (dbPassword == password) {
// // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // }

// // // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // // //   ));
  
// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "temprature1": map["temprature1"],
// // // // // // // //       "temprature2": map["temprature2"],
// // // // // // // //       "temprature3": map["temprature3"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ------------------------------------------
// // // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // // // This is a completely independent table/endpoint pair from data_list above —
// // // // // // // // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // // // // // // // ------------------------------------------

// // // // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // // // status: 1 = Start, 0 = Stop
// // // // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // // // // // // // ) async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     Sql.named('''
// // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2, @status)
// // // // // // // //       RETURNING *
// // // // // // // //     '''),
// // // // // // // //     parameters: {
// // // // // // // //       "motor_type": motorType,
// // // // // // // //       "machine_id": machineId,
// // // // // // // //       "test_id": testId,
// // // // // // // //       "operation_name": operationName,
// // // // // // // //       "field_1": field1,
// // // // // // // //       "field_2": field2,
// // // // // // // //       "status": status,
// // // // // // // //     },
// // // // // // // //   ));

// // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // }

// // // // // // // // // Query Function to select all rows from target table machine_data
// // // // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, status, created_at FROM machine_data ORDER BY id ASC'
// // // // // // // //   ));

// // // // // // // //   return result.map((row) {
// // // // // // // //     final map = row.toColumnMap();
// // // // // // // //     return {
// // // // // // // //       "id": map["id"],
// // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // //       "test_id": map["test_id"],
// // // // // // // //       "operation_name": map["operation_name"],
// // // // // // // //       "field_1": map["field_1"],
// // // // // // // //       "field_2": map["field_2"],
// // // // // // // //       "status": map["status"],
// // // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // // //     };
// // // // // // // //   }).toList();
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // ==========================================
// // // // // // // // Future<void> main() async {
// // // // // // // //   // Only Postgres is required for login/dashboard/form routes to work,
// // // // // // // //   // so that's the only thing we block server startup on.
// // // // // // // //   await connectDB();

// // // // // // // //   final router = Router();

// // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await loginUser(username, password);
// // // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET Endpoint targeting data_list
// // // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // ------------------------------------------
// // // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // // //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
// // // // // // // //   // ------------------------------------------
// // // // // // // //   router.post('/add-machine-record', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // // //       String field2 = body['field_2']?.toString() ?? '';
// // // // // // // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // // // // // // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // //       }

// // // // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
// // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   // GET Endpoint targeting machine_data
// // // // // // // //   router.get('/get-machine-records', (Request request) async {
// // // // // // // //     try {
// // // // // // // //       final logs = await fetchMachineRecordsFromDB();
// // // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // // //     } catch (e) {
// // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // //     }
// // // // // // // //   });

// // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // //   print("Server engine operational on http://Neon:3000");

// // // // // // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // // // // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // // // // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // // // // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // // // // // }

// // // // // // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // // // // // //   try {
// // // // // // // //     await connectMQTT();
// // // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // //       await startPostgresListenBridge();
// // // // // // // //     } else {
// // // // // // // //       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
// // // // // // // //     }
// // // // // // // //   } catch (e) {
// // // // // // // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // // // // // // //   }
// // // // // // // // }



// // // // // // // import 'dart:async';
// // // // // // // import 'dart:convert';
// // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // late Connection conn;
// // // // // // // late Connection listenConn; 
// // // // // // // late MqttServerClient mqttClient;

// // // // // // // // ==========================================
// // // // // // // // 1. DATABASE CONNECTIVITY (Neon — cloud Postgres)
// // // // // // // // ==========================================
// // // // // // // final _pgEndpoint = Endpoint(
// // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // //   port: 5432,
// // // // // // //   database: 'neondb',
// // // // // // //   username: 'neondb_owner',
// // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // );

// // // // // // // // Neon requires SSL — connections without it are rejected outright, unlike
// // // // // // // // the local setup this replaces.
// // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require, connectTimeout: const Duration(seconds: 10));

// // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // Neon's free tier auto-suspends the database after a period of
// // // // // // // // inactivity — the first connection after a quiet spell can take a few
// // // // // // // // seconds while it wakes back up, so this keeps retrying instead of
// // // // // // // // giving up after one failed attempt.
// // // // // // // Future<Connection> _openConnection() async {
// // // // // // //   while (true) {
// // // // // // //     try {
// // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // //     } catch (e) {
// // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // //       print("  (If this persists, check your internet connection and the project status on the Neon dashboard.)");
// // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // //     }
// // // // // // //   }
// // // // // // // }

// // // // // // // Future<void> connectDB() async {
// // // // // // //   conn = await _openConnection();
// // // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // // //   listenConn = await _openConnection();
// // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // }

// // // // // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // // // // reopens just the query connection and retries the action once before giving up.
// // // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // // //   try {
// // // // // // //     return await action();
// // // // // // //   } catch (e) {
// // // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // // //     conn = await _openConnection();
// // // // // // //     return await action();
// // // // // // //   }
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // // ==========================================
// // // // // // // Future<void> connectMQTT() async {
// // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // // // //   mqttClient.port = 1883;
// // // // // // //   mqttClient.logging(on: false);
// // // // // // //   mqttClient.keepAlivePeriod = 20;
// // // // // // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // // // // // //   try {
// // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // //     await mqttClient.connect();
// // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // //   } catch (e) {
// // // // // // //     print('MQTT Connection failure: $e');
// // // // // // //     mqttClient.disconnect();
// // // // // // //   }
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // ==========================================
// // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // // //       builder.addString(payload);

// // // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // //     } else {
// // // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // //     }
// // // // // // //   });
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // // ==========================================
// // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // //     parameters: {'username': username.trim()},
// // // // // // //   ));

// // // // // // //   if (result.isNotEmpty) {
// // // // // // //     final row = result.first;
// // // // // // //     String dbPassword = row[2].toString();

// // // // // // //     if (dbPassword == password) {
// // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // //     }
// // // // // // //   }
// // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // }

// // // // // // // // ------------------------------------------
// // // // // // // // TABLE: machine_sensor_data
// // // // // // // // (id, amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // // // // // // This is the live telemetry table the Dashboard now reads from — it
// // // // // // // // replaces the old data_list table/endpoint pair entirely. Rows are
// // // // // // // // expected to be written by the sensor/device pipeline (e.g. via the
// // // // // // // // Postgres LISTEN/NOTIFY -> MQTT bridge above), not by this app's UI.
// // // // // // // // ------------------------------------------

// // // // // // // // Query Function to select all rows from target table machine_sensor_data
// // // // // // // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at FROM machine_sensor_data ORDER BY id ASC'
// // // // // // //   ));

// // // // // // //   return result.map((row) {
// // // // // // //     final map = row.toColumnMap();
// // // // // // //     return {
// // // // // // //       "id": map["id"],
// // // // // // //       "amb_temp": map["amb_temp"],
// // // // // // //       "tm1_fet": map["tm1_fet"],
// // // // // // //       "tm1_ret": map["tm1_ret"],
// // // // // // //       "tm2_fet": map["tm2_fet"],
// // // // // // //       "tm2_ret": map["tm2_ret"],
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ------------------------------------------
// // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // // This is a completely independent table/endpoint pair from
// // // // // // // // machine_sensor_data above — it powers the Log Entry form only. The
// // // // // // // // dashboard reads machine_sensor_data.
// // // // // // // // ------------------------------------------

// // // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // // status: 1 = Start, 0 = Stop
// // // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2, @status)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "operation_name": operationName,
// // // // // // //       "field_1": field1,
// // // // // // //       "field_2": field2,
// // // // // // //       "status": status,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query Function to select all rows from target table machine_data
// // // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, status, created_at FROM machine_data ORDER BY id ASC'
// // // // // // //   ));

// // // // // // //   return result.map((row) {
// // // // // // //     final map = row.toColumnMap();
// // // // // // //     return {
// // // // // // //       "id": map["id"],
// // // // // // //       "motor_type": map["motor_type"],
// // // // // // //       "machine_id": map["machine_id"],
// // // // // // //       "test_id": map["test_id"],
// // // // // // //       "operation_name": map["operation_name"],
// // // // // // //       "field_1": map["field_1"],
// // // // // // //       "field_2": map["field_2"],
// // // // // // //       "status": map["status"],
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // ==========================================
// // // // // // // Future<void> main() async {
// // // // // // //   // Only Postgres is required for login/dashboard/form routes to work,
// // // // // // //   // so that's the only thing we block server startup on.
// // // // // // //   await connectDB();

// // // // // // //   final router = Router();

// // // // // // //   router.post('/login', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await loginUser(username, password);
// // // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
// // // // // // //   router.get('/get-sensor-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final logs = await fetchSensorDataFromDB();
// // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // ------------------------------------------
// // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // //   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
// // // // // // //   // ------------------------------------------
// // // // // // //   router.post('/add-machine-record', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // //       String field2 = body['field_2']?.toString() ?? '';
// // // // // // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // // // // // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
// // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // GET Endpoint targeting machine_data
// // // // // // //   router.get('/get-machine-records', (Request request) async {
// // // // // // //     try {
// // // // // // //       final logs = await fetchMachineRecordsFromDB();
// // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // //   print("Server engine operational on http://Neon:3000");

// // // // // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // // // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // // // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // // // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // // // // }

// // // // // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // // // // //   try {
// // // // // // //     await connectMQTT();
// // // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // //       await startPostgresListenBridge();
// // // // // // //     } else {
// // // // // // //       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
// // // // // // //     }
// // // // // // //   } catch (e) {
// // // // // // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // // // // // //   }
// // // // // // // }



// // // // // // import 'dart:async';
// // // // // // import 'dart:convert';
// // // // // // import 'package:mongo_dart/mongo_dart.dart';
// // // // // // import 'package:shelf/shelf.dart';
// // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // late Db db;
// // // // // // late MqttServerClient mqttClient;

// // // // // // // ==========================================
// // // // // // // 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// // // // // // // ==========================================
// // // // // // // SECURITY NOTE: this mirrors the pattern in the original Postgres file
// // // // // // // (credentials hardcoded in source), but since this URI has now been
// // // // // // // pasted into a chat, treat the password as compromised — rotate it in
// // // // // // // Atlas ("Database Access" -> edit user -> new password) and, ideally,
// // // // // // // load the URI from an environment variable instead of committing it:
// // // // // // //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// // // // // // const String _mongoUri =
// // // // // //     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// // // // // // // Opens a single connection, retrying every 3s until it succeeds — same
// // // // // // // resilience behavior as the old _openConnection() for Neon (Atlas free
// // // // // // // tier doesn't auto-suspend the way Neon's does, but a transient network
// // // // // // // blip on first boot is still worth retrying through).
// // // // // // Future<Db> _openConnection() async {
// // // // // //   while (true) {
// // // // // //     try {
// // // // // //       final database = await Db.create(_mongoUri);
// // // // // //       await database.open();
// // // // // //       return database;
// // // // // //     } catch (e) {
// // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // //       print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
// // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // Future<void> connectDB() async {
// // // // // //   db = await _openConnection();
// // // // // //   print("Connected to MongoDB (database: ${db.databaseName})");
// // // // // // }

// // // // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // // // reopens the connection and retries the action once before giving up.
// // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // //   try {
// // // // // //     return await action();
// // // // // //   } catch (e) {
// // // // // //     print("Query failed ($e). Reconnecting to MongoDB and retrying...");
// // // // // //     db = await _openConnection();
// // // // // //     return await action();
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // ==========================================
// // // // // // Future<void> connectMQTT() async {
// // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
// // // // // //   mqttClient.port = 1883;
// // // // // //   mqttClient.logging(on: false);
// // // // // //   mqttClient.keepAlivePeriod = 20;
// // // // // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // // // // //   try {
// // // // // //     print('Connecting to MQTT Broker...');
// // // // // //     await mqttClient.connect();
// // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // //   } catch (e) {
// // // // // //     print('MQTT Connection failure: $e');
// // // // // //     mqttClient.disconnect();
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// // // // // // // ==========================================
// // // // // // // Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// // // // // // // is a Change Stream on the collection, which watches for inserts/updates in
// // // // // // // (near) real time. Change Streams require the deployment to be a replica
// // // // // // // set — Atlas clusters (including the free M0 tier) already are one, so
// // // // // // // this works without extra setup.
// // // // // // //
// // // // // // Future<void> startMongoChangeStreamBridge() async {
// // // // // //   final collection = db.collection('machine_sensor_data');
// // // // // //   // First positional arg is an aggregation pipeline to filter/shape events
// // // // // //   // (empty list = no filtering, receive every change). `fullDocument:
// // // // // //   // 'updateLookup'` makes update events include the complete document
// // // // // //   // instead of just the changed fields.
// // // // // //   final stream = collection.watch(
// // // // // //     <Map<String, Object>>[],
// // // // // //     changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
// // // // // //   );

// // // // // //   print("MongoDB change stream actively watching collection: machine_sensor_data");

// // // // // //   stream.listen((event) {
// // // // // //     final doc = event.fullDocument;
// // // // // //     if (doc == null) return;

// // // // // //     final payload = jsonEncode(_sensorRowToJson(doc));
// // // // // //     print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

// // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // //       builder.addString(payload);

// // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // //     } else {
// // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // //     }
// // // // // //   }, onError: (e) {
// // // // // //     print("[MQTT BRIDGE ERROR] Change stream error: $e");
// // // // // //   });
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // ==========================================
// // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // //   final row = await _withRetry(
// // // // // //     () => db.collection('Users').findOne(where.eq('username', username.trim())),
// // // // // //   );

// // // // // //   if (row != null) {
// // // // // //     // ASSUMPTION: the `users` collection has a `password` field (the old
// // // // // //     // Postgres code read column index 2 positionally). Rename this key to
// // // // // //     // match your actual document shape if it differs.
// // // // // //     final dbPassword = row['password']?.toString() ?? '';

// // // // // //     if (dbPassword == password) {
// // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // //     }
// // // // // //   }
// // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // }

// // // // // // // ------------------------------------------
// // // // // // // COLLECTION: machine_sensor_data
// // // // // // // (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // // // // // This is the live telemetry collection the Dashboard reads from. Rows are
// // // // // // // expected to be written by the sensor/device pipeline (e.g. via whatever
// // // // // // // replaces the old MQTT->Postgres path on the device side), not by this
// // // // // // // app's UI.
// // // // // // // ------------------------------------------

// // // // // // // Turns a raw Mongo document into the JSON shape the Flutter app expects.
// // // // // // // `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// // // // // // // app just uses it as an opaque, ascending-over-time sort/display key —
// // // // // // // ObjectId hex strings sort lexicographically in the same order they were
// // // // // // // created, so ascending string sort == chronological order.
// // // // // // Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
// // // // // //   return {
// // // // // //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // // // // //     "amb_temp": row["amb_temp"],
// // // // // //     "tm1_fet": row["tm1_fet"],
// // // // // //     "tm1_ret": row["tm1_ret"],
// // // // // //     "tm2_fet": row["tm2_fet"],
// // // // // //     "tm2_ret": row["tm2_ret"],
// // // // // //     "created_at": row["created_at"]?.toString(),
// // // // // //   };
// // // // // // }

// // // // // // // Query Function to select all rows from target collection machine_sensor_data
// // // // // // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// // // // // //   // Sort ascending by _id (chronological) — same intent as the old
// // // // // //   // `ORDER BY id ASC`.
// // // // // //   //
// // // // // //   // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
// // // // // //   // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
// // // // // //   // strings aren't numeric, so that parse will yield 0 for every row and
// // // // // //   // the client-side sort becomes a no-op — which is harmless *only because*
// // // // // //   // this query already returns rows in the correct chronological order. If
// // // // // //   // you ever change this query to sort differently, update the Flutter
// // // // // //   // sort comparator to parse `created_at` as a DateTime instead of `id`.
// // // // // //   final rows = await _withRetry(
// // // // // //     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
// // // // // //   );

// // // // // //   return rows.map(_sensorRowToJson).toList();
// // // // // // }

// // // // // // // ------------------------------------------
// // // // // // // SEPARATE COLLECTION: machine_data
// // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // Completely independent from machine_sensor_data above — it powers the Log
// // // // // // // Entry form only. The dashboard reads machine_sensor_data.
// // // // // // // ------------------------------------------

// // // // // // // Inserts a new document into machine_data.
// // // // // // // status: 1 = Start, 0 = Stop
// // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // // // // // ) async {
// // // // // //   final doc = {
// // // // // //     "motor_type": motorType,
// // // // // //     "machine_id": machineId,
// // // // // //     "test_id": testId,
// // // // // //     "operation_name": operationName,
// // // // // //     "field_1": field1,
// // // // // //     "field_2": field2,
// // // // // //     "status": status,
// // // // // //     "created_at": DateTime.now().toUtc(),
// // // // // //   };

// // // // // //   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

// // // // // //   return {
// // // // // //     "success": result.isSuccess,
// // // // // //     "record": {
// // // // // //       "id": (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString(),
// // // // // //       ...doc,
// // // // // //       "created_at": doc["created_at"].toString(),
// // // // // //     }.toString(),
// // // // // //   };
// // // // // // }

// // // // // // // Query Function to select all rows from target collection machine_data
// // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // //   final rows = await _withRetry(
// // // // // //     () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
// // // // // //   );

// // // // // //   return rows.map((row) {
// // // // // //     return {
// // // // // //       "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // // // // //       "motor_type": row["motor_type"],
// // // // // //       "machine_id": row["machine_id"],
// // // // // //       "test_id": row["test_id"],
// // // // // //       "operation_name": row["operation_name"],
// // // // // //       "field_1": row["field_1"],
// // // // // //       "field_2": row["field_2"],
// // // // // //       "status": row["status"],
// // // // // //       "created_at": row["created_at"]?.toString(),
// // // // // //     };
// // // // // //   }).toList();
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // ==========================================
// // // // // // Future<void> main() async {
// // // // // //   // Only MongoDB is required for login/dashboard/form routes to work,
// // // // // //   // so that's the only thing we block server startup on.
// // // // // //   await connectDB();

// // // // // //   final router = Router();

// // // // // //   router.post('/login', (Request request) async {
// // // // // //     try {
// // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // //       String username = body['username']?.toString() ?? '';
// // // // // //       String password = body['password']?.toString() ?? '';

// // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // // //       }

// // // // // //       final result = await loginUser(username, password);
// // // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // //     }
// // // // // //   });

// // // // // //   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
// // // // // //   router.get('/get-sensor-data', (Request request) async {
// // // // // //     try {
// // // // // //       final logs = await fetchSensorDataFromDB();
// // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // //     }
// // // // // //   });

// // // // // //   // ------------------------------------------
// // // // // //   // SEPARATE COLLECTION ROUTES: machine_data
// // // // // //   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
// // // // // //   // ------------------------------------------
// // // // // //   router.post('/add-machine-record', (Request request) async {
// // // // // //     try {
// // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // //       String field2 = body['field_2']?.toString() ?? '';
// // // // // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // // // // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // //       }

// // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
// // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // //     }
// // // // // //   });

// // // // // //   // GET Endpoint targeting machine_data
// // // // // //   router.get('/get-machine-records', (Request request) async {
// // // // // //     try {
// // // // // //       final logs = await fetchMachineRecordsFromDB();
// // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // //     }
// // // // // //   });

// // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // //   print("Server engine operational on http://MongoDB:3000");

// // // // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // // // }

// // // // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // // // //   try {
// // // // // //     await connectMQTT();
// // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // //       await startMongoChangeStreamBridge();
// // // // // //     } else {
// // // // // //       print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
// // // // // //     }
// // // // // //   } catch (e) {
// // // // // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // // // // //   }
// // // // // // }

// // // // // import 'dart:async';
// // // // // import 'dart:convert';
// // // // // import 'package:mongo_dart/mongo_dart.dart';
// // // // // import 'package:shelf/shelf.dart';
// // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // late Db db;
// // // // // late MqttServerClient mqttClient;

// // // // // // ==========================================
// // // // // // 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// // // // // // ==========================================
// // // // // // SECURITY NOTE: this mirrors the pattern in the original Postgres file
// // // // // // (credentials hardcoded in source), but since this URI has now been
// // // // // // pasted into a chat, treat the password as compromised — rotate it in
// // // // // // Atlas ("Database Access" -> edit user -> new password) and, ideally,
// // // // // // load the URI from an environment variable instead of committing it:
// // // // // //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// // // // // const String _mongoUri =
// // // // //     // 'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';
// // // // //       'mongodb://localhost:27017/Railway';
// // // // // // Opens a single connection, retrying every 3s until it succeeds — same
// // // // // // resilience behavior as the old _openConnection() for Neon (Atlas free
// // // // // // tier doesn't auto-suspend the way Neon's does, but a transient network
// // // // // // blip on first boot is still worth retrying through).
// // // // // Future<Db> _openConnection() async {
// // // // //   while (true) {
// // // // //     try {
// // // // //       final database = await Db.create(_mongoUri);
// // // // //       await database.open();
// // // // //       return database;
// // // // //     } catch (e) {
// // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // //       print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
// // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // //     }
// // // // //   }
// // // // // }

// // // // // Future<void> connectDB() async {
// // // // //   db = await _openConnection();
// // // // //   print("Connected to MongoDB (database: ${db.databaseName})");
// // // // // }

// // // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // // reopens the connection and retries the action once before giving up.
// // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // //   try {
// // // // //     return await action();
// // // // //   } catch (e) {
// // // // //     print("Query failed ($e). Reconnecting to MongoDB and retrying...");
// // // // //     db = await _openConnection();
// // // // //     return await action();
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // ==========================================
// // // // // Future<void> connectMQTT() async {
// // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
// // // // //   mqttClient.port = 1883;
// // // // //   mqttClient.logging(on: false);
// // // // //   mqttClient.keepAlivePeriod = 20;
// // // // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // // // //   try {
// // // // //     print('Connecting to MQTT Broker...');
// // // // //     await mqttClient.connect();
// // // // //     print('Connected to MQTT Broker successfully!');
// // // // //   } catch (e) {
// // // // //     print('MQTT Connection failure: $e');
// // // // //     mqttClient.disconnect();
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// // // // // // ==========================================
// // // // // // Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// // // // // // is a Change Stream on the collection, which watches for inserts/updates in
// // // // // // (near) real time. Change Streams require the deployment to be a replica
// // // // // // set — Atlas clusters (including the free M0 tier) already are one, so
// // // // // // this works without extra setup.
// // // // // //
// // // // // Future<void> startMongoChangeStreamBridge() async {
// // // // //   final collection = db.collection('machine_sensor_data');
// // // // //   // First positional arg is an aggregation pipeline to filter/shape events
// // // // //   // (empty list = no filtering, receive every change). `fullDocument:
// // // // //   // 'updateLookup'` makes update events include the complete document
// // // // //   // instead of just the changed fields.
// // // // //   final stream = collection.watch(
// // // // //     <Map<String, Object>>[],
// // // // //     changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
// // // // //   );

// // // // //   print("MongoDB change stream actively watching collection: machine_sensor_data");

// // // // //   stream.listen((event) {
// // // // //     final doc = event.fullDocument;
// // // // //     if (doc == null) return;

// // // // //     final payload = jsonEncode(_sensorRowToJson(doc));
// // // // //     print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

// // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // //       final builder = MqttClientPayloadBuilder();
// // // // //       builder.addString(payload);

// // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // //     } else {
// // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // //     }
// // // // //   }, onError: (e) {
// // // // //     print("[MQTT BRIDGE ERROR] Change stream error: $e");
// // // // //   });
// // // // // }

// // // // // // ==========================================
// // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // ==========================================
// // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // //   final row = await _withRetry(
// // // // //     () => db.collection('Users').findOne(where.eq('username', username.trim())),
// // // // //   );

// // // // //   if (row != null) {
// // // // //     // ASSUMPTION: the `users` collection has a `password` field (the old
// // // // //     // Postgres code read column index 2 positionally). Rename this key to
// // // // //     // match your actual document shape if it differs.
// // // // //     final dbPassword = row['password']?.toString() ?? '';

// // // // //     if (dbPassword == password) {
// // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // //     }
// // // // //   }
// // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // }

// // // // // // ------------------------------------------
// // // // // // COLLECTION: machine_sensor_data
// // // // // // (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // // // // This is the live telemetry collection the Dashboard reads from. Rows are
// // // // // // expected to be written by the sensor/device pipeline (e.g. via whatever
// // // // // // replaces the old MQTT->Postgres path on the device side), not by this
// // // // // // app's UI.
// // // // // // ------------------------------------------

// // // // // // Decodes the creation time embedded in a Mongo ObjectId: the first 4
// // // // // // bytes (8 hex chars) of every ObjectId are a big-endian Unix timestamp in
// // // // // // seconds. Decoding it manually here (rather than relying on whatever
// // // // // // `.timestamp`/`.getTimestamp()` helper a given mongo_dart version does or
// // // // // // doesn't expose) keeps this working regardless of the installed package
// // // // // // version.
// // // // // DateTime? _timestampFromObjectId(ObjectId id) {
// // // // //   try {
// // // // //     final hex = id.oid;
// // // // //     final seconds = int.parse(hex.substring(0, 8), radix: 16);
// // // // //     return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
// // // // //   } catch (_) {
// // // // //     return null;
// // // // //   }
// // // // // }

// // // // // // Resolves the "true" creation time for a machine_sensor_data row.
// // // // // // Prefers the document's own `createdAt` field, but falls back to the
// // // // // // timestamp embedded in the Mongo `_id` (every ObjectId encodes its
// // // // // // creation second) whenever `createdAt` is missing, null, or unparsable —
// // // // // // which is exactly the case you're hitting: some rows from the sensor
// // // // // // pipeline come through with `createdAt: null`. The ObjectId is generated
// // // // // // by the driver/server at insert time regardless of what the sensor
// // // // // // payload did or didn't include, so this always has a value.
// // // // // DateTime? _sensorTimestamp(Map<String, dynamic> row) {
// // // // //   final explicit = _asDateTime(row['createdAt']);
// // // // //   if (explicit != null) return explicit;

// // // // //   final id = row['_id'];
// // // // //   if (id is ObjectId) return _timestampFromObjectId(id);

// // // // //   return null;
// // // // // }

// // // // // // Turns a raw Mongo document into the JSON shape the Flutter app expects.
// // // // // // `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// // // // // // app just uses it as an opaque, ascending-over-time sort/display key —
// // // // // // ObjectId hex strings sort lexicographically in the same order they were
// // // // // // created, so ascending string sort == chronological order.
// // // // // Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
// // // // //   return {
// // // // //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // // // //     "amb_temp": row["amb_temp"],
// // // // //     "tm1_fet": row["tm1_fet"],
// // // // //     "tm1_ret": row["tm1_ret"],
// // // // //     "tm2_fet": row["tm2_fet"],
// // // // //     "tm2_ret": row["tm2_ret"],
// // // // //     // See _sensorTimestamp: uses the document's createdAt when present,
// // // // //     // otherwise derives it from the ObjectId so this is never null even
// // // // //     // for rows the sensor pipeline wrote without a timestamp.
// // // // //     "created_at": _sensorTimestamp(row)?.toIso8601String(),
// // // // //   };
// // // // // }

// // // // // // Query Function to select all rows from target collection machine_sensor_data
// // // // // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// // // // //   // Sort ascending by _id (chronological) — same intent as the old
// // // // //   // `ORDER BY id ASC`.
// // // // //   //
// // // // //   // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
// // // // //   // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
// // // // //   // strings aren't numeric, so that parse will yield 0 for every row and
// // // // //   // the client-side sort becomes a no-op — which is harmless *only because*
// // // // //   // this query already returns rows in the correct chronological order. If
// // // // //   // you ever change this query to sort differently, update the Flutter
// // // // //   // sort comparator to parse `created_at` (sourced from Mongo's `createdAt`)
// // // // //   // as a DateTime instead of `id`.
// // // // //   final rows = await _withRetry(
// // // // //     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
// // // // //   );

// // // // //   return rows.map(_sensorRowToJson).toList();
// // // // // }

// // // // // // ------------------------------------------
// // // // // // SESSION SCOPING: machine_data (Start/Stop) -> machine_sensor_data window
// // // // // // ------------------------------------------
// // // // // // A "session" is one Start (status=1) + its matching Stop (status=0) for a
// // // // // // given (motor_type, test_id) pair. The dashboard shows only the sensor
// // // // // // readings whose created_at falls between that Start and Stop — or, if no
// // // // // // Stop has been logged yet, everything from Start up to now (a live/running
// // // // // // session).

// // // // // // Best-effort conversion since `created_at` may come back from Mongo as a
// // // // // // native DateTime (for docs this app wrote) or as a String (for docs written
// // // // // // by an external device/sensor pipeline that this app doesn't control).
// // // // // DateTime? _asDateTime(dynamic v) {
// // // // //   if (v == null) return null;
// // // // //   if (v is DateTime) return v;
// // // // //   return DateTime.tryParse(v.toString());
// // // // // }

// // // // // // Returns the distinct (motor_type, test_id) combinations seen in
// // // // // // machine_data, most-recently-active first, each tagged with whether its
// // // // // // latest event was a Start (still running) or a Stop (completed) — this is
// // // // // // what populates the Dashboard's session-picker dropdown.
// // // // // Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
// // // // //   final rows = await _withRetry(
// // // // //     () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
// // // // //   );

// // // // //   // Dart Maps preserve insertion order, and we insert in descending-recency
// // // // //   // order, so `seen.values` naturally comes out most-recent-first with one
// // // // //   // entry per (motor_type, test_id).
// // // // //   final seen = <String, Map<String, dynamic>>{};
// // // // //   for (final row in rows) {
// // // // //     final motorType = row['motor_type']?.toString() ?? '';
// // // // //     final testId = row['test_id']?.toString() ?? '';
// // // // //     if (motorType.isEmpty || testId.isEmpty) continue;
// // // // //     final key = '$motorType\u0000$testId';
// // // // //     seen.putIfAbsent(key, () => {
// // // // //           "motor_type": motorType,
// // // // //           "test_id": testId,
// // // // //           "last_status": row['status'],
// // // // //           "is_active": row['status'] == 1,
// // // // //           "last_activity": _asDateTime(row['created_at'])?.toIso8601String(),
// // // // //         });
// // // // //   }
// // // // //   return seen.values.toList();
// // // // // }

// // // // // // Finds the latest Start for (motor_type, test_id), its matching Stop (if
// // // // // // any), and every machine_sensor_data reading recorded in that window.
// // // // // Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
// // // // //   final sessionDocs = await _withRetry(
// // // // //     () => db
// // // // //         .collection('machine_data')
// // // // //         .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
// // // // //         .toList(),
// // // // //   );

// // // // //   // Latest Start: first status==1 doc when walking newest -> oldest.
// // // // //   Map<String, dynamic>? startDoc;
// // // // //   for (final d in sessionDocs) {
// // // // //     if (d['status'] == 1) {
// // // // //       startDoc = d;
// // // // //       break;
// // // // //     }
// // // // //   }
// // // // //   if (startDoc == null) {
// // // // //     return {"found": false, "motor_type": motorType, "test_id": testId};
// // // // //   }
// // // // //   final startTime = _asDateTime(startDoc['created_at']);

// // // // //   // Matching Stop: earliest status==0 doc that occurs after startTime, i.e.
// // // // //   // the first Stop encountered walking oldest -> newest starting right
// // // // //   // after the Start.
// // // // //   DateTime? stopTime;
// // // // //   for (final d in sessionDocs.reversed) {
// // // // //     if (d['status'] == 0) {
// // // // //       final t = _asDateTime(d['created_at']);
// // // // //       if (t != null && startTime != null && t.isAfter(startTime)) {
// // // // //         stopTime = t;
// // // // //         break;
// // // // //       }
// // // // //     }
// // // // //   }

// // // // //   // Filtered (and sorted) in application code rather than via a Mongo
// // // // //   // query/sort, because machine_sensor_data is written by an external
// // // // //   // pipeline this app doesn't control and some rows come through with a
// // // // //   // null/missing `createdAt` — sorting server-side on that field alone
// // // // //   // would misplace those rows. _sensorTimestamp() falls back to the
// // // // //   // ObjectId's embedded creation time for exactly those rows, so every
// // // // //   // row gets a usable timestamp before sorting/filtering.
// // // // //   final allSensorRows = await _withRetry(
// // // // //     () => db.collection('machine_sensor_data').find().toList(),
// // // // //   );

// // // // //   allSensorRows.sort((a, b) {
// // // // //     final ta = _sensorTimestamp(a);
// // // // //     final tb = _sensorTimestamp(b);
// // // // //     if (ta == null && tb == null) return 0;
// // // // //     if (ta == null) return -1;
// // // // //     if (tb == null) return 1;
// // // // //     return ta.compareTo(tb);
// // // // //   });

// // // // //   final windowed = allSensorRows.where((row) {
// // // // //     final t = _sensorTimestamp(row);
// // // // //     if (t == null) return false;
// // // // //     if (startTime != null && t.isBefore(startTime)) return false;
// // // // //     if (stopTime != null && t.isAfter(stopTime)) return false;
// // // // //     return true;
// // // // //   }).map(_sensorRowToJson).toList();

// // // // //   return {
// // // // //     "found": true,
// // // // //     "motor_type": motorType,
// // // // //     "test_id": testId,
// // // // //     "start_time": startTime?.toIso8601String(),
// // // // //     "stop_time": stopTime?.toIso8601String(),
// // // // //     "is_active": stopTime == null,
// // // // //     "sensor_data": windowed,
// // // // //   };
// // // // // }

// // // // // // ------------------------------------------
// // // // // // SEPARATE COLLECTION: machine_data
// // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // Completely independent from machine_sensor_data above — it powers the Log
// // // // // // Entry form only. The dashboard reads machine_sensor_data.
// // // // // // ------------------------------------------

// // // // // // Inserts a new document into machine_data.
// // // // // // status: 1 = Start, 0 = Stop
// // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // // // // ) async {
// // // // //   final doc = {
// // // // //     "motor_type": motorType,
// // // // //     "machine_id": machineId,
// // // // //     "test_id": testId,
// // // // //     "operation_name": operationName,
// // // // //     "field_1": field1,
// // // // //     "field_2": field2,
// // // // //     "status": status,
// // // // //     "created_at": DateTime.now().toUtc(),
// // // // //   };

// // // // //   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

// // // // //   return {
// // // // //     "success": result.isSuccess,
// // // // //     "record": {
// // // // //       "id": (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString(),
// // // // //       ...doc,
// // // // //       "created_at": doc["created_at"].toString(),
// // // // //     }.toString(),
// // // // //   };
// // // // // }

// // // // // // Query Function to select all rows from target collection machine_data
// // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // //   final rows = await _withRetry(
// // // // //     () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
// // // // //   );

// // // // //   return rows.map((row) {
// // // // //     return {
// // // // //       "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // // // //       "motor_type": row["motor_type"],
// // // // //       "machine_id": row["machine_id"],
// // // // //       "test_id": row["test_id"],
// // // // //       "operation_name": row["operation_name"],
// // // // //       "field_1": row["field_1"],
// // // // //       "field_2": row["field_2"],
// // // // //       "status": row["status"],
// // // // //       "created_at": row["created_at"]?.toString(),
// // // // //     };
// // // // //   }).toList();
// // // // // }

// // // // // // ==========================================
// // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // ==========================================
// // // // // Future<void> main() async {
// // // // //   // Only MongoDB is required for login/dashboard/form routes to work,
// // // // //   // so that's the only thing we block server startup on.
// // // // //   await connectDB();

// // // // //   final router = Router();

// // // // //   router.post('/login', (Request request) async {
// // // // //     try {
// // // // //       final body = jsonDecode(await request.readAsString());
// // // // //       String username = body['username']?.toString() ?? '';
// // // // //       String password = body['password']?.toString() ?? '';

// // // // //       if (username.isEmpty || password.isEmpty) {
// // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // //       }

// // // // //       final result = await loginUser(username, password);
// // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
// // // // //   router.get('/get-sensor-data', (Request request) async {
// // // // //     try {
// // // // //       final logs = await fetchSensorDataFromDB();
// // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   // ------------------------------------------
// // // // //   // SEPARATE COLLECTION ROUTES: machine_data
// // // // //   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
// // // // //   // ------------------------------------------
// // // // //   router.post('/add-machine-record', (Request request) async {
// // // // //     try {
// // // // //       final body = jsonDecode(await request.readAsString());

// // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // //       String field2 = body['field_2']?.toString() ?? '';
// // // // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // // // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // //       }

// // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
// // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   // GET Endpoint targeting machine_data
// // // // //   router.get('/get-machine-records', (Request request) async {
// // // // //     try {
// // // // //       final logs = await fetchMachineRecordsFromDB();
// // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   // ------------------------------------------
// // // // //   // SESSION-SCOPED ROUTES
// // // // //   // Power the Dashboard's session picker + session-windowed sensor view.
// // // // //   // ------------------------------------------

// // // // //   // Lists distinct (motor_type, test_id) sessions, most recently active
// // // // //   // first — populates the Dashboard's dropdown.
// // // // //   router.get('/get-machine-sessions', (Request request) async {
// // // // //     try {
// // // // //       final sessions = await fetchMachineSessionsFromDB();
// // // // //       return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   // Returns machine_sensor_data readings between a session's Start and
// // // // //   // Stop (or Start-to-now if it's still running), for one motor_type +
// // // // //   // test_id. e.g. /get-session-sensor-data?motor_type=Motor+1&test_id=TST-1
// // // // //   router.get('/get-session-sensor-data', (Request request) async {
// // // // //     try {
// // // // //       final motorType = request.url.queryParameters['motor_type'] ?? '';
// // // // //       final testId = request.url.queryParameters['test_id'] ?? '';

// // // // //       if (motorType.isEmpty || testId.isEmpty) {
// // // // //         return Response(400, body: jsonEncode({"message": "motor_type and test_id are required"}), headers: {"Content-Type": "application/json"});
// // // // //       }

// // // // //       final result = await fetchSessionSensorData(motorType, testId);
// // // // //       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // //   print("Server engine operational on http://MongoDB:3000");

// // // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // // }

// // // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // // //   try {
// // // // //     await connectMQTT();
// // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // //       await startMongoChangeStreamBridge();
// // // // //     } else {
// // // // //       print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
// // // // //     }
// // // // //   } catch (e) {
// // // // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // // // //   }
// // // // // }



// // // // import 'dart:async';
// // // // import 'dart:convert';
// // // // import 'package:mongo_dart/mongo_dart.dart';
// // // // import 'package:shelf/shelf.dart';
// // // // import 'package:shelf/shelf_io.dart' as io;
// // // // import 'package:shelf_router/shelf_router.dart';
// // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // late Db db;
// // // // late MqttServerClient mqttClient;

// // // // // ==========================================
// // // // // 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// // // // // ==========================================
// // // // // SECURITY NOTE: this mirrors the pattern in the original Postgres file
// // // // // (credentials hardcoded in source), but since this URI has now been
// // // // // pasted into a chat, treat the password as compromised — rotate it in
// // // // // Atlas ("Database Access" -> edit user -> new password) and, ideally,
// // // // // load the URI from an environment variable instead of committing it:
// // // // //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// // // // const String _mongoUri =
// // // //     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// // // // // Opens a single connection, retrying every 3s until it succeeds — same
// // // // // resilience behavior as the old _openConnection() for Neon (Atlas free
// // // // // tier doesn't auto-suspend the way Neon's does, but a transient network
// // // // // blip on first boot is still worth retrying through).
// // // // Future<Db> _openConnection() async {
// // // //   while (true) {
// // // //     try {
// // // //       final database = await Db.create(_mongoUri);
// // // //       await database.open();
// // // //       return database;
// // // //     } catch (e) {
// // // //       print("DB connection failed, retrying in 3s: $e");
// // // //       print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
// // // //       await Future.delayed(const Duration(seconds: 3));
// // // //     }
// // // //   }
// // // // }

// // // // Future<void> connectDB() async {
// // // //   db = await _openConnection();
// // // //   print("Connected to MongoDB (database: ${db.databaseName})");
// // // // }

// // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // reopens the connection and retries the action once before giving up.
// // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // //   try {
// // // //     return await action();
// // // //   } catch (e) {
// // // //     print("Query failed ($e). Reconnecting to MongoDB and retrying...");
// // // //     db = await _openConnection();
// // // //     return await action();
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 2. MQTT CLIENT PUBLISHER
// // // // // ==========================================
// // // // Future<void> connectMQTT() async {
// // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
// // // //   mqttClient.port = 1883;
// // // //   mqttClient.logging(on: false);
// // // //   mqttClient.keepAlivePeriod = 20;
// // // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // // //   try {
// // // //     print('Connecting to MQTT Broker...');
// // // //     await mqttClient.connect();
// // // //     print('Connected to MQTT Broker successfully!');
// // // //   } catch (e) {
// // // //     print('MQTT Connection failure: $e');
// // // //     mqttClient.disconnect();
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// // // // // ==========================================
// // // // // Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// // // // // is a Change Stream on the collection, which watches for inserts/updates in
// // // // // (near) real time. Change Streams require the deployment to be a replica
// // // // // set — Atlas clusters (including the free M0 tier) already are one, so
// // // // // this works without extra setup.
// // // // //
// // // // Future<void> startMongoChangeStreamBridge() async {
// // // //   final collection = db.collection('machine_sensor_data');
// // // //   // First positional arg is an aggregation pipeline to filter/shape events
// // // //   // (empty list = no filtering, receive every change). `fullDocument:
// // // //   // 'updateLookup'` makes update events include the complete document
// // // //   // instead of just the changed fields.
// // // //   final stream = collection.watch(
// // // //     <Map<String, Object>>[],
// // // //     changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
// // // //   );

// // // //   print("MongoDB change stream actively watching collection: machine_sensor_data");

// // // //   stream.listen((event) {
// // // //     final doc = event.fullDocument;
// // // //     if (doc == null) return;

// // // //     final payload = jsonEncode(_sensorRowToJson(doc));
// // // //     print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

// // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // //       final builder = MqttClientPayloadBuilder();
// // // //       builder.addString(payload);

// // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // //     } else {
// // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // //     }
// // // //   }, onError: (e) {
// // // //     print("[MQTT BRIDGE ERROR] Change stream error: $e");
// // // //   });
// // // // }

// // // // // ==========================================
// // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // ==========================================
// // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // //   final row = await _withRetry(
// // // //     () => db.collection('Users').findOne(where.eq('username', username.trim())),
// // // //   );

// // // //   if (row != null) {
// // // //     // ASSUMPTION: the `users` collection has a `password` field (the old
// // // //     // Postgres code read column index 2 positionally). Rename this key to
// // // //     // match your actual document shape if it differs.
// // // //     final dbPassword = row['password']?.toString() ?? '';

// // // //     if (dbPassword == password) {
// // // //       return {"success": true, "message": "Login successful", "username": username};
// // // //     }
// // // //   }
// // // //   return {"success": false, "message": "Invalid username or password"};
// // // // }

// // // // // ------------------------------------------
// // // // // COLLECTION: machine_sensor_data
// // // // // (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // // // This is the live telemetry collection the Dashboard reads from. Rows are
// // // // // expected to be written by the sensor/device pipeline (e.g. via whatever
// // // // // replaces the old MQTT->Postgres path on the device side), not by this
// // // // // app's UI.
// // // // // ------------------------------------------

// // // // // Decodes the creation time embedded in a Mongo ObjectId: the first 4
// // // // // bytes (8 hex chars) of every ObjectId are a big-endian Unix timestamp in
// // // // // seconds. Decoding it manually here (rather than relying on whatever
// // // // // `.timestamp`/`.getTimestamp()` helper a given mongo_dart version does or
// // // // // doesn't expose) keeps this working regardless of the installed package
// // // // // version.
// // // // DateTime? _timestampFromObjectId(ObjectId id) {
// // // //   try {
// // // //     final hex = id.oid;
// // // //     final seconds = int.parse(hex.substring(0, 8), radix: 16);
// // // //     return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
// // // //   } catch (_) {
// // // //     return null;
// // // //   }
// // // // }

// // // // // Resolves the "true" creation time for a machine_sensor_data row.
// // // // // Prefers the document's own `createdAt` field, but falls back to the
// // // // // timestamp embedded in the Mongo `_id` (every ObjectId encodes its
// // // // // creation second) whenever `createdAt` is missing, null, or unparsable —
// // // // // which is exactly the case you're hitting: some rows from the sensor
// // // // // pipeline come through with `createdAt: null`. The ObjectId is generated
// // // // // by the driver/server at insert time regardless of what the sensor
// // // // // payload did or didn't include, so this always has a value.
// // // // DateTime? _sensorTimestamp(Map<String, dynamic> row) {
// // // //   final explicit = _asDateTime(row['createdAt']);
// // // //   if (explicit != null) return explicit;

// // // //   final id = row['_id'];
// // // //   if (id is ObjectId) return _timestampFromObjectId(id);

// // // //   return null;
// // // // }

// // // // // Turns a raw Mongo document into the JSON shape the Flutter app expects.
// // // // // `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// // // // // app just uses it as an opaque, ascending-over-time sort/display key —
// // // // // ObjectId hex strings sort lexicographically in the same order they were
// // // // // created, so ascending string sort == chronological order.
// // // // Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
// // // //   return {
// // // //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // // //     "amb_temp": row["amb_temp"],
// // // //     "tm1_fet": row["tm1_fet"],
// // // //     "tm1_ret": row["tm1_ret"],
// // // //     "tm2_fet": row["tm2_fet"],
// // // //     "tm2_ret": row["tm2_ret"],
// // // //     // See _sensorTimestamp: uses the document's createdAt when present,
// // // //     // otherwise derives it from the ObjectId so this is never null even
// // // //     // for rows the sensor pipeline wrote without a timestamp.
// // // //     "created_at": _sensorTimestamp(row)?.toIso8601String(),
// // // //   };
// // // // }

// // // // // Query Function to select all rows from target collection machine_sensor_data
// // // // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// // // //   // Sort ascending by _id (chronological) — same intent as the old
// // // //   // `ORDER BY id ASC`.
// // // //   //
// // // //   // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
// // // //   // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
// // // //   // strings aren't numeric, so that parse will yield 0 for every row and
// // // //   // the client-side sort becomes a no-op — which is harmless *only because*
// // // //   // this query already returns rows in the correct chronological order. If
// // // //   // you ever change this query to sort differently, update the Flutter
// // // //   // sort comparator to parse `created_at` (sourced from Mongo's `createdAt`)
// // // //   // as a DateTime instead of `id`.
// // // //   final rows = await _withRetry(
// // // //     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
// // // //   );

// // // //   return rows.map(_sensorRowToJson).toList();
// // // // }

// // // // // ------------------------------------------
// // // // // SESSION SCOPING: machine_data (Start/Stop) -> machine_sensor_data window
// // // // // ------------------------------------------
// // // // // A "session" is one Start (status=1) + its matching Stop (status=0) for a
// // // // // given (motor_type, test_id) pair. The dashboard shows only the sensor
// // // // // readings whose created_at falls between that Start and Stop — or, if no
// // // // // Stop has been logged yet, everything from Start up to now (a live/running
// // // // // session).

// // // // // Best-effort conversion since `created_at` may come back from Mongo as a
// // // // // native DateTime (for docs this app wrote) or as a String (for docs written
// // // // // by an external device/sensor pipeline that this app doesn't control).
// // // // DateTime? _asDateTime(dynamic v) {
// // // //   if (v == null) return null;
// // // //   if (v is DateTime) return v;
// // // //   return DateTime.tryParse(v.toString());
// // // // }

// // // // // Returns the distinct (motor_type, test_id) combinations seen in
// // // // // machine_data, most-recently-active first, each tagged with whether its
// // // // // latest event was a Start (still running) or a Stop (completed) — this is
// // // // // what populates the Dashboard's session-picker dropdown.
// // // // Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
// // // //   final rows = await _withRetry(
// // // //     () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
// // // //   );

// // // //   // Dart Maps preserve insertion order, and we insert in descending-recency
// // // //   // order, so `seen.values` naturally comes out most-recent-first with one
// // // //   // entry per (motor_type, test_id).
// // // //   final seen = <String, Map<String, dynamic>>{};
// // // //   for (final row in rows) {
// // // //     final motorType = row['motor_type']?.toString() ?? '';
// // // //     final testId = row['test_id']?.toString() ?? '';
// // // //     if (motorType.isEmpty || testId.isEmpty) continue;
// // // //     final key = '$motorType\u0000$testId';
// // // //     seen.putIfAbsent(key, () => {
// // // //           "motor_type": motorType,
// // // //           "test_id": testId,
// // // //           "last_status": row['status'],
// // // //           "is_active": row['status'] == 1,
// // // //           "last_activity": _asDateTime(row['created_at'])?.toIso8601String(),
// // // //         });
// // // //   }
// // // //   return seen.values.toList();
// // // // }

// // // // // Finds the latest Start for (motor_type, test_id), its matching Stop (if
// // // // // any), and every machine_sensor_data reading recorded in that window.
// // // // Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
// // // //   final sessionDocs = await _withRetry(
// // // //     () => db
// // // //         .collection('machine_data')
// // // //         .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
// // // //         .toList(),
// // // //   );

// // // //   // Latest Start: first status==1 doc when walking newest -> oldest.
// // // //   Map<String, dynamic>? startDoc;
// // // //   for (final d in sessionDocs) {
// // // //     if (d['status'] == 1) {
// // // //       startDoc = d;
// // // //       break;
// // // //     }
// // // //   }
// // // //   if (startDoc == null) {
// // // //     return {"found": false, "motor_type": motorType, "test_id": testId};
// // // //   }
// // // //   final startTime = _asDateTime(startDoc['created_at']);

// // // //   // Matching Stop: earliest status==0 doc that occurs after startTime, i.e.
// // // //   // the first Stop encountered walking oldest -> newest starting right
// // // //   // after the Start.
// // // //   DateTime? stopTime;
// // // //   for (final d in sessionDocs.reversed) {
// // // //     if (d['status'] == 0) {
// // // //       final t = _asDateTime(d['created_at']);
// // // //       if (t != null && startTime != null && t.isAfter(startTime)) {
// // // //         stopTime = t;
// // // //         break;
// // // //       }
// // // //     }
// // // //   }

// // // //   // Filtered (and sorted) in application code rather than via a Mongo
// // // //   // query/sort, because machine_sensor_data is written by an external
// // // //   // pipeline this app doesn't control and some rows come through with a
// // // //   // null/missing `createdAt` — sorting server-side on that field alone
// // // //   // would misplace those rows. _sensorTimestamp() falls back to the
// // // //   // ObjectId's embedded creation time for exactly those rows, so every
// // // //   // row gets a usable timestamp before sorting/filtering.
// // // //   final allSensorRows = await _withRetry(
// // // //     () => db.collection('machine_sensor_data').find().toList(),
// // // //   );

// // // //   allSensorRows.sort((a, b) {
// // // //     final ta = _sensorTimestamp(a);
// // // //     final tb = _sensorTimestamp(b);
// // // //     if (ta == null && tb == null) return 0;
// // // //     if (ta == null) return -1;
// // // //     if (tb == null) return 1;
// // // //     return ta.compareTo(tb);
// // // //   });

// // // //   final windowed = allSensorRows.where((row) {
// // // //     final t = _sensorTimestamp(row);
// // // //     if (t == null) return false;
// // // //     if (startTime != null && t.isBefore(startTime)) return false;
// // // //     if (stopTime != null && t.isAfter(stopTime)) return false;
// // // //     return true;
// // // //   }).map(_sensorRowToJson).toList();

// // // //   return {
// // // //     "found": true,
// // // //     "motor_type": motorType,
// // // //     "test_id": testId,
// // // //     "start_time": startTime?.toIso8601String(),
// // // //     "stop_time": stopTime?.toIso8601String(),
// // // //     "is_active": stopTime == null,
// // // //     "sensor_data": windowed,
// // // //   };
// // // // }

// // // // // ------------------------------------------
// // // // // SEPARATE COLLECTION: machine_data
// // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, field_3, status)
// // // // // Completely independent from machine_sensor_data above — it powers the Log
// // // // // Entry form only. The dashboard reads machine_sensor_data.
// // // // // ------------------------------------------

// // // // // Inserts a new document into machine_data.
// // // // // status: 1 = Start, 0 = Stop
// // // // //
// // // // // FIX: previously this returned {"success": result.isSuccess, ...} but the
// // // // // route handler ignored that flag entirely and always answered the client
// // // // // with HTTP 201 — so a failed/rejected insert still looked like a success
// // // // // to the Flutter app (it shows the "Started"/"Stopped" animation and adds
// // // // // the row to Active Sessions) even though nothing was written to MongoDB.
// // // // // Now this throws when the driver reports the write didn't succeed, so the
// // // // // route's existing try/catch turns that into a real error response instead
// // // // // of a fake 201.
// // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, String field3, int status
// // // // ) async {
// // // //   final doc = {
// // // //     "motor_type": motorType,
// // // //     "machine_id": machineId,
// // // //     "test_id": testId,
// // // //     "operation_name": operationName,
// // // //     "field_1": field1,
// // // //     "field_2": field2,
// // // //     "field_3": field3,
// // // //     "status": status,
// // // //     "created_at": DateTime.now().toUtc(),
// // // //   };

// // // //   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

// // // //   if (!result.isSuccess) {
// // // //     // Log the full WriteResult server-side (write errors, write concern
// // // //     // errors, etc. all show up in result.toString()) so this is
// // // //     // diagnosable from the server console, not just a generic 500 on the
// // // //     // client.
// // // //     print("[INSERT FAILED] machine_data insert did not succeed: $result");
// // // //     throw Exception('Database did not confirm the write (isSuccess=false) — nothing was saved.');
// // // //   }

// // // //   final insertedId = (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString();
// // // //   print("[INSERT OK] machine_data id=$insertedId motor_type=$motorType test_id=$testId status=$status");

// // // //   return {
// // // //     "success": true,
// // // //     "record": {
// // // //       "id": insertedId,
// // // //       ...doc,
// // // //       "created_at": doc["created_at"].toString(),
// // // //     },
// // // //   };
// // // // }

// // // // // Query Function to select all rows from target collection machine_data
// // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // //   final rows = await _withRetry(
// // // //     () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
// // // //   );

// // // //   return rows.map((row) {
// // // //     return {
// // // //       "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // // //       "motor_type": row["motor_type"],
// // // //       "machine_id": row["machine_id"],
// // // //       "test_id": row["test_id"],
// // // //       "operation_name": row["operation_name"],
// // // //       "field_1": row["field_1"],
// // // //       "field_2": row["field_2"],
// // // //       "field_3": row["field_3"],
// // // //       "status": row["status"],
// // // //       "created_at": row["created_at"]?.toString(),
// // // //     };
// // // //   }).toList();
// // // // }

// // // // // ==========================================
// // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // ==========================================
// // // // Future<void> main() async {
// // // //   // Only MongoDB is required for login/dashboard/form routes to work,
// // // //   // so that's the only thing we block server startup on.
// // // //   await connectDB();

// // // //   final router = Router();

// // // //   router.post('/login', (Request request) async {
// // // //     try {
// // // //       final body = jsonDecode(await request.readAsString());
// // // //       String username = body['username']?.toString() ?? '';
// // // //       String password = body['password']?.toString() ?? '';

// // // //       if (username.isEmpty || password.isEmpty) {
// // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // //       }

// // // //       final result = await loginUser(username, password);
// // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
// // // //   router.get('/get-sensor-data', (Request request) async {
// // // //     try {
// // // //       final logs = await fetchSensorDataFromDB();
// // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   // ------------------------------------------
// // // //   // SEPARATE COLLECTION ROUTES: machine_data
// // // //   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
// // // //   // ------------------------------------------
// // // //   router.post('/add-machine-record', (Request request) async {
// // // //     try {
// // // //       final body = jsonDecode(await request.readAsString());

// // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // //       String testId = body['test_id']?.toString() ?? '';
// // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // //       String field1 = body['field_1']?.toString() ?? '';
// // // //       String field2 = body['field_2']?.toString() ?? '';
// // // //       String field3 = body['field_3']?.toString() ?? '';
// // // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty || field3.isEmpty) {
// // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // //       }

// // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, field3, status);

// // // //       // FIX: this used to unconditionally return 201 regardless of what
// // // //       // `result` actually said. insertMachineRecord() now throws instead
// // // //       // of returning success:false, so by the time we get here the insert
// // // //       // is confirmed — but we still check explicitly rather than trusting
// // // //       // that invariant blindly, so a future change to insertMachineRecord
// // // //       // can't silently reintroduce the same bug.
// // // //       final success = result["success"] == true;
// // // //       return Response(
// // // //         success ? 201 : 500,
// // // //         body: jsonEncode(result),
// // // //         headers: {"Content-Type": "application/json"},
// // // //       );
// // // //     } catch (e) {
// // // //       print("[/add-machine-record] Insert failed: $e");
// // // //       return Response.internalServerError(
// // // //         body: jsonEncode({"success": false, "message": e.toString()}),
// // // //         headers: {"Content-Type": "application/json"},
// // // //       );
// // // //     }
// // // //   });

// // // //   // GET Endpoint targeting machine_data
// // // //   router.get('/get-machine-records', (Request request) async {
// // // //     try {
// // // //       final logs = await fetchMachineRecordsFromDB();
// // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   // ------------------------------------------
// // // //   // SESSION-SCOPED ROUTES
// // // //   // Power the Dashboard's session picker + session-windowed sensor view.
// // // //   // ------------------------------------------

// // // //   // Lists distinct (motor_type, test_id) sessions, most recently active
// // // //   // first — populates the Dashboard's dropdown.
// // // //   router.get('/get-machine-sessions', (Request request) async {
// // // //     try {
// // // //       final sessions = await fetchMachineSessionsFromDB();
// // // //       return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   // Returns machine_sensor_data readings between a session's Start and
// // // //   // Stop (or Start-to-now if it's still running), for one motor_type +
// // // //   // test_id. e.g. /get-session-sensor-data?motor_type=Motor+1&test_id=TST-1
// // // //   router.get('/get-session-sensor-data', (Request request) async {
// // // //     try {
// // // //       final motorType = request.url.queryParameters['motor_type'] ?? '';
// // // //       final testId = request.url.queryParameters['test_id'] ?? '';

// // // //       if (motorType.isEmpty || testId.isEmpty) {
// // // //         return Response(400, body: jsonEncode({"message": "motor_type and test_id are required"}), headers: {"Content-Type": "application/json"});
// // // //       }

// // // //       final result = await fetchSessionSensorData(motorType, testId);
// // // //       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // //   print("Server engine operational on http://MongoDB:3000");

// // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // }

// // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // //   try {
// // // //     await connectMQTT();
// // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // //       await startMongoChangeStreamBridge();
// // // //     } else {
// // // //       print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
// // // //     }
// // // //   } catch (e) {
// // // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // // //   }
// // // // }




// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'package:mongo_dart/mongo_dart.dart';
// // // import 'package:shelf/shelf.dart';
// // // import 'package:shelf/shelf_io.dart' as io;
// // // import 'package:shelf_router/shelf_router.dart';
// // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // import 'package:mqtt_client/mqtt_client.dart';

// // // late Db db;
// // // late MqttServerClient mqttClient;

// // // // ==========================================
// // // // 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// // // // ==========================================
// // // // SECURITY NOTE: this mirrors the pattern in the original Postgres file
// // // // (credentials hardcoded in source), but since this URI has now been
// // // // pasted into a chat, treat the password as compromised — rotate it in
// // // // Atlas ("Database Access" -> edit user -> new password) and, ideally,
// // // // load the URI from an environment variable instead of committing it:
// // // //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// // // const String _mongoUri =
// // //     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// // // // Opens a single connection, retrying every 3s until it succeeds — same
// // // // resilience behavior as the old _openConnection() for Neon (Atlas free
// // // // tier doesn't auto-suspend the way Neon's does, but a transient network
// // // // blip on first boot is still worth retrying through).
// // // Future<Db> _openConnection() async {
// // //   while (true) {
// // //     try {
// // //       final database = await Db.create(_mongoUri);
// // //       await database.open();
// // //       return database;
// // //     } catch (e) {
// // //       print("DB connection failed, retrying in 3s: $e");
// // //       print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
// // //       await Future.delayed(const Duration(seconds: 3));
// // //     }
// // //   }
// // // }

// // // Future<void> connectDB() async {
// // //   db = await _openConnection();
// // //   print("Connected to MongoDB (database: ${db.databaseName})");
// // // }

// // // // Runs a query; if it fails because the connection has gone stale,
// // // // reopens the connection and retries the action once before giving up.
// // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // //   try {
// // //     return await action();
// // //   } catch (e) {
// // //     print("Query failed ($e). Reconnecting to MongoDB and retrying...");
// // //     db = await _openConnection();
// // //     return await action();
// // //   }
// // // }

// // // // ==========================================
// // // // 2. MQTT CLIENT PUBLISHER
// // // // ==========================================
// // // Future<void> connectMQTT() async {
// // //   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
// // //   mqttClient.port = 1883;
// // //   mqttClient.logging(on: false);
// // //   mqttClient.keepAlivePeriod = 20;
// // //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// // //   try {
// // //     print('Connecting to MQTT Broker...');
// // //     await mqttClient.connect();
// // //     print('Connected to MQTT Broker successfully!');
// // //   } catch (e) {
// // //     print('MQTT Connection failure: $e');
// // //     mqttClient.disconnect();
// // //   }
// // // }

// // // // ==========================================
// // // // 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// // // // ==========================================
// // // // Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// // // // is a Change Stream on the collection, which watches for inserts/updates in
// // // // (near) real time. Change Streams require the deployment to be a replica
// // // // set — Atlas clusters (including the free M0 tier) already are one, so
// // // // this works without extra setup.
// // // //
// // // Future<void> startMongoChangeStreamBridge() async {
// // //   final collection = db.collection('machine_sensor_data');
// // //   // First positional arg is an aggregation pipeline to filter/shape events
// // //   // (empty list = no filtering, receive every change). `fullDocument:
// // //   // 'updateLookup'` makes update events include the complete document
// // //   // instead of just the changed fields.
// // //   final stream = collection.watch(
// // //     <Map<String, Object>>[],
// // //     changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
// // //   );

// // //   print("MongoDB change stream actively watching collection: machine_sensor_data");

// // //   stream.listen((event) {
// // //     final doc = event.fullDocument;
// // //     if (doc == null) return;

// // //     final payload = jsonEncode(_sensorRowToJson(doc));
// // //     print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

// // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // //       final builder = MqttClientPayloadBuilder();
// // //       builder.addString(payload);

// // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // //     } else {
// // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // //     }
// // //   }, onError: (e) {
// // //     print("[MQTT BRIDGE ERROR] Change stream error: $e");
// // //   });
// // // }

// // // // ==========================================
// // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // ==========================================
// // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // //   final row = await _withRetry(
// // //     () => db.collection('Users').findOne(where.eq('username', username.trim())),
// // //   );

// // //   if (row != null) {
// // //     // ASSUMPTION: the `users` collection has a `password` field (the old
// // //     // Postgres code read column index 2 positionally). Rename this key to
// // //     // match your actual document shape if it differs.
// // //     final dbPassword = row['password']?.toString() ?? '';

// // //     if (dbPassword == password) {
// // //       return {"success": true, "message": "Login successful", "username": username};
// // //     }
// // //   }
// // //   return {"success": false, "message": "Invalid username or password"};
// // // }

// // // // ------------------------------------------
// // // // COLLECTION: machine_sensor_data
// // // // (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // // This is the live telemetry collection the Dashboard reads from. Rows are
// // // // expected to be written by the sensor/device pipeline (e.g. via whatever
// // // // replaces the old MQTT->Postgres path on the device side), not by this
// // // // app's UI.
// // // // ------------------------------------------

// // // // Decodes the creation time embedded in a Mongo ObjectId: the first 4
// // // // bytes (8 hex chars) of every ObjectId are a big-endian Unix timestamp in
// // // // seconds. Decoding it manually here (rather than relying on whatever
// // // // `.timestamp`/`.getTimestamp()` helper a given mongo_dart version does or
// // // // doesn't expose) keeps this working regardless of the installed package
// // // // version.
// // // DateTime? _timestampFromObjectId(ObjectId id) {
// // //   try {
// // //     final hex = id.oid;
// // //     final seconds = int.parse(hex.substring(0, 8), radix: 16);
// // //     return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
// // //   } catch (_) {
// // //     return null;
// // //   }
// // // }

// // // // Resolves the "true" creation time for a machine_sensor_data row.
// // // // Prefers the document's own `createdAt` field, but falls back to the
// // // // timestamp embedded in the Mongo `_id` (every ObjectId encodes its
// // // // creation second) whenever `createdAt` is missing, null, or unparsable —
// // // // which is exactly the case you're hitting: some rows from the sensor
// // // // pipeline come through with `createdAt: null`. The ObjectId is generated
// // // // by the driver/server at insert time regardless of what the sensor
// // // // payload did or didn't include, so this always has a value.
// // // DateTime? _sensorTimestamp(Map<String, dynamic> row) {
// // //   final explicit = _asDateTime(row['createdAt']);
// // //   if (explicit != null) return explicit;

// // //   final id = row['_id'];
// // //   if (id is ObjectId) return _timestampFromObjectId(id);

// // //   return null;
// // // }

// // // // Turns a raw Mongo document into the JSON shape the Flutter app expects.
// // // // `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// // // // app just uses it as an opaque, ascending-over-time sort/display key —
// // // // ObjectId hex strings sort lexicographically in the same order they were
// // // // created, so ascending string sort == chronological order.
// // // Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
// // //   return {
// // //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // //     "amb_temp": row["amb_temp"],
// // //     "tm1_fet": row["tm1_fet"],
// // //     "tm1_ret": row["tm1_ret"],
// // //     "tm2_fet": row["tm2_fet"],
// // //     "tm2_ret": row["tm2_ret"],
// // //     // See _sensorTimestamp: uses the document's createdAt when present,
// // //     // otherwise derives it from the ObjectId so this is never null even
// // //     // for rows the sensor pipeline wrote without a timestamp.
// // //     "created_at": _sensorTimestamp(row)?.toIso8601String(),
// // //   };
// // // }

// // // // Query Function to select all rows from target collection machine_sensor_data
// // // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// // //   // Sort ascending by _id (chronological) — same intent as the old
// // //   // `ORDER BY id ASC`.
// // //   //
// // //   // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
// // //   // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
// // //   // strings aren't numeric, so that parse will yield 0 for every row and
// // //   // the client-side sort becomes a no-op — which is harmless *only because*
// // //   // this query already returns rows in the correct chronological order. If
// // //   // you ever change this query to sort differently, update the Flutter
// // //   // sort comparator to parse `created_at` (sourced from Mongo's `createdAt`)
// // //   // as a DateTime instead of `id`.
// // //   final rows = await _withRetry(
// // //     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
// // //   );

// // //   return rows.map(_sensorRowToJson).toList();
// // // }

// // // // ------------------------------------------
// // // // COLLECTION: vfddatas
// // // // (machineId, outputCurrent, outputVoltage, outputRPM, outputFrequency,
// // // //  outputPower, createdAt, updatedAt)
// // // // A separate telemetry stream from a VFD (Variable Frequency Drive) unit —
// // // // written by its own external pipeline, same as machine_sensor_data. Powers
// // // // the Dashboard's 5-tab VFD chart (Current / Voltage / RPM / Frequency /
// // // // Power), one series per tab.
// // // // ------------------------------------------

// // // // Turns a raw Mongo vfddatas document into the JSON shape the Flutter app
// // // // expects. Mirrors _sensorRowToJson's approach: `_id` -> `id` (hex string),
// // // // and createdAt is normalized to an ISO string so the client never has to
// // // // deal with Mongo's native DateTime/BSON encoding.
// // // Map<String, dynamic> _vfdRowToJson(Map<String, dynamic> row) {
// // //   return {
// // //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // //     "machineId": row["machineId"]?.toString(),
// // //     "outputCurrent": row["outputCurrent"],
// // //     "outputVoltage": row["outputVoltage"],
// // //     "outputRPM": row["outputRPM"],
// // //     "outputFrequency": row["outputFrequency"],
// // //     "outputPower": row["outputPower"],
// // //     // Same createdAt-with-ObjectId-fallback treatment as
// // //     // machine_sensor_data, in case a future writer omits createdAt too.
// // //     "created_at": (_asDateTime(row["createdAt"]) ??
// // //             (row["_id"] is ObjectId ? _timestampFromObjectId(row["_id"] as ObjectId) : null))
// // //         ?.toIso8601String(),
// // //   };
// // // }

// // // // Query Function to select all rows from target collection vfddatas, sorted
// // // // ascending by _id (chronological) — same intent as machine_sensor_data's
// // // // fetch above, so the Flutter line charts plot oldest-to-newest, left to
// // // // right, with no client-side re-sort needed.
// // // Future<List<Map<String, dynamic>>> fetchVfdDataFromDB() async {
// // //   final rows = await _withRetry(
// // //     () => db.collection('vfddatas').find(where.sortBy('_id')).toList(),
// // //   );

// // //   return rows.map(_vfdRowToJson).toList();
// // // }

// // // // ------------------------------------------
// // // // SESSION SCOPING: machine_data (Start/Stop) -> machine_sensor_data window
// // // // ------------------------------------------
// // // // A "session" is one Start (status=1) + its matching Stop (status=0) for a
// // // // given (motor_type, test_id) pair. The dashboard shows only the sensor
// // // // readings whose created_at falls between that Start and Stop — or, if no
// // // // Stop has been logged yet, everything from Start up to now (a live/running
// // // // session).

// // // // Best-effort conversion since `created_at` may come back from Mongo as a
// // // // native DateTime (for docs this app wrote) or as a String (for docs written
// // // // by an external device/sensor pipeline that this app doesn't control).
// // // DateTime? _asDateTime(dynamic v) {
// // //   if (v == null) return null;
// // //   if (v is DateTime) return v;
// // //   return DateTime.tryParse(v.toString());
// // // }

// // // // Returns the distinct (motor_type, test_id) combinations seen in
// // // // machine_data, most-recently-active first, each tagged with whether its
// // // // latest event was a Start (still running) or a Stop (completed) — this is
// // // // what populates the Dashboard's session-picker dropdown.
// // // Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
// // //   final rows = await _withRetry(
// // //     () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
// // //   );

// // //   // Dart Maps preserve insertion order, and we insert in descending-recency
// // //   // order, so `seen.values` naturally comes out most-recent-first with one
// // //   // entry per (motor_type, test_id).
// // //   final seen = <String, Map<String, dynamic>>{};
// // //   for (final row in rows) {
// // //     final motorType = row['motor_type']?.toString() ?? '';
// // //     final testId = row['test_id']?.toString() ?? '';
// // //     if (motorType.isEmpty || testId.isEmpty) continue;
// // //     final key = '$motorType\u0000$testId';
// // //     seen.putIfAbsent(key, () => {
// // //           "motor_type": motorType,
// // //           "test_id": testId,
// // //           "last_status": row['status'],
// // //           "is_active": row['status'] == 1,
// // //           "last_activity": _asDateTime(row['created_at'])?.toIso8601String(),
// // //         });
// // //   }
// // //   return seen.values.toList();
// // // }

// // // // Finds the latest Start for (motor_type, test_id), its matching Stop (if
// // // // any), and every machine_sensor_data reading recorded in that window.
// // // Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
// // //   final sessionDocs = await _withRetry(
// // //     () => db
// // //         .collection('machine_data')
// // //         .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
// // //         .toList(),
// // //   );

// // //   // Latest Start: first status==1 doc when walking newest -> oldest.
// // //   Map<String, dynamic>? startDoc;
// // //   for (final d in sessionDocs) {
// // //     if (d['status'] == 1) {
// // //       startDoc = d;
// // //       break;
// // //     }
// // //   }
// // //   if (startDoc == null) {
// // //     return {"found": false, "motor_type": motorType, "test_id": testId};
// // //   }
// // //   final startTime = _asDateTime(startDoc['created_at']);

// // //   // Matching Stop: earliest status==0 doc that occurs after startTime, i.e.
// // //   // the first Stop encountered walking oldest -> newest starting right
// // //   // after the Start.
// // //   DateTime? stopTime;
// // //   for (final d in sessionDocs.reversed) {
// // //     if (d['status'] == 0) {
// // //       final t = _asDateTime(d['created_at']);
// // //       if (t != null && startTime != null && t.isAfter(startTime)) {
// // //         stopTime = t;
// // //         break;
// // //       }
// // //     }
// // //   }

// // //   // Filtered (and sorted) in application code rather than via a Mongo
// // //   // query/sort, because machine_sensor_data is written by an external
// // //   // pipeline this app doesn't control and some rows come through with a
// // //   // null/missing `createdAt` — sorting server-side on that field alone
// // //   // would misplace those rows. _sensorTimestamp() falls back to the
// // //   // ObjectId's embedded creation time for exactly those rows, so every
// // //   // row gets a usable timestamp before sorting/filtering.
// // //   final allSensorRows = await _withRetry(
// // //     () => db.collection('machine_sensor_data').find().toList(),
// // //   );

// // //   allSensorRows.sort((a, b) {
// // //     final ta = _sensorTimestamp(a);
// // //     final tb = _sensorTimestamp(b);
// // //     if (ta == null && tb == null) return 0;
// // //     if (ta == null) return -1;
// // //     if (tb == null) return 1;
// // //     return ta.compareTo(tb);
// // //   });

// // //   final windowed = allSensorRows.where((row) {
// // //     final t = _sensorTimestamp(row);
// // //     if (t == null) return false;
// // //     if (startTime != null && t.isBefore(startTime)) return false;
// // //     if (stopTime != null && t.isAfter(stopTime)) return false;
// // //     return true;
// // //   }).map(_sensorRowToJson).toList();

// // //   return {
// // //     "found": true,
// // //     "motor_type": motorType,
// // //     "test_id": testId,
// // //     "start_time": startTime?.toIso8601String(),
// // //     "stop_time": stopTime?.toIso8601String(),
// // //     "is_active": stopTime == null,
// // //     "sensor_data": windowed,
// // //   };
// // // }

// // // // ------------------------------------------
// // // // SEPARATE COLLECTION: machine_data
// // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, field_3, status)
// // // // Completely independent from machine_sensor_data above — it powers the Log
// // // // Entry form only. The dashboard reads machine_sensor_data.
// // // // ------------------------------------------

// // // // Inserts a new document into machine_data.
// // // // status: 1 = Start, 0 = Stop
// // // //
// // // // FIX: previously this returned {"success": result.isSuccess, ...} but the
// // // // route handler ignored that flag entirely and always answered the client
// // // // with HTTP 201 — so a failed/rejected insert still looked like a success
// // // // to the Flutter app (it shows the "Started"/"Stopped" animation and adds
// // // // the row to Active Sessions) even though nothing was written to MongoDB.
// // // // Now this throws when the driver reports the write didn't succeed, so the
// // // // route's existing try/catch turns that into a real error response instead
// // // // of a fake 201.
// // // Future<Map<String, dynamic>> insertMachineRecord(
// // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, String field3, int status
// // // ) async {
// // //   final doc = {
// // //     "motor_type": motorType,
// // //     "machine_id": machineId,
// // //     "test_id": testId,
// // //     "operation_name": operationName,
// // //     "field_1": field1,
// // //     "field_2": field2,
// // //     "field_3": field3,
// // //     "status": status,
// // //     "created_at": DateTime.now().toUtc(),
// // //   };

// // //   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

// // //   if (!result.isSuccess) {
// // //     // Log the full WriteResult server-side (write errors, write concern
// // //     // errors, etc. all show up in result.toString()) so this is
// // //     // diagnosable from the server console, not just a generic 500 on the
// // //     // client.
// // //     print("[INSERT FAILED] machine_data insert did not succeed: $result");
// // //     throw Exception('Database did not confirm the write (isSuccess=false) — nothing was saved.');
// // //   }

// // //   final insertedId = (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString();
// // //   print("[INSERT OK] machine_data id=$insertedId motor_type=$motorType test_id=$testId status=$status");

// // //   return {
// // //     "success": true,
// // //     "record": {
// // //       "id": insertedId,
// // //       ...doc,
// // //       "created_at": doc["created_at"].toString(),
// // //     },
// // //   };
// // // }

// // // // Query Function to select all rows from target collection machine_data
// // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // //   final rows = await _withRetry(
// // //     () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
// // //   );

// // //   return rows.map((row) {
// // //     return {
// // //       "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// // //       "motor_type": row["motor_type"],
// // //       "machine_id": row["machine_id"],
// // //       "test_id": row["test_id"],
// // //       "operation_name": row["operation_name"],
// // //       "field_1": row["field_1"],
// // //       "field_2": row["field_2"],
// // //       "field_3": row["field_3"],
// // //       "status": row["status"],
// // //       "created_at": row["created_at"]?.toString(),
// // //     };
// // //   }).toList();
// // // }

// // // // ==========================================
// // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // ==========================================
// // // Future<void> main() async {
// // //   // Only MongoDB is required for login/dashboard/form routes to work,
// // //   // so that's the only thing we block server startup on.
// // //   await connectDB();

// // //   final router = Router();

// // //   router.post('/login', (Request request) async {
// // //     try {
// // //       final body = jsonDecode(await request.readAsString());
// // //       String username = body['username']?.toString() ?? '';
// // //       String password = body['password']?.toString() ?? '';

// // //       if (username.isEmpty || password.isEmpty) {
// // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // //       }

// // //       final result = await loginUser(username, password);
// // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
// // //   router.get('/get-sensor-data', (Request request) async {
// // //     try {
// // //       final logs = await fetchSensorDataFromDB();
// // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   // GET Endpoint targeting vfddatas — powers the Dashboard's 5-tab VFD
// // //   // chart (Current / Voltage / RPM / Frequency / Power).
// // //   router.get('/get-vfd-data', (Request request) async {
// // //     try {
// // //       final logs = await fetchVfdDataFromDB();
// // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   // ------------------------------------------
// // //   // SEPARATE COLLECTION ROUTES: machine_data
// // //   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
// // //   // ------------------------------------------
// // //   router.post('/add-machine-record', (Request request) async {
// // //     try {
// // //       final body = jsonDecode(await request.readAsString());

// // //       String motorType = body['motor_type']?.toString() ?? '';
// // //       String machineId = body['machine_id']?.toString() ?? '';
// // //       String testId = body['test_id']?.toString() ?? '';
// // //       String operationName = body['operation_name']?.toString() ?? '';
// // //       String field1 = body['field_1']?.toString() ?? '';
// // //       String field2 = body['field_2']?.toString() ?? '';
// // //       String field3 = body['field_3']?.toString() ?? '';
// // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty || field3.isEmpty) {
// // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // //       }

// // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, field3, status);

// // //       // FIX: this used to unconditionally return 201 regardless of what
// // //       // `result` actually said. insertMachineRecord() now throws instead
// // //       // of returning success:false, so by the time we get here the insert
// // //       // is confirmed — but we still check explicitly rather than trusting
// // //       // that invariant blindly, so a future change to insertMachineRecord
// // //       // can't silently reintroduce the same bug.
// // //       final success = result["success"] == true;
// // //       return Response(
// // //         success ? 201 : 500,
// // //         body: jsonEncode(result),
// // //         headers: {"Content-Type": "application/json"},
// // //       );
// // //     } catch (e) {
// // //       print("[/add-machine-record] Insert failed: $e");
// // //       return Response.internalServerError(
// // //         body: jsonEncode({"success": false, "message": e.toString()}),
// // //         headers: {"Content-Type": "application/json"},
// // //       );
// // //     }
// // //   });

// // //   // GET Endpoint targeting machine_data
// // //   router.get('/get-machine-records', (Request request) async {
// // //     try {
// // //       final logs = await fetchMachineRecordsFromDB();
// // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   // ------------------------------------------
// // //   // SESSION-SCOPED ROUTES
// // //   // Power the Dashboard's session picker + session-windowed sensor view.
// // //   // ------------------------------------------

// // //   // Lists distinct (motor_type, test_id) sessions, most recently active
// // //   // first — populates the Dashboard's dropdown.
// // //   router.get('/get-machine-sessions', (Request request) async {
// // //     try {
// // //       final sessions = await fetchMachineSessionsFromDB();
// // //       return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   // Returns machine_sensor_data readings between a session's Start and
// // //   // Stop (or Start-to-now if it's still running), for one motor_type +
// // //   // test_id. e.g. /get-session-sensor-data?motor_type=Motor+1&test_id=TST-1
// // //   router.get('/get-session-sensor-data', (Request request) async {
// // //     try {
// // //       final motorType = request.url.queryParameters['motor_type'] ?? '';
// // //       final testId = request.url.queryParameters['test_id'] ?? '';

// // //       if (motorType.isEmpty || testId.isEmpty) {
// // //         return Response(400, body: jsonEncode({"message": "motor_type and test_id are required"}), headers: {"Content-Type": "application/json"});
// // //       }

// // //       final result = await fetchSessionSensorData(motorType, testId);
// // //       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // //   await io.serve(handler, '0.0.0.0', 3000);
// // //   print("Server engine operational on http://MongoDB:3000");

// // //   // Login, the form, and the dashboard never depend on this — it's purely
// // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // //   unawaited(_startRealtimeBridgeInBackground());
// // // }

// // // Future<void> _startRealtimeBridgeInBackground() async {
// // //   try {
// // //     await connectMQTT();
// // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // //       await startMongoChangeStreamBridge();
// // //     } else {
// // //       print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
// // //     }
// // //   } catch (e) {
// // //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// // //   }
// // // }

























// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:mongo_dart/mongo_dart.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'package:mqtt_client/mqtt_client.dart';

// // late Db db;
// // late MqttServerClient mqttClient;

// // // ==========================================
// // // 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// // // ==========================================
// // // SECURITY NOTE: this mirrors the pattern in the original Postgres file
// // // (credentials hardcoded in source), but since this URI has now been
// // // pasted into a chat, treat the password as compromised — rotate it in
// // // Atlas ("Database Access" -> edit user -> new password) and, ideally,
// // // load the URI from an environment variable instead of committing it:
// // //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// // const String _mongoUri =
// //     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// // // Opens a single connection, retrying every 3s until it succeeds — same
// // // resilience behavior as the old _openConnection() for Neon (Atlas free
// // // tier doesn't auto-suspend the way Neon's does, but a transient network
// // // blip on first boot is still worth retrying through).
// // Future<Db> _openConnection() async {
// //   while (true) {
// //     try {
// //       final database = await Db.create(_mongoUri);
// //       await database.open();
// //       return database;
// //     } catch (e) {
// //       print("DB connection failed, retrying in 3s: $e");
// //       print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
// //       await Future.delayed(const Duration(seconds: 3));
// //     }
// //   }
// // }

// // Future<void> connectDB() async {
// //   db = await _openConnection();
// //   print("Connected to MongoDB (database: ${db.databaseName})");
// // }

// // // Runs a query; if it fails because the connection has gone stale,
// // // reopens the connection and retries the action once before giving up.
// // Future<T> _withRetry<T>(Future<T> Function() action) async {
// //   try {
// //     return await action();
// //   } catch (e) {
// //     print("Query failed ($e). Reconnecting to MongoDB and retrying...");
// //     db = await _openConnection();
// //     return await action();
// //   }
// // }

// // // ==========================================
// // // 2. MQTT CLIENT PUBLISHER
// // // ==========================================
// // Future<void> connectMQTT() async {
// //   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
// //   mqttClient.port = 1883;
// //   mqttClient.logging(on: false);
// //   mqttClient.keepAlivePeriod = 20;
// //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// //   try {
// //     print('Connecting to MQTT Broker...');
// //     await mqttClient.connect();
// //     print('Connected to MQTT Broker successfully!');
// //   } catch (e) {
// //     print('MQTT Connection failure: $e');
// //     mqttClient.disconnect();
// //   }
// // }

// // // ==========================================
// // // 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// // // ==========================================
// // // Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// // // is a Change Stream on the collection, which watches for inserts/updates in
// // // (near) real time. Change Streams require the deployment to be a replica
// // // set — Atlas clusters (including the free M0 tier) already are one, so
// // // this works without extra setup.
// // //
// // Future<void> startMongoChangeStreamBridge() async {
// //   final collection = db.collection('machine_sensor_data');
// //   // First positional arg is an aggregation pipeline to filter/shape events
// //   // (empty list = no filtering, receive every change). `fullDocument:
// //   // 'updateLookup'` makes update events include the complete document
// //   // instead of just the changed fields.
// //   final stream = collection.watch(
// //     <Map<String, Object>>[],
// //     changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
// //   );

// //   print("MongoDB change stream actively watching collection: machine_sensor_data");

// //   stream.listen((event) {
// //     final doc = event.fullDocument;
// //     if (doc == null) return;

// //     final payload = jsonEncode(_sensorRowToJson(doc));
// //     print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       final builder = MqttClientPayloadBuilder();
// //       builder.addString(payload);

// //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// //     } else {
// //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// //     }
// //   }, onError: (e) {
// //     print("[MQTT BRIDGE ERROR] Change stream error: $e");
// //   });
// // }

// // // ==========================================
// // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // ==========================================
// // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// //   final row = await _withRetry(
// //     () => db.collection('Users').findOne(where.eq('username', username.trim())),
// //   );

// //   if (row != null) {
// //     // ASSUMPTION: the `users` collection has a `password` field (the old
// //     // Postgres code read column index 2 positionally). Rename this key to
// //     // match your actual document shape if it differs.
// //     final dbPassword = row['password']?.toString() ?? '';

// //     if (dbPassword == password) {
// //       return {"success": true, "message": "Login successful", "username": username};
// //     }
// //   }
// //   return {"success": false, "message": "Invalid username or password"};
// // }

// // // ------------------------------------------
// // // COLLECTION: machine_sensor_data
// // // (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // This is the live telemetry collection the Dashboard reads from. Rows are
// // // expected to be written by the sensor/device pipeline (e.g. via whatever
// // // replaces the old MQTT->Postgres path on the device side), not by this
// // // app's UI.
// // // ------------------------------------------

// // // Decodes the creation time embedded in a Mongo ObjectId: the first 4
// // // bytes (8 hex chars) of every ObjectId are a big-endian Unix timestamp in
// // // seconds. Decoding it manually here (rather than relying on whatever
// // // `.timestamp`/`.getTimestamp()` helper a given mongo_dart version does or
// // // doesn't expose) keeps this working regardless of the installed package
// // // version.
// // DateTime? _timestampFromObjectId(ObjectId id) {
// //   try {
// //     final hex = id.oid;
// //     final seconds = int.parse(hex.substring(0, 8), radix: 16);
// //     return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
// //   } catch (_) {
// //     return null;
// //   }
// // }

// // // Resolves the "true" creation time for a machine_sensor_data row.
// // // Prefers the document's own `createdAt` field, but falls back to the
// // // timestamp embedded in the Mongo `_id` (every ObjectId encodes its
// // // creation second) whenever `createdAt` is missing, null, or unparsable —
// // // which is exactly the case you're hitting: some rows from the sensor
// // // pipeline come through with `createdAt: null`. The ObjectId is generated
// // // by the driver/server at insert time regardless of what the sensor
// // // payload did or didn't include, so this always has a value.
// // DateTime? _sensorTimestamp(Map<String, dynamic> row) {
// //   final explicit = _asDateTime(row['createdAt']);
// //   if (explicit != null) return explicit;

// //   final id = row['_id'];
// //   if (id is ObjectId) return _timestampFromObjectId(id);

// //   return null;
// // }

// // // Turns a raw Mongo document into the JSON shape the Flutter app expects.
// // // `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// // // app just uses it as an opaque, ascending-over-time sort/display key —
// // // ObjectId hex strings sort lexicographically in the same order they were
// // // created, so ascending string sort == chronological order.
// // Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
// //   return {
// //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// //     "amb_temp": row["amb_temp"],
// //     "tm1_fet": row["tm1_fet"],
// //     "tm1_ret": row["tm1_ret"],
// //     "tm2_fet": row["tm2_fet"],
// //     "tm2_ret": row["tm2_ret"],
// //     // See _sensorTimestamp: uses the document's createdAt when present,
// //     // otherwise derives it from the ObjectId so this is never null even
// //     // for rows the sensor pipeline wrote without a timestamp.
// //     "created_at": _sensorTimestamp(row)?.toIso8601String(),
// //   };
// // }

// // // Query Function to select all rows from target collection machine_sensor_data
// // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// //   // Sort ascending by _id (chronological) — same intent as the old
// //   // `ORDER BY id ASC`.
// //   //
// //   // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
// //   // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
// //   // strings aren't numeric, so that parse will yield 0 for every row and
// //   // the client-side sort becomes a no-op — which is harmless *only because*
// //   // this query already returns rows in the correct chronological order. If
// //   // you ever change this query to sort differently, update the Flutter
// //   // sort comparator to parse `created_at` (sourced from Mongo's `createdAt`)
// //   // as a DateTime instead of `id`.
// //   final rows = await _withRetry(
// //     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
// //   );

// //   return rows.map(_sensorRowToJson).toList();
// // }

// // // ------------------------------------------
// // // COLLECTION: vfddatas
// // // (machineId, outputCurrent, outputVoltage, outputRPM, outputFrequency,
// // //  outputPower, createdAt, updatedAt)
// // // A separate telemetry stream from a VFD (Variable Frequency Drive) unit —
// // // written by its own external pipeline, same as machine_sensor_data. Powers
// // // the Dashboard's 5-tab VFD chart (Current / Voltage / RPM / Frequency /
// // // Power), one series per tab.
// // // ------------------------------------------

// // // Turns a raw Mongo vfddatas document into the JSON shape the Flutter app
// // // expects. Mirrors _sensorRowToJson's approach: `_id` -> `id` (hex string),
// // // and createdAt is normalized to an ISO string so the client never has to
// // // deal with Mongo's native DateTime/BSON encoding.
// // Map<String, dynamic> _vfdRowToJson(Map<String, dynamic> row) {
// //   return {
// //     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// //     "machineId": row["machineId"]?.toString(),
// //     "outputCurrent": row["outputCurrent"],
// //     "outputVoltage": row["outputVoltage"],
// //     "outputRPM": row["outputRPM"],
// //     "outputFrequency": row["outputFrequency"],
// //     "outputPower": row["outputPower"],
// //     // Same createdAt-with-ObjectId-fallback treatment as
// //     // machine_sensor_data, in case a future writer omits createdAt too.
// //     "created_at": (_asDateTime(row["createdAt"]) ??
// //             (row["_id"] is ObjectId ? _timestampFromObjectId(row["_id"] as ObjectId) : null))
// //         ?.toIso8601String(),
// //   };
// // }

// // // Query Function to select all rows from target collection vfddatas, sorted
// // // ascending by _id (chronological) — same intent as machine_sensor_data's
// // // fetch above, so the Flutter line charts plot oldest-to-newest, left to
// // // right, with no client-side re-sort needed.
// // Future<List<Map<String, dynamic>>> fetchVfdDataFromDB() async {
// //   final rows = await _withRetry(
// //     () => db.collection('vfddatas').find(where.sortBy('_id')).toList(),
// //   );

// //   return rows.map(_vfdRowToJson).toList();
// // }

// // // ------------------------------------------
// // // SESSION SCOPING: machine_data (Start/Stop) -> machine_sensor_data window
// // // ------------------------------------------
// // // A "session" is one Start (status=1) + its matching Stop (status=0) for a
// // // given (motor_type, test_id) pair. The dashboard shows only the sensor
// // // readings whose created_at falls between that Start and Stop — or, if no
// // // Stop has been logged yet, everything from Start up to now (a live/running
// // // session).

// // // Best-effort conversion since `created_at` may come back from Mongo as a
// // // native DateTime (for docs this app wrote) or as a String (for docs written
// // // by an external device/sensor pipeline that this app doesn't control).
// // DateTime? _asDateTime(dynamic v) {
// //   if (v == null) return null;
// //   if (v is DateTime) return v;
// //   return DateTime.tryParse(v.toString());
// // }

// // // Returns the distinct (motor_type, test_id) combinations seen in
// // // machine_data, most-recently-active first, each tagged with whether its
// // // latest event was a Start (still running) or a Stop (completed) — this is
// // // what populates the Dashboard's session-picker dropdown.
// // Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
// //   final rows = await _withRetry(
// //     () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
// //   );

// //   // Dart Maps preserve insertion order, and we insert in descending-recency
// //   // order, so `seen.values` naturally comes out most-recent-first with one
// //   // entry per (motor_type, test_id).
// //   final seen = <String, Map<String, dynamic>>{};
// //   for (final row in rows) {
// //     final motorType = row['motor_type']?.toString() ?? '';
// //     final testId = row['test_id']?.toString() ?? '';
// //     if (motorType.isEmpty || testId.isEmpty) continue;
// //     final key = '$motorType\u0000$testId';
// //     seen.putIfAbsent(key, () => {
// //           "motor_type": motorType,
// //           "test_id": testId,
// //           "last_status": row['status'],
// //           "is_active": row['status'] == 1,
// //           "last_activity": _asDateTime(row['created_at'])?.toIso8601String(),
// //         });
// //   }
// //   return seen.values.toList();
// // }

// // // Finds the latest Start for (motor_type, test_id), its matching Stop (if
// // // any), and every machine_sensor_data reading recorded in that window.
// // Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
// //   final sessionDocs = await _withRetry(
// //     () => db
// //         .collection('machine_data')
// //         .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
// //         .toList(),
// //   );

// //   // Latest Start: first status==1 doc when walking newest -> oldest.
// //   Map<String, dynamic>? startDoc;
// //   for (final d in sessionDocs) {
// //     if (d['status'] == 1) {
// //       startDoc = d;
// //       break;
// //     }
// //   }
// //   if (startDoc == null) {
// //     return {"found": false, "motor_type": motorType, "test_id": testId};
// //   }
// //   final startTime = _asDateTime(startDoc['created_at']);

// //   // Matching Stop: earliest status==0 doc that occurs after startTime, i.e.
// //   // the first Stop encountered walking oldest -> newest starting right
// //   // after the Start.
// //   DateTime? stopTime;
// //   for (final d in sessionDocs.reversed) {
// //     if (d['status'] == 0) {
// //       final t = _asDateTime(d['created_at']);
// //       if (t != null && startTime != null && t.isAfter(startTime)) {
// //         stopTime = t;
// //         break;
// //       }
// //     }
// //   }

// //   // Filtered (and sorted) in application code rather than via a Mongo
// //   // query/sort, because machine_sensor_data is written by an external
// //   // pipeline this app doesn't control and some rows come through with a
// //   // null/missing `createdAt` — sorting server-side on that field alone
// //   // would misplace those rows. _sensorTimestamp() falls back to the
// //   // ObjectId's embedded creation time for exactly those rows, so every
// //   // row gets a usable timestamp before sorting/filtering.
// //   final allSensorRows = await _withRetry(
// //     () => db.collection('machine_sensor_data').find().toList(),
// //   );

// //   allSensorRows.sort((a, b) {
// //     final ta = _sensorTimestamp(a);
// //     final tb = _sensorTimestamp(b);
// //     if (ta == null && tb == null) return 0;
// //     if (ta == null) return -1;
// //     if (tb == null) return 1;
// //     return ta.compareTo(tb);
// //   });

// //   final windowed = allSensorRows.where((row) {
// //     final t = _sensorTimestamp(row);
// //     if (t == null) return false;
// //     if (startTime != null && t.isBefore(startTime)) return false;
// //     if (stopTime != null && t.isAfter(stopTime)) return false;
// //     return true;
// //   }).map(_sensorRowToJson).toList();

// //   return {
// //     "found": true,
// //     "motor_type": motorType,
// //     "test_id": testId,
// //     "start_time": startTime?.toIso8601String(),
// //     "stop_time": stopTime?.toIso8601String(),
// //     "is_active": stopTime == null,
// //     "sensor_data": windowed,
// //   };
// // }

// // // ------------------------------------------
// // // DAY-WISE RANGE FILTER: machine_data (Start/Stop, any motor/test) ->
// // // combined machine_sensor_data window
// // // ------------------------------------------
// // // Same Start(status=1)/Stop(status=0) session concept as
// // // fetchSessionSensorData above, but instead of one caller-specified
// // // (motor_type, test_id), this builds EVERY session across the whole
// // // machine_data collection, keeps only the ones whose Start falls inside
// // // the requested [from, to] day range, and returns the combined
// // // machine_sensor_data readings across all of those sessions' windows —
// // // which is what powers the Dashboard's "SESSION LOG · DATE RANGE" table.
// // Future<Map<String, dynamic>> fetchSensorDataInRange(DateTime from, DateTime to) async {
// //   final machineRows = await _withRetry(
// //     () => db.collection('machine_data').find(where.sortBy('created_at')).toList(),
// //   );

// //   // Walk chronologically, matching each Start with the next Stop for the
// //   // SAME (motor_type, test_id) key. A Start with no later Stop yet is left
// //   // open (stop_time stays null -> that session's sensor window runs to
// //   // "now" when queried below).
// //   final openStarts = <String, Map<String, dynamic>>{};
// //   final sessions = <Map<String, dynamic>>[];

// //   for (final row in machineRows) {
// //     final motorType = row['motor_type']?.toString() ?? '';
// //     final testId = row['test_id']?.toString() ?? '';
// //     if (motorType.isEmpty || testId.isEmpty) continue;
// //     final key = '$motorType\u0000$testId';
// //     final status = row['status'];

// //     if (status == 1) {
// //       // A fresh Start replaces any still-open Start for this same key —
// //       // keeps this robust even against back-to-back Starts with no Stop
// //       // logged in between.
// //       openStarts[key] = row;
// //     } else if (status == 0) {
// //       final start = openStarts.remove(key);
// //       if (start != null) {
// //         sessions.add({
// //           "motor_type": motorType,
// //           "test_id": testId,
// //           "machine_id": start["machine_id"],
// //           "operation_name": start["operation_name"],
// //           "start_time": _asDateTime(start["created_at"]),
// //           "stop_time": _asDateTime(row["created_at"]),
// //         });
// //       }
// //     }
// //   }
// //   // Anything still open at the end of the collection is a running session.
// //   for (final start in openStarts.values) {
// //     sessions.add({
// //       "motor_type": start["motor_type"],
// //       "test_id": start["test_id"],
// //       "machine_id": start["machine_id"],
// //       "operation_name": start["operation_name"],
// //       "start_time": _asDateTime(start["created_at"]),
// //       "stop_time": null,
// //     });
// //   }

// //   // Keep only sessions whose Start landed inside the requested day range.
// //   final matched = sessions.where((s) {
// //     final st = s["start_time"] as DateTime?;
// //     if (st == null) return false;
// //     return !st.isBefore(from) && !st.isAfter(to);
// //   }).toList()
// //     ..sort((a, b) => (a["start_time"] as DateTime).compareTo(b["start_time"] as DateTime));

// //   // Same "pull everything once, sort by resolved timestamp, then filter in
// //   // application code" approach as fetchSessionSensorData — necessary
// //   // because some machine_sensor_data rows arrive with a null createdAt.
// //   final allSensorRows = await _withRetry(() => db.collection('machine_sensor_data').find().toList());
// //   allSensorRows.sort((a, b) {
// //     final ta = _sensorTimestamp(a);
// //     final tb = _sensorTimestamp(b);
// //     if (ta == null && tb == null) return 0;
// //     if (ta == null) return -1;
// //     if (tb == null) return 1;
// //     return ta.compareTo(tb);
// //   });

// //   // Combine every matched session's window into one deduplicated,
// //   // chronologically-sorted list (a reading that falls inside two
// //   // overlapping sessions is only included once).
// //   final combined = <Map<String, dynamic>>[];
// //   final seenIds = <String>{};
// //   for (final session in matched) {
// //     final st = session["start_time"] as DateTime?;
// //     final sp = session["stop_time"] as DateTime?;
// //     for (final row in allSensorRows) {
// //       final t = _sensorTimestamp(row);
// //       if (t == null) continue;
// //       if (st != null && t.isBefore(st)) continue;
// //       if (sp != null && t.isAfter(sp)) continue;
// //       final json = _sensorRowToJson(row);
// //       final id = json["id"]?.toString() ?? '';
// //       if (id.isNotEmpty && !seenIds.add(id)) continue;
// //       combined.add(json);
// //     }
// //   }
// //   combined.sort((a, b) {
// //     final ta = DateTime.tryParse(a["created_at"]?.toString() ?? '');
// //     final tb = DateTime.tryParse(b["created_at"]?.toString() ?? '');
// //     if (ta == null && tb == null) return 0;
// //     if (ta == null) return -1;
// //     if (tb == null) return 1;
// //     return ta.compareTo(tb);
// //   });

// //   return {
// //     "from": from.toIso8601String(),
// //     "to": to.toIso8601String(),
// //     "sessions": matched
// //         .map((s) => {
// //               "motor_type": s["motor_type"],
// //               "test_id": s["test_id"],
// //               "machine_id": s["machine_id"],
// //               "operation_name": s["operation_name"],
// //               "start_time": (s["start_time"] as DateTime?)?.toIso8601String(),
// //               "stop_time": (s["stop_time"] as DateTime?)?.toIso8601String(),
// //               "is_active": s["stop_time"] == null,
// //             })
// //         .toList(),
// //     "sensor_data": combined,
// //   };
// // }

// // // ------------------------------------------
// // // SEPARATE COLLECTION: machine_data
// // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, field_3, status)
// // // Completely independent from machine_sensor_data above — it powers the Log
// // // Entry form only. The dashboard reads machine_sensor_data.
// // // ------------------------------------------

// // // Inserts a new document into machine_data.
// // // status: 1 = Start, 0 = Stop
// // //
// // // FIX: previously this returned {"success": result.isSuccess, ...} but the
// // // route handler ignored that flag entirely and always answered the client
// // // with HTTP 201 — so a failed/rejected insert still looked like a success
// // // to the Flutter app (it shows the "Started"/"Stopped" animation and adds
// // // the row to Active Sessions) even though nothing was written to MongoDB.
// // // Now this throws when the driver reports the write didn't succeed, so the
// // // route's existing try/catch turns that into a real error response instead
// // // of a fake 201.
// // Future<Map<String, dynamic>> insertMachineRecord(
// //   String motorType, String machineId, String testId, String operationName, String field1, String field2, String field3, int status
// // ) async {
// //   final doc = {
// //     "motor_type": motorType,
// //     "machine_id": machineId,
// //     "test_id": testId,
// //     "operation_name": operationName,
// //     "field_1": field1,
// //     "field_2": field2,
// //     "field_3": field3,
// //     "status": status,
// //     "created_at": DateTime.now().toUtc(),
// //   };

// //   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

// //   if (!result.isSuccess) {
// //     // Log the full WriteResult server-side (write errors, write concern
// //     // errors, etc. all show up in result.toString()) so this is
// //     // diagnosable from the server console, not just a generic 500 on the
// //     // client.
// //     print("[INSERT FAILED] machine_data insert did not succeed: $result");
// //     throw Exception('Database did not confirm the write (isSuccess=false) — nothing was saved.');
// //   }

// //   final insertedId = (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString();
// //   print("[INSERT OK] machine_data id=$insertedId motor_type=$motorType test_id=$testId status=$status");

// //   return {
// //     "success": true,
// //     "record": {
// //       "id": insertedId,
// //       ...doc,
// //       "created_at": doc["created_at"].toString(),
// //     },
// //   };
// // }

// // // Query Function to select all rows from target collection machine_data
// // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// //   final rows = await _withRetry(
// //     () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
// //   );

// //   return rows.map((row) {
// //     return {
// //       "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
// //       "motor_type": row["motor_type"],
// //       "machine_id": row["machine_id"],
// //       "test_id": row["test_id"],
// //       "operation_name": row["operation_name"],
// //       "field_1": row["field_1"],
// //       "field_2": row["field_2"],
// //       "field_3": row["field_3"],
// //       "status": row["status"],
// //       "created_at": row["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ==========================================
// // // 5. MAIN SERVICE DRIVER Entrypoint
// // // ==========================================
// // Future<void> main() async {
// //   // Only MongoDB is required for login/dashboard/form routes to work,
// //   // so that's the only thing we block server startup on.
// //   await connectDB();

// //   final router = Router();

// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());
// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await loginUser(username, password);
// //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
// //   router.get('/get-sensor-data', (Request request) async {
// //     try {
// //       final logs = await fetchSensorDataFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting vfddatas — powers the Dashboard's 5-tab VFD
// //   // chart (Current / Voltage / RPM / Frequency / Power).
// //   router.get('/get-vfd-data', (Request request) async {
// //     try {
// //       final logs = await fetchVfdDataFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // ------------------------------------------
// //   // SEPARATE COLLECTION ROUTES: machine_data
// //   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
// //   // ------------------------------------------
// //   router.post('/add-machine-record', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       String field1 = body['field_1']?.toString() ?? '';
// //       String field2 = body['field_2']?.toString() ?? '';
// //       String field3 = body['field_3']?.toString() ?? '';
// //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty || field3.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, field3, status);

// //       // FIX: this used to unconditionally return 201 regardless of what
// //       // `result` actually said. insertMachineRecord() now throws instead
// //       // of returning success:false, so by the time we get here the insert
// //       // is confirmed — but we still check explicitly rather than trusting
// //       // that invariant blindly, so a future change to insertMachineRecord
// //       // can't silently reintroduce the same bug.
// //       final success = result["success"] == true;
// //       return Response(
// //         success ? 201 : 500,
// //         body: jsonEncode(result),
// //         headers: {"Content-Type": "application/json"},
// //       );
// //     } catch (e) {
// //       print("[/add-machine-record] Insert failed: $e");
// //       return Response.internalServerError(
// //         body: jsonEncode({"success": false, "message": e.toString()}),
// //         headers: {"Content-Type": "application/json"},
// //       );
// //     }
// //   });

// //   // GET Endpoint targeting machine_data
// //   router.get('/get-machine-records', (Request request) async {
// //     try {
// //       final logs = await fetchMachineRecordsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // ------------------------------------------
// //   // SESSION-SCOPED ROUTES
// //   // Power the Dashboard's session picker + session-windowed sensor view.
// //   // ------------------------------------------

// //   // Lists distinct (motor_type, test_id) sessions, most recently active
// //   // first — populates the Dashboard's dropdown.
// //   router.get('/get-machine-sessions', (Request request) async {
// //     try {
// //       final sessions = await fetchMachineSessionsFromDB();
// //       return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // Returns machine_sensor_data readings between a session's Start and
// //   // Stop (or Start-to-now if it's still running), for one motor_type +
// //   // test_id. e.g. /get-session-sensor-data?motor_type=Motor+1&test_id=TST-1
// //   router.get('/get-session-sensor-data', (Request request) async {
// //     try {
// //       final motorType = request.url.queryParameters['motor_type'] ?? '';
// //       final testId = request.url.queryParameters['test_id'] ?? '';

// //       if (motorType.isEmpty || testId.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "motor_type and test_id are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await fetchSessionSensorData(motorType, testId);
// //       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // Day-wise range filter: every machine_data Start/Stop session whose
// //   // Start falls within [from, to] (YYYY-MM-DD, inclusive), plus the
// //   // combined machine_sensor_data readings across all of those sessions'
// //   // windows. Powers the Dashboard's "SESSION LOG · DATE RANGE" table.
// //   // e.g. /get-sensor-data-range?from=2026-07-01&to=2026-07-04
// //   router.get('/get-sensor-data-range', (Request request) async {
// //     try {
// //       final fromStr = request.url.queryParameters['from'] ?? '';
// //       final toStr = request.url.queryParameters['to'] ?? '';
// //       if (fromStr.isEmpty || toStr.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "from and to (YYYY-MM-DD) are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       DateTime parseDay(String s, {required bool endOfDay}) {
// //         final parts = s.split('-').map(int.parse).toList();
// //         return endOfDay
// //             ? DateTime.utc(parts[0], parts[1], parts[2], 23, 59, 59, 999)
// //             : DateTime.utc(parts[0], parts[1], parts[2]);
// //       }

// //       final from = parseDay(fromStr, endOfDay: false);
// //       final to = parseDay(toStr, endOfDay: true);

// //       final result = await fetchSensorDataInRange(from, to);
// //       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// //   await io.serve(handler, '0.0.0.0', 3000);
// //   print("Server engine operational on http://MongoDB:3000");

// //   // Login, the form, and the dashboard never depend on this — it's purely
// //   // for the live MQTT telemetry bridge, so it runs in the background and
// //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// //   unawaited(_startRealtimeBridgeInBackground());
// // }

// // Future<void> _startRealtimeBridgeInBackground() async {
// //   try {
// //     await connectMQTT();
// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       await startMongoChangeStreamBridge();
// //     } else {
// //       print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
// //     }
// //   } catch (e) {
// //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// //   }
// // }



// import 'dart:async';
// import 'dart:convert';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:mqtt_client/mqtt_client.dart';

// late Db db;
// late MqttServerClient mqttClient;

// // ==========================================
// // 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// // ==========================================
// // SECURITY NOTE: rotate this password in Atlas ("Database Access" -> edit
// // user -> new password) and load the URI from an environment variable
// // instead of committing it:
// //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// const String _mongoUri =
//     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// Future<Db> _openConnection() async {
//   while (true) {
//     try {
//       final database = await Db.create(_mongoUri);
//       await database.open();
//       return database;
//     } catch (e) {
//       print("DB connection failed, retrying in 3s: $e");
//       print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
//       await Future.delayed(const Duration(seconds: 3));
//     }
//   }
// }

// Future<void> connectDB() async {
//   db = await _openConnection();
//   print("Connected to MongoDB (database: ${db.databaseName})");
// }

// // ------------------------------------------
// // RECONNECT GUARD
// // ------------------------------------------
// // FIX: previously every failing query independently called
// // `db = await _openConnection()`. Under concurrent load, multiple requests
// // failing at the same instant each raced to open their OWN new connection,
// // stomping over `db` mid-reconnect and immediately hitting the dead socket
// // again -> the "Broken pipe" / "No master connection" burst seen in the
// // logs. Now there is at most ONE reconnect in flight at a time; anyone else
// // who fails while it's happening just awaits the SAME future instead of
// // starting another one.
// Future<Db>? _reconnectFuture;

// Future<Db> _reconnect() {
//   final inFlight = _reconnectFuture;
//   if (inFlight != null) return inFlight;

//   final future = _openConnection().then((newDb) {
//     db = newDb;
//     print("Reconnected to MongoDB.");
//     _reconnectFuture = null;
//     return newDb;
//   }).catchError((e) {
//     _reconnectFuture = null;
//     throw e;
//   });

//   _reconnectFuture = future;
//   return future;
// }

// // Runs a query; retries through a shared reconnect with backoff instead of
// // giving up after a single attempt, since a reconnect storm (many requests
// // failing at once) previously meant the "one retry" often landed on a
// // connection that hadn't stabilized yet.
// Future<T> _withRetry<T>(Future<T> Function() action, {int maxAttempts = 3}) async {
//   var attempt = 0;
//   while (true) {
//     try {
//       return await action();
//     } catch (e) {
//       attempt++;
//       if (attempt >= maxAttempts) {
//         print("Query failed after $attempt attempts ($e). Giving up.");
//         rethrow;
//       }
//       print("Query failed ($e). Reconnecting to MongoDB and retrying (attempt $attempt)...");
//       await _reconnect();
//       await Future.delayed(Duration(milliseconds: 300 * attempt));
//     }
//   }
// }

// // ------------------------------------------
// // KEEPALIVE
// // ------------------------------------------
// // Atlas / the hosting network can silently close an idle socket. Pinging
// // periodically keeps the connection warm so the FIRST real request after a
// // quiet period doesn't discover a dead socket. If the ping itself fails,
// // that's a signal to proactively reconnect rather than waiting for a user
// // request to trip over it.
// Timer? _keepAliveTimer;

// void _startKeepAlive() {
//   _keepAliveTimer?.cancel();
//   _keepAliveTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
//     try {
//       await db.serverStatus();
//     } catch (e) {
//       print("Keepalive ping failed ($e), reconnecting...");
//       try {
//         await _reconnect();
//       } catch (e2) {
//         print("Keepalive reconnect attempt failed: $e2");
//       }
//     }
//   });
// }

// // ==========================================
// // 2. MQTT CLIENT PUBLISHER
// // ==========================================
// Future<void> connectMQTT() async {
//   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
//   mqttClient.port = 1883;
//   mqttClient.logging(on: false);
//   mqttClient.keepAlivePeriod = 20;
//   mqttClient.connectTimeoutPeriod = 8000;

//   try {
//     print('Connecting to MQTT Broker...');
//     await mqttClient.connect();
//     print('Connected to MQTT Broker successfully!');
//   } catch (e) {
//     print('MQTT Connection failure: $e');
//     mqttClient.disconnect();
//   }
// }

// // ==========================================
// // 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// // ==========================================
// Future<void> startMongoChangeStreamBridge() async {
//   final collection = db.collection('machine_sensor_data');
//   final stream = collection.watch(
//     <Map<String, Object>>[],
//     changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
//   );

//   print("MongoDB change stream actively watching collection: machine_sensor_data");

//   stream.listen((event) {
//     final doc = event.fullDocument;
//     if (doc == null) return;

//     final payload = jsonEncode(_sensorRowToJson(doc));
//     print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

//     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
//       final builder = MqttClientPayloadBuilder();
//       builder.addString(payload);

//       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
//       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
//     } else {
//       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
//     }
//   }, onError: (e) {
//     print("[MQTT BRIDGE ERROR] Change stream error: $e");
//   });
// }

// // ==========================================
// // 4. BUSINESS LOGIC DATABASE QUERIES
// // ==========================================
// Future<Map<String, dynamic>> loginUser(String username, String password) async {
//   final row = await _withRetry(
//     () => db.collection('Users').findOne(where.eq('username', username.trim())),
//   );

//   if (row != null) {
//     final dbPassword = row['password']?.toString() ?? '';

//     if (dbPassword == password) {
//       return {"success": true, "message": "Login successful", "username": username};
//     }
//   }
//   return {"success": false, "message": "Invalid username or password"};
// }

// // ------------------------------------------
// // COLLECTION: machine_sensor_data
// // ------------------------------------------
// DateTime? _timestampFromObjectId(ObjectId id) {
//   try {
//     final hex = id.oid;
//     final seconds = int.parse(hex.substring(0, 8), radix: 16);
//     return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
//   } catch (_) {
//     return null;
//   }
// }

// DateTime? _sensorTimestamp(Map<String, dynamic> row) {
//   final explicit = _asDateTime(row['createdAt']);
//   if (explicit != null) return explicit;

//   final id = row['_id'];
//   if (id is ObjectId) return _timestampFromObjectId(id);

//   return null;
// }

// Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
//   return {
//     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
//     "amb_temp": row["amb_temp"],
//     "tm1_fet": row["tm1_fet"],
//     "tm1_ret": row["tm1_ret"],
//     "tm2_fet": row["tm2_fet"],
//     "tm2_ret": row["tm2_ret"],
//     "created_at": _sensorTimestamp(row)?.toIso8601String(),
//   };
// }

// Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
//   final rows = await _withRetry(
//     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
//   );

//   return rows.map(_sensorRowToJson).toList();
// }

// // ------------------------------------------
// // COLLECTION: vfddatas
// // ------------------------------------------
// Map<String, dynamic> _vfdRowToJson(Map<String, dynamic> row) {
//   return {
//     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
//     "machineId": row["machineId"]?.toString(),
//     "outputCurrent": row["outputCurrent"],
//     "outputVoltage": row["outputVoltage"],
//     "outputRPM": row["outputRPM"],
//     "outputFrequency": row["outputFrequency"],
//     "outputPower": row["outputPower"],
//     "created_at": (_asDateTime(row["createdAt"]) ??
//             (row["_id"] is ObjectId ? _timestampFromObjectId(row["_id"] as ObjectId) : null))
//         ?.toIso8601String(),
//   };
// }

// Future<List<Map<String, dynamic>>> fetchVfdDataFromDB() async {
//   final rows = await _withRetry(
//     () => db.collection('vfddatas').find(where.sortBy('_id')).toList(),
//   );

//   return rows.map(_vfdRowToJson).toList();
// }

// // ------------------------------------------
// // SESSION SCOPING
// // ------------------------------------------
// DateTime? _asDateTime(dynamic v) {
//   if (v == null) return null;
//   if (v is DateTime) return v;
//   return DateTime.tryParse(v.toString());
// }

// Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
//   final rows = await _withRetry(
//     () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
//   );

//   final seen = <String, Map<String, dynamic>>{};
//   for (final row in rows) {
//     final motorType = row['motor_type']?.toString() ?? '';
//     final testId = row['test_id']?.toString() ?? '';
//     if (motorType.isEmpty || testId.isEmpty) continue;
//     final key = '$motorType\u0000$testId';
//     seen.putIfAbsent(key, () => {
//           "motor_type": motorType,
//           "test_id": testId,
//           "last_status": row['status'],
//           "is_active": row['status'] == 1,
//           "last_activity": _asDateTime(row['created_at'])?.toIso8601String(),
//         });
//   }
//   return seen.values.toList();
// }

// Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
//   final sessionDocs = await _withRetry(
//     () => db
//         .collection('machine_data')
//         .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
//         .toList(),
//   );

//   Map<String, dynamic>? startDoc;
//   for (final d in sessionDocs) {
//     if (d['status'] == 1) {
//       startDoc = d;
//       break;
//     }
//   }
//   if (startDoc == null) {
//     return {"found": false, "motor_type": motorType, "test_id": testId};
//   }
//   final startTime = _asDateTime(startDoc['created_at']);

//   DateTime? stopTime;
//   for (final d in sessionDocs.reversed) {
//     if (d['status'] == 0) {
//       final t = _asDateTime(d['created_at']);
//       if (t != null && startTime != null && t.isAfter(startTime)) {
//         stopTime = t;
//         break;
//       }
//     }
//   }

//   final allSensorRows = await _withRetry(
//     () => db.collection('machine_sensor_data').find().toList(),
//   );

//   allSensorRows.sort((a, b) {
//     final ta = _sensorTimestamp(a);
//     final tb = _sensorTimestamp(b);
//     if (ta == null && tb == null) return 0;
//     if (ta == null) return -1;
//     if (tb == null) return 1;
//     return ta.compareTo(tb);
//   });

//   final windowed = allSensorRows.where((row) {
//     final t = _sensorTimestamp(row);
//     if (t == null) return false;
//     if (startTime != null && t.isBefore(startTime)) return false;
//     if (stopTime != null && t.isAfter(stopTime)) return false;
//     return true;
//   }).map(_sensorRowToJson).toList();

//   return {
//     "found": true,
//     "motor_type": motorType,
//     "test_id": testId,
//     "start_time": startTime?.toIso8601String(),
//     "stop_time": stopTime?.toIso8601String(),
//     "is_active": stopTime == null,
//     "sensor_data": windowed,
//   };
// }

// Future<Map<String, dynamic>> fetchSensorDataInRange(DateTime from, DateTime to) async {
//   final machineRows = await _withRetry(
//     () => db.collection('machine_data').find(where.sortBy('created_at')).toList(),
//   );

//   final openStarts = <String, Map<String, dynamic>>{};
//   final sessions = <Map<String, dynamic>>[];

//   for (final row in machineRows) {
//     final motorType = row['motor_type']?.toString() ?? '';
//     final testId = row['test_id']?.toString() ?? '';
//     if (motorType.isEmpty || testId.isEmpty) continue;
//     final key = '$motorType\u0000$testId';
//     final status = row['status'];

//     if (status == 1) {
//       openStarts[key] = row;
//     } else if (status == 0) {
//       final start = openStarts.remove(key);
//       if (start != null) {
//         sessions.add({
//           "motor_type": motorType,
//           "test_id": testId,
//           "machine_id": start["machine_id"],
//           "operation_name": start["operation_name"],
//           "start_time": _asDateTime(start["created_at"]),
//           "stop_time": _asDateTime(row["created_at"]),
//         });
//       }
//     }
//   }
//   for (final start in openStarts.values) {
//     sessions.add({
//       "motor_type": start["motor_type"],
//       "test_id": start["test_id"],
//       "machine_id": start["machine_id"],
//       "operation_name": start["operation_name"],
//       "start_time": _asDateTime(start["created_at"]),
//       "stop_time": null,
//     });
//   }

//   final matched = sessions.where((s) {
//     final st = s["start_time"] as DateTime?;
//     if (st == null) return false;
//     return !st.isBefore(from) && !st.isAfter(to);
//   }).toList()
//     ..sort((a, b) => (a["start_time"] as DateTime).compareTo(b["start_time"] as DateTime));

//   final allSensorRows = await _withRetry(() => db.collection('machine_sensor_data').find().toList());
//   allSensorRows.sort((a, b) {
//     final ta = _sensorTimestamp(a);
//     final tb = _sensorTimestamp(b);
//     if (ta == null && tb == null) return 0;
//     if (ta == null) return -1;
//     if (tb == null) return 1;
//     return ta.compareTo(tb);
//   });

//   final combined = <Map<String, dynamic>>[];
//   final seenIds = <String>{};
//   for (final session in matched) {
//     final st = session["start_time"] as DateTime?;
//     final sp = session["stop_time"] as DateTime?;
//     for (final row in allSensorRows) {
//       final t = _sensorTimestamp(row);
//       if (t == null) continue;
//       if (st != null && t.isBefore(st)) continue;
//       if (sp != null && t.isAfter(sp)) continue;
//       final json = _sensorRowToJson(row);
//       final id = json["id"]?.toString() ?? '';
//       if (id.isNotEmpty && !seenIds.add(id)) continue;
//       combined.add(json);
//     }
//   }
//   combined.sort((a, b) {
//     final ta = DateTime.tryParse(a["created_at"]?.toString() ?? '');
//     final tb = DateTime.tryParse(b["created_at"]?.toString() ?? '');
//     if (ta == null && tb == null) return 0;
//     if (ta == null) return -1;
//     if (tb == null) return 1;
//     return ta.compareTo(tb);
//   });

//   return {
//     "from": from.toIso8601String(),
//     "to": to.toIso8601String(),
//     "sessions": matched
//         .map((s) => {
//               "motor_type": s["motor_type"],
//               "test_id": s["test_id"],
//               "machine_id": s["machine_id"],
//               "operation_name": s["operation_name"],
//               "start_time": (s["start_time"] as DateTime?)?.toIso8601String(),
//               "stop_time": (s["stop_time"] as DateTime?)?.toIso8601String(),
//               "is_active": s["stop_time"] == null,
//             })
//         .toList(),
//     "sensor_data": combined,
//   };
// }

// // ------------------------------------------
// // SEPARATE COLLECTION: machine_data
// // ------------------------------------------
// Future<Map<String, dynamic>> insertMachineRecord(
//   String motorType, String machineId, String testId, String operationName, String field1, String field2, String field3, int status
// ) async {
//   final doc = {
//     "motor_type": motorType,
//     "machine_id": machineId,
//     "test_id": testId,
//     "operation_name": operationName,
//     "field_1": field1,
//     "field_2": field2,
//     "field_3": field3,
//     "status": status,
//     "created_at": DateTime.now().toUtc(),
//   };

//   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

//   if (!result.isSuccess) {
//     print("[INSERT FAILED] machine_data insert did not succeed: $result");
//     throw Exception('Database did not confirm the write (isSuccess=false) — nothing was saved.');
//   }

//   final insertedId = (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString();
//   print("[INSERT OK] machine_data id=$insertedId motor_type=$motorType test_id=$testId status=$status");

//   return {
//     "success": true,
//     "record": {
//       "id": insertedId,
//       ...doc,
//       "created_at": doc["created_at"].toString(),
//     },
//   };
// }

// Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
//   final rows = await _withRetry(
//     () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
//   );

//   return rows.map((row) {
//     return {
//       "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
//       "motor_type": row["motor_type"],
//       "machine_id": row["machine_id"],
//       "test_id": row["test_id"],
//       "operation_name": row["operation_name"],
//       "field_1": row["field_1"],
//       "field_2": row["field_2"],
//       "field_3": row["field_3"],
//       "status": row["status"],
//       "created_at": row["created_at"]?.toString(),
//     };
//   }).toList();
// }

// // ==========================================
// // 5. MAIN SERVICE DRIVER Entrypoint
// // ==========================================
// Future<void> main() async {
//   await connectDB();
//   _startKeepAlive();

//   final router = Router();

//   router.post('/login', (Request request) async {
//     try {
//       final body = jsonDecode(await request.readAsString());
//       String username = body['username']?.toString() ?? '';
//       String password = body['password']?.toString() ?? '';

//       if (username.isEmpty || password.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
//       }

//       final result = await loginUser(username, password);
//       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.get('/get-sensor-data', (Request request) async {
//     try {
//       final logs = await fetchSensorDataFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.get('/get-vfd-data', (Request request) async {
//     try {
//       final logs = await fetchVfdDataFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.post('/add-machine-record', (Request request) async {
//     try {
//       final body = jsonDecode(await request.readAsString());

//       String motorType = body['motor_type']?.toString() ?? '';
//       String machineId = body['machine_id']?.toString() ?? '';
//       String testId = body['test_id']?.toString() ?? '';
//       String operationName = body['operation_name']?.toString() ?? '';
//       String field1 = body['field_1']?.toString() ?? '';
//       String field2 = body['field_2']?.toString() ?? '';
//       String field3 = body['field_3']?.toString() ?? '';
//       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

//       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty || field3.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
//       }

//       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, field3, status);

//       final success = result["success"] == true;
//       return Response(
//         success ? 201 : 500,
//         body: jsonEncode(result),
//         headers: {"Content-Type": "application/json"},
//       );
//     } catch (e) {
//       print("[/add-machine-record] Insert failed: $e");
//       return Response.internalServerError(
//         body: jsonEncode({"success": false, "message": e.toString()}),
//         headers: {"Content-Type": "application/json"},
//       );
//     }
//   });

//   router.get('/get-machine-records', (Request request) async {
//     try {
//       final logs = await fetchMachineRecordsFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.get('/get-machine-sessions', (Request request) async {
//     try {
//       final sessions = await fetchMachineSessionsFromDB();
//       return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.get('/get-session-sensor-data', (Request request) async {
//     try {
//       final motorType = request.url.queryParameters['motor_type'] ?? '';
//       final testId = request.url.queryParameters['test_id'] ?? '';

//       if (motorType.isEmpty || testId.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "motor_type and test_id are required"}), headers: {"Content-Type": "application/json"});
//       }

//       final result = await fetchSessionSensorData(motorType, testId);
//       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.get('/get-sensor-data-range', (Request request) async {
//     try {
//       final fromStr = request.url.queryParameters['from'] ?? '';
//       final toStr = request.url.queryParameters['to'] ?? '';
//       if (fromStr.isEmpty || toStr.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "from and to (YYYY-MM-DD) are required"}), headers: {"Content-Type": "application/json"});
//       }

//       DateTime parseDay(String s, {required bool endOfDay}) {
//         final parts = s.split('-').map(int.parse).toList();
//         return endOfDay
//             ? DateTime.utc(parts[0], parts[1], parts[2], 23, 59, 59, 999)
//             : DateTime.utc(parts[0], parts[1], parts[2]);
//       }

//       final from = parseDay(fromStr, endOfDay: false);
//       final to = parseDay(toStr, endOfDay: true);

//       final result = await fetchSensorDataInRange(from, to);
//       return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
//   await io.serve(handler, '0.0.0.0', 3000);
//   print("Server engine operational on http://MongoDB:3000");

//   unawaited(_startRealtimeBridgeInBackground());
// }

// Future<void> _startRealtimeBridgeInBackground() async {
//   try {
//     await connectMQTT();
//     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
//       await startMongoChangeStreamBridge();
//     } else {
//       print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
//     }
//   } catch (e) {
//     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
//   }
// }




import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBgDeep,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAccent,
          brightness: Brightness.dark,
          primary: kAccent,
          secondary: kAmber,
          surface: kPanel,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme)
            .apply(bodyColor: kTextPrimary, displayColor: kTextPrimary),
      ),
      home: const LoginPage(),
    );
  }
}

// ==========================================
// SERVER ADDRESS — now pointing at the hosted backend instead of your LAN IP.
// ==========================================
// const String kApiBaseUrl = 'http://192.168.1.38:3000';
// const String kApiBaseUrl = 'https://railway-70e7.onrender.com';
const String kApiBaseUrl = 'https://railwayapp-1dsa.onrender.com';


// ==========================================
// NEW DEPENDENCIES REQUIRED FOR THE "SCAN READING" (OCR) FEATURE ON THE
// LOG ENTRY PAGE. Add to pubspec.yaml:
//   image_picker: ^1.0.7
// (http is already a dependency.) OCR itself is done by a cloud API call
// (see kOcrApiKey / _ocrExtractText below), not a native/on-device plugin
// — this is what makes it work identically on Flutter Web, mobile, and
// desktop. The previous approach (google_mlkit_text_recognition) doesn't
// run on Flutter Web at all, which is why the OCR screen crashed with
// "Image.file is not supported on Flutter Web" — image previews now use
// Image.memory instead, which works everywhere.
// Android: camera permission in AndroidManifest.xml. iOS: add
// NSCameraUsageDescription and NSPhotoLibraryUsageDescription to
// ios/Runner/Info.plist. Dashboard page is untouched by this feature.
// ==========================================

// ==========================================
// OCR API KEY — this demo uses OCR.space's free, shared "helloworld" key
// (https://ocr.space/ocrapi), which works out of the box but is rate-
// limited and shared across everyone using it. For real use, grab your
// own free key at https://ocr.space/ocrapi/freekey and put it here.
// ==========================================
const String kOcrApiKey = 'helloworld';

// ==========================================
// DESIGN TOKENS — "Instrumentation Console" identity
// ==========================================
const kBgDeep = Color(0xFF0A0F1C);
const kPanel = Color(0xFF121A2C);
const kPanelAlt = Color(0xFF1B2540);
const kGrid = Color(0xFF253355);
const kAccent = Color(0xFF00E5A0);
const kAccentDeep = Color(0xFF00B37E);
const kAmber = Color(0xFFFFB020);
const kEmber = Color(0xFFFF6B4A);
const kEmberDeep = Color(0xFFCC4A30);
const kViolet = Color(0xFF8B7CF6);
const kCyan = Color(0xFF3AC7E8);
const kTextPrimary = Color(0xFFEAF0FB);
const kTextMuted = Color(0xFF8C98B8);
const kTextFaint = Color(0xFF54607D);

TextStyle _display({double size = 20, FontWeight weight = FontWeight.w700, Color color = kTextPrimary, double spacing = 0}) =>
    GoogleFonts.spaceGrotesk(fontSize: size, fontWeight: weight, color: color, letterSpacing: spacing);

TextStyle _body({double size = 13, FontWeight weight = FontWeight.w400, Color color = kTextMuted}) =>
    GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

TextStyle _mono({double size = 13, FontWeight weight = FontWeight.w600, Color color = kTextPrimary}) =>
    GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: weight, color: color);

Color _thermalColor(double v) {
  if (v < 40) return kAccent;
  if (v < 75) return kAmber;
  return kEmber;
}

// ==========================================
// TOUCH-TO-REVEAL CHART LABELS
// Wraps any chart's CustomPaint (or chart Stack) so that pressing/dragging
// a finger over it shows a small floating label bubble with whatever
// `hitTest` reports for that touch position — e.g. "Ambient: 32.1°" on a
// pie slice, or "MCH-001: 12 A" on a comparison bar. The bubble follows
// the finger and disappears the moment touch is released, so it never
// clutters the chart when the person isn't actively touching it.
// ==========================================
class _TouchableChart extends StatefulWidget {
  final Widget child;
  final String? Function(Offset localPosition, Size size) hitTest;
  const _TouchableChart({required this.child, required this.hitTest});

  @override
  State<_TouchableChart> createState() => _TouchableChartState();
}

class _TouchableChartState extends State<_TouchableChart> {
  Offset? _pos;
  String? _label;

  void _update(Offset local, Size size) {
    final label = widget.hitTest(local, size);
    setState(() {
      _pos = local;
      _label = label;
    });
  }

  void _clear() {
    if (_pos == null && _label == null) return;
    setState(() {
      _pos = null;
      _label = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _update(d.localPosition, size),
          onPanStart: (d) => _update(d.localPosition, size),
          onPanUpdate: (d) => _update(d.localPosition, size),
          onPanEnd: (_) => _clear(),
          onTapUp: (_) => _clear(),
          onTapCancel: _clear,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              widget.child,
              if (_pos != null && _label != null)
                Positioned(
                  left: (_pos!.dx - 60).clamp(0.0, math.max(0.0, size.width - 120)),
                  top: math.max(0.0, _pos!.dy - 42),
                  child: IgnorePointer(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: kBgDeep.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kAccent.withOpacity(0.5)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8)],
                      ),
                      child: Text(
                        _label!,
                        style: _mono(size: 11.5, weight: FontWeight.w700, color: kTextPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Which slice label a touch point falls on for a pie/donut chart, given
// its center and (possibly elliptical, for the 3D pie) radii. Angle 0 is
// straight up, matching every pie painter in this file (they all start
// sweeping from -pi/2). Returns null for touches outside the ring or
// inside the donut hole.
String? _donutSliceLabel({
  required Offset local,
  required Offset center,
  required double radiusX,
  required double radiusY,
  required List<String> labels,
  required List<double> values,
  double holeFraction = 0.5,
}) {
  final total = values.fold<double>(0, (a, b) => a + b.abs());
  if (total <= 0 || radiusX <= 0 || radiusY <= 0) return null;
  final dx = (local.dx - center.dx) / radiusX;
  final dy = (local.dy - center.dy) / radiusY;
  final distSq = dx * dx + dy * dy;
  if (distSq > 1.0 || distSq < holeFraction * holeFraction) return null;
  var angle = math.atan2(dy, dx) + math.pi / 2;
  if (angle < 0) angle += 2 * math.pi;
  double cum = 0;
  for (int i = 0; i < values.length; i++) {
    final sweep = (values[i].abs() / total) * 2 * math.pi;
    if (sweep <= 0) continue;
    if (angle <= cum + sweep + 0.0001) return labels[i];
    cum += sweep;
  }
  return labels.isNotEmpty ? labels.last : null;
}

Route _consoleRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 480),
    reverseTransitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(scale: Tween<double>(begin: 0.96, end: 1).animate(curved), child: child),
      );
    },
  );
}

class MachineData {
  String motorType;
  String machineId;
  String testId;
  String operationName;
  String field1;
  String field2;
  String field3;
  int status;

  MachineData({
    this.motorType = '',
    this.machineId = '',
    this.testId = '',
    this.operationName = '',
    this.field1 = '',
    this.field2 = '',
    this.field3 = '',
    this.status = 1,
  });

  Map<String, dynamic> toJson() => {
        'motor_type': motorType,
        'machine_id': machineId,
        'test_id': testId,
        'operation_name': operationName,
        'field_1': field1,
        'field_2': field2,
        'field_3': field3,
        'status': status,
      };
}

class _GlowOrbsPainter extends CustomPainter {
  final double animation;
  _GlowOrbsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final positions = [
      Offset(size.width * 0.15 + 40 * math.sin(animation * 2 * math.pi), size.height * 0.18 + 25 * math.cos(animation * 2 * math.pi)),
      Offset(size.width * 0.85 + 25 * math.cos(animation * 2 * math.pi + 1), size.height * 0.14 + 35 * math.sin(animation * 2 * math.pi + 1)),
      Offset(size.width * 0.5 + 30 * math.sin(animation * 2 * math.pi + 2), size.height * 0.8 + 20 * math.cos(animation * 2 * math.pi + 2)),
    ];
    final colors = [kAccent.withOpacity(0.10), kAmber.withOpacity(0.06), kEmber.withOpacity(0.05)];
    final radii = [170.0, 130.0, 110.0];
    for (int i = 0; i < positions.length; i++) {
      paint.color = colors[i];
      canvas.drawCircle(positions[i], radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlowOrbsPainter old) => old.animation != animation;
}

class _ConsoleGridPainter extends CustomPainter {
  final double t;
  final double opacity;
  _ConsoleGridPainter({required this.t, this.opacity = 0.35});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kGrid.withOpacity(opacity)
      ..strokeWidth = 0.8;
    const step = 26.0;
    final shift = (t * step) % step;
    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConsoleGridPainter old) => old.t != t;
}

class RipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  RipplePainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = color.withOpacity((1 - progress) * 0.3)
      ..style = PaintingStyle.fill;
    final r = math.max(size.width, size.height) * progress * 1.5;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), r, paint);
  }

  @override
  bool shouldRepaint(RipplePainter old) => old.progress != progress;
}

class _Stagger extends StatelessWidget {
  final Animation<double> controller;
  final int index;
  final int total;
  final Widget child;
  const _Stagger({required this.controller, required this.index, required this.total, required this.child});

  @override
  Widget build(BuildContext context) {
    final span = total <= 1 ? 1.0 : total.toDouble();
    final start = (index / span) * 0.55;
    final end = (start + 0.45).clamp(0.0, 1.0);
    final curved = CurvedAnimation(parent: controller, curve: Interval(start, end, curve: Curves.easeOutCubic));
    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) => Opacity(
        opacity: curved.value.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, (1 - curved.value) * 16), child: child),
      ),
    );
  }
}

class _Shimmer extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius radius;
  const _Shimmer({this.height = 16, this.width, this.radius = const BorderRadius.all(Radius.circular(10))});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final shift = _ctrl.value * 3 - 1.5;
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.radius,
            gradient: LinearGradient(
              begin: Alignment(-1 + shift, 0),
              end: Alignment(0.4 + shift, 0),
              colors: const [kPanelAlt, kGrid, kPanelAlt],
            ),
          ),
        );
      },
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({this.color = kAccent});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final v = _ctrl.value;
        return SizedBox(
          width: 22,
          height: 22,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - v).clamp(0.0, 1.0),
                child: Container(
                  width: 10 + (v * 12),
                  height: 10 + (v * 12),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withOpacity(0.4)),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  boxShadow: [BoxShadow(color: widget.color.withOpacity(0.8), blurRadius: 6)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, this.color = kAccent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(color: color),
          const SizedBox(width: 2),
          Text(label, style: _mono(size: 11, weight: FontWeight.w700, color: color).copyWith(letterSpacing: 0.6)),
        ],
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final BorderRadius radius;
  final IconData fallbackIcon;
  const _BrandLogo({
    this.height = 40,
    this.width = 40,
    this.padding = const EdgeInsets.all(6),
    this.radius = const BorderRadius.all(Radius.circular(12)),
    this.fallbackIcon = Icons.precision_manufacturing_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: Colors.white, borderRadius: radius, border: Border.all(color: kGrid)),
      child: Image.asset(
        'assets/logo1.png',
        height: height,
        width: width,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: kBgDeep, size: math.min(height, width) * 0.7),
      ),
    );
  }
}

class _FormBannerImage extends StatelessWidget {
  const _FormBannerImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGrid),
        color: kPanelAlt,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/locorailway.png',
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) => Container(
              color: kPanelAlt,
              alignment: Alignment.center,
              child: const Icon(Icons.train_rounded, color: kTextFaint, size: 40),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 70,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [kBgDeep.withOpacity(0.55), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsoleSection extends StatelessWidget {
  final String eyebrow;
  final List<Widget> children;
  const _ConsoleSection({required this.eyebrow, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanel, kPanelAlt.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGrid),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 13, decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(eyebrow, style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.3)),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ConsoleDropdownField extends StatelessWidget {
  final String? value;
  final String label;
  final String hint;
  final IconData icon;
  final List<String> options;
  final void Function(String?) onChanged;
  final void Function(String?) onSaved;

  const _ConsoleDropdownField({
    required this.value,
    required this.label,
    required this.hint,
    required this.icon,
    required this.options,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: kGrid)),
      child: DropdownButtonFormField<String>(
        value: value,
        items: options
            .map((o) => DropdownMenuItem<String>(value: o, child: Text(o, style: _mono(size: 14, color: kTextPrimary))))
            .toList(),
        selectedItemBuilder: (context) => options
            .map((o) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    o,
                    style: _mono(size: 14, weight: FontWeight.w700, color: kTextPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        onSaved: onSaved,
        dropdownColor: kPanelAlt,
        icon: Icon(Icons.expand_more_rounded, color: kTextMuted),
        style: _mono(size: 14, color: kTextPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: _body(size: 12.5, color: kTextMuted),
          floatingLabelStyle: _body(size: 12.5, color: kAccent),
          hintText: hint,
          hintStyle: _body(size: 12.5, color: kTextFaint),
          prefixIcon: Icon(icon, color: kTextMuted, size: 19),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
      ),
    );
  }
}

// A single tappable source option (Camera / Gallery) for the OCR scan
// card on the Log Entry page — greys out and disables while a scan is
// already in progress.
class _OcrSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _OcrSourceButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: kPanelAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: enabled ? kCyan.withOpacity(0.4) : kGrid),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: enabled ? kCyan : kTextFaint, size: 22),
            const SizedBox(height: 6),
            Text(label, style: _body(size: 11.5, weight: FontWeight.w600, color: enabled ? kTextPrimary : kTextFaint)),
          ],
        ),
      ),
    );
  }
}

class _ConsoleField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final void Function(String?) onSaved;

  const _ConsoleField({required this.controller, required this.label, required this.hint, required this.icon, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: kGrid)),
      child: TextFormField(
        controller: controller,
        style: _mono(size: 14, color: kTextPrimary),
        cursorColor: kAccent,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: _body(size: 12.5, color: kTextMuted),
          floatingLabelStyle: _body(size: 12.5, color: kAccent),
          hintText: hint,
          hintStyle: _body(size: 12.5, color: kTextFaint),
          prefixIcon: Icon(icon, color: kTextMuted, size: 19),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required field' : null,
        onSaved: onSaved,
      ),
    );
  }
}

class _ThermalField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final void Function(String?) onSaved;
  const _ThermalField({required this.controller, required this.label, required this.hint, required this.onSaved});

  @override
  State<_ThermalField> createState() => _ThermalFieldState();
}

class _ThermalFieldState extends State<_ThermalField> {
  Color _dot = kTextFaint;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    final v = double.tryParse(widget.controller.text);
    final next = v == null ? kTextFaint : _thermalColor(v);
    if (next != _dot) setState(() => _dot = next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: kGrid)),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: _mono(size: 14, color: kTextPrimary),
        cursorColor: kAccent,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: _body(size: 12.5, color: kTextMuted),
          floatingLabelStyle: _body(size: 12.5, color: kAccent),
          hintText: widget.hint,
          hintStyle: _body(size: 12.5, color: kTextFaint),
          suffixText: '°C',
          suffixStyle: _mono(size: 12.5, color: kTextMuted),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dot,
                boxShadow: [BoxShadow(color: _dot.withOpacity(0.7), blurRadius: 6)],
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Reading required' : null,
        onSaved: widget.onSaved,
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final String label;
  final List<Color> colors;
  final IconData? icon;

  const _AnimatedButton({
    required this.onTap,
    required this.isLoading,
    required this.label,
    this.colors = const [kAccent, kAccentDeep],
    this.icon,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  double _ripple = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1, end: 0.95).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() async {
    if (widget.onTap == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _ripple = 0.01);
    for (double v = 0.01; v <= 1.0; v += 0.04) {
      await Future.delayed(const Duration(milliseconds: 12));
      if (mounted) setState(() => _ripple = v);
    }
    if (mounted) setState(() => _ripple = 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); _onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CustomPaint(
            painter: RipplePainter(_ripple, Colors.white),
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.colors),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: widget.colors.first.withOpacity(0.45), blurRadius: 18, offset: const Offset(0, 8))
                ],
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: kBgDeep, strokeWidth: 2.5))
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, color: kBgDeep, size: 20),
                            const SizedBox(width: 8),
                          ],
                          Text(widget.label, style: GoogleFonts.spaceGrotesk(color: kBgDeep, fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.3)),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Slow diagonal light sweep drifting across a panel — purely decorative,
// reinforces a glossy "instrument glass" feel without being distracting
// (very low opacity, long period).
class _ShineSweepPainter extends CustomPainter {
  final double t; // 0..1, looping
  final Color color;
  final double opacity;
  _ShineSweepPainter({required this.t, this.color = Colors.white, this.opacity = 0.05});

  @override
  void paint(Canvas canvas, Size size) {
    final travel = size.width + size.height;
    final pos = t * travel * 1.5 - size.height * 0.4;
    final bandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.transparent, color.withOpacity(opacity), Colors.transparent],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(pos - 46, -30, 92, size.height + 60));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bandPaint);
  }

  @override
  bool shouldRepaint(covariant _ShineSweepPainter old) => old.t != t;
}

class _GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;
  final Color glowColor;
  final double glowOpacity;
  final bool animated;
  const _GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = const BorderRadius.all(Radius.circular(20)),
    this.glowColor = kAccent,
    this.glowOpacity = 0,
    this.animated = true,
  });

  @override
  State<_GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<_GlassCard> with SingleTickerProviderStateMixin {
  late final AnimationController _shineCtrl;

  @override
  void initState() {
    super.initState();
    _shineCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 7))..repeat();
  }

  @override
  void dispose() {
    _shineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPanel, kPanelAlt.withOpacity(0.85)],
        ),
        border: Border.all(color: kGrid),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.32), blurRadius: 20, offset: const Offset(0, 10)),
          if (widget.glowOpacity > 0)
            BoxShadow(color: widget.glowColor.withOpacity(widget.glowOpacity), blurRadius: 24, spreadRadius: -2),
        ],
      ),
      child: ClipRRect(
        borderRadius: widget.radius,
        child: Stack(
          children: [
            Padding(padding: widget.padding, child: widget.child),
            if (widget.animated)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _shineCtrl,
                    builder: (_, __) => CustomPaint(painter: _ShineSweepPainter(t: _shineCtrl.value)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PulseGlow extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool active;
  final BorderRadius radius;
  const _PulseGlow({required this.child, this.color = kEmber, this.active = true, this.radius = const BorderRadius.all(Radius.circular(20))});

  @override
  State<_PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<_PulseGlow> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1700))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.radius,
            boxShadow: [
              BoxShadow(color: widget.color.withOpacity(0.10 + 0.20 * (1 - t)), blurRadius: 14 + 16 * t, spreadRadius: -1 + 2 * t),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;

  final String loginApiUrl = '$kApiBaseUrl/login';

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 9))..repeat();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse(loginApiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': _usernameCtrl.text.trim(), 'password': _passwordCtrl.text}),
          )
          .timeout(const Duration(seconds: 90));
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(context, _consoleRoute(const MainShell()));
        }
      } else {
        _showSnack('Access Denied: Invalid credentials.', false);
      }
    } on TimeoutException {
      _showSnack('Server is taking too long to respond. Please try again.', false);
    } catch (e) {
      _showSnack('Network Error: Cannot reach server.', false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(success ? Icons.check_circle_rounded : Icons.error_rounded, color: success ? kAccent : kEmber, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: _body(size: 13, color: kTextPrimary))),
        ],
      ),
      backgroundColor: kPanel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: (success ? kAccent : kEmber).withOpacity(0.4))),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDeep,
      body: Stack(
        children: [
          Container(color: kBgDeep),
          AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => CustomPaint(size: MediaQuery.of(context).size, painter: _GlowOrbsPainter(_bgCtrl.value))),
          CustomPaint(size: MediaQuery.of(context).size, painter: _ConsoleGridPainter(t: 0, opacity: 0.22)),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: _Stagger(
                    controller: _entryCtrl,
                    index: 0,
                    total: 6,
                    child: const _BrandLogo(height: 56, width: 56, padding: EdgeInsets.all(8), radius: BorderRadius.all(Radius.circular(14))),
                  ),
                ),
                Positioned(
                  top: 22,
                  right: 16,
                  child: _Stagger(
                    controller: _entryCtrl,
                    index: 0,
                    total: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: kGrid)),
                      child: Image.asset(
                        'assets/logo2.png',
                        height: 36,
                        width: 130,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 26, color: kTextFaint),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 86),
                      _Stagger(
                        controller: _entryCtrl,
                        index: 1,
                        total: 6,
                        child: _PulseGlow(
                          color: kAccent,
                          radius: const BorderRadius.all(Radius.circular(999)),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [kAccent.withOpacity(0.22), kAccent.withOpacity(0.08)]),
                              border: Border.all(color: kAccent.withOpacity(0.35)),
                            ),
                            child: const Icon(Icons.lock_person_rounded, size: 38, color: kAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _Stagger(controller: _entryCtrl, index: 2, total: 6, child: const _StatusPill(label: 'SYSTEM ONLINE')),
                      const SizedBox(height: 18),
                      _Stagger(
                        controller: _entryCtrl,
                        index: 3,
                        total: 6,
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [kTextPrimary, kAccent],
                              ).createShader(bounds),
                              child: Text('Welcome Back', style: _display(size: 27, color: Colors.white)),
                            ),
                            const SizedBox(height: 4),
                            Text('Sign in to access machine log metrics', style: _body(size: 13.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _Stagger(
                        controller: _entryCtrl,
                        index: 4,
                        total: 6,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanel, kPanelAlt.withOpacity(0.9)]),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: kGrid),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 30, offset: const Offset(0, 14))],
                          ),
                          child: Column(
                            children: [
                              _ConsoleField(controller: _usernameCtrl, label: 'Username', hint: 'Username', icon: Icons.person_outline_rounded, onSaved: (_) {}),
                              _LoginPasswordField(
                                controller: _passwordCtrl,
                                obscure: _obscurePassword,
                                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _Stagger(
                        controller: _entryCtrl,
                        index: 5,
                        total: 6,
                        child: _AnimatedButton(onTap: _isLoading ? null : _login, isLoading: _isLoading, label: 'Sign In', icon: Icons.login_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  const _LoginPasswordField({required this.controller, required this.obscure, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: kGrid)),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: _mono(size: 14, color: kTextPrimary),
        cursorColor: kAccent,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: _body(size: 12.5, color: kTextMuted),
          floatingLabelStyle: _body(size: 12.5, color: kAccent),
          hintText: 'Password',
          hintStyle: _body(size: 12.5, color: kTextFaint),
          prefixIcon: const Icon(Icons.key_rounded, color: kTextMuted, size: 19),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: kTextMuted, size: 19),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final _pages = const [MachineFormPage(), DashboardPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDeep,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: Container(
          height: 66,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPanel,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kGrid),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                alignment: _selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [kAccent.withOpacity(0.18), kAccent.withOpacity(0.08)]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kAccent.withOpacity(0.25)),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: _NavButton(icon: Icons.assignment_rounded, label: 'Log Entry', selected: _selectedIndex == 0, onTap: () => setState(() => _selectedIndex = 0))),
                  Expanded(child: _NavButton(icon: Icons.dashboard_rounded, label: 'Dashboard', selected: _selectedIndex == 1, onTap: () => setState(() => _selectedIndex = 1))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 220),
        style: _body(size: 10, weight: FontWeight.w600, color: selected ? kAccent : kTextFaint),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 220),
              scale: selected ? 1.12 : 1.0,
              curve: Curves.easeOutBack,
              child: Icon(icon, color: selected ? kAccent : kTextFaint, size: 21),
            ),
            const SizedBox(height: 3),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class MachineFormPage extends StatefulWidget {
  const MachineFormPage({super.key});

  @override
  State<MachineFormPage> createState() => _MachineFormPageState();
}

class _MachineFormPageState extends State<MachineFormPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final MachineData _model = MachineData();
  bool _isSubmitting = false;
  bool _submitSuccess = false;
  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;

  static const List<String> _motorTypeOptions = ['Motor 1', 'Motor 2'];
  String? _selectedMotorType;
  String? _lastSubmittedMotorType;
  int? _lastSubmittedStatus;

  final Map<String, TextEditingController> _ctrlMap = {};
  final List<String> _keys = ['machineId', 'testId', 'operationName', 'field1', 'field2', 'field3'];

  // ------------------------------------------------------------------
  // SCAN READING · OCR
  // Lets the operator snap or upload a photo of a gauge/display instead
  // of typing readings by hand — the image is sent to a cloud OCR API
  // (see _ocrExtractText / kOcrApiKey above), which reads back the text
  // and numbers. Labeled readings (Velocity, Temperature, etc.) are
  // matched and dropped into Field 1 / Field 2 for the operator to
  // double-check before submitting.
  // ------------------------------------------------------------------
  final ImagePicker _imagePicker = ImagePicker();
  bool _isScanning = false;
  Uint8List? _scannedImageBytes;
  // Labeled readings OCR found in the last scanned image, in display
  // order (e.g. "Velocity" -> "0.57 mm/s") — shown to the operator as
  // proof of what was actually read off the screen/gauge, separate from
  // whatever ends up auto-filled into Field 1 / Field 2.
  List<MapEntry<String, String>> _extractedReadings = [];

  // ------------------------------------------------------------------
  // ACTIVE SESSIONS TABLE
  // A "session" here is one Start (status=1) for a given (motor_type,
  // test_id) pair that has no matching Stop yet. `_activeRecords` mirrors
  // that state on screen:
  //   - populated on page load from /get-machine-records (so it survives
  //     app restarts / re-logins),
  //   - a row is added/updated the moment a Start is submitted from the
  //     form,
  //   - a row is removed the moment its "Stop" button is tapped and the
  //     server confirms the Stop was recorded.
  // ------------------------------------------------------------------
  List<Map<String, dynamic>> _activeRecords = [];
  bool _isLoadingActive = true;
  final Set<String> _stoppingKeys = {};

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    for (var k in _keys) { _ctrlMap[k] = TextEditingController(); }
    _fetchActiveRecords();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    for (var c in _ctrlMap.values) { c.dispose(); }
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacement(context, _consoleRoute(const LoginPage()));
  }

  String _recordKey(Map<String, dynamic> r) => '${r['motor_type']}\u0000${r['test_id']}';

  void _upsertActiveRecord(Map<String, dynamic> record) {
    final key = _recordKey(record);
    final idx = _activeRecords.indexWhere((r) => _recordKey(r) == key);
    if (idx >= 0) {
      _activeRecords[idx] = record;
    } else {
      _activeRecords.insert(0, record);
    }
  }

  void _removeActiveRecordByKey(String key) {
    _activeRecords.removeWhere((r) => _recordKey(r) == key);
  }

  // Sends image bytes to OCR.space's cloud OCR API and returns the
  // recognized text. Using bytes (not a file path) and a plain HTTP call
  // is what makes this work identically on Flutter Web, mobile, and
  // desktop — unlike a native/on-device OCR plugin, there's no platform-
  // specific code path here at all.
  Future<String> _ocrExtractText(Uint8List bytes) async {
    final request = http.MultipartRequest('POST', Uri.parse('https://api.ocr.space/parse/image'))
      ..fields['apikey'] = kOcrApiKey
      ..fields['OCREngine'] = '2' // engine 2 reads numbers/decimals more reliably
      ..fields['scale'] = 'true'
      ..fields['isTable'] = 'false'
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'scan.jpg'));

    final streamed = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception('OCR service returned HTTP ${response.statusCode}');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['IsErroredOnProcessing'] == true) {
      final rawError = body['ErrorMessage'];
      final message = rawError is List ? rawError.join('; ') : rawError?.toString();
      throw Exception(message ?? 'OCR could not process that image');
    }

    final results = body['ParsedResults'] as List<dynamic>?;
    if (results == null || results.isEmpty) return '';
    return results.map((r) => r['ParsedText']?.toString() ?? '').join('\n');
  }

  // Opens the camera or gallery, sends the picked image to the cloud OCR
  // API above, and parses the recognized text for the labeled readings a
  // monitoring app/gauge display typically shows (Velocity, Enveloped
  // Acc., Temperature — matched case-insensitively with the number that
  // follows each label). Every labeled reading found is kept in
  // `_extractedReadings` so the operator can see exactly what OCR read
  // off the screen. Field 1 gets the Velocity/first vibration-style
  // reading, Field 2 gets Temperature — with a fallback to "just the
  // first two numbers found" if no known labels matched, so unlabeled
  // gauge photos still work. The operator still reviews/edits before
  // hitting Start.
  Future<void> _pickAndScanImage(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;

      // readAsBytes works the same way on web, mobile, and desktop —
      // picked.path is not a real filesystem path on web, which is why
      // the previous Image.file/File(path) approach crashed there.
      final bytes = await picked.readAsBytes();

      setState(() {
        _isScanning = true;
        _scannedImageBytes = bytes;
        _extractedReadings = [];
      });

      final text = await _ocrExtractText(bytes);

      // Split into lines (dropping blanks) so each label can be matched
      // against the SAME visual row it appears on. Also keep a flattened
      // version as a fallback for photos where OCR splits a label and its
      // value across separate lines, or merges unrelated lines together
      // (this is what was going wrong on full screenshots that include a
      // trend graph below the header row — OCR sometimes lumps an axis
      // number from the chart into the same "line" as the header text).
      final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
      final flatText = lines.join(' ');

      // Each known reading is defined by its label AND its unit. Anchoring
      // on the unit (not just "the last number near the label") is what
      // makes this immune to trend-graph noise: chart axis ticks are bare
      // numbers with no unit attached, so they can never match here, no
      // matter how OCR merges/reorders the surrounding lines.
      const readingLabels = ['Velocity', 'Enveloped Acc', 'Temperature'];
      const readingKeywords = <String, String>{
        'Velocity': 'velocity',
        'Enveloped Acc': 'enveloped',
        'Temperature': 'temperature',
      };
      const readingUnitPatterns = <String, String>{
        'Velocity': r'mm\s*/?\s*s',
        'Enveloped Acc': r'g\s*e\b',
        'Temperature': r'°?\s*c\b',
      };
      // Captures a number immediately followed (within a short gap, to
      // skip the checkmark icon/whitespace) by the reading's own unit.
      RegExp unitAnchored(String unit) => RegExp('(-?\\d+\\.?\\d*)\\s{0,3}$unit', caseSensitive: false);
      final numOnLine = RegExp(r'-?\d+\.\d+|-?\d+');

      final readings = <MapEntry<String, String>>[];
      for (final label in readingLabels) {
        final keyword = readingKeywords[label]!;
        final unitRegex = unitAnchored(readingUnitPatterns[label]!);
        String? value;

        // Primary: same row as the label, value confirmed by its unit —
        // this is the top-right-corner reading, not a bare axis tick.
        for (final line in lines) {
          if (line.toLowerCase().contains(keyword)) {
            value = unitRegex.firstMatch(line)?.group(1);
            if (value != null) break;
          }
        }

        // Fallback A: unit-anchored search across the whole flattened
        // text, in case OCR split the label/value/unit across lines.
        value ??= unitRegex.firstMatch(flatText)?.group(1);

        // Fallback B: no unit came through OCR at all (rare) — fall back
        // to the old "last number on the label's row" heuristic.
        if (value == null) {
          for (final line in lines) {
            if (line.toLowerCase().contains(keyword)) {
              final numsOnLine = numOnLine.allMatches(line).map((m) => m.group(0)!).toList();
              if (numsOnLine.isNotEmpty) {
                value = numsOnLine.last;
                break;
              }
            }
          }
        }

        if (value != null) readings.add(MapEntry(label, value));
      }

      // Fallback for photos of unlabeled gauges/displays: if none of the
      // known labels matched, just take the first two numbers found in
      // reading order.
      if (readings.isEmpty) {
        final numbers = RegExp(r'-?\d+\.?\d*')
            .allMatches(flatText)
            .map((m) => m.group(0)!)
            .where((s) => s.isNotEmpty && s != '-' && s != '.')
            .toList();
        for (var i = 0; i < numbers.length && i < 2; i++) {
          readings.add(MapEntry('Reading ${i + 1}', numbers[i]));
        }
      }

      if (!mounted) return;

      if (readings.isEmpty) {
        _showOcrSnack('No numeric readings found in that image.', false);
      } else {
        setState(() {
          _extractedReadings = readings;
          // Prefer the semantically-matched labels for Field 1/2/3; fall
          // back to whichever readings came out of the generic pass
          // otherwise, in the order they were found.
          final velocity = readings.firstWhere((r) => r.key == 'Velocity', orElse: () => readings[0]);
          _ctrlMap['field1']!.text = velocity.value;

          final envelopedOrSecond = readings.firstWhere(
            (r) => r.key == 'Enveloped Acc',
            orElse: () => readings.length > 1 ? readings[1] : readings[0],
          );
          _ctrlMap['field2']!.text = envelopedOrSecond.value;

          final tempOrThird = readings.firstWhere(
            (r) => r.key == 'Temperature',
            orElse: () => readings.length > 2 ? readings[2] : readings.last,
          );
          _ctrlMap['field3']!.text = tempOrThird.value;
        });
        _showOcrSnack(
          'Extracted ${readings.length} reading${readings.length == 1 ? '' : 's'} — double-check Field 1/2/3 before submitting.',
          true,
        );
      }
    } catch (e) {
      if (mounted) _showOcrSnack('OCR failed: ${e.toString().replaceFirst('Exception: ', '')}', false);
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _showOcrSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(success ? Icons.check_circle_rounded : Icons.error_rounded, color: success ? kAccent : kEmber, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: _body(size: 13, color: kTextPrimary))),
        ],
      ),
      backgroundColor: kPanel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: (success ? kAccent : kEmber).withOpacity(0.4))),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Loads every machine_data row and keeps only the latest event per
  // (motor_type, test_id). Rows come back ascending by _id (chronological),
  // so the last time a key appears while walking the list is its most
  // recent status — if that status is 1 (Start), the session is still
  // "active" and belongs in the table.
  Future<void> _fetchActiveRecords() async {
    if (mounted) setState(() => _isLoadingActive = true);
    try {
      final res = await http.get(Uri.parse('$kApiBaseUrl/get-machine-records'));
      if (res.statusCode == 200) {
        final List<dynamic> parsed = jsonDecode(res.body);
        final latest = <String, Map<String, dynamic>>{};
        for (final item in parsed) {
          final row = Map<String, dynamic>.from(item as Map);
          final motorType = row['motor_type']?.toString() ?? '';
          final testId = row['test_id']?.toString() ?? '';
          if (motorType.isEmpty || testId.isEmpty) continue;
          latest['$motorType\u0000$testId'] = row;
        }
        final active = latest.values.where((r) => r['status'] == 1).toList()
          ..sort((a, b) {
            final ta = DateTime.tryParse(a['created_at']?.toString() ?? '') ?? DateTime(0);
            final tb = DateTime.tryParse(b['created_at']?.toString() ?? '') ?? DateTime(0);
            return tb.compareTo(ta);
          });
        if (mounted) {
          setState(() {
            _activeRecords = active;
            _isLoadingActive = false;
          });
        }
      } else if (mounted) {
        setState(() => _isLoadingActive = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingActive = false);
    }
  }

  // Pulls a human-readable message out of a failed /add-machine-record
  // response — the server sends back {"message": "..."} (and, since a
  // recent backend fix, a real 500 instead of a fake 201 when the Mongo
  // write itself failed), so this is what actually tells the operator why
  // a submit/stop didn't go through instead of it just silently doing
  // nothing.
  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return body['message'].toString();
      }
    } catch (_) {
      // Response body wasn't JSON (e.g. a raw 502 from a proxy) — fall
      // through to the generic message below.
    }
    return 'Server rejected the request (HTTP ${response.statusCode}).';
  }

  // Form submit — now always logs a Start (status = 1). Stopping a running
  // session happens from the "Active Sessions" table below via _stopRecord,
  // not by resubmitting this form.
  //
  // NOTE: this never uploads the scanned image anywhere — OCR only ever
  // extracts numbers into the Field 1 / Field 2 text controllers on-
  // device; the JSON body sent below is exactly the same six text values
  // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
  // whether they were typed by hand or filled in via a scan.
  //
  // IMPORTANT: values are read directly from `_selectedMotorType` and the
  // TextEditingControllers here — NOT from Form.save()'s onSaved
  // indirection. That indirection was observed going stale (fields
  // visibly filled on screen, but Form.save() populating _model with
  // empty strings anyway) after enough setState() churn elsewhere in this
  // page (e.g. repeated OCR scans). Reading straight from the same state
  // that's bound to what's on screen removes any chance of that drift.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showOcrSnack('Please fill in every field above — check for red error text.', false);
      return;
    }

    final motorType = (_selectedMotorType ?? '').trim();
    final machineId = _ctrlMap['machineId']!.text.trim();
    final testId = _ctrlMap['testId']!.text.trim();
    final operationName = _ctrlMap['operationName']!.text.trim();
    final field1 = _ctrlMap['field1']!.text.trim();
    final field2 = _ctrlMap['field2']!.text.trim();
    final field3 = _ctrlMap['field3']!.text.trim();

    // Belt-and-suspenders: the server rejects the request if ANY of these
    // seven fields arrives empty. Checking again here — by name — means a
    // failure tells you exactly which field is still blank instead of the
    // server's generic "All fields are required".
    final missing = <String>[];
    if (motorType.isEmpty) missing.add('Motor Type');
    if (machineId.isEmpty) missing.add('Machine ID');
    if (testId.isEmpty) missing.add('Test ID');
    if (operationName.isEmpty) missing.add('Operation Name');
    if (field1.isEmpty) missing.add('Field 1');
    if (field2.isEmpty) missing.add('Field 2');
    if (field3.isEmpty) missing.add('Field 3');
    if (missing.isNotEmpty) {
      _showOcrSnack('Missing: ${missing.join(', ')}', false);
      return;
    }

    // If a session for this exact Motor/Test ID is already running (still
    // in Active Sessions), Start now means "restart the current run":
    // silently Stop the old one first, then log the new Start. This is
    // what actually stops you from being able to Start the same session
    // over and over without ever Stopping it — previously nothing here
    // checked _activeRecords at all.
    final sessionKey = '$motorType\u0000$testId';
    final existingActive = _activeRecords.where((r) => _recordKey(r) == sessionKey).toList();

    setState(() => _isSubmitting = true);

    if (existingActive.isNotEmpty) {
      final stopped = await _stopRecord(existingActive.first, silent: true);
      if (!stopped) {
        // _stopRecord already showed the error snackbar explaining why.
        if (mounted) setState(() => _isSubmitting = false);
        return;
      }
    }

    _model
      ..motorType = motorType
      ..machineId = machineId
      ..testId = testId
      ..operationName = operationName
      ..field1 = field1
      ..field2 = field2
      ..field3 = field3
      ..status = 1;

    try {
      final response = await http.post(
        Uri.parse('$kApiBaseUrl/add-machine-record'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_model.toJson()),
      );
      if (response.statusCode == 201) {
        final startedRecord = {
          'motor_type': _model.motorType,
          'machine_id': _model.machineId,
          'test_id': _model.testId,
          'operation_name': _model.operationName,
          'field_1': _model.field1,
          'field_2': _model.field2,
          'field_3': _model.field3,
          'status': 1,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        };

        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _submitSuccess = true;
            _lastSubmittedMotorType = _selectedMotorType;
            _lastSubmittedStatus = 1;
            _upsertActiveRecord(startedRecord);
          });
        }

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _submitSuccess = false);

        // Clear the form so the next entry starts fresh — the just-started
        // session now lives in the Active Sessions table above the button.
        // Also clears the OCR scan preview + extracted-readings list, so a
        // successful submit resets the whole card back to its blank state
        // instead of leaving the old scanned photo/readings lingering on
        // screen for the next entry.
        setState(() {
          _selectedMotorType = null;
          _scannedImageBytes = null;
          _extractedReadings = [];
        });
        _formKey.currentState!.reset();
        for (var c in _ctrlMap.values) { c.clear(); }
        _entryCtrl.forward(from: 0);
      } else {
        // Was previously silent — the spinner would just stop with no
        // explanation, which is exactly what made a validation failure
        // (e.g. Motor Type left unselected) look like nothing happened.
        final message = _extractErrorMessage(response);
        if (mounted) {
          setState(() => _isSubmitting = false);
          _showOcrSnack('Not saved: $message', false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showOcrSnack('Not saved: could not reach the server.', false);
      }
    }
  }

  // Stops one specific running session from the Active Sessions table.
  // Sends a Stop (status = 0) using that row's own stored field values, and
  // — once the server confirms it — removes the row from the table, since
  // it's no longer active.
  //
  // `silent`: when true (used internally by _submit()'s auto-stop-before-
  // restart flow below), this skips its own success snackbar/animation so
  // it doesn't visually collide with the Start that immediately follows.
  // Returns true only once the server has actually confirmed the Stop —
  // callers that chain a Start after this MUST check that return value
  // rather than assuming it always succeeds.
  Future<bool> _stopRecord(Map<String, dynamic> record, {bool silent = false}) async {
    final key = _recordKey(record);
    setState(() => _stoppingKeys.add(key));

    final payload = {
      'motor_type': record['motor_type'],
      'machine_id': record['machine_id'],
      'test_id': record['test_id'],
      'operation_name': record['operation_name'],
      'field_1': record['field_1'],
      'field_2': record['field_2'],
      'field_3': record['field_3'],
      'status': 0,
    };

    try {
      final response = await http.post(
        Uri.parse('$kApiBaseUrl/add-machine-record'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (response.statusCode == 201) {
        if (mounted) {
          setState(() {
            _removeActiveRecordByKey(key);
            _stoppingKeys.remove(key);
            if (!silent) {
              _submitSuccess = true;
              _lastSubmittedMotorType = record['motor_type']?.toString();
              _lastSubmittedStatus = 0;
            }
          });
          if (!silent) {
            await Future.delayed(const Duration(seconds: 2));
            if (mounted) setState(() => _submitSuccess = false);
          }
        }
        return true;
      } else {
        final message = _extractErrorMessage(response);
        if (mounted) {
          setState(() => _stoppingKeys.remove(key));
          _showOcrSnack('Stop not saved: $message', false);
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        setState(() => _stoppingKeys.remove(key));
        _showOcrSnack('Stop not saved: could not reach the server.', false);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool lastWasStart = _lastSubmittedStatus == 1;

    return Scaffold(
      backgroundColor: kBgDeep,
      // The header banner below has a fixed height (196) purely for
      // decoration. Without this, opening the keyboard while typing in a
      // field shrinks the available body height, and that fixed-height
      // decoration no longer fits — RenderFlex overflow. Turning off
      // resize here means the decoration always gets full height; the
      // ListView below still auto-scrolls a focused field into view via
      // Flutter's normal keyboard-avoidance for text fields, independent
      // of this setting.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 196,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [kPanel, kBgDeep], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  child: AnimatedBuilder(
                    animation: _bgCtrl,
                    builder: (_, __) => CustomPaint(painter: _ConsoleGridPainter(t: _bgCtrl.value), child: const SizedBox.expand()),
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _Stagger(
                    controller: _entryCtrl,
                    index: 0,
                    total: 7,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const _BrandLogo(height: 38, width: 38),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MACHINE METRICS', style: _body(size: 10.5, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.3)),
                              Text('New Reading', style: _display(size: 20)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.power_settings_new_rounded, color: kTextMuted, size: 24),
                          tooltip: 'Logout',
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _Stagger(controller: _entryCtrl, index: 0, total: 7, child: const _StatusPill(label: 'LIVE • MACHINE_DATA')),
                  const SizedBox(height: 18),
                  _Stagger(
                    controller: _entryCtrl,
                    index: 1,
                    total: 7,
                    child: const _FormBannerImage(),
                  ),
                  const SizedBox(height: 20),
                  _Stagger(
                    controller: _entryCtrl,
                    index: 2,
                    total: 7,
                    child: _ConsoleSection(
                      eyebrow: 'IDENTIFICATION',
                      children: [
                        _ConsoleDropdownField(
                          value: _selectedMotorType,
                          label: 'Motor Type',
                          hint: 'Select motor',
                          icon: Icons.precision_manufacturing_rounded,
                          options: _motorTypeOptions,
                          onChanged: (v) => setState(() => _selectedMotorType = v),
                          onSaved: (v) => _model.motorType = v ?? '',
                        ),
                        _ConsoleField(controller: _ctrlMap['machineId']!, label: 'Machine ID', hint: 'e.g. MCH-001', icon: Icons.sell_rounded, onSaved: (v) => _model.machineId = v ?? ''),
                        _ConsoleField(controller: _ctrlMap['testId']!, label: 'Test ID', hint: 'e.g. TST-2026-01', icon: Icons.qr_code_2_rounded, onSaved: (v) => _model.testId = v ?? ''),
                      ],
                    ),
                  ),
                  _Stagger(
                    controller: _entryCtrl,
                    index: 3,
                    total: 7,
                    child: _ConsoleSection(
                      eyebrow: 'SCAN READING · OCR',
                      children: [
                        Text(
                          'Snap or upload a photo of the gauge/display — Field 1, Field 2, and Field 3 below will be auto-filled from the numbers it detects.',
                          style: _body(size: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _OcrSourceButton(
                                icon: Icons.photo_camera_rounded,
                                label: 'Camera',
                                onTap: _isScanning ? null : () => _pickAndScanImage(ImageSource.camera),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _OcrSourceButton(
                                icon: Icons.photo_library_rounded,
                                label: 'Gallery',
                                onTap: _isScanning ? null : () => _pickAndScanImage(ImageSource.gallery),
                              ),
                            ),
                          ],
                        ),
                        if (_isScanning) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: kCyan),
                              ),
                              const SizedBox(width: 10),
                              Text('Reading image with OCR…', style: _body(size: 12)),
                            ],
                          ),
                        ],
                        if (_scannedImageBytes != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _scannedImageBytes!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        if (_extractedReadings.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kPanelAlt,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kGrid),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.text_snippet_rounded, color: kCyan, size: 15),
                                    const SizedBox(width: 6),
                                    Text(
                                      'EXTRACTED FROM IMAGE',
                                      style: _body(size: 9.5, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 1.1),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                for (final reading in _extractedReadings)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(reading.key, style: _body(size: 12.5, color: kTextMuted)),
                                        Text(reading.value, style: _mono(size: 13, weight: FontWeight.w700, color: kTextPrimary)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _Stagger(
                    controller: _entryCtrl,
                    index: 4,
                    total: 7,
                    child: _ConsoleSection(
                      eyebrow: 'OPERATION DETAILS',
                      children: [
                        _ConsoleField(controller: _ctrlMap['operationName']!, label: 'Operation Name', hint: 'e.g. Load Test', icon: Icons.settings_suggest_rounded, onSaved: (v) => _model.operationName = v ?? ''),
                        _ConsoleField(controller: _ctrlMap['field1']!, label: 'Field 1', hint: 'e.g. 25.0', icon: Icons.looks_one_rounded, onSaved: (v) => _model.field1 = v ?? ''),
                        _ConsoleField(controller: _ctrlMap['field2']!, label: 'Field 2', hint: 'e.g. 58.0', icon: Icons.looks_two_rounded, onSaved: (v) => _model.field2 = v ?? ''),
                        _ConsoleField(controller: _ctrlMap['field3']!, label: 'Field 3', hint: 'e.g. 35.5', icon: Icons.looks_3_rounded, onSaved: (v) => _model.field3 = v ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Stagger(
                    controller: _entryCtrl,
                    index: 5,
                    total: 7,
                    child: _AnimatedButton(
                      onTap: _isSubmitting ? null : _submit,
                      isLoading: _isSubmitting,
                      label: 'Start Session',
                      icon: Icons.play_arrow_rounded,
                      colors: const [kAccent, kAccentDeep],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Stagger(
                    controller: _entryCtrl,
                    index: 6,
                    total: 7,
                    child: _ConsoleSection(
                      eyebrow: 'ACTIVE SESSIONS · AWAITING STOP',
                      children: [
                        if (_isLoadingActive)
                          const _Shimmer(height: 64, radius: BorderRadius.all(Radius.circular(14)))
                        else if (_activeRecords.isEmpty)
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: kTextFaint, size: 18),
                              const SizedBox(width: 8),
                              Expanded(child: Text('No sessions currently running. Submit Start above to begin one.', style: _body(size: 12.5))),
                            ],
                          )
                        else
                          Column(
                            children: _activeRecords
                                .map((r) => _ActiveSessionTile(
                                      record: r,
                                      isStopping: _stoppingKeys.contains(_recordKey(r)),
                                      onStop: () => _stopRecord(r),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: _submitSuccess
                ? Container(
                    key: const ValueKey('success'),
                    color: Colors.black.withOpacity(0.6),
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.85, end: 1),
                        duration: const Duration(milliseconds: 380),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: kPanel,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: (lastWasStart ? kAccent : kEmber).withOpacity(0.35)),
                            boxShadow: [BoxShadow(color: (lastWasStart ? kAccent : kEmber).withOpacity(0.18), blurRadius: 30)],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: (lastWasStart ? kAccent : kEmber).withOpacity(0.14)),
                                child: Icon(
                                  lastWasStart ? Icons.play_circle_rounded : Icons.stop_circle_rounded,
                                  color: lastWasStart ? kAccent : kEmber,
                                  size: 46,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(lastWasStart ? 'Started' : 'Stopped', style: _display(size: 17)),
                              const SizedBox(height: 4),
                              Text(
                                _lastSubmittedMotorType != null
                                    ? '${_lastSubmittedMotorType!} • Synced to machine_data'
                                    : 'Synced to machine_data',
                                style: _body(size: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}

// A single row in the "Active Sessions" table on the Log Entry page.
// Shows the key identifying fields for a running (Started, not yet
// Stopped) session, plus a Stop button that stops exactly that session.
class _ActiveSessionTile extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isStopping;
  final VoidCallback onStop;
  const _ActiveSessionTile({required this.record, required this.isStopping, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: kGrid)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle, color: kAccent.withOpacity(0.12)),
            child: const Icon(Icons.bolt_rounded, color: kAccent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record['motor_type'] ?? ''} · ${record['test_id'] ?? ''}',
                  style: _mono(size: 13.5, weight: FontWeight.w700, color: kTextPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Machine ${record['machine_id'] ?? ''} · ${record['operation_name'] ?? ''}',
                  style: _body(size: 11.5, color: kTextMuted),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'F1 ${record['field_1'] ?? '—'} · F2 ${record['field_2'] ?? '—'} · F3 ${record['field_3'] ?? '—'}',
                  style: _mono(size: 11, weight: FontWeight.w600, color: kTextFaint),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isStopping ? null : onStop,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kEmber, kEmberDeep]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: kEmber.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: isStopping
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: kBgDeep),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stop_rounded, color: kBgDeep, size: 16),
                        const SizedBox(width: 4),
                        Text('Stop', style: GoogleFonts.spaceGrotesk(color: kBgDeep, fontWeight: FontWeight.w700, fontSize: 12.5)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


class _DeltaRangeGauge extends StatelessWidget {
  final String label;
  final double value;
  final double maxAbs;
  final Color accentColor;
  final IconData icon;
  // Explicit alert override for window-specific thresholds (e.g. "5 MIN
  // total is below 0.1" or "15 MIN total is above 0.5") — separate from
  // the gauge's own relative hot-zone coloring, since those are two
  // different kinds of "something's off" signal.
  final bool showAlert;
  final String? alertText;
  const _DeltaRangeGauge({
    required this.label,
    required this.value,
    required this.maxAbs,
    this.accentColor = kAccent,
    this.icon = Icons.show_chart_rounded,
    this.showAlert = false,
    this.alertText,
  });

  Color _zoneColor(double v) {
    final ratio = maxAbs <= 0 ? 0.0 : (v.abs() / maxAbs).clamp(0.0, 1.0);
    if (ratio < 0.35) return kAccent;
    if (ratio < 0.7) return kAmber;
    return kEmber;
  }

  @override
  Widget build(BuildContext context) {
    final color = _zoneColor(value);
    final isHot = (maxAbs > 0 && value.abs() >= maxAbs * 0.7) || showAlert;
    return _PulseGlow(
      active: isHot,
      color: kEmber,
      radius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Same icon-in-a-colored-circle heading style as the
                      // circular gauge boxes (AMBIENT / TRACTION MOTOR
                      // panels), so the linear "Total Δ" gauges read as part
                      // of the same visual family instead of plain text.
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [accentColor.withOpacity(0.28), accentColor.withOpacity(0.08)]),
                          border: Border.all(color: accentColor.withOpacity(0.4)),
                        ),
                        child: Icon(icon, color: accentColor, size: 12),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          label,
                          style: _body(size: 13, weight: FontWeight.w600, color: kTextMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: value),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => Text(
                        '${v >= 0 ? '+' : ''}${v.toStringAsFixed(2)}°',
                        style: _mono(size: 15, weight: FontWeight.w700, color: kTextPrimary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      showAlert ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                      color: showAlert ? kEmber : color,
                      size: 17,
                    ),
                  ],
                ),
              ],
            ),
            if (showAlert) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: kEmber, size: 13),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alertText ?? 'Out of expected range',
                      style: _body(size: 11, weight: FontWeight.w600, color: kEmber),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.5,
                end: maxAbs <= 0 ? 0.5 : ((value + maxAbs) / (2 * maxAbs)).clamp(0.0, 1.0),
              ),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, pct, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final markerX = (pct * w).clamp(9.0, w - 9.0);
                    final zeroX = (w / 2 - 5).clamp(0.0, w - 10);
                    return SizedBox(
                      height: 44,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 14,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                height: 10,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [kEmber, kAmber, kAccent, kAmber, kEmber],
                                    stops: [0.0, 0.35, 0.5, 0.65, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: markerX - 9,
                            child: Icon(Icons.arrow_drop_down_rounded, color: kTextPrimary, size: 28),
                          ),
                          Positioned(
                            top: 28,
                            left: 0,
                            child: Text('-${maxAbs.toStringAsFixed(2)}', style: _mono(size: 10.5, weight: FontWeight.w700, color: kEmber)),
                          ),
                          Positioned(
                            top: 28,
                            left: zeroX,
                            child: Text('0', style: _mono(size: 10.5, weight: FontWeight.w700, color: kAccent)),
                          ),
                          Positioned(
                            top: 28,
                            right: 0,
                            child: Text('+${maxAbs.toStringAsFixed(2)}', style: _mono(size: 10.5, weight: FontWeight.w700, color: kEmber)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThresholdGauge extends StatelessWidget {
  final String label;
  final double value;
  final double lowBound;
  final double highBound;
  final double maxValue;
  const _ThresholdGauge({
    required this.label,
    required this.value,
    this.lowBound = 40,
    this.highBound = 75,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    final color = _thermalColor(value);
    final isHot = value >= highBound;
    return _PulseGlow(
      active: isHot,
      color: kEmber,
      radius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: _body(size: 13, weight: FontWeight.w600, color: kTextMuted)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: value),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => Text('${v.toStringAsFixed(3)}°', style: _mono(size: 15, weight: FontWeight.w700, color: kTextPrimary)),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.check_circle_rounded, color: color, size: 17),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (value / maxValue).clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, pct, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final markerX = (pct * w).clamp(8.0, w - 8.0);
                    final lowX = ((lowBound / maxValue) * w).clamp(0.0, w - 30);
                    final highX = ((highBound / maxValue) * w).clamp(0.0, w - 30);
                    return SizedBox(
                      height: 44,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 14,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: const [kAccent, kAmber, kEmber],
                                    stops: [0.0, (lowBound / maxValue).clamp(0.0, 1.0), (highBound / maxValue).clamp(0.0, 1.0)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: markerX - 9,
                            child: Icon(Icons.arrow_drop_down_rounded, color: kTextPrimary, size: 28),
                          ),
                          Positioned(
                            top: 28,
                            left: lowX,
                            child: Text(lowBound.toStringAsFixed(3), style: _mono(size: 10.5, weight: FontWeight.w700, color: kAmber)),
                          ),
                          Positioned(
                            top: 28,
                            left: highX,
                            child: Text(highBound.toStringAsFixed(3), style: _mono(size: 10.5, weight: FontWeight.w700, color: kEmber)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Circular "speedometer" style gauge — draws a 270° ring, background track
// in kGrid, foreground arc colored by _thermalColor(value), with the
// numeric value + unit centered inside and a pulsing live-dot + label
// underneath. Used for the per-column LIVE READINGS grid (replaces the old
// linear Average Overview gauges).
class _CircularGaugePainter extends CustomPainter {
  final double percent; // 0..1, already clamped by caller
  final Color color;
  _CircularGaugePainter({required this.percent, required this.color});

  static const double _startAngle = 2.3561944901; // 135°, in radians
  static const double _sweepAngle = 4.71238898; // 270°, in radians

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 7;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = kGrid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, bgPaint);

    final sweep = _sweepAngle * percent.clamp(0.0, 1.0);
    if (sweep > 0) {
      final fgPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: sweep,
          colors: [color.withOpacity(0.55), color],
          transform: GradientRotation(_startAngle),
        ).createShader(rect);
      canvas.drawArc(rect, _startAngle, sweep, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularGaugePainter old) => old.percent != percent || old.color != color;
}

// A small bright "comet" that glides back and forth along the filled
// portion of the ring — purely decorative, gives the gauge a sense of
// being alive/updating even between poll ticks, without implying the
// value itself is moving.
class _CircularGaugeCometPainter extends CustomPainter {
  final double percent;
  final double t; // 0..1, looping
  final Color color;
  _CircularGaugeCometPainter({required this.percent, required this.t, required this.color});

  static const double _startAngle = 2.3561944901;
  static const double _sweepAngle = 4.71238898;

  @override
  void paint(Canvas canvas, Size size) {
    if (percent <= 0.02) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 7;
    final phase = (math.sin(t * 2 * math.pi) + 1) / 2; // 0 -> 1 -> 0
    final angle = _startAngle + _sweepAngle * percent * phase;
    final dotCenter = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));

    final glowPaint = Paint()
      ..color = color.withOpacity(0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(dotCenter, 5, glowPaint);

    final dotPaint = Paint()..color = Colors.white.withOpacity(0.95);
    canvas.drawCircle(dotCenter, 2.6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _CircularGaugeCometPainter old) =>
      old.t != t || old.percent != percent || old.color != color;
}

class _CircularGauge extends StatefulWidget {
  final String label;
  final double value;
  final double maxValue;
  final bool isLive;
  final Color accentColor;
  final bool showCard;
  const _CircularGauge({
    required this.label,
    required this.value,
    this.maxValue = 100,
    this.isLive = true,
    this.accentColor = kAccent,
    this.showCard = true,
  });

  @override
  State<_CircularGauge> createState() => _CircularGaugeState();
}

class _CircularGaugeState extends State<_CircularGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _spinCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thermal = _thermalColor(widget.value);
    // Ring stays the parameter's own identity color at rest, and blends
    // toward the thermal warning color as the reading climbs — so each
    // gauge is visually distinct at a glance, while still surfacing danger.
    final isHot = widget.value >= 75;
    final ringColor = isHot ? thermal : Color.lerp(widget.accentColor, thermal, 0.3)!;
    final pct = (widget.value / widget.maxValue).clamp(0.0, 1.0);

    final ring = SizedBox(
      width: 88,
      height: 88,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: pct),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animPct, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(size: const Size(88, 88), painter: _CircularGaugePainter(percent: animPct, color: ringColor)),
              if (widget.isLive)
                AnimatedBuilder(
                  animation: _spinCtrl,
                  builder: (_, __) => CustomPaint(
                    size: const Size(88, 88),
                    painter: _CircularGaugeCometPainter(percent: animPct, t: _spinCtrl.value, color: widget.accentColor),
                  ),
                ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.value),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, v, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(v.toStringAsFixed(1), style: _mono(size: 16, weight: FontWeight.w800, color: kTextPrimary)),
                    Text('°C', style: _body(size: 9, color: kTextFaint)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final labelRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PulseDot(color: widget.isLive ? widget.accentColor : kTextFaint),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            widget.label,
            style: _body(size: 11, weight: FontWeight.w600, color: kTextMuted),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (!widget.showCard) {
      // Bare variant for nesting inside a grouped panel (e.g. the
      // Traction Motor boxes) — the panel itself already provides the
      // card/border/shadow, so this just contributes ring + label.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [ring, const SizedBox(height: 8), labelRow],
      );
    }

    return _PulseGlow(
      active: isHot,
      color: kEmber,
      radius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPanelAlt, Color.alphaBlend(widget.accentColor.withOpacity(0.08), kPanelAlt)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: widget.accentColor.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 3,
              decoration: BoxDecoration(color: widget.accentColor, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 9),
            ring,
            const SizedBox(height: 8),
            labelRow,
          ],
        ),
      ),
    );
  }
}

// A 3D-styled panel that groups related circular gauges under one heading
// — used for AMBIENT (single gauge) and per-motor DRIVE END / NON DRIVE
// END pairs. Unlike a one-shot entrance animation, this keeps moving the
// whole time it's on screen: a slow continuous "breathing" 3D tilt (subtle
// rotateX/rotateY oscillation via a repeating controller), a soft diagonal
// light sweep drifting across the glass, a bouncy elastic pop on first
// mount, and a tactile press-down scale on tap — all layered on top of the
// existing pulsing glow (_PulseGlow) while live.
class _GaugeGroupBox extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final List<Widget> gauges;
  final bool isLive;
  const _GaugeGroupBox({
    required this.title,
    required this.icon,
    required this.accent,
    required this.gauges,
    required this.isLive,
  });

  @override
  State<_GaugeGroupBox> createState() => _GaugeGroupBoxState();
}

class _GaugeGroupBoxState extends State<_GaugeGroupBox> with TickerProviderStateMixin {
  late final AnimationController _popCtrl;
  late final AnimationController _tiltCtrl;
  late final AnimationController _shineCtrl;
  double _pressScale = 1.0;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650))..forward();
    _tiltCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
    _shineCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    _tiltCtrl.dispose();
    _shineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    final popCurve = CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressScale = 0.97),
      onTapUp: (_) => setState(() => _pressScale = 1.0),
      onTapCancel: () => setState(() => _pressScale = 1.0),
      child: AnimatedScale(
        scale: _pressScale,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: Listenable.merge([popCurve, _tiltCtrl]),
          builder: (context, child) {
            final tilt = math.sin(_tiltCtrl.value * 2 * math.pi);
            return Transform.scale(
              scale: popCurve.value.clamp(0.0, 1.4),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0009)
                  ..rotateX(0.022 * tilt)
                  ..rotateY(-0.016 * tilt),
                child: child,
              ),
            );
          },
          child: _PulseGlow(
            active: widget.isLive,
            color: accent,
            radius: BorderRadius.circular(22),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: accent.withOpacity(0.32), width: 1.1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 18, offset: const Offset(0, 10)),
                  BoxShadow(color: accent.withOpacity(0.16), blurRadius: 26, spreadRadius: -6),
                  BoxShadow(color: Colors.white.withOpacity(0.03), blurRadius: 1, offset: const Offset(-1, -1)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kPanelAlt, kPanel],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(colors: [accent.withOpacity(0.28), accent.withOpacity(0.08)]),
                                  border: Border.all(color: accent.withOpacity(0.4)),
                                ),
                                child: Icon(widget.icon, color: accent, size: 15),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: _display(size: 13, weight: FontWeight.w700, color: kTextPrimary).copyWith(letterSpacing: 0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: widget.gauges.length == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                            children: widget.gauges,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _shineCtrl,
                          builder: (_, __) => CustomPaint(painter: _ShineSweepPainter(t: _shineCtrl.value, color: accent, opacity: 0.08)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ==========================================
// DASHBOARD — emptied out per request. All previous functionality (live
// gauges, session picker, time-windowed delta tables/gauges, polling,
// etc.) has been removed. This just renders a blank page with a logout
// action, so the "Dashboard" tab in the bottom nav still exists and works,
// it simply has nothing on it.
// ==========================================
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// A continuously auto-scrolling horizontal ticker — the content list is
// rendered twice back-to-back and the scroll position is driven by a
// Ticker (not user touch), jumping back to 0 exactly when it's scrolled
// through one full copy of the content. Because copy #2 is identical to
// copy #1, that reset is visually seamless — the banner appears to loop
// forever with no jump/flicker.
class _MarqueeBanner extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final double speed; // pixels per tick (~60 ticks/sec)
  const _MarqueeBanner({required this.items, this.height = 44, this.speed = 0.6});

  @override
  State<_MarqueeBanner> createState() => _MarqueeBannerState();
}

class _MarqueeBannerState extends State<_MarqueeBanner> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final Ticker _ticker;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    // Content is duplicated, so one full "loop" is half of the total
    // scrollable width (maxScroll spans both copies).
    final loopPoint = maxScroll / 2;
    _offset += widget.speed;
    if (_offset >= loopPoint) _offset = 0;
    _scrollController.jumpTo(_offset);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [...widget.items, ...widget.items],
      ),
    );
  }
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _pollTimer;
  Map<String, dynamic>? _liveRow;
  // Total number of readings currently in machine_sensor_data — a plain
  // count, no chart involved. Updated on the same poll as everything else.
  int _totalCount = 0;
  bool _isLoadingLive = true;
  // Average of each column across EVERY row currently in
  // machine_sensor_data (not just the latest one) — computed fresh on
  // every poll from the same response used for the live row/count.
  final Map<String, double> _averages = {};

  // Same five sensor columns as before, renamed for display: Ambient
  // (was "Amb Temp"), and each traction motor's Drive End / Non Drive End
  // (was TM1/TM2 FET/RET) — pulled from the current row in
  // machine_sensor_data via /get-sensor-data, refreshed every 2s.
  static const List<String> _bannerKeys = ['amb_temp', 'tm1_fet', 'tm1_ret', 'tm2_fet', 'tm2_ret'];
  static const Map<String, String> _bannerLabels = {
    'amb_temp': 'Ambient',
    'tm1_fet': 'Traction Motor 1 · Drive End',
    'tm1_ret': 'Traction Motor 1 · Non Drive End',
    'tm2_fet': 'Traction Motor 2 · Drive End',
    'tm2_ret': 'Traction Motor 2 · Non Drive End',
  };
  static const Map<String, Color> _bannerColors = {
    'amb_temp': kAccent,
    'tm1_fet': kAmber,
    'tm1_ret': kEmber,
    'tm2_fet': kViolet,
    'tm2_ret': kCyan,
  };

  // ------------------------------------------------------------------
  // VFD METRICS · 5-TAB CHART
  // Separate telemetry stream (collection: vfddatas) from a Variable
  // Frequency Drive unit — Current / Voltage / RPM / Frequency / Power.
  // Only one metric's chart is shown at a time; the tab row selects which.
  // Polled on the same 2s cadence as machine_sensor_data, via the same
  // _pollTimer below.
  // ------------------------------------------------------------------
  List<Map<String, dynamic>> _vfdRows = [];
  bool _isLoadingVfd = true;
  // One flag per metric — all shown by default. Tapping a tab toggles just
  // that metric's chart on/off; any number can be visible at once (this
  // isn't an exclusive tab selection).
  List<bool> _vfdVisible = List.filled(5, true);

  static const List<_VfdMetricDef> _vfdMetrics = [
    _VfdMetricDef(key: 'outputCurrent', label: 'Current', unit: 'A', color: kAccent, icon: Icons.bolt_rounded, chartType: _VfdCompareChartType.horizontal),
    _VfdMetricDef(key: 'outputVoltage', label: 'Voltage', unit: 'V', color: kAmber, icon: Icons.flash_on_rounded, chartType: _VfdCompareChartType.bar),
    _VfdMetricDef(key: 'outputRPM', label: 'RPM', unit: 'RPM', color: kViolet, icon: Icons.speed_rounded, chartType: _VfdCompareChartType.radial),
    _VfdMetricDef(key: 'outputFrequency', label: 'Frequency', unit: 'Hz', color: kCyan, icon: Icons.graphic_eq_rounded, chartType: _VfdCompareChartType.pie),
    _VfdMetricDef(key: 'outputPower', label: 'Power', unit: 'kW', color: kEmber, icon: Icons.power_rounded, chartType: _VfdCompareChartType.verticalDots),
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveData();
    _fetchVfdData();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _fetchLiveData();
      _fetchVfdData();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  double _numField(String key) {
    if (_liveRow == null) return 0;
    final raw = _liveRow![key];
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString().trim()) ?? 0;
  }

  // Pulls the latest row straight from machine_sensor_data — same
  // session-agnostic "current value" source the dashboard used before,
  // just driving a scrolling banner now instead of gauges. Also computes
  // the average of each column across every row returned, for the
  // AVERAGE VALUES card.
  Future<void> _fetchLiveData() async {
    try {
      final res = await http.get(Uri.parse('$kApiBaseUrl/get-sensor-data'));
      if (res.statusCode == 200) {
        final List<dynamic> parsed = jsonDecode(res.body);

        final sums = <String, double>{for (final k in _bannerKeys) k: 0};
        int counted = 0;
        for (final item in parsed) {
          final row = Map<String, dynamic>.from(item as Map);
          counted++;
          for (final k in _bannerKeys) {
            final raw = row[k];
            final v = raw is num ? raw.toDouble() : double.tryParse(raw?.toString().trim() ?? '') ?? 0;
            sums[k] = sums[k]! + v;
          }
        }

        if (mounted) {
          setState(() {
            _liveRow = parsed.isNotEmpty ? Map<String, dynamic>.from(parsed.last as Map) : null;
            _totalCount = parsed.length;
            _isLoadingLive = false;
            for (final k in _bannerKeys) {
              _averages[k] = counted > 0 ? sums[k]! / counted : 0;
            }
          });
        }
      }
    } catch (_) {
      // Keep showing whatever was last fetched; try again next tick.
    }
  }

  // Pulls every row from the vfddatas collection — same session-agnostic
  // "everything so far" shape as machine_sensor_data above. The chart only
  // needs the most recent handful of points, so trimming to the tail
  // happens in _vfdSeries() below rather than here, keeping this fetch
  // simple and reusable if more of the history is ever needed elsewhere.
  Future<void> _fetchVfdData() async {
    try {
      final res = await http.get(Uri.parse('$kApiBaseUrl/get-vfd-data'));
      if (res.statusCode == 200) {
        final List<dynamic> parsed = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            _vfdRows = parsed.map((e) => Map<String, dynamic>.from(e as Map)).toList();
            _isLoadingVfd = false;
          });
        }
      }
    } catch (_) {
      // Keep showing whatever was last fetched; try again next tick.
    }
  }

  // Last [maxPoints] readings for one VFD metric key, oldest -> newest —
  // exactly what the line chart plots left-to-right. Missing/unparsable
  // values fall back to 0 rather than breaking the series.
  List<double> _vfdSeries(String key, {int maxPoints = 24}) {
    final recent = _vfdRows.length > maxPoints ? _vfdRows.sublist(_vfdRows.length - maxPoints) : _vfdRows;
    return recent.map((row) {
      final raw = row[key];
      if (raw == null) return 0.0;
      if (raw is num) return raw.toDouble();
      return double.tryParse(raw.toString().trim()) ?? 0.0;
    }).toList();
  }

  // Most recent vfddatas row for each machineId ("MCH-001", "MCH-002", ...).
  // _vfdRows is chronological ascending (oldest -> newest, same as
  // fetchVfdDataFromDB's sort), so walking it forward and overwriting each
  // machine's entry as we go naturally leaves the LAST write per machine —
  // its latest reading — by the time the loop finishes.
  Map<String, Map<String, dynamic>> _latestVfdByMachine() {
    final latest = <String, Map<String, dynamic>>{};
    for (final row in _vfdRows) {
      final id = row['machineId']?.toString();
      if (id == null || id.isEmpty) continue;
      latest[id] = row;
    }
    return latest;
  }

  // Reads one numeric VFD field out of a raw vfddatas row (as returned by
  // _latestVfdByMachine), tolerating it arriving as a String.
  double _vfdNum(Map<String, dynamic> row, String key) {
    final raw = row[key];
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString().trim()) ?? 0;
  }

  // ------------------------------------------------------------------
  // SESSION LOG · DATE RANGE FILTER
  // Day-wise From/To filter over machine_data's Start(1)/Stop(0) sessions
  // (any motor_type/test_id) — whichever sessions START inside the picked
  // range get their machine_sensor_data window pulled and combined into
  // one chronological table, with column totals and 5-min/15-min deltas
  // computed client-side from that combined list.
  // ------------------------------------------------------------------
  DateTime? _rangeFrom;
  DateTime? _rangeTo;
  bool _isLoadingRange = false;
  bool _hasAppliedRange = false;
  String? _rangeError;
  List<Map<String, dynamic>> _rangeSessions = [];
  List<Map<String, dynamic>> _rangeSensorData = [];

  Future<void> _pickRangeDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = (isFrom ? _rangeFrom : _rangeTo) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: kAccent, surface: kPanel, onSurface: kTextPrimary),
          dialogBackgroundColor: kPanel,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _rangeFrom = picked;
        } else {
          _rangeTo = picked;
        }
      });
    }
  }

  void _clearRangeFilter() {
    setState(() {
      _rangeFrom = null;
      _rangeTo = null;
      _rangeError = null;
      _hasAppliedRange = false;
      _rangeSessions = [];
      _rangeSensorData = [];
    });
  }

  String _fmtDateYmd(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  String _fmtDateDisplay(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _applyRangeFilter() async {
    if (_rangeFrom == null || _rangeTo == null) {
      setState(() => _rangeError = 'Pick both a From date and a To date.');
      return;
    }
    if (_rangeTo!.isBefore(_rangeFrom!)) {
      setState(() => _rangeError = 'To date must be on or after the From date.');
      return;
    }
    setState(() {
      _isLoadingRange = true;
      _rangeError = null;
    });
    try {
      final uri = Uri.parse('$kApiBaseUrl/get-sensor-data-range').replace(queryParameters: {
        'from': _fmtDateYmd(_rangeFrom!),
        'to': _fmtDateYmd(_rangeTo!),
      });
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final parsed = jsonDecode(res.body) as Map<String, dynamic>;
        final sessions = (parsed['sessions'] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        final sensorData = (parsed['sensor_data'] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (mounted) {
          setState(() {
            _rangeSessions = sessions;
            _rangeSensorData = sensorData;
            _isLoadingRange = false;
            _hasAppliedRange = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingRange = false;
            _rangeError = 'Server rejected the request (HTTP ${res.statusCode}).';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRange = false;
          _rangeError = 'Could not reach the server.';
        });
      }
    }
  }

  double _rangeNum(Map<String, dynamic> row, String key) {
    final raw = row[key];
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString().trim()) ?? 0;
  }

  DateTime? _rangeTime(Map<String, dynamic> row) => DateTime.tryParse(row['created_at']?.toString() ?? '');

  // Sum of every row's value for one column — the "add of each column"
  // totals row underneath the table.
  double _rangeColumnTotal(String key) => _rangeSensorData.fold<double>(0, (sum, row) => sum + _rangeNum(row, key));

  // Last reading's value minus whatever reading sits at-or-before
  // (lastTime - window) — a rolling "how much did this change over the
  // last 5/15 minutes" delta. Returns null when there isn't enough
  // history before that point yet to compare against.
  double? _rangeColumnDelta(String key, Duration window) {
    if (_rangeSensorData.isEmpty) return null;
    final last = _rangeSensorData.last;
    final lastTime = _rangeTime(last);
    if (lastTime == null) return null;
    final target = lastTime.subtract(window);

    Map<String, dynamic>? baseline;
    for (final row in _rangeSensorData) {
      final t = _rangeTime(row);
      if (t == null) continue;
      if (!t.isAfter(target)) {
        baseline = row;
      } else {
        break;
      }
    }
    if (baseline == null) return null;
    return _rangeNum(last, key) - _rangeNum(baseline, key);
  }

  // Same-timestamp dedup ("take one time"): if two+ rows share the exact
  // same createdAt instant, only the FIRST one encountered (in the given
  // chronological order) is kept — otherwise an exact-duplicate write
  // would sit inside one bucket as two separate points and could distort
  // that bucket's |last-first| diff. Rows without a parseable timestamp
  // are dropped entirely since they can't be bucketed anyway.
  List<Map<String, dynamic>> _dedupeByTimestamp(List<Map<String, dynamic>> rows) {
    final seen = <DateTime>{};
    final result = <Map<String, dynamic>>[];
    for (final row in rows) {
      final t = _rangeTime(row);
      if (t == null) continue;
      if (seen.add(t)) result.add(row);
    }
    return result;
  }

  // ------------------------------------------------------------------
  // NODE.JS-STYLE INTERVAL CALCULATION (mirrors getMachineAnalysis.js)
  // The Node backend controller builds its 5-min/15-min stability report
  // like this, per (motor_type, test_id) Start(1)->Stop(0) session:
  //   1. getNearestRecord(records, targetTime)   — nearest actual reading
  //      to a target timestamp.
  //   2. generateIntervalData(records, on, off, N) — walk on->off in N-
  //      minute steps, picking the nearest reading at every step.
  //   3. calculateDifferences(records, field)   — consecutive |cur-prev|
  //      diffs across that interval series.
  //   4. calculateStatus(records, field, limit) — take the LAST 6 interval
  //      readings (5 diffs), sum them, and declare
  //      Stable (sum < limit) / Unstable (sum >= limit) / Insufficient
  //      Data (fewer than 6 interval readings available).
  // The four methods below are direct Dart ports of that same flow, used
  // by _computeCheck/_sessionHealth in place of the old bucket-diff
  // approach, so the app's Machine Health Analysis matches the backend
  // exactly.
  // ------------------------------------------------------------------

  // Mirrors getRecordTime() — a row's timestamp, trying both field names
  // the backend accepts (created_at from machine_data queries, createdAt
  // from raw Mongo documents).
  String? _recordTimeStr(Map<String, dynamic> row) {
    final a = row['created_at'];
    if (a != null && a.toString().isNotEmpty) return a.toString();
    final b = row['createdAt'];
    if (b != null && b.toString().isNotEmpty) return b.toString();
    return null;
  }

  // Direct port of getNearestRecord(): linear scan for whichever record
  // has the smallest absolute time distance from targetTime.
  Map<String, dynamic>? _getNearestRecord(List<Map<String, dynamic>> records, DateTime targetTime) {
    if (records.isEmpty) return null;
    Map<String, dynamic> nearest = records.first;
    final firstTime = DateTime.tryParse(_recordTimeStr(nearest) ?? '');
    double minDiff = firstTime == null ? double.infinity : targetTime.difference(firstTime).inMilliseconds.abs().toDouble();

    for (final rec in records) {
      final t = DateTime.tryParse(_recordTimeStr(rec) ?? '');
      if (t == null) continue;
      final diff = targetTime.difference(t).inMilliseconds.abs().toDouble();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = rec;
      }
    }
    return nearest;
  }

  // Direct port of generateIntervalData(): walk from startTime to endTime
  // in `intervalMinutes` steps, appending the nearest actual reading at
  // each step.
  List<Map<String, dynamic>> _generateIntervalData(
    List<Map<String, dynamic>> records,
    DateTime startTime,
    DateTime endTime,
    int intervalMinutes,
  ) {
    final output = <Map<String, dynamic>>[];
    DateTime current = startTime;
    while (!current.isAfter(endTime)) {
      final record = _getNearestRecord(records, current);
      if (record != null) output.add(record);
      current = current.add(Duration(minutes: intervalMinutes));
    }
    return output;
  }

  // Direct port of calculateDifferences(): consecutive absolute
  // differences for one field, rounded to 3 decimals same as the Node
  // controller's Number(...).toFixed(3).
  List<double> _calculateDifferences(List<Map<String, dynamic>> records, String field) {
    final diffs = <double>[];
    for (int i = 1; i < records.length; i++) {
      final prev = _rangeNum(records[i - 1], field);
      final curr = _rangeNum(records[i], field);
      diffs.add(double.parse((curr - prev).abs().toStringAsFixed(3)));
    }
    return diffs;
  }

  // Direct port of calculateStatus(): takes only the LAST 6 interval
  // readings; if fewer than 6 are available, the result is Insufficient
  // Data (matches the Node controller's "INSUFFICIENT DATA" branch).
  // Otherwise sums the 5 consecutive differences and compares that sum
  // against `limit` — sum < limit is Stable, otherwise Unstable.
  _CheckResult _calculateStatus(List<Map<String, dynamic>> records, String field, double limit) {
    final lastSix = records.length > 6 ? records.sublist(records.length - 6) : records;
    if (lastSix.length < 6) {
      return const _CheckResult(sum: null, status: _HealthStatus.incomplete);
    }
    final differences = _calculateDifferences(lastSix, field);
    final rawSum = differences.fold<double>(0, (a, b) => a + b);
    final sum = double.parse(rawSum.toStringAsFixed(3));
    return _CheckResult(sum: sum, status: sum < limit ? _HealthStatus.stable : _HealthStatus.unstable);
  }

  // One test point's 5-min-or-15-min check for one session: generates the
  // interval series across [onTime, offTime] at `intervalMinutes` spacing
  // (nearest-reading per step, exactly like the Node controller's
  // generateIntervalData), then runs calculateStatus on that series —
  // replaces the old bucket-diff-sum approach.
  _CheckResult _computeCheck(
    List<Map<String, dynamic>> sessionRows,
    DateTime onTime,
    DateTime offTime,
    String key,
    int intervalMinutes,
    double threshold,
  ) {
    final rows = _dedupeByTimestamp(sessionRows)..sort((a, b) => _rangeTime(a)!.compareTo(_rangeTime(b)!));
    final intervalData = _generateIntervalData(rows, onTime, offTime, intervalMinutes);
    return _calculateStatus(intervalData, key, threshold);
  }

  // Full health breakdown for one session: its own sensor rows, then a
  // 5-min AND a 15-min _CheckResult for each of the 4 test points —
  // mirrors the Node controller's per-field { fiveMinute, fifteenMinute }
  // report, generated once per (motor_type, test_id) ON->OFF session.
  _SessionHealth _sessionHealth(Map<String, dynamic> session) {
    final rows = _sessionRows(session);
    final onTime = DateTime.tryParse(session['start_time']?.toString() ?? '');
    final offTime = DateTime.tryParse(session['stop_time']?.toString() ?? '');

    final checks = <String, _CheckResult>{};
    for (final tp in _testPoints) {
      if (onTime == null || offTime == null) {
        checks['${tp.key}_5'] = const _CheckResult(sum: null, status: _HealthStatus.incomplete);
        checks['${tp.key}_15'] = const _CheckResult(sum: null, status: _HealthStatus.incomplete);
        continue;
      }
      checks['${tp.key}_5'] = _computeCheck(rows, onTime, offTime, tp.key, 5, 0.5);
      checks['${tp.key}_15'] = _computeCheck(rows, onTime, offTime, tp.key, 15, 1.0);
    }
    return _SessionHealth(session: session, checks: checks);
  }

  // ------------------------------------------------------------------
  // MACHINE HEALTH ANALYSIS
  // Per SESSION (one machine_data Start(1)->Stop(0) pair, i.e. one row of
  // _rangeSessions) and per TEST POINT (TM1/TM2 Drive End / Non-Drive
  // End), the checks above (_computeCheck/_sessionHealth) declare the
  // motor UNSTABLE if the summed 5-consecutive-difference total reaches
  // the threshold (0.5 for the 5-min check, 1 for the 15-min check) —
  // otherwise STABLE. A test point with fewer than 6 interval readings is
  // INCOMPLETE rather than guessed at, exactly like the Node backend.
  // ------------------------------------------------------------------
  static const List<_TestPointDef> _testPoints = [
    _TestPointDef(key: 'tm1_fet', shortLabel: 'TM1 DE', fullLabel: 'TM1 · Drive End'),
    _TestPointDef(key: 'tm1_ret', shortLabel: 'TM1 NDE', fullLabel: 'TM1 · Non-Drive End'),
    _TestPointDef(key: 'tm2_fet', shortLabel: 'TM2 DE', fullLabel: 'TM2 · Drive End'),
    _TestPointDef(key: 'tm2_ret', shortLabel: 'TM2 NDE', fullLabel: 'TM2 · Non-Drive End'),
  ];

  int _healthRowsPerPage = 5;
  int _healthPage = 0;

  // This session's own machine_sensor_data readings — filtered out of the
  // already-fetched, combined _rangeSensorData by this session's own
  // [start_time, stop_time] window (no extra network call needed).
  List<Map<String, dynamic>> _sessionRows(Map<String, dynamic> session) {
    final start = DateTime.tryParse(session['start_time']?.toString() ?? '');
    final stop = DateTime.tryParse(session['stop_time']?.toString() ?? '');
    return _rangeSensorData.where((row) {
      final t = _rangeTime(row);
      if (t == null) return false;
      if (start != null && t.isBefore(start)) return false;
      if (stop != null && t.isAfter(stop)) return false;
      return true;
    }).toList();
  }

  // Flattens every check (every test point × both windows × every
  // session) into one stable/unstable/incomplete tally — feeds the
  // "STABILITY" pie chart under the Session Log filter.
  Map<_HealthStatus, int> _aggregateHealthCounts(List<_SessionHealth> healths) {
    final counts = <_HealthStatus, int>{_HealthStatus.stable: 0, _HealthStatus.unstable: 0, _HealthStatus.incomplete: 0};
    for (final h in healths) {
      for (final result in h.checks.values) {
        counts[result.status] = counts[result.status]! + 1;
      }
    }
    return counts;
  }

  void _logout() {
    Navigator.pushReplacement(context, _consoleRoute(const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _liveRow != null;
    final latestVfdByMachine = _latestVfdByMachine();

    final items = _bannerKeys.map((k) {
      final color = _bannerColors[k]!;
      final label = _bannerLabels[k]!;
      final value = hasData ? _numField(k).toStringAsFixed(1) : '--';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color.withOpacity(0.7), blurRadius: 6)]),
            ),
            const SizedBox(width: 8),
            Text(label, style: _body(size: 13, weight: FontWeight.w600, color: kTextMuted)),
            const SizedBox(width: 8),
            Text('$value°', style: _mono(size: 14, weight: FontWeight.w800, color: kTextPrimary)),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: kBgDeep,
      appBar: AppBar(
        backgroundColor: kPanel,
        elevation: 0,
        title: Text('Dashboard', style: _display(size: 15)),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new_rounded, color: kTextMuted),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: kGrid),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: kPanel,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _MarqueeBanner(items: items),
          ),
          Container(height: 1, color: kGrid),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Grouped 3D pie — right under the banner, first thing the
                // operator sees. Three slices only: Ambient on its own, and
                // each traction motor collapsed to the average of its Drive
                // End / Non Drive End readings, so the headline chart reads
                // "one number per machine part" instead of five raw sensors.
                _PieChart3DCard(
                  title: 'MACHINE OVERVIEW',
                  labels: const ['Ambient', 'Traction Motor 1', 'Traction Motor 2'],
                  values: [
                    _numField('amb_temp'),
                    (_numField('tm1_fet') + _numField('tm1_ret')) / 2,
                    (_numField('tm2_fet') + _numField('tm2_ret')) / 2,
                  ],
                  colors: const [kAccent, kAmber, kViolet],
                  hasData: hasData,
                ),
                const SizedBox(height: 16),
                // Plain count — a number, no chart.
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGrid),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kAccent.withOpacity(0.12),
                        ),
                        child: const Icon(Icons.storage_rounded, color: kAccent, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL READINGS · MACHINE_SENSOR_DATA', style: _body(size: 10, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1)),
                            const SizedBox(height: 2),
                            Text(_totalCount.toString(), style: _display(size: 24)),
                          ],
                        ),
                      ),
                      _StatusPill(label: hasData ? 'LIVE' : 'WAITING', color: hasData ? kAccent : kAmber),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Average of each column across every row in
                // machine_sensor_data — same plain row style as LIVE
                // VALUES, just showing the average instead of the latest.
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGrid),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 3, height: 13, decoration: BoxDecoration(color: kViolet, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 8),
                          Text('AVERAGE VALUES · ALL READINGS', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1)),
                          const Spacer(),
                          _StatusPill(label: '$_totalCount PTS', color: kViolet),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (_isLoadingLive)
                        const _Shimmer(height: 160, radius: BorderRadius.all(Radius.circular(14)))
                      else if (!hasData)
                        Row(
                          children: [
                            Icon(Icons.sensors_off_rounded, color: kTextFaint, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text('No sensor data received yet.', style: _body(size: 12.5))),
                          ],
                        )
                      else
                        for (int i = 0; i < _bannerKeys.length; i++) ...[
                          _LiveValueRow(
                            label: _bannerLabels[_bannerKeys[i]]!,
                            value: _averages[_bannerKeys[i]] ?? 0,
                            color: _bannerColors[_bannerKeys[i]]!,
                          ),
                          if (i != _bannerKeys.length - 1) Divider(color: kGrid, height: 22),
                        ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Grouped circular-gauge "live streaming" view — Ambient on
                // its own, each traction motor's Drive End / Non Drive End
                // paired under one heading. Reuses the same _GaugeGroupBox
                // + _CircularGauge widgets (with their built-in breathing
                // tilt / comet / press feedback), driven by the same
                // _liveRow polled every 2s above — so this updates on its
                // own with no extra fetching.
                Row(
                  children: [
                    Container(width: 3, height: 13, decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text('LIVE STREAMING', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1)),
                    const Spacer(),
                    _StatusPill(label: hasData ? 'LIVE' : 'WAITING', color: hasData ? kAccent : kAmber),
                  ],
                ),
                const SizedBox(height: 12),
                if (_isLoadingLive)
                  const _Shimmer(height: 420, radius: BorderRadius.all(Radius.circular(16)))
                else if (!hasData)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(20), border: Border.all(color: kGrid)),
                    child: Row(
                      children: [
                        Icon(Icons.sensors_off_rounded, color: kTextFaint, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text('No sensor data received yet.', style: _body(size: 12.5))),
                      ],
                    ),
                  )
                else ...[
                  _GaugeGroupBox(
                    title: 'AMBIENT',
                    icon: Icons.device_thermostat_rounded,
                    accent: kAccent,
                    isLive: true,
                    gauges: [
                      _CircularGauge(label: 'Ambient', value: _numField('amb_temp'), isLive: true, accentColor: kAccent, showCard: false),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _GaugeGroupBox(
                    title: 'TRACTION MOTOR 1',
                    icon: Icons.settings_rounded,
                    accent: kAmber,
                    isLive: true,
                    gauges: [
                      _CircularGauge(label: 'Drive End', value: _numField('tm1_fet'), isLive: true, accentColor: kAmber, showCard: false),
                      _CircularGauge(label: 'Non Drive End', value: _numField('tm1_ret'), isLive: true, accentColor: kEmber, showCard: false),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _GaugeGroupBox(
                    title: 'TRACTION MOTOR 2',
                    icon: Icons.settings_rounded,
                    accent: kViolet,
                    isLive: true,
                    gauges: [
                      _CircularGauge(label: 'Drive End', value: _numField('tm2_fet'), isLive: true, accentColor: kViolet, showCard: false),
                      _CircularGauge(label: 'Non Drive End', value: _numField('tm2_ret'), isLive: true, accentColor: kCyan, showCard: false),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                // VFD METRICS — pill-style show/hide toggles (any
                // combination can be on at once, not an exclusive tab
                // selector) followed by a 2-column grid of every visible
                // metric's chart, all inside this one card.
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGrid),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 3, height: 13, decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 8),
                          Text('VFD METRICS · VFD DATAS', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1)),
                          const Spacer(),
                          _StatusPill(label: _vfdRows.isNotEmpty ? 'LIVE' : 'WAITING', color: _vfdRows.isNotEmpty ? kAccent : kAmber),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('SHOW CHANNELS', style: _body(size: 9.5, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 1.1)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (int i = 0; i < _vfdMetrics.length; i++)
                            _VfdTabButton(
                              icon: _vfdMetrics[i].icon,
                              label: _vfdMetrics[i].label,
                              color: _vfdMetrics[i].color,
                              selected: _vfdVisible[i],
                              onTap: () => setState(() => _vfdVisible[i] = !_vfdVisible[i]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Blue = MCH-001 · Amber = MCH-002', style: _body(size: 10.5, color: kTextFaint)),
                      const SizedBox(height: 18),
                      if (_isLoadingVfd)
                        const _Shimmer(height: 180, radius: BorderRadius.all(Radius.circular(16)))
                      else if (!_vfdVisible.contains(true))
                        Row(
                          children: [
                            Icon(Icons.visibility_off_rounded, color: kTextFaint, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text('All channels hidden — tap a pill above to show its chart.', style: _body(size: 12.5))),
                          ],
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const gap = 12.0;
                            final cardWidth = (constraints.maxWidth - gap) / 2;
                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: [
                                for (int i = 0; i < _vfdMetrics.length; i++)
                                  if (_vfdVisible[i])
                                    SizedBox(
                                      width: cardWidth,
                                      child: _VfdCompareCard(
                                        key: ValueKey(_vfdMetrics[i].key),
                                        label: _vfdMetrics[i].label,
                                        unit: _vfdMetrics[i].unit,
                                        icon: _vfdMetrics[i].icon,
                                        chartType: _vfdMetrics[i].chartType,
                                        machine1Label: 'MCH-001',
                                        machine2Label: 'MCH-002',
                                        color1: kCyan,
                                        color2: kAmber,
                                        value1: latestVfdByMachine['MCH-001'] == null
                                            ? null
                                            : _vfdNum(latestVfdByMachine['MCH-001']!, _vfdMetrics[i].key),
                                        value2: latestVfdByMachine['MCH-002'] == null
                                            ? null
                                            : _vfdNum(latestVfdByMachine['MCH-002']!, _vfdMetrics[i].key),
                                      ),
                                    ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // MACHINE READINGS BY ID — one card per physical VFD unit,
                // keyed off vfddatas' own machineId field rather than the
                // dashboard's motor-averaging elsewhere. Each card shows
                // that machine's single latest reading (timestamp + all 5
                // channels) exactly as it last arrived, so it stays
                // accurate even if the two machines report at different
                // rates or one goes offline.
                Row(
                  children: [
                    Container(width: 3, height: 13, decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text('MACHINE READINGS · BY MACHINE ID', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1)),
                  ],
                ),
                const SizedBox(height: 12),
                _MachineLastReadingCard(
                  title: 'Traction Motor 1',
                  machineId: 'MCH-001',
                  accent: kAccent,
                  row: latestVfdByMachine['MCH-001'],
                ),
                const SizedBox(height: 14),
                _MachineLastReadingCard(
                  title: 'Traction Motor 2',
                  machineId: 'MCH-002',
                  accent: kAmber,
                  row: latestVfdByMachine['MCH-002'],
                ),
                const SizedBox(height: 16),
                // SESSION LOG · DATE RANGE FILTER — From/To day pickers +
                // Clear, filtering machine_data's Start(1)/Stop(0) sessions
                // by which day the Start happened on. Every matching
                // session's machine_sensor_data window is combined into one
                // table below, with a column-totals row and rolling 5-min /
                // 15-min delta rows underneath it.
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGrid),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 3, height: 13, decoration: BoxDecoration(color: kCyan, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 8),
                          Expanded(child: Text('SESSION LOG · DATE RANGE', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1))),
                          if (_hasAppliedRange) _StatusPill(label: '${_rangeSessions.length} SESSIONS', color: kCyan),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _RangeDateButton(
                              label: 'From Date',
                              value: _rangeFrom == null ? null : _fmtDateDisplay(_rangeFrom!),
                              onTap: () => _pickRangeDate(isFrom: true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _RangeDateButton(
                              label: 'To Date',
                              value: _rangeTo == null ? null : _fmtDateDisplay(_rangeTo!),
                              onTap: () => _pickRangeDate(isFrom: false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _AnimatedButton(
                              onTap: _isLoadingRange ? null : _applyRangeFilter,
                              isLoading: _isLoadingRange,
                              label: 'Apply Filter',
                              icon: Icons.filter_alt_rounded,
                              colors: const [kCyan, kAccentDeep],
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _isLoadingRange ? null : _clearRangeFilter,
                            child: Container(
                              height: 54,
                              width: 54,
                              decoration: BoxDecoration(
                                color: kPanelAlt,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kGrid),
                              ),
                              child: const Icon(Icons.clear_rounded, color: kTextMuted, size: 22),
                            ),
                          ),
                        ],
                      ),
                      if (_rangeError != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.error_outline_rounded, color: kEmber, size: 15),
                            const SizedBox(width: 6),
                            Expanded(child: Text(_rangeError!, style: _body(size: 11.5, weight: FontWeight.w600, color: kEmber))),
                          ],
                        ),
                      ],
                      if (_hasAppliedRange) ...[
                        const SizedBox(height: 18),
                        if (_rangeSensorData.isEmpty)
                          Row(
                            children: [
                              Icon(Icons.event_busy_rounded, color: kTextFaint, size: 18),
                              const SizedBox(width: 8),
                              Expanded(child: Text('No sessions/readings found in that date range.', style: _body(size: 12.5))),
                            ],
                          )
                        else if (_rangeSessions.isNotEmpty) ...[
                          // Stability is driven entirely by the Machine Health
                          // Analysis table below (per-session, per-test-point
                          // 5-min/15-min interval checks) — the old standalone
                          // "Δ 5 MIN / Δ 15 MIN (sum of differences)" card has
                          // been removed so there's a single source of truth.
                          // Computed once and shared by the pie + trend line
                          // charts below so _sessionHealth doesn't run twice.
                          Builder(builder: (context) {
                            final rangeHealths = _rangeSessions.map(_sessionHealth).toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StabilityPieCard(counts: _aggregateHealthCounts(rangeHealths)),
                                const SizedBox(height: 16),
                                _StabilityTrendCard(healths: rangeHealths),
                              ],
                            );
                          }),
                          const SizedBox(height: 16),
                          _ReadingsPerTestCard(
                            sessions: _rangeSessions,
                            countFn: (s) => _sessionRows(s).length,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                if (_hasAppliedRange && _rangeSessions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Builder(builder: (context) {
                    // Computed once per build from the sessions/readings the
                    // filter above already fetched — no extra network calls.
                    final healths = _rangeSessions.map(_sessionHealth).toList();

                    // Aggregate stable/unstable/incomplete counts per test
                    // point across EVERY session's 5-min AND 15-min check
                    // (2 checks per session per test point) — feeds the
                    // summary bars and the "N checks" pill.
                    final counts = <String, Map<_HealthStatus, int>>{
                      for (final tp in _testPoints) tp.key: {_HealthStatus.stable: 0, _HealthStatus.unstable: 0, _HealthStatus.incomplete: 0},
                    };
                    int totalChecks = 0;
                    for (final h in healths) {
                      for (final tp in _testPoints) {
                        for (final suffix in ['5', '15']) {
                          final result = h.checks['${tp.key}_$suffix']!;
                          counts[tp.key]![result.status] = counts[tp.key]![result.status]! + 1;
                          totalChecks++;
                        }
                      }
                    }

                    // Rows-per-page pagination over the session list.
                    final totalPages = (healths.length / _healthRowsPerPage).ceil().clamp(1, 1 << 30);
                    final page = _healthPage.clamp(0, totalPages - 1);
                    final pageStart = page * _healthRowsPerPage;
                    final pageEnd = math.min(pageStart + _healthRowsPerPage, healths.length);
                    final pageHealths = healths.sublist(pageStart, pageEnd);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HealthSummaryCard(counts: counts, testPoints: _testPoints, totalChecks: totalChecks),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: kPanel,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kGrid),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(width: 3, height: 13, decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(2))),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('MACHINE HEALTH ANALYSIS', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.1))),
                                  _StatusPill(label: '${healths.length} RECORDS', color: kAccent),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _MachineHealthTable(healths: pageHealths, testPoints: _testPoints),
                              const SizedBox(height: 14),
                              _HealthPaginationBar(
                                total: healths.length,
                                pageStart: pageStart,
                                pageEnd: pageEnd,
                                rowsPerPage: _healthRowsPerPage,
                                page: page,
                                totalPages: totalPages,
                                onRowsPerPageChanged: (v) => setState(() {
                                  _healthRowsPerPage = v;
                                  _healthPage = 0;
                                }),
                                onPageChanged: (p) => setState(() => _healthPage = p),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// One plain row for a live value: a colored dot, the label, and the
// number — no chart/gauge/bar. Value changes animate via a simple
// count-up/down tween, but nothing here is drawn as a graphic.
class _LiveValueRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _LiveValueRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color.withOpacity(0.7), blurRadius: 6)]),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: _body(size: 13, weight: FontWeight.w600, color: kTextMuted))),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text('${v.toStringAsFixed(1)}°', style: _mono(size: 15, weight: FontWeight.w800, color: kTextPrimary)),
          ),
        ],
      ),
    );
  }
}

// 3D-styled ("extruded/tilted") pie chart painter — the same slice data
// as the flat donut above, but drawn as a squashed ellipse (perspective)
// with a darkened "side wall" stacked underneath each slice to fake
// depth, similar to how spreadsheet apps render a "3D pie chart".
class _PieChart3DPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double animation; // 0..1, sweeps the whole chart in on first draw
  final double depth;
  _PieChart3DPainter({required this.values, required this.colors, this.animation = 1.0, this.depth = 14});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b.abs());
    final rw = size.width / 2;
    final rh = (size.height - depth) / 2;
    final center = Offset(size.width / 2, rh + 2);

    if (total <= 0) {
      final emptyPaint = Paint()
        ..color = kGrid
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;
      canvas.drawOval(Rect.fromCenter(center: center, width: rw * 2 - 8, height: rh * 2 - 8), emptyPaint);
      return;
    }

    final topRect = Rect.fromCenter(center: center, width: rw * 2, height: rh * 2);

    // Side "wall": the same slice angles, stacked at several y-offsets
    // below the top face and darkened, so the pie reads as an extruded
    // disc viewed slightly from above rather than a flat circle.
    final steps = depth.round().clamp(1, 40);
    for (int s = steps; s >= 1; s--) {
      double startAngle = -math.pi / 2;
      final wallRect = topRect.shift(Offset(0, s.toDouble()));
      for (int i = 0; i < values.length; i++) {
        final sweep = (values[i].abs() / total) * 2 * math.pi * animation;
        if (sweep <= 0) continue;
        final darker = Color.lerp(colors[i], Colors.black, 0.4)!;
        canvas.drawArc(wallRect, startAngle, sweep, true, Paint()..color = darker);
        startAngle += sweep;
      }
    }

    // Top face — full-color slices with a faint highlight edge.
    double startAngle = -math.pi / 2;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i].abs() / total) * 2 * math.pi * animation;
      if (sweep <= 0) continue;
      canvas.drawArc(topRect, startAngle, sweep, true, Paint()..color = colors[i]);
      canvas.drawArc(
        topRect,
        startAngle,
        sweep,
        true,
        Paint()
          ..color = Colors.white.withOpacity(0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      startAngle += sweep;
    }

    // Donut hole punched through the top face only.
    final holeRect = Rect.fromCenter(center: center, width: rw * 2 * 0.5, height: rh * 2 * 0.5);
    canvas.drawOval(holeRect, Paint()..color = kPanel);
    canvas.drawOval(holeRect, Paint()..color = kGrid..style = PaintingStyle.stroke..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant _PieChart3DPainter old) =>
      old.values != values || old.colors != colors || old.animation != animation || old.depth != depth;
}

// Card wrapping the 3D pie chart with a centered total and legend.
class _PieChart3DCard extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;
  final bool hasData;
  final String title;
  final String subtitle;
  const _PieChart3DCard({
    required this.labels,
    required this.values,
    required this.colors,
    required this.hasData,
    this.title = 'TEMPERATURE SHARE',
    this.subtitle = 'Ambient vs. Traction Motor averages',
  });

  @override
  Widget build(BuildContext context) {
    final total = values.fold<double>(0, (a, b) => a + b.abs());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPanelAlt, kPanel],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kCyan.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 12)),
          BoxShadow(color: kCyan.withOpacity(0.10), blurRadius: 30, spreadRadius: -6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [kCyan.withOpacity(0.30), kCyan.withOpacity(0.08)]),
                  border: Border.all(color: kCyan.withOpacity(0.45)),
                ),
                child: Icon(Icons.pie_chart_rounded, color: kCyan, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: _display(size: 14, weight: FontWeight.w700, color: kTextPrimary).copyWith(letterSpacing: 0.6),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusPill(label: hasData ? 'LIVE' : 'WAITING', color: hasData ? kAccent : kAmber),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(subtitle, style: _body(size: 11, color: kTextFaint)),
          ),
          const SizedBox(height: 20),
          if (!hasData)
            Row(
              children: [
                Icon(Icons.pie_chart_outline_rounded, color: kTextFaint, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('No sensor data received yet.', style: _body(size: 12.5))),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, animValue, _) => SizedBox(
                    width: 168,
                    height: 148,
                    child: _TouchableChart(
                      hitTest: (local, size) {
                        const depth = 18.0;
                        final rw = size.width / 2;
                        final rh = (size.height - depth) / 2;
                        final center = Offset(size.width / 2, rh + 2);
                        final lbl = _donutSliceLabel(
                          local: local,
                          center: center,
                          radiusX: rw,
                          radiusY: rh,
                          labels: labels,
                          values: values,
                          holeFraction: 0.5,
                        );
                        if (lbl == null) return null;
                        final idx = labels.indexOf(lbl);
                        return '$lbl: ${values[idx].toStringAsFixed(1)}°';
                      },
                      child: CustomPaint(
                        size: const Size(168, 148),
                        painter: _PieChart3DPainter(values: values, colors: colors, animation: animValue, depth: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < labels.length; i++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: colors[i].withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors[i].withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors[i],
                                  boxShadow: [BoxShadow(color: colors[i].withOpacity(0.7), blurRadius: 6)],
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  labels[i],
                                  style: _body(size: 11.5, weight: FontWeight.w600, color: kTextPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: values[i]),
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, v, _) => Text(
                                      '${v.toStringAsFixed(1)}°',
                                      style: _mono(size: 12.5, weight: FontWeight.w800, color: kTextPrimary),
                                    ),
                                  ),
                                  Text(
                                    total > 0 ? '${((values[i].abs() / total) * 100).toStringAsFixed(0)}%' : '0%',
                                    style: _body(size: 9.5, weight: FontWeight.w600, color: colors[i]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Which comparison-chart shape a metric's card renders as — deliberately
// varied per metric (bar / horizontal track / donut / dual-ring gauge /
// vertical dot-line) rather than one repeated chart type for all five.
enum _VfdCompareChartType { bar, horizontal, pie, radial, verticalDots }

// Static description of one VFD tab: which vfddatas field it plots, its
// display label/unit, and the color/icon used consistently for its tab
// button, chart line, and value readout.
class _VfdMetricDef {
  final String key;
  final String label;
  final String unit;
  final Color color;
  final IconData icon;
  final _VfdCompareChartType chartType;
  const _VfdMetricDef({
    required this.key,
    required this.label,
    required this.unit,
    required this.color,
    required this.icon,
    this.chartType = _VfdCompareChartType.bar,
  });
}

// One pill-shaped "show channel" toggle. Selected = solid fill in the
// metric's own color; unselected = flat/muted outline (per the request,
// this reads as "off" without looking disabled-to-tap). Any number of
// these can be selected at once — it's an independent toggle, not an
// exclusive tab selector — so tapping one never affects the others.
class _VfdTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _VfdTabButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? color : kPanelAlt,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? color : kGrid),
          boxShadow: selected
              ? [BoxShadow(color: color.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? kBgDeep : kTextFaint),
            const SizedBox(width: 7),
            Text(
              label,
              style: _body(size: 12.5, weight: FontWeight.w700, color: selected ? kBgDeep : kTextFaint),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple line-chart painter for one VFD metric's recent readings: a faint
// horizontal grid, a gradient fill under the line, a smooth stroked line
// through every point, and a glowing dot marking the latest reading.
class _VfdLineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _VfdLineChartPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final range = (maxV - minV).abs() < 0.0001 ? 1.0 : (maxV - minV);

    final gridPaint = Paint()
      ..color = kGrid
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1 ? size.width : size.width * (i / (values.length - 1));
      final normalized = (values[i] - minV) / range;
      final y = size.height - (normalized * (size.height - 8)) - 4;
      points.add(Offset(x, y));
    }

    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.32), color.withOpacity(0.02)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final last = points.last;
    canvas.drawCircle(last, 7, Paint()..color = color.withOpacity(0.30)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawCircle(last, 3.6, Paint()..color = Colors.white);
    canvas.drawCircle(last, 3.6, Paint()..color = color.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  bool shouldRepaint(covariant _VfdLineChartPainter old) => old.values != values || old.color != color;
}

// Card for one VFD metric's chart: header (icon, "LABEL · LAST READINGS",
// live value readout), then either an empty-state row or the line chart
// itself over the last N readings.
class _VfdChartCard extends StatelessWidget {
  final String label;
  final String unit;
  final Color color;
  final IconData icon;
  final List<double> values;
  final bool hasData;
  const _VfdChartCard({
    super.key,
    required this.label,
    required this.unit,
    required this.color,
    required this.icon,
    required this.values,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    final latest = values.isNotEmpty ? values.last : 0.0;
    final showChart = hasData && values.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanelAlt, kPanel]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.32)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.10), blurRadius: 20, spreadRadius: -6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [color.withOpacity(0.28), color.withOpacity(0.08)]),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Icon(icon, color: color, size: 15),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${label.toUpperCase()} · LAST READINGS',
                  style: _body(size: 10.5, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showChart)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: latest),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => Text(
                    '${v.toStringAsFixed(1)} $unit',
                    style: _mono(size: 15, weight: FontWeight.w800, color: kTextPrimary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (!showChart)
            Row(
              children: [
                Icon(Icons.show_chart_rounded, color: kTextFaint, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('No VFD data received yet.', style: _body(size: 12.5))),
              ],
            )
          else
            SizedBox(
              height: 150,
              width: double.infinity,
              child: CustomPaint(painter: _VfdLineChartPainter(values: values, color: color)),
            ),
        ],
      ),
    );
  }
}

// One card in "MACHINE READINGS · BY MACHINE ID": the given machine's
// single latest vfddatas reading — an "Updated" timestamp row, then plain
// rows for Voltage / Current / Frequency / RPM / Power. `row` is that
// machine's most recent document (from _latestVfdByMachine()), or null if
// no reading has arrived for this machineId yet.
class _MachineLastReadingCard extends StatelessWidget {
  final String title;
  final String machineId;
  final Color accent;
  final Map<String, dynamic>? row;
  const _MachineLastReadingCard({
    required this.title,
    required this.machineId,
    required this.accent,
    required this.row,
  });

  static const List<_VfdMetricDef> _fields = [
    _VfdMetricDef(key: 'outputVoltage', label: 'Voltage', unit: 'V', color: kAmber, icon: Icons.flash_on_rounded),
    _VfdMetricDef(key: 'outputCurrent', label: 'Current', unit: 'A', color: kAccent, icon: Icons.bolt_rounded),
    _VfdMetricDef(key: 'outputFrequency', label: 'Frequency', unit: 'Hz', color: kCyan, icon: Icons.graphic_eq_rounded),
    _VfdMetricDef(key: 'outputRPM', label: 'RPM', unit: '', color: kViolet, icon: Icons.speed_rounded),
    _VfdMetricDef(key: 'outputPower', label: 'Power', unit: 'kW', color: kEmber, icon: Icons.power_rounded),
  ];

  double _num(String key) {
    final raw = row?[key];
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString().trim()) ?? 0;
  }

  // Whole numbers print without a decimal (matches "0 V" / "0 Hz" style),
  // anything fractional keeps one decimal place.
  String _fmtValue(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  String _fmtTimestamp() {
    final iso = row?['created_at']?.toString();
    if (iso == null || iso.isEmpty) return 'No data yet';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return 'No data yet';
    final l = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(l.day)}/${two(l.month)}/${l.year} ${two(l.hour)}:${two(l.minute)}:${two(l.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasReading = row != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanel, kPanelAlt.withOpacity(0.6)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: accent.withOpacity(0.08), blurRadius: 18, spreadRadius: -6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 13, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: _display(size: 13, weight: FontWeight.w700, color: accent).copyWith(letterSpacing: 0.6),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusPill(label: machineId, color: hasReading ? accent : kTextFaint),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Updated', style: _body(size: 12.5, weight: FontWeight.w600, color: kTextMuted)),
              Text(_fmtTimestamp(), style: _mono(size: 12, weight: FontWeight.w700, color: hasReading ? kTextPrimary : kTextFaint)),
            ],
          ),
          Divider(color: kGrid, height: 24),
          for (int i = 0; i < _fields.length; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_fields[i].icon, size: 14, color: _fields[i].color),
                    const SizedBox(width: 8),
                    Text(_fields[i].label, style: _body(size: 12.5, weight: FontWeight.w600, color: kTextMuted)),
                  ],
                ),
                Text(
                  hasReading
                      ? '${_fmtValue(_num(_fields[i].key))}${_fields[i].unit.isEmpty ? '' : ' ${_fields[i].unit}'}'
                      : '—',
                  style: _mono(size: 13, weight: FontWeight.w700, color: kTextPrimary),
                ),
              ],
            ),
            if (i != _fields.length - 1) Divider(color: kGrid, height: 20),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// MCH-001 vs MCH-002 COMPARISON CARDS
// One card per VFD metric, each rendering a DIFFERENT chart shape (bar,
// horizontal track, donut, dual-ring gauge, vertical dot-line) so the
// five metrics don't all look the same. Every chart plots exactly two
// numbers — each machine's most recent reading — not a history, so it's
// always "the last data" and updates live on each 2s poll.
// ==========================================

// Two vertical bars, one per machine, height proportional to value vs the
// larger of the two (or 1 if both are ~0, so an empty state still draws a
// flat baseline instead of one full-height bar). Used for Voltage.
class _CompareBarPainter extends CustomPainter {
  final double v1;
  final double v2;
  final Color c1;
  final Color c2;
  _CompareBarPainter({required this.v1, required this.v2, required this.c1, required this.c2});

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = math.max(v1.abs(), math.max(v2.abs(), 0.0001));
    const barWidth = 34.0;
    final gap = size.width - barWidth * 2;
    final x1 = gap / 3;
    final x2 = gap / 3 * 2 + barWidth;
    final trackTop = 6.0;
    final trackBottom = size.height - 4;
    final trackHeight = trackBottom - trackTop;

    void bar(double x, double v, Color c) {
      final h = (v.abs() / maxV) * trackHeight;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, trackBottom - h, barWidth, h),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(Rect.fromLTWH(x, trackTop, barWidth, trackHeight), topLeft: const Radius.circular(6), topRight: const Radius.circular(6)),
        Paint()..color = kGrid.withOpacity(0.4),
      );
      canvas.drawRRect(rect, Paint()..shader = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [c, c.withOpacity(0.55)]).createShader(rect.outerRect));
    }

    bar(x1, v1, c1);
    bar(x2, v2, c2);
  }

  @override
  bool shouldRepaint(covariant _CompareBarPainter old) => old.v1 != v1 || old.v2 != v2;
}

// Two stacked horizontal "tracks" (one per machine), each a thin bar from
// 0 to the shared max with a bright dot marking that machine's value —
// like a mini thermometer laid on its side. Used for Current.
class _CompareHorizontalPainter extends CustomPainter {
  final double v1;
  final double v2;
  final Color c1;
  final Color c2;
  _CompareHorizontalPainter({required this.v1, required this.v2, required this.c1, required this.c2});

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = math.max(v1.abs(), math.max(v2.abs(), 0.0001));
    final rowH = size.height / 2;

    void track(double cy, double v, Color c) {
      final trackPaint = Paint()
        ..color = kGrid
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(4, cy), Offset(size.width - 4, cy), trackPaint);
      final pct = (v.abs() / maxV).clamp(0.0, 1.0);
      final dotX = 4 + pct * (size.width - 8);
      canvas.drawLine(Offset(4, cy), Offset(dotX, cy), Paint()..color = c..strokeWidth = 6..strokeCap = StrokeCap.round);
      canvas.drawCircle(Offset(dotX, cy), 7, Paint()..color = c.withOpacity(0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      canvas.drawCircle(Offset(dotX, cy), 4.2, Paint()..color = Colors.white);
    }

    track(rowH * 0.5 + 2, v1, c1);
    track(rowH * 1.5 - 2, v2, c2);
  }

  @override
  bool shouldRepaint(covariant _CompareHorizontalPainter old) => old.v1 != v1 || old.v2 != v2;
}

// A small donut split into two slices by each machine's share of the
// combined total — same rendering approach as the dashboard's other pie
// charts, just with exactly two slices. Used for Frequency.
class _CompareDonutPainter extends CustomPainter {
  final double v1;
  final double v2;
  final Color c1;
  final Color c2;
  final double animation;
  _CompareDonutPainter({required this.v1, required this.v2, required this.c1, required this.c2, this.animation = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2;
    final total = v1.abs() + v2.abs();

    if (total <= 0.0001) {
      canvas.drawCircle(center, radius, Paint()..color = kGrid..style = PaintingStyle.stroke..strokeWidth = 12);
      return;
    }

    double start = -math.pi / 2;
    for (final entry in [MapEntry(v1, c1), MapEntry(v2, c2)]) {
      final sweep = (entry.key.abs() / total) * 2 * math.pi * animation;
      if (sweep <= 0) continue;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, true, Paint()..color = entry.value);
      start += sweep;
    }
    canvas.drawCircle(center, radius * 0.55, Paint()..color = kPanelAlt);
  }

  @override
  bool shouldRepaint(covariant _CompareDonutPainter old) => old.v1 != v1 || old.v2 != v2 || old.animation != animation;
}

// Two concentric arcs on one ring — outer arc for machine 1, inner arc for
// machine 2 — each swept proportional to its own value vs a shared max.
// Reads like a compact dual speedometer. Used for RPM.
class _CompareRadialPainter extends CustomPainter {
  final double v1;
  final double v2;
  final Color c1;
  final Color c2;
  final double animation;
  _CompareRadialPainter({required this.v1, required this.v2, required this.c1, required this.c2, this.animation = 1.0});

  static const double _start = 2.3561944901; // 135°
  static const double _sweepMax = 4.71238898; // 270°

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = math.min(size.width, size.height) / 2 - 6;
    final innerR = outerR - 12;
    final maxV = math.max(v1.abs(), math.max(v2.abs(), 0.0001));

    void ring(double r, double v, Color c) {
      final rect = Rect.fromCircle(center: center, radius: r);
      canvas.drawArc(rect, _start, _sweepMax, false, Paint()..color = kGrid..style = PaintingStyle.stroke..strokeWidth = 9..strokeCap = StrokeCap.round);
      final sweep = _sweepMax * (v.abs() / maxV).clamp(0.0, 1.0) * animation;
      if (sweep > 0) {
        canvas.drawArc(rect, _start, sweep, false, Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 9..strokeCap = StrokeCap.round);
      }
    }

    ring(outerR, v1, c1);
    ring(innerR, v2, c2);
  }

  @override
  bool shouldRepaint(covariant _CompareRadialPainter old) => old.v1 != v1 || old.v2 != v2 || old.animation != animation;
}

// A single vertical track with a dot for each machine's value (higher
// value sits higher on the track) joined by a connecting line — like the
// horizontal track rotated 90°. Used for Power.
class _CompareVerticalDotsPainter extends CustomPainter {
  final double v1;
  final double v2;
  final Color c1;
  final Color c2;
  _CompareVerticalDotsPainter({required this.v1, required this.v2, required this.c1, required this.c2});

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = math.max(v1.abs(), math.max(v2.abs(), 0.0001));
    final cx = size.width / 2;
    final top = 8.0;
    final bottom = size.height - 8;

    canvas.drawLine(Offset(cx, top), Offset(cx, bottom), Paint()..color = kGrid..strokeWidth = 5..strokeCap = StrokeCap.round);

    double yFor(double v) => bottom - (v.abs() / maxV).clamp(0.0, 1.0) * (bottom - top);
    final y1 = yFor(v1);
    final y2 = yFor(v2);

    canvas.drawLine(Offset(cx, y1), Offset(cx, y2), Paint()..color = Colors.white.withOpacity(0.25)..strokeWidth = 3);

    void dot(double y, Color c) {
      canvas.drawCircle(Offset(cx, y), 8, Paint()..color = c.withOpacity(0.32)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(Offset(cx, y), 5, Paint()..color = c);
      canvas.drawCircle(Offset(cx, y), 5, Paint()..color = Colors.white.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    }

    dot(y1, c1);
    dot(y2, c2);
  }

  @override
  bool shouldRepaint(covariant _CompareVerticalDotsPainter old) => old.v1 != v1 || old.v2 != v2;
}

// One metric's MCH-001-vs-MCH-002 comparison card: header (icon + metric
// name + unit), the metric's own chart shape in the middle, and a two-chip
// legend underneath showing each machine's exact last value. `value1`/
// `value2` are null when that machine has no reading yet at all (as
// opposed to a reading of 0), which renders as a dim "—" chip instead of
// a phantom zero bar/dot.
class _VfdCompareCard extends StatelessWidget {
  final String label;
  final String unit;
  final IconData icon;
  final _VfdCompareChartType chartType;
  final String machine1Label;
  final String machine2Label;
  final Color color1;
  final Color color2;
  final double? value1;
  final double? value2;
  const _VfdCompareCard({
    super.key,
    required this.label,
    required this.unit,
    required this.icon,
    required this.chartType,
    required this.machine1Label,
    required this.machine2Label,
    required this.color1,
    required this.color2,
    required this.value1,
    required this.value2,
  });

  String _fmt(double? v) {
    if (v == null) return '—';
    final s = v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return unit.isEmpty ? s : '$s $unit';
  }

  Widget _buildChart() {
    final v1 = value1 ?? 0.0;
    final v2 = value2 ?? 0.0;

    String label1() => '$machine1Label: ${_fmt(value1)}';
    String label2() => '$machine2Label: ${_fmt(value2)}';

    switch (chartType) {
      case _VfdCompareChartType.bar:
        return _TouchableChart(
          hitTest: (local, size) {
            const barWidth = 34.0;
            final gap = size.width - barWidth * 2;
            final x1 = gap / 3;
            final x2 = gap / 3 * 2 + barWidth;
            if (local.dx >= x1 && local.dx <= x1 + barWidth) return label1();
            if (local.dx >= x2 && local.dx <= x2 + barWidth) return label2();
            return null;
          },
          child: CustomPaint(painter: _CompareBarPainter(v1: v1, v2: v2, c1: color1, c2: color2), size: Size.infinite),
        );
      case _VfdCompareChartType.horizontal:
        return _TouchableChart(
          hitTest: (local, size) {
            final rowH = size.height / 2;
            return local.dy < rowH ? label1() : label2();
          },
          child: CustomPaint(painter: _CompareHorizontalPainter(v1: v1, v2: v2, c1: color1, c2: color2), size: Size.infinite),
        );
      case _VfdCompareChartType.pie:
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) => _TouchableChart(
            hitTest: (local, size) {
              final center = Offset(size.width / 2, size.height / 2);
              final r = math.min(size.width, size.height) / 2 - 2;
              final lbl = _donutSliceLabel(
                local: local,
                center: center,
                radiusX: r,
                radiusY: r,
                labels: [machine1Label, machine2Label],
                values: [v1.abs(), v2.abs()],
                holeFraction: 0.55,
              );
              if (lbl == null) return null;
              return lbl == machine1Label ? label1() : label2();
            },
            child: CustomPaint(painter: _CompareDonutPainter(v1: v1, v2: v2, c1: color1, c2: color2, animation: t), size: Size.infinite),
          ),
        );
      case _VfdCompareChartType.radial:
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) => _TouchableChart(
            hitTest: (local, size) {
              final center = Offset(size.width / 2, size.height / 2);
              final outerR = math.min(size.width, size.height) / 2 - 6;
              final innerR = outerR - 12;
              final dist = (local - center).distance;
              if (dist < innerR - 16 || dist > outerR + 16) return null;
              return (dist - outerR).abs() <= (dist - innerR).abs() ? label1() : label2();
            },
            child: CustomPaint(painter: _CompareRadialPainter(v1: v1, v2: v2, c1: color1, c2: color2, animation: t), size: Size.infinite),
          ),
        );
      case _VfdCompareChartType.verticalDots:
        return _TouchableChart(
          hitTest: (local, size) {
            final maxV = math.max(v1.abs(), math.max(v2.abs(), 0.0001));
            const top = 8.0;
            final bottom = size.height - 8;
            double yFor(double v) => bottom - (v.abs() / maxV).clamp(0.0, 1.0) * (bottom - top);
            final y1 = yFor(v1);
            final y2 = yFor(v2);
            return (local.dy - y1).abs() <= (local.dy - y2).abs() ? label1() : label2();
          },
          child: CustomPaint(painter: _CompareVerticalDotsPainter(v1: v1, v2: v2, c1: color1, c2: color2), size: Size.infinite),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAny = value1 != null || value2 != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanelAlt, kPanel]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGrid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: kTextMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: _body(size: 10.5, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit.isNotEmpty) Text(unit, style: _body(size: 10.5, weight: FontWeight.w600, color: kTextFaint)),
            ],
          ),
          const SizedBox(height: 12),
          if (!hasAny)
            SizedBox(
              height: 110,
              child: Center(
                child: Text('No VFD data yet', style: _body(size: 12, color: kTextFaint)),
              ),
            )
          else
            SizedBox(height: 110, width: double.infinity, child: _buildChart()),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color1)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(machine1Label, style: _body(size: 10.5, weight: FontWeight.w600, color: kTextMuted), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Text(_fmt(value1), style: _mono(size: 11.5, weight: FontWeight.w800, color: kTextPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color2)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(machine2Label, style: _body(size: 10.5, weight: FontWeight.w600, color: kTextMuted), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Text(_fmt(value2), style: _mono(size: 11.5, weight: FontWeight.w800, color: kTextPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

// One "From Date" / "To Date" field for the Session Log range filter —
// tapping it opens the date picker (wired up by the caller); shows the
// picked date once set, or a muted placeholder before that.
class _RangeDateButton extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;
  const _RangeDateButton({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: kPanelAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kGrid),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 14, color: kTextFaint),
                const SizedBox(width: 6),
                Text(label, style: _body(size: 10.5, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 0.6)),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value ?? 'Select date',
              style: _mono(size: 14, weight: FontWeight.w700, color: value == null ? kTextFaint : kTextPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeResultsTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  final List<_VfdMetricDef> columns;
  final double Function(Map<String, dynamic> row, String key) rowNum;
  final DateTime? Function(Map<String, dynamic> row) rowTime;
  final double Function(String key) columnTotal;
  final double? Function(String key) fiveMinDelta;
  final double? Function(String key) fifteenMinDelta;
  const _RangeResultsTable({
    required this.rows,
    required this.columns,
    required this.rowNum,
    required this.rowTime,
    required this.columnTotal,
    required this.fiveMinDelta,
    required this.fifteenMinDelta,
  });

  String _fmtTime(DateTime? t) {
    if (t == null) return '—';
    final l = t.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(l.hour)}:${two(l.minute)}:${two(l.second)}';
  }

  String _fmtNum(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  String _fmtDelta(double? v) {
    if (v == null) return '—';
    final s = v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return v > 0 ? '+$s' : s;
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = _body(size: 10.5, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 0.6);
    final cellStyle = _mono(size: 12, weight: FontWeight.w600, color: kTextPrimary);
    final totalStyle = _mono(size: 12, weight: FontWeight.w800, color: kAccent);

    // Cap the number of raw reading rows shown so a wide date range
    // doesn't try to render thousands of DataRows at once — the totals
    // and deltas below are still computed from the FULL result set, this
    // only limits how many individual rows are listed.
    const maxRows = 60;
    final displayRows = rows.length > maxRows ? rows.sublist(rows.length - maxRows) : rows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rows.length > maxRows)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Showing the most recent $maxRows of ${rows.length} readings — totals & deltas use all of them.', style: _body(size: 11, color: kTextFaint)),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(kPanelAlt),
            dataRowColor: MaterialStateProperty.all(kPanel),
            dividerThickness: 0.6,
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: [
              DataColumn(label: Text('TIME', style: headerStyle)),
              for (final c in columns) DataColumn(label: Text(c.label.toUpperCase(), style: headerStyle), numeric: true),
            ],
            rows: [
              for (final row in displayRows)
                DataRow(cells: [
                  DataCell(Text(_fmtTime(rowTime(row)), style: cellStyle)),
                  for (final c in columns) DataCell(Text(_fmtNum(rowNum(row, c.key)), style: cellStyle)),
                ]),
              DataRow(
                color: MaterialStateProperty.all(kAccent.withOpacity(0.08)),
                cells: [
                  DataCell(Text('TOTAL', style: totalStyle)),
                  for (final c in columns) DataCell(Text(_fmtNum(columnTotal(c.key)), style: totalStyle)),
                ],
              ),
              DataRow(
                color: MaterialStateProperty.all(kAmber.withOpacity(0.08)),
                cells: [
                  DataCell(Text('Δ 5 MIN', style: totalStyle.copyWith(color: kAmber))),
                  for (final c in columns) DataCell(Text(_fmtDelta(fiveMinDelta(c.key)), style: totalStyle.copyWith(color: kAmber))),
                ],
              ),
              DataRow(
                color: MaterialStateProperty.all(kViolet.withOpacity(0.08)),
                cells: [
                  DataCell(Text('Δ 15 MIN', style: totalStyle.copyWith(color: kViolet))),
                  for (final c in columns) DataCell(Text(_fmtDelta(fifteenMinDelta(c.key)), style: totalStyle.copyWith(color: kViolet))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// MACHINE HEALTH ANALYSIS — supporting types & widgets
// ==========================================

// One of the 4 physical test points a session's readings are checked
// against: TM1/TM2 × Drive End/Non-Drive End.
class _TestPointDef {
  final String key;
  final String shortLabel;
  final String fullLabel;
  const _TestPointDef({required this.key, required this.shortLabel, required this.fullLabel});
}

enum _HealthStatus { stable, unstable, incomplete }

// Result of one 5-min-or-15-min check for one test point in one session:
// the summed |last-first| bucket delta, and the stable/unstable/incomplete
// verdict it produced against that window's threshold.
class _CheckResult {
  final double? sum;
  final _HealthStatus status;
  const _CheckResult({required this.sum, required this.status});
}

// One session's full health breakdown: the session doc itself (motor
// type, machine id, test id, operation, start/stop) plus a 5-min and
// 15-min _CheckResult for each of the 4 test points, keyed
// "<testPointKey>_5" / "<testPointKey>_15".
class _SessionHealth {
  final Map<String, dynamic> session;
  final Map<String, _CheckResult> checks;
  const _SessionHealth({required this.session, required this.checks});
}

Color _healthColor(_HealthStatus status) {
  switch (status) {
    case _HealthStatus.stable:
      return kAccent;
    case _HealthStatus.unstable:
      return kEmber;
    case _HealthStatus.incomplete:
      return kAmber;
  }
}

// Small colored-dot + label legend chip, e.g. "● Stable".
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(label, style: _body(size: 11.5, weight: FontWeight.w600, color: kTextMuted)),
      ],
    );
  }
}

// One horizontal stacked bar: a fixed-width label on the left, then a
// track on the right filled with stable(green)/unstable(red)/incomplete
// (amber) segments sized by their share of `maxTotal` (the largest total
// among all test points, so every bar shares the same scale).
class _HealthBarRow extends StatelessWidget {
  final String label;
  final Map<_HealthStatus, int> counts;
  final int maxTotal;
  const _HealthBarRow({required this.label, required this.counts, required this.maxTotal});

  @override
  Widget build(BuildContext context) {
    final stable = counts[_HealthStatus.stable] ?? 0;
    final unstable = counts[_HealthStatus.unstable] ?? 0;
    final incomplete = counts[_HealthStatus.incomplete] ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 116,
          child: Text(label, style: _body(size: 11.5, weight: FontWeight.w600, color: kTextMuted), overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final unit = maxTotal <= 0 ? 0.0 : w / maxTotal;
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 20,
                  child: Stack(
                    children: [
                      Container(color: kGrid.withOpacity(0.35)),
                      Row(
                        children: [
                          Container(width: unit * stable, color: kAccent),
                          Container(width: unit * unstable, color: kEmber),
                          Container(width: unit * incomplete, color: kAmber),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// The "STABLE / UNSTABLE / INCOMPLETE" summary card: legend, a "N CHECKS"
// pill (sessions × test points × 2 windows), and one stacked bar per test
// point aggregating both its 5-min and 15-min check results across every
// session currently in view.
class _HealthSummaryCard extends StatelessWidget {
  final Map<String, Map<_HealthStatus, int>> counts;
  final List<_TestPointDef> testPoints;
  final int totalChecks;
  const _HealthSummaryCard({required this.counts, required this.testPoints, required this.totalChecks});

  @override
  Widget build(BuildContext context) {
    final maxTotal = testPoints.fold<int>(1, (m, tp) {
      final c = counts[tp.key]!;
      final total = (c[_HealthStatus.stable] ?? 0) + (c[_HealthStatus.unstable] ?? 0) + (c[_HealthStatus.incomplete] ?? 0);
      return math.max(m, total);
    });

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(20), border: Border.all(color: kGrid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 13, decoration: BoxDecoration(color: kCyan, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Expanded(child: Text('STABLE / UNSTABLE / INCOMPLETE', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.0))),
              _StatusPill(label: '$totalChecks CHECKS', color: kCyan),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Text('Breakdown across drive-end and non-drive-end test points for both motors', style: _body(size: 10.5, color: kTextFaint)),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: const [
              _LegendDot(color: kAccent, label: 'Stable'),
              _LegendDot(color: kEmber, label: 'Unstable'),
              _LegendDot(color: kAmber, label: 'Incomplete'),
            ],
          ),
          const SizedBox(height: 18),
          for (final tp in testPoints) ...[
            _HealthBarRow(label: tp.fullLabel, counts: counts[tp.key]!, maxTotal: maxTotal),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// Fixed-width header cell used by _MachineHealthTable.
class _HealthHeaderCell extends StatelessWidget {
  final String label;
  final double width;
  const _HealthHeaderCell(this.label, this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, bottom: 8),
        child: Text(label, style: _body(size: 10, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 0.6)),
      ),
    );
  }
}

// Fixed-width data cell used by _MachineHealthTable.
class _HealthDataCell extends StatelessWidget {
  final Widget child;
  final double width;
  const _HealthDataCell(this.child, this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(padding: const EdgeInsets.only(right: 12, top: 2, bottom: 2), child: child),
    );
  }
}

// Small pill used for Machine ID / Test ID values, matching the tag style
// used elsewhere in the app for short identifiers.
class _HealthTagChip extends StatelessWidget {
  final String label;
  const _HealthTagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: kAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: kAccent.withOpacity(0.3))),
      child: Text(label, style: _mono(size: 11, weight: FontWeight.w700, color: kAccent)),
    );
  }
}

// One 5-MIN or 15-MIN check tile inside a test-point cell: a status badge
// ("MOTOR DECLARED STABLE/UNSTABLE" or "INCOMPLETE"), the summed delta
// ("SUM"), and a threshold pill showing which side of the 0.5/1 line that
// sum landed on.
class _HealthCheckTile extends StatelessWidget {
  final String windowLabel;
  final _CheckResult result;
  final double threshold;
  const _HealthCheckTile({required this.windowLabel, required this.result, required this.threshold});

  String _fmtNum(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
  String _fmtThreshold(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final color = _healthColor(result.status);
    String statusText;
    IconData icon;
    String thresholdText;
    if (result.status == _HealthStatus.unstable) {
      statusText = 'MOTOR DECLARED UNSTABLE';
      icon = Icons.close_rounded;
      thresholdText = '\u2265${_fmtThreshold(threshold)}';
    } else if (result.status == _HealthStatus.stable) {
      statusText = 'MOTOR DECLARED STABLE';
      icon = Icons.check_rounded;
      thresholdText = '<${_fmtThreshold(threshold)}';
    } else {
      statusText = 'INCOMPLETE DATA';
      icon = Icons.hourglass_empty_rounded;
      thresholdText = '—';
    }

    return Container(
      width: 178,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGrid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(windowLabel, style: _body(size: 9.5, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 0.4)),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.4))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 10, color: color),
                      const SizedBox(width: 3),
                      Flexible(child: Text(statusText, style: _body(size: 8, weight: FontWeight.w800, color: color), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SUM', style: _body(size: 9.5, weight: FontWeight.w700, color: kTextFaint)),
              Text(result.sum == null ? '—' : _fmtNum(result.sum!), style: _mono(size: 12.5, weight: FontWeight.w800, color: kTextPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(thresholdText, style: _mono(size: 10, weight: FontWeight.w800, color: color)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// The Machine Health Analysis table itself: one row per session (Motor,
// Machine ID, Test ID, Operation, ON Time, OFF Time), then one cell per
// test point holding that session's 5-MIN and 15-MIN check tiles stacked
// vertically. Wrapped in a single horizontal scroller so header and body
// stay aligned as one block.
class _MachineHealthTable extends StatelessWidget {
  final List<_SessionHealth> healths;
  final List<_TestPointDef> testPoints;
  const _MachineHealthTable({required this.healths, required this.testPoints});

  String _fmtDt(String? iso) {
    if (iso == null) return '—';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '—';
    final l = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(l.day)}/${two(l.month)}/${l.year} ${two(l.hour)}:${two(l.minute)}:${two(l.second)}';
  }

  @override
  Widget build(BuildContext context) {
    if (healths.isEmpty) {
      return Row(
        children: [
          Icon(Icons.inbox_rounded, color: kTextFaint, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text('No sessions on this page.', style: _body(size: 12.5))),
        ],
      );
    }

    final cellStyle = _mono(size: 12, weight: FontWeight.w600, color: kTextPrimary);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HealthHeaderCell('MOTOR', 84),
              _HealthHeaderCell('MACHINE ID', 96),
              _HealthHeaderCell('TEST ID', 96),
              _HealthHeaderCell('OPERATION', 84),
              _HealthHeaderCell('ON TIME', 150),
              _HealthHeaderCell('OFF TIME', 150),
              for (final tp in testPoints) _HealthHeaderCell(tp.shortLabel, 190),
            ],
          ),
          Divider(color: kGrid, height: 18),
          for (int i = 0; i < healths.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HealthDataCell(Text(healths[i].session['motor_type']?.toString() ?? '—', style: cellStyle), 84),
                _HealthDataCell(_HealthTagChip(healths[i].session['machine_id']?.toString() ?? '—'), 96),
                _HealthDataCell(_HealthTagChip(healths[i].session['test_id']?.toString() ?? '—'), 96),
                _HealthDataCell(Text(healths[i].session['operation_name']?.toString() ?? '—', style: cellStyle), 84),
                _HealthDataCell(Text(_fmtDt(healths[i].session['start_time']?.toString()), style: cellStyle.copyWith(fontSize: 11)), 150),
                _HealthDataCell(Text(_fmtDt(healths[i].session['stop_time']?.toString()), style: cellStyle.copyWith(fontSize: 11)), 150),
                for (final tp in testPoints)
                  _HealthDataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HealthCheckTile(windowLabel: '5 MIN', result: healths[i].checks['${tp.key}_5']!, threshold: 0.5),
                        const SizedBox(height: 8),
                        _HealthCheckTile(windowLabel: '15 MIN', result: healths[i].checks['${tp.key}_15']!, threshold: 1.0),
                      ],
                    ),
                    190,
                  ),
              ],
            ),
            if (i != healths.length - 1) Divider(color: kGrid, height: 22),
          ],
        ],
      ),
    );
  }
}

// A single prev/next/first/last icon button that dims and disables itself
// when there's nowhere to go.
class _HealthPageIconButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _HealthPageIconButton({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20, color: enabled ? kTextMuted : kTextFaint),
      onPressed: enabled ? onTap : null,
    );
  }
}

// "Showing X - Y of N records", a rows-per-page dropdown, and
// first/prev/[page]/next/last controls for the Machine Health table.
class _HealthPaginationBar extends StatelessWidget {
  final int total;
  final int pageStart;
  final int pageEnd;
  final int rowsPerPage;
  final int page;
  final int totalPages;
  final ValueChanged<int> onRowsPerPageChanged;
  final ValueChanged<int> onPageChanged;
  const _HealthPaginationBar({
    required this.total,
    required this.pageStart,
    required this.pageEnd,
    required this.rowsPerPage,
    required this.page,
    required this.totalPages,
    required this.onRowsPerPageChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          total == 0 ? 'No records' : 'Showing ${pageStart + 1} - $pageEnd of $total records',
          style: _body(size: 12, color: kTextMuted),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Rows per page:', style: _body(size: 11.5, color: kTextMuted)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: kPanelAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: kAmber.withOpacity(0.5))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: rowsPerPage,
                  dropdownColor: kPanelAlt,
                  style: _mono(size: 12.5, weight: FontWeight.w700, color: kTextPrimary),
                  icon: Icon(Icons.expand_more_rounded, color: kTextMuted, size: 18),
                  items: const [5, 10, 20, 50].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                  onChanged: (v) {
                    if (v != null) onRowsPerPageChanged(v);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _HealthPageIconButton(icon: Icons.first_page_rounded, enabled: page > 0, onTap: () => onPageChanged(0)),
            _HealthPageIconButton(icon: Icons.chevron_left_rounded, enabled: page > 0, onTap: () => onPageChanged(page - 1)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(10)),
              child: Text('${page + 1}', style: _mono(size: 12.5, weight: FontWeight.w800, color: kBgDeep)),
            ),
            _HealthPageIconButton(icon: Icons.chevron_right_rounded, enabled: page < totalPages - 1, onTap: () => onPageChanged(page + 1)),
            _HealthPageIconButton(icon: Icons.last_page_rounded, enabled: page < totalPages - 1, onTap: () => onPageChanged(totalPages - 1)),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// SESSION LOG · STABILITY PIE + READINGS-PER-TEST
// ==========================================

// Donut painter for the 3-way stable/unstable/incomplete split — same
// "slices sized by share of total, punched-out center" approach as the
// dashboard's other pie charts, generalized to N (color, value) slices.
class _StabilityPiePainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double animation;
  _StabilityPiePainter({required this.values, required this.colors, this.animation = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2;
    final total = values.fold<double>(0, (a, b) => a + b);

    if (total <= 0) {
      canvas.drawCircle(center, radius, Paint()..color = kGrid..style = PaintingStyle.stroke..strokeWidth = 14);
      return;
    }

    double start = -math.pi / 2;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi * animation;
      if (sweep <= 0) continue;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, true, Paint()..color = colors[i]);
      start += sweep;
    }
    canvas.drawCircle(center, radius * 0.56, Paint()..color = kPanel);
    canvas.drawCircle(center, radius * 0.56, Paint()..color = kGrid..style = PaintingStyle.stroke..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant _StabilityPiePainter old) =>
      old.values != values || old.colors != colors || old.animation != animation;
}

// "STABILITY" card for the Session Log filter: a donut of every check's
// stable/unstable/incomplete verdict (across every session, test point,
// and window currently in view), a centered total-checks count, and a
// colored legend with the exact count + percentage for each slice.
class _StabilityPieCard extends StatelessWidget {
  final Map<_HealthStatus, int> counts;
  const _StabilityPieCard({required this.counts});

  @override
  Widget build(BuildContext context) {
    final stable = counts[_HealthStatus.stable] ?? 0;
    final unstable = counts[_HealthStatus.unstable] ?? 0;
    final incomplete = counts[_HealthStatus.incomplete] ?? 0;
    final total = stable + unstable + incomplete;

    final slices = [
      MapEntry('Stable', MapEntry(stable, kAccent)),
      MapEntry('Unstable', MapEntry(unstable, kEmber)),
      MapEntry('Incomplete', MapEntry(incomplete, kAmber)),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanelAlt, kPanel]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kCyan.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 13, decoration: BoxDecoration(color: kCyan, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Expanded(child: Text('STABILITY · PIE CHART', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.0))),
              _StatusPill(label: '$total CHECKS', color: kCyan),
            ],
          ),
          const SizedBox(height: 18),
          if (total == 0)
            Row(
              children: [
                Icon(Icons.pie_chart_outline_rounded, color: kTextFaint, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('No checks to summarize yet.', style: _body(size: 12.5))),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, animValue, _) => SizedBox(
                    width: 128,
                    height: 128,
                    child: _TouchableChart(
                      hitTest: (local, size) {
                        final center = Offset(size.width / 2, size.height / 2);
                        final r = math.min(size.width, size.height) / 2 - 2;
                        final lbl = _donutSliceLabel(
                          local: local,
                          center: center,
                          radiusX: r,
                          radiusY: r,
                          labels: const ['Stable', 'Unstable', 'Incomplete'],
                          values: [stable.toDouble(), unstable.toDouble(), incomplete.toDouble()],
                          holeFraction: 0.56,
                        );
                        if (lbl == null) return null;
                        final count = {'Stable': stable, 'Unstable': unstable, 'Incomplete': incomplete}[lbl] ?? 0;
                        return '$lbl: $count';
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(128, 128),
                            painter: _StabilityPiePainter(
                              values: [stable.toDouble(), unstable.toDouble(), incomplete.toDouble()],
                              colors: const [kAccent, kEmber, kAmber],
                              animation: animValue,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$total', style: _mono(size: 18, weight: FontWeight.w800, color: kTextPrimary)),
                              Text('CHECKS', style: _body(size: 8.5, weight: FontWeight.w700, color: kTextFaint).copyWith(letterSpacing: 1.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final slice in slices)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: slice.value.value,
                                  boxShadow: [BoxShadow(color: slice.value.value.withOpacity(0.6), blurRadius: 5)],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(slice.key, style: _body(size: 12, weight: FontWeight.w600, color: kTextPrimary))),
                              Text('${slice.value.key}', style: _mono(size: 12.5, weight: FontWeight.w800, color: kTextPrimary)),
                              const SizedBox(width: 6),
                              Text(
                                total > 0 ? '(${((slice.value.key / total) * 100).toStringAsFixed(0)}%)' : '(0%)',
                                style: _body(size: 10.5, weight: FontWeight.w600, color: slice.value.value),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Line-chart painter for the Stability Trend — plots the number of
// unstable checks per session (0..8, since there are 4 test points × 2
// windows per session) across the filtered date range, with a real Y
// axis (0 / half / max tick labels + gridlines) and an X axis (first and
// last session labels, plus in-between ones when there's room). Values
// are `int` since "how many checks were unstable" is always a whole
// number.
class _StabilityTrendPainter extends CustomPainter {
  final List<int> values;
  final List<String> xLabels;
  final int maxValue;
  final Color color;
  static const double leftMargin = 26;
  static const double bottomMargin = 20;
  static const double topMargin = 8;
  static const double rightMargin = 10;

  _StabilityTrendPainter({
    required this.values,
    required this.xLabels,
    required this.maxValue,
    this.color = kEmber,
  });

  List<Offset> _points(Size size) {
    final plotW = size.width - leftMargin - rightMargin;
    final plotH = size.height - topMargin - bottomMargin;
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1 ? leftMargin + plotW / 2 : leftMargin + plotW * (i / (values.length - 1));
      final frac = maxValue <= 0 ? 0.0 : (values[i] / maxValue).clamp(0.0, 1.0);
      final y = topMargin + plotH * (1 - frac);
      points.add(Offset(x, y));
    }
    return points;
  }

  void _drawAxisText(Canvas canvas, String text, Offset topLeft, {double maxWidth = 48}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: kTextFaint, fontSize: 9)),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    tp.paint(canvas, topLeft);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final plotW = size.width - leftMargin - rightMargin;
    final plotH = size.height - topMargin - bottomMargin;
    if (plotW <= 0 || plotH <= 0) return;

    // Y axis: gridlines + 0 / half / max tick labels.
    final gridPaint = Paint()
      ..color = kGrid
      ..strokeWidth = 1;
    for (int i = 0; i <= 2; i++) {
      final frac = i / 2;
      final y = topMargin + plotH * (1 - frac);
      canvas.drawLine(Offset(leftMargin, y), Offset(size.width - rightMargin, y), gridPaint);
      final labelVal = (maxValue * frac).round();
      _drawAxisText(canvas, '$labelVal', Offset(0, y - 6), maxWidth: leftMargin - 4);
    }
    // Y axis vertical rule.
    canvas.drawLine(Offset(leftMargin, topMargin), Offset(leftMargin, size.height - bottomMargin), gridPaint);

    if (values.isEmpty) return;
    final points = _points(size);

    // X axis: always label the first and last session; label any others
    // only if there's realistically room so text doesn't overlap.
    final canFitEvery = points.length <= 1 || (plotW / points.length) >= 34;
    for (int i = 0; i < points.length; i++) {
      final isEdge = i == 0 || i == points.length - 1;
      if (!isEdge && !canFitEvery) continue;
      final label = i < xLabels.length ? xLabels[i] : '';
      if (label.isEmpty) continue;
      double x = points[i].dx - 18;
      x = x.clamp(0.0, math.max(0.0, size.width - 40));
      _drawAxisText(canvas, label, Offset(x, size.height - bottomMargin + 4), maxWidth: 40);
    }

    // Filled area under the line for readability.
    final fillPath = Path()..moveTo(points.first.dx, size.height - bottomMargin);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height - bottomMargin);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.28), color.withOpacity(0.02)],
        ).createShader(Rect.fromLTWH(leftMargin, topMargin, plotW, plotH)),
    );

    // The line itself.
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // A dot at every session's point.
    for (final p in points) {
      canvas.drawCircle(p, 3.6, Paint()..color = kBgDeep);
      canvas.drawCircle(p, 3.6, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.6);
    }
  }

  @override
  bool shouldRepaint(covariant _StabilityTrendPainter old) =>
      old.values != values || old.xLabels != xLabels || old.maxValue != maxValue || old.color != color;
}

// "STABILITY TREND" card: number of unstable checks per session (out of
// 4 test points × 2 windows = 8 max), plotted as a line across every
// session currently in the Session Log's date range, with a real Y axis
// (0/half/max) and X axis (session Test IDs). Touching/dragging over the
// line shows which session + how many unstable checks it had, same
// touch-to-reveal behavior as every other chart in the app.
class _StabilityTrendCard extends StatelessWidget {
  final List<_SessionHealth> healths;
  const _StabilityTrendCard({required this.healths});

  @override
  Widget build(BuildContext context) {
    final values = healths.map((h) => h.checks.values.where((c) => c.status == _HealthStatus.unstable).length).toList();
    final xLabels = healths.map((h) => h.session['test_id']?.toString() ?? '').toList();
    const maxValue = 8; // 4 test points × 2 windows per session

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanelAlt, kPanel]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kEmber.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 13, decoration: BoxDecoration(color: kEmber, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Expanded(child: Text('STABILITY TREND · UNSTABLE CHECKS PER SESSION', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.0))),
              _StatusPill(label: '${healths.length} SESSIONS', color: kEmber),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Text('Touch or drag over the line to see a session\'s exact count', style: _body(size: 10.5, color: kTextFaint)),
          ),
          const SizedBox(height: 16),
          if (values.isEmpty)
            Row(
              children: [
                Icon(Icons.show_chart_rounded, color: kTextFaint, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('No sessions to plot yet.', style: _body(size: 12.5))),
              ],
            )
          else
            SizedBox(
              height: 160,
              width: double.infinity,
              child: _TouchableChart(
                hitTest: (local, size) {
                  final painter = _StabilityTrendPainter(values: values, xLabels: xLabels, maxValue: maxValue);
                  final points = painter._points(size);
                  if (points.isEmpty) return null;
                  int nearest = 0;
                  double bestDist = double.infinity;
                  for (int i = 0; i < points.length; i++) {
                    final d = (points[i].dx - local.dx).abs();
                    if (d < bestDist) {
                      bestDist = d;
                      nearest = i;
                    }
                  }
                  final label = xLabels[nearest].isEmpty ? 'Session ${nearest + 1}' : xLabels[nearest];
                  return '$label: ${values[nearest]} unstable';
                },
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _StabilityTrendPainter(values: values, xLabels: xLabels, maxValue: maxValue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// "READINGS PER TEST" card: one row per session in the filtered date
// range — Test ID / Machine ID / Motor, and the total count of
// machine_sensor_data readings that fell between that session's Start
// (status 1) and Stop (status 0).
class _ReadingsPerTestCard extends StatelessWidget {
  final List<Map<String, dynamic>> sessions;
  final int Function(Map<String, dynamic> session) countFn;
  const _ReadingsPerTestCard({required this.sessions, required this.countFn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kPanel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGrid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 13, decoration: BoxDecoration(color: kViolet, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Expanded(child: Text('READINGS PER TEST · STATUS 1 → 0', style: _body(size: 11, weight: FontWeight.w700, color: kTextMuted).copyWith(letterSpacing: 1.0))),
              _StatusPill(label: '${sessions.length} TESTS', color: kViolet),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Text('Total machine_sensor_data readings recorded between each Start and Stop', style: _body(size: 10.5, color: kTextFaint)),
          ),
          const SizedBox(height: 14),
          if (sessions.isEmpty)
            Row(
              children: [
                Icon(Icons.inbox_rounded, color: kTextFaint, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('No sessions in this date range.', style: _body(size: 12.5))),
              ],
            )
          else
            for (int i = 0; i < sessions.length; i++) ...[
              Row(
                children: [
                  Icon(Icons.precision_manufacturing_rounded, size: 14, color: kTextFaint),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${sessions[i]['motor_type'] ?? '—'}',
                      style: _body(size: 12, weight: FontWeight.w600, color: kTextMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _HealthTagChip(sessions[i]['test_id']?.toString() ?? '—'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: kViolet.withOpacity(0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: kViolet.withOpacity(0.35))),
                    child: Text('${countFn(sessions[i])} readings', style: _mono(size: 11.5, weight: FontWeight.w800, color: kViolet)),
                  ),
                ],
              ),
              if (i != sessions.length - 1) Divider(color: kGrid, height: 20),
            ],
        ],
      ),
    );
  }
}