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

// // // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // // //   String motorType,
// // // // // // // // // // // //   String machineId,
// // // // // // // // // // // //   String testId,
// // // // // // // // // // // //   String operationName,
// // // // // // // // // // // // ) async {
// // // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // // //     Sql.named(
// // // // // // // // // // // //       '''
// // // // // // // // // // // //       INSERT INTO machine_data
// // // // // // // // // // // //       (
// // // // // // // // // // // //         motor_type,
// // // // // // // // // // // //         machine_id,
// // // // // // // // // // // //         test_id,
// // // // // // // // // // // //         operation_name
// // // // // // // // // // // //       )
// // // // // // // // // // // //       VALUES
// // // // // // // // // // // //       (
// // // // // // // // // // // //         @motor_type,
// // // // // // // // // // // //         @machine_id,
// // // // // // // // // // // //         @test_id,
// // // // // // // // // // // //         @operation_name
// // // // // // // // // // // //       )
// // // // // // // // // // // //       RETURNING *
// // // // // // // // // // // //       '''
// // // // // // // // // // // //     ),
// // // // // // // // // // // //     parameters: {
// // // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // // //       "operation_name": operationName,
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
// // // // // // // // // // // //       final body =
// // // // // // // // // // // //           jsonDecode(await request.readAsString());

// // // // // // // // // // // //       String username =
// // // // // // // // // // // //           body['username']?.toString() ?? '';

// // // // // // // // // // // //       String password =
// // // // // // // // // // // //           body['password']?.toString() ?? '';

// // // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // // //         return Response(
// // // // // // // // // // // //           400,
// // // // // // // // // // // //           body: jsonEncode({
// // // // // // // // // // // //             "message":
// // // // // // // // // // // //                 "Username and Password required"
// // // // // // // // // // // //           }),
// // // // // // // // // // // //           headers: {
// // // // // // // // // // // //             "Content-Type": "application/json"
// // // // // // // // // // // //           },
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       final result =
// // // // // // // // // // // //           await loginUser(username, password);

// // // // // // // // // // // //       if (result["success"]) {
// // // // // // // // // // // //         return Response.ok(
// // // // // // // // // // // //           jsonEncode(result),
// // // // // // // // // // // //           headers: {
// // // // // // // // // // // //             "Content-Type": "application/json"
// // // // // // // // // // // //           },
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       return Response(
// // // // // // // // // // // //         401,
// // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // //         headers: {
// // // // // // // // // // // //           "Content-Type": "application/json"
// // // // // // // // // // // //         },
// // // // // // // // // // // //       );
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // //         body: jsonEncode({
// // // // // // // // // // // //           "message": e.toString()
// // // // // // // // // // // //         }),
// // // // // // // // // // // //       );
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });

// // // // // // // // // // // //   router.post('/add-machine-data',
// // // // // // // // // // // //       (Request request) async {
// // // // // // // // // // // //     try {
// // // // // // // // // // // //       final body =
// // // // // // // // // // // //           jsonDecode(await request.readAsString());

// // // // // // // // // // // //       String motorType =
// // // // // // // // // // // //           body['motor_type']?.toString() ?? '';

// // // // // // // // // // // //       String machineId =
// // // // // // // // // // // //           body['machine_id']?.toString() ?? '';

// // // // // // // // // // // //       String testId =
// // // // // // // // // // // //           body['test_id']?.toString() ?? '';

// // // // // // // // // // // //       String operationName =
// // // // // // // // // // // //           body['operation_name']?.toString() ?? '';

// // // // // // // // // // // //       if (motorType.isEmpty ||
// // // // // // // // // // // //           machineId.isEmpty ||
// // // // // // // // // // // //           testId.isEmpty ||
// // // // // // // // // // // //           operationName.isEmpty) {
// // // // // // // // // // // //         return Response(
// // // // // // // // // // // //           400,
// // // // // // // // // // // //           body: jsonEncode({
// // // // // // // // // // // //             "message":
// // // // // // // // // // // //                 "All fields are required"
// // // // // // // // // // // //           }),
// // // // // // // // // // // //           headers: {
// // // // // // // // // // // //             "Content-Type": "application/json"
// // // // // // // // // // // //           },
// // // // // // // // // // // //         );
// // // // // // // // // // // //       }

// // // // // // // // // // // //       final result = await insertMachineData(
// // // // // // // // // // // //         motorType,
// // // // // // // // // // // //         machineId,
// // // // // // // // // // // //         testId,
// // // // // // // // // // // //         operationName,
// // // // // // // // // // // //       );

// // // // // // // // // // // //       return Response(
// // // // // // // // // // // //         201,
// // // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // // //         headers: {
// // // // // // // // // // // //           "Content-Type": "application/json"
// // // // // // // // // // // //         },
// // // // // // // // // // // //       );
// // // // // // // // // // // //     } catch (e) {
// // // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // // //         body: jsonEncode({
// // // // // // // // // // // //           "message": e.toString()
// // // // // // // // // // // //         }),
// // // // // // // // // // // //       );
// // // // // // // // // // // //     }
// // // // // // // // // // // //   });

// // // // // // // // // // // //   final handler = Pipeline()
// // // // // // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // // // // // //       .addMiddleware(logRequests())
// // // // // // // // // // // //       .addHandler(router.call);

// // // // // // // // // // // //   await io.serve(
// // // // // // // // // // // //     handler,
// // // // // // // // // // // //     '0.0.0.0',
// // // // // // // // // // // //     3000,
// // // // // // // // // // // //   );

// // // // // // // // // // // //   print(
// // // // // // // // // // // //     "Server running on http://localhost:3000",
// // // // // // // // // // // //   );
// // // // // // // // // // // // }




// // // // // // // // // // // import 'dart:convert';

// // // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // // // // // // // // // // late Connection conn;

// // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // //   conn = await Connection.open(
// // // // // // // // // // //     Endpoint(
// // // // // // // // // // //       host: 'localhost',
// // // // // // // // // // //       port: 5432,
// // // // // // // // // // //       database: 'Input_Logs',
// // // // // // // // // // //       username: 'postgres',
// // // // // // // // // // //       password: 'postgres123',
// // // // // // // // // // //     ),
// // // // // // // // // // //     settings: ConnectionSettings(
// // // // // // // // // // //       sslMode: SslMode.disable,
// // // // // // // // // // //     ),
// // // // // // // // // // //   );

// // // // // // // // // // //   print("Connected to PostgreSQL");
// // // // // // // // // // // }

// // // // // // // // // // // Future<Map<String, dynamic>> loginUser(
// // // // // // // // // // //   String username,
// // // // // // // // // // //   String password,
// // // // // // // // // // // ) async {
// // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // //     Sql.named(
// // // // // // // // // // //       '''
// // // // // // // // // // //       SELECT *
// // // // // // // // // // //       FROM users
// // // // // // // // // // //       WHERE username=@username
// // // // // // // // // // //       ''',
// // // // // // // // // // //     ),
// // // // // // // // // // //     parameters: {
// // // // // // // // // // //       'username': username.trim(),
// // // // // // // // // // //     },
// // // // // // // // // // //   );

// // // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // // //     final row = result.first;

// // // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // // //       return {
// // // // // // // // // // //         "success": true,
// // // // // // // // // // //         "message": "Login successful",
// // // // // // // // // // //         "username": username,
// // // // // // // // // // //       };
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   return {
// // // // // // // // // // //     "success": false,
// // // // // // // // // // //     "message": "Invalid username or password",
// // // // // // // // // // //   };
// // // // // // // // // // // }

// // // // // // // // // // // // Updated handler function signature to accept field1 and field2 parameters
// // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // //   String motorType,
// // // // // // // // // // //   String machineId,
// // // // // // // // // // //   String testId,
// // // // // // // // // // //   String operationName,
// // // // // // // // // // //   String field1,
// // // // // // // // // // //   String field2,
// // // // // // // // // // // ) async {
// // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // //     Sql.named(
// // // // // // // // // // //       '''
// // // // // // // // // // //       INSERT INTO machine_data
// // // // // // // // // // //       (
// // // // // // // // // // //         motor_type,
// // // // // // // // // // //         machine_id,
// // // // // // // // // // //         test_id,
// // // // // // // // // // //         operation_name,
// // // // // // // // // // //         field_1,
// // // // // // // // // // //         field_2
// // // // // // // // // // //       )
// // // // // // // // // // //       VALUES
// // // // // // // // // // //       (
// // // // // // // // // // //         @motor_type,
// // // // // // // // // // //         @machine_id,
// // // // // // // // // // //         @test_id,
// // // // // // // // // // //         @operation_name,
// // // // // // // // // // //         @field_1,
// // // // // // // // // // //         @field_2
// // // // // // // // // // //       )
// // // // // // // // // // //       RETURNING *
// // // // // // // // // // //       '''
// // // // // // // // // // //     ),
// // // // // // // // // // //     parameters: {
// // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // // //       "field_1": field1,
// // // // // // // // // // //       "field_2": field2,
// // // // // // // // // // //     },
// // // // // // // // // // //   );

// // // // // // // // // // //   return {
// // // // // // // // // // //     "success": true,
// // // // // // // // // // //     "record": result.first.toString(),
// // // // // // // // // // //   };
// // // // // // // // // // // }

// // // // // // // // // // // Future<void> main() async {
// // // // // // // // // // //   await connectDB();

// // // // // // // // // // //   final router = Router();

// // // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // //         return Response(
// // // // // // // // // // //           400,
// // // // // // // // // // //           body: jsonEncode({"message": "Username and Password required"}),
// // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // //         );
// // // // // // // // // // //       }

// // // // // // // // // // //       final result = await loginUser(username, password);

// // // // // // // // // // //       if (result["success"]) {
// // // // // // // // // // //         return Response.ok(
// // // // // // // // // // //           jsonEncode(result),
// // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // //         );
// // // // // // // // // // //       }

// // // // // // // // // // //       return Response(
// // // // // // // // // // //         401,
// // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // //       );
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // //       );
// // // // // // // // // // //     }
// // // // // // // // // // //   });

// // // // // // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // // // // //       String field1 = body['field_1']?.toString() ?? ''; // Captured Field 1
// // // // // // // // // // //       String field2 = body['field_2']?.toString() ?? ''; // Captured Field 2

// // // // // // // // // // //       if (motorType.isEmpty ||
// // // // // // // // // // //           machineId.isEmpty ||
// // // // // // // // // // //           testId.isEmpty ||
// // // // // // // // // // //           operationName.isEmpty ||
// // // // // // // // // // //           field1.isEmpty ||
// // // // // // // // // // //           field2.isEmpty) {
// // // // // // // // // // //         return Response(
// // // // // // // // // // //           400,
// // // // // // // // // // //           body: jsonEncode({"message": "All fields are required"}),
// // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // //         );
// // // // // // // // // // //       }

// // // // // // // // // // //       final result = await insertMachineData(
// // // // // // // // // // //         motorType,
// // // // // // // // // // //         machineId,
// // // // // // // // // // //         testId,
// // // // // // // // // // //         operationName,
// // // // // // // // // // //         field1,
// // // // // // // // // // //         field2,
// // // // // // // // // // //       );

// // // // // // // // // // //       return Response(
// // // // // // // // // // //         201,
// // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // //       );
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // //       );
// // // // // // // // // // //     }
// // // // // // // // // // //   });

// // // // // // // // // // //   final handler = Pipeline()
// // // // // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // // // // //       .addMiddleware(logRequests())
// // // // // // // // // // //       .addHandler(router.call);

// // // // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);

// // // // // // // // // // //   print("Server running on http://localhost:3000");
// // // // // // // // // // // }





// // // // // // // // // // // direct mqtt

// // // // // // // // // // // import 'dart:convert';
// // // // // // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // // // // // // late Connection conn;
// // // // // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 1. POSTGRESQL CONNECTION & OPERATIONS
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // // //   conn = await Connection.open(
// // // // // // // // // // //     Endpoint(
// // // // // // // // // // //       host: 'localhost',
// // // // // // // // // // //       port: 5432,
// // // // // // // // // // //       database: 'Input_Logs',
// // // // // // // // // // //       username: 'postgres',
// // // // // // // // // // //       password: 'postgres123',
// // // // // // // // // // //     ),
// // // // // // // // // // //     settings: ConnectionSettings(
// // // // // // // // // // //       sslMode: SslMode.disable,
// // // // // // // // // // //     ),
// // // // // // // // // // //   );

// // // // // // // // // // //   print("Connected to PostgreSQL");
// // // // // // // // // // // }

// // // // // // // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // //     Sql.named(
// // // // // // // // // // //       '''
// // // // // // // // // // //       SELECT *
// // // // // // // // // // //       FROM users
// // // // // // // // // // //       WHERE username=@username
// // // // // // // // // // //       ''',
// // // // // // // // // // //     ),
// // // // // // // // // // //     parameters: {
// // // // // // // // // // //       'username': username.trim(),
// // // // // // // // // // //     },
// // // // // // // // // // //   );

// // // // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // // // //     final row = result.first;
// // // // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // // // //     if (dbPassword == password) {
// // // // // // // // // // //       return {
// // // // // // // // // // //         "success": true,
// // // // // // // // // // //         "message": "Login successful",
// // // // // // // // // // //         "username": username,
// // // // // // // // // // //       };
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   return {
// // // // // // // // // // //     "success": false,
// // // // // // // // // // //     "message": "Invalid username or password",
// // // // // // // // // // //   };
// // // // // // // // // // // }

// // // // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // // // //   String motorType,
// // // // // // // // // // //   String machineId,
// // // // // // // // // // //   String testId,
// // // // // // // // // // //   String operationName,
// // // // // // // // // // //   String field1,
// // // // // // // // // // //   String field2,
// // // // // // // // // // // ) async {
// // // // // // // // // // //   final result = await conn.execute(
// // // // // // // // // // //     Sql.named(
// // // // // // // // // // //       '''
// // // // // // // // // // //       INSERT INTO machine_data
// // // // // // // // // // //       (
// // // // // // // // // // //         motor_type,
// // // // // // // // // // //         machine_id,
// // // // // // // // // // //         test_id,
// // // // // // // // // // //         operation_name,
// // // // // // // // // // //         field_1,
// // // // // // // // // // //         field_2
// // // // // // // // // // //       )
// // // // // // // // // // //       VALUES
// // // // // // // // // // //       (
// // // // // // // // // // //         @motor_type,
// // // // // // // // // // //         @machine_id,
// // // // // // // // // // //         @test_id,
// // // // // // // // // // //         @operation_name,
// // // // // // // // // // //         @field_1,
// // // // // // // // // // //         @field_2
// // // // // // // // // // //       )
// // // // // // // // // // //       RETURNING *
// // // // // // // // // // //       '''
// // // // // // // // // // //     ),
// // // // // // // // // // //     parameters: {
// // // // // // // // // // //       "motor_type": motorType,
// // // // // // // // // // //       "machine_id": machineId,
// // // // // // // // // // //       "test_id": testId,
// // // // // // // // // // //       "operation_name": operationName,
// // // // // // // // // // //       "field_1": field1,
// // // // // // // // // // //       "field_2": field2,
// // // // // // // // // // //     },
// // // // // // // // // // //   );

// // // // // // // // // // //   return {
// // // // // // // // // // //     "success": true,
// // // // // // // // // // //     "record": result.first.toString(),
// // // // // // // // // // //   };
// // // // // // // // // // // }

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 2. MQTT BROKER PUBLISHER CONNECTION
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> connectMQTT() async {
// // // // // // // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'dart_backend_publisher');
// // // // // // // // // // //   mqttClient.port = 1883;
// // // // // // // // // // //   mqttClient.logging(on: false);
// // // // // // // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // // // // // // //   try {
// // // // // // // // // // //     print('Connecting to MQTT Broker...');
// // // // // // // // // // //     await mqttClient.connect();
// // // // // // // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // // // // // // //   } catch (e) {
// // // // // // // // // // //     print('MQTT Connection exception: $e');
// // // // // // // // // // //     mqttClient.disconnect();
// // // // // // // // // // //   }
// // // // // // // // // // // }

// // // // // // // // // // // void publishMachineData(Map<String, dynamic> data) {
// // // // // // // // // // //   const String topic = 'machine/metrics';
// // // // // // // // // // //   final builder = MqttClientPayloadBuilder();
// // // // // // // // // // //   builder.addString(jsonEncode(data));

// // // // // // // // // // //   if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // // // //     mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // // // //     print('Published data to MQTT topic: $topic');
// // // // // // // // // // //   } else {
// // // // // // // // // // //     print('MQTT client not connected, skipping publish.');
// // // // // // // // // // //   }
// // // // // // // // // // // }

// // // // // // // // // // // // ==========================================
// // // // // // // // // // // // 3. MAIN SERVER ROUTING ENTRYPOINT
// // // // // // // // // // // // ==========================================
// // // // // // // // // // // Future<void> main() async {
// // // // // // // // // // //   await connectDB();   // This will now resolve perfectly
// // // // // // // // // // //   await connectMQTT(); // This will now resolve perfectly

// // // // // // // // // // //   final router = Router();

// // // // // // // // // // //   router.post('/login', (Request request) async {
// // // // // // // // // // //     try {
// // // // // // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // // // // // //         return Response(
// // // // // // // // // // //           400,
// // // // // // // // // // //           body: jsonEncode({"message": "Username and Password required"}),
// // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // //         );
// // // // // // // // // // //       }

// // // // // // // // // // //       final result = await loginUser(username, password);

// // // // // // // // // // //       if (result["success"]) {
// // // // // // // // // // //         return Response.ok(
// // // // // // // // // // //           jsonEncode(result),
// // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // //         );
// // // // // // // // // // //       }

// // // // // // // // // // //       return Response(
// // // // // // // // // // //         401,
// // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // //       );
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // //       );
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

// // // // // // // // // // //       if (motorType.isEmpty ||
// // // // // // // // // // //           machineId.isEmpty ||
// // // // // // // // // // //           testId.isEmpty ||
// // // // // // // // // // //           operationName.isEmpty ||
// // // // // // // // // // //           field1.isEmpty ||
// // // // // // // // // // //           field2.isEmpty) {
// // // // // // // // // // //         return Response(
// // // // // // // // // // //           400,
// // // // // // // // // // //           body: jsonEncode({"message": "All fields are required"}),
// // // // // // // // // // //           headers: {"Content-Type": "application/json"},
// // // // // // // // // // //         );
// // // // // // // // // // //       }

// // // // // // // // // // //       // 1. Insert directly into Postgres 
// // // // // // // // // // //       final result = await insertMachineData(
// // // // // // // // // // //         motorType,
// // // // // // // // // // //         machineId,
// // // // // // // // // // //         testId,
// // // // // // // // // // //         operationName,
// // // // // // // // // // //         field1,
// // // // // // // // // // //         field2,
// // // // // // // // // // //       );

// // // // // // // // // // //       // 2. Publish to MQTT Broker for MongoDB Ingestion
// // // // // // // // // // //       publishMachineData({
// // // // // // // // // // //         "motor_type": motorType,
// // // // // // // // // // //         "machine_id": machineId,
// // // // // // // // // // //         "test_id": testId,
// // // // // // // // // // //         "operation_name": operationName,
// // // // // // // // // // //         "field_1": field1,
// // // // // // // // // // //         "field_2": field2,
// // // // // // // // // // //         "timestamp": DateTime.now().toIso8601String()
// // // // // // // // // // //       });

// // // // // // // // // // //       return Response(
// // // // // // // // // // //         201,
// // // // // // // // // // //         body: jsonEncode(result),
// // // // // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // // // // //       );
// // // // // // // // // // //     } catch (e) {
// // // // // // // // // // //       return Response.internalServerError(
// // // // // // // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // // // // // // //       );
// // // // // // // // // // //     }
// // // // // // // // // // //   });

// // // // // // // // // // //   final handler = Pipeline()
// // // // // // // // // // //       .addMiddleware(corsHeaders())
// // // // // // // // // // //       .addMiddleware(logRequests())
// // // // // // // // // // //       .addHandler(router.call);

// // // // // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);

// // // // // // // // // // //   print("Server running on http://localhost:3000");
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
// // // // // // // // // // late Connection listenConn; // Separate connection dedicated solely to LISTEN
// // // // // // // // // // late MqttServerClient mqttClient;

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // //   // final endpoint = Endpoint(
// // // // // // // // // //   //   host: 'localhost',
// // // // // // // // // //   //   port: 5432,
// // // // // // // // // //   //   database: 'Input_Logs',
// // // // // // // // // //   //   username: 'postgres',
// // // // // // // // // //   //   password: 'postgres123',
// // // // // // // // // //   // );
  
// // // // // // // // // //   final endpoint = Endpoint(
// // // // // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // // //   port: 5432,
// // // // // // // // // //   database: 'neondb',
// // // // // // // // // //   username: 'neondb_owner',
// // // // // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // // // // );

// // // // // // // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // //   // Connection for executing normal queries
// // // // // // // // // //   conn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // //   print("Connected to PostgreSQL (Query Client)");

// // // // // // // // // //   // Persistent connection dedicated to receiving LISTEN events
// // // // // // // // // //   listenConn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
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
// // // // // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // // // // //   // Instruct Postgres to begin listening on our custom channel
// // // // // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // // // // //   // Stream listener that captures broadcasts continuously
// // // // // // // // // // //   listenConn.channels['machine_channel'].listen((notification) {
// // // // // // // // // // //     final String? payload = notification.payload;
    
// // // // // // // // // // //     if (payload != null) {
// // // // // // // // // // //       print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // // // // //       // Forward directly over MQTT
// // // // // // // // // // //       if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // // // // // // //         final builder = MqttClientPayloadBuilder();
// // // // // // // // // // //         builder.addString(payload);

// // // // // // // // // // //         mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // // // // // // //         print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // // // // // // //       } else {
// // // // // // // // // // //         print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // // // // // // //       }
// // // // // // // // // // //     }
// // // // // // // // // // //   });
// // // // // // // // // // // }


// // // // // // // // // // // ==========================================
// // // // // // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<void> startPostgresListenBridge() async {
// // // // // // // // // //   // Instruct Postgres to begin listening on our custom channel
// // // // // // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // // // // // //   // In postgres v3+, the notification stream yields String directly
// // // // // // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // // // // // //     // Forward directly over MQTT
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
// // // // // // // // // //       "field_1": field1,
// // // // // // // // // //       "field_2": field2,
// // // // // // // // // //     },
// // // // // // // // // //   );

// // // // // // // // // //   return {"success": true, "record": result.first.toString()};
// // // // // // // // // // }

// // // // // // // // // // // ==========================================
// // // // // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // // // // ==========================================
// // // // // // // // // // Future<void> main() async {
// // // // // // // // // //   await connectDB();
// // // // // // // // // //   await connectMQTT();
  
// // // // // // // // // //   // Launch the asynchronous Listen -> Publish loop runner
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

// // // // // // // // // //       // Perform standard SQL insert. The DB trigger executes the broadcast pipeline.
// // // // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);

// // // // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
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
// // // // // // // // // // Future<void> connectDB() async {
// // // // // // // // // //   final endpoint = Endpoint(
// // // // // // // // // //     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // // //     port: 5432,
// // // // // // // // // //     database: 'neondb',
// // // // // // // // // //     username: 'neondb_owner',
// // // // // // // // // //     password: 'npg_mT9C4KeOaJVN',
// // // // // // // // // //   );

// // // // // // // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // // //   conn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // //   print("Connected to PostgreSQL (Query Client)");

// // // // // // // // // //   listenConn = await Connection.open(endpoint, settings: settings);
// // // // // // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // // // // // }

// // // // // // // // // Future<void> connectDB() async {
// // // // // // // // //   final endpoint = Endpoint(
// // // // // // // // //     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // // // //     port: 5432,
// // // // // // // // //     database: 'neondb',
// // // // // // // // //     username: 'neondb_owner',
// // // // // // // // //     password: 'npg_mT9C4KeOaJVN',
// // // // // // // // //   );

// // // // // // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // //   bool connected = false;
// // // // // // // // //   while (!connected) {
// // // // // // // // //     try {
// // // // // // // // //       conn = await Connection.open(endpoint, settings: settings);
// // // // // // // // //       listenConn = await Connection.open(endpoint, settings: settings);
// // // // // // // // //       print("Connected to PostgreSQL");
// // // // // // // // //       connected = true;
// // // // // // // // //     } catch (e) {
// // // // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // // // // //     }
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
// // // // // // // // //   final result = await conn.execute(
// // // // // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // // // // //     parameters: {'username': username.trim()},
// // // // // // // // //   );

// // // // // // // // //   if (result.isNotEmpty) {
// // // // // // // // //     final row = result.first;
// // // // // // // // //     String dbPassword = row[2].toString();

// // // // // // // // //     if (dbPassword == password) {
// // // // // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // // // // }

// // // // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // // // ) async {
// // // // // // // // //   final result = await conn.execute(
// // // // // // // // //     Sql.named('''
// // // // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // // // //       RETURNING *
// // // // // // // // //     '''),
// // // // // // // // //     parameters: {
// // // // // // // // //       "motor_type": motorType,
// // // // // // // // //       "machine_id": machineId,
// // // // // // // // //       "test_id": testId,
// // // // // // // // //       "operation_name": operationName,
// // // // // // // // //       "field_1": double.tryParse(field1) ?? 0.0,
// // // // // // // // //       "field_2": double.tryParse(field2) ?? 0.0,
// // // // // // // // //     },
// // // // // // // // //   );

// // // // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // // // }

// // // // // // // // // // Query Function to select all logs from target table data_lsit
// // // // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // // // //   final result = await conn.execute(
// // // // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM data_lsit ORDER BY id ASC'
// // // // // // // // //   );
  
// // // // // // // // //   return result.map((row) {
// // // // // // // // //     final map = row.toColumnMap();
// // // // // // // // //     return {
// // // // // // // // //       "id": map["id"],
// // // // // // // // //       "motor_type": map["motor_type"],
// // // // // // // // //       "machine_id": map["machine_id"],
// // // // // // // // //       "test_id": map["test_id"],
// // // // // // // // //       "operation_name": map["operation_name"],
// // // // // // // // //       "field_1": map["field_1"],
// // // // // // // // //       "field_2": map["field_2"],
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
// // // // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // // // // // //       String field2 = body['field_2']?.toString() ?? '';

// // // // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // // // //       }

// // // // // // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
// // // // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // // // //     }
// // // // // // // // //   });

// // // // // // // // //   // GET Endpoint targeting data_lsit 
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

// // // // // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // // }



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
// // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // ==========================================
// // // // // // // final _pgEndpoint = Endpoint(
// // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // //   port: 5432,
// // // // // // //   database: 'neondb',
// // // // // // //   username: 'neondb_owner',
// // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // );

// // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // Future<Connection> _openConnection() async {
// // // // // // //   while (true) {
// // // // // // //     try {
// // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // //     } catch (e) {
// // // // // // //       print("DB connection failed, retrying in 3s: $e");
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

// // // // // // // // Inserts a new row into machine_data
// // // // // // // // Columns: motor_type, machine_id, test_id, operation_name, field_1, field_2
// // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // //   String motorType,
// // // // // // //   String machineId,
// // // // // // //   String testId,
// // // // // // //   String operationName,
// // // // // // //   double field1,
// // // // // // //   double field2,
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "operation_name": operationName,
// // // // // // //       "field_1": field1,
// // // // // // //       "field_2": field2,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query all logs from machine_data
// // // // // // // Future<List<Map<String, dynamic>>> fetchMachineData() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC',
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
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // ==========================================
// // // // // // // Future<void> main() async {
// // // // // // //   await connectDB();
// // // // // // //   await connectMQTT();

// // // // // // //   startPostgresListenBridge();

// // // // // // //   final router = Router();

// // // // // // //   // POST /login
// // // // // // //   router.post('/login', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // // //       String username = body['username']?.toString() ?? '';
// // // // // // //       String password = body['password']?.toString() ?? '';

// // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // //         return Response(400,
// // // // // // //             body: jsonEncode({"message": "Username/Password required"}),
// // // // // // //             headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await loginUser(username, password);
// // // // // // //       return Response(result["success"] ? 200 : 401,
// // // // // // //           body: jsonEncode(result),
// // // // // // //           headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // POST /add-machine-data — inserts into machine_data table
// // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // //       String motorType     = body['motor_type']?.toString() ?? '';
// // // // // // //       String machineId     = body['machine_id']?.toString() ?? '';
// // // // // // //       String testId        = body['test_id']?.toString() ?? '';
// // // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // // //       double field1        = double.tryParse(body['field_1']?.toString() ?? '') ?? 0.0;
// // // // // // //       double field2        = double.tryParse(body['field_2']?.toString() ?? '') ?? 0.0;

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty) {
// // // // // // //         return Response(400,
// // // // // // //             body: jsonEncode({"message": "motor_type, machine_id, test_id, and operation_name are required"}),
// // // // // // //             headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
// // // // // // //       return Response(201,
// // // // // // //           body: jsonEncode(result),
// // // // // // //           headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // GET /get-machine-data — fetches all rows from machine_data
// // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final logs = await fetchMachineData();
// // // // // // //       return Response.ok(jsonEncode(logs),
// // // // // // //           headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   final handler = Pipeline()
// // // // // // //       .addMiddleware(corsHeaders())
// // // // // // //       .addMiddleware(logRequests())
// // // // // // //       .addHandler(router.call);

// // // // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // }









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
// // // // // // // // 1. DATABASE CONNECTIVITY
// // // // // // // // ==========================================
// // // // // // // final _pgEndpoint = Endpoint(
// // // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // // //   port: 5432,
// // // // // // //   database: 'neondb',
// // // // // // //   username: 'neondb_owner',
// // // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // // );

// // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // Neon's free-tier compute auto-suspends after a period of inactivity,
// // // // // // // // which silently drops any open connection — this helper is what lets
// // // // // // // // us open a fresh one again on demand, instead of only at server startup.
// // // // // // // Future<Connection> _openConnection() async {
// // // // // // //   while (true) {
// // // // // // //     try {
// // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // //     } catch (e) {
// // // // // // //       print("DB connection failed, retrying in 3s: $e");
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

// // // // // // // // Runs a query; if it fails because the connection has gone stale
// // // // // // // // (e.g. Neon suspended the compute and dropped it), reopens just the
// // // // // // // // query connection and retries the action once before giving up.
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

// // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // //   ));
  
// // // // // // //   return result.map((row) {
// // // // // // //     final map = row.toColumnMap();
// // // // // // //     return {
// // // // // // //       "id": map["id"],
// // // // // // //       "motor_type": map["motor_type"],
// // // // // // //       "machine_id": map["machine_id"],
// // // // // // //       "test_id": map["test_id"],
// // // // // // //       "temprature1": map["temprature1"],
// // // // // // //       "temprature2": map["temprature2"],
// // // // // // //       "temprature3": map["temprature3"],
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ------------------------------------------
// // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // This is a completely independent table/endpoint pair from data_list above —
// // // // // // // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // // // // // // ------------------------------------------

// // // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "operation_name": operationName,
// // // // // // //       "field_1": field1,
// // // // // // //       "field_2": field2,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query Function to select all rows from target table machine_data
// // // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC'
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
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // // ==========================================
// // // // // // // Future<void> main() async {
// // // // // // //   await connectDB();
// // // // // // //   await connectMQTT();
  
// // // // // // //   startPostgresListenBridge(); 

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

// // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // GET Endpoint targeting data_list
// // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // ------------------------------------------
// // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
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

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2);
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
// // // // // // //   print("Server engine operational on http://localhost:3000");
// // // // // // // }



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
// // // // // // // // 1. DATABASE CONNECTIVITY (fully local — no cloud)
// // // // // // // // ==========================================
// // // // // // // final _pgEndpoint = Endpoint(
// // // // // // //   host: '192.168.50.167',
// // // // // // //   port: 5432,
// // // // // // //   database: 'Railway',
// // // // // // //   username: 'postgres',
// // // // // // //   password: 'postgres123',
// // // // // // // );

// // // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.disable, connectTimeout: const Duration(seconds: 5));

// // // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // // On localhost the most common reason this fails is simply that the
// // // // // // // // PostgreSQL Windows service hasn't started yet — this keeps retrying
// // // // // // // // until it's up, so you don't have to manually restart the Dart server.
// // // // // // // Future<Connection> _openConnection() async {
// // // // // // //   while (true) {
// // // // // // //     try {
// // // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // // //     } catch (e) {
// // // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // // //       print("  (Is the local PostgreSQL service running? Check services.msc → postgresql-x64-...)");
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

// // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // //   ));
  
// // // // // // //   return result.map((row) {
// // // // // // //     final map = row.toColumnMap();
// // // // // // //     return {
// // // // // // //       "id": map["id"],
// // // // // // //       "motor_type": map["motor_type"],
// // // // // // //       "machine_id": map["machine_id"],
// // // // // // //       "test_id": map["test_id"],
// // // // // // //       "temprature1": map["temprature1"],
// // // // // // //       "temprature2": map["temprature2"],
// // // // // // //       "temprature3": map["temprature3"],
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ------------------------------------------
// // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // // This is a completely independent table/endpoint pair from data_list above —
// // // // // // // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // // // // // // ------------------------------------------

// // // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "operation_name": operationName,
// // // // // // //       "field_1": field1,
// // // // // // //       "field_2": field2,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query Function to select all rows from target table machine_data
// // // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC'
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

// // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // GET Endpoint targeting data_list
// // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // ------------------------------------------
// // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
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

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2);
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
// // // // // // //   print("Server engine operational on http://localhost:3000");

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

// // // // // // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // // // // // ) async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     Sql.named('''
// // // // // // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // // // // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // // // // // //       RETURNING *
// // // // // // //     '''),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // // // // // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // // // // // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // // // // // //     },
// // // // // // //   ));

// // // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // // }

// // // // // // // // Query Function to select all logs from target table data_list
// // // // // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // // // // // //   ));
  
// // // // // // //   return result.map((row) {
// // // // // // //     final map = row.toColumnMap();
// // // // // // //     return {
// // // // // // //       "id": map["id"],
// // // // // // //       "motor_type": map["motor_type"],
// // // // // // //       "machine_id": map["machine_id"],
// // // // // // //       "test_id": map["test_id"],
// // // // // // //       "temprature1": map["temprature1"],
// // // // // // //       "temprature2": map["temprature2"],
// // // // // // //       "temprature3": map["temprature3"],
// // // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // // //     };
// // // // // // //   }).toList();
// // // // // // // }

// // // // // // // // ------------------------------------------
// // // // // // // // SEPARATE TABLE: machine_data
// // // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // // This is a completely independent table/endpoint pair from data_list above —
// // // // // // // // it powers the Log Entry form only. The dashboard keeps reading data_list.
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

// // // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // // // // // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // // // // // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // // // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // // // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // // // //       }

// // // // // // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // // // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // GET Endpoint targeting data_list
// // // // // // //   router.get('/get-machine-data', (Request request) async {
// // // // // // //     try {
// // // // // // //       final logs = await fetchLogsFromDB();
// // // // // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // // // //     }
// // // // // // //   });

// // // // // // //   // ------------------------------------------
// // // // // // //   // SEPARATE TABLE ROUTES: machine_data
// // // // // // //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
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
// // // // // // import 'package:postgres/postgres.dart';
// // // // // // import 'package:shelf/shelf.dart';
// // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // late Connection conn;
// // // // // // late Connection listenConn; 
// // // // // // late MqttServerClient mqttClient;

// // // // // // // ==========================================
// // // // // // // 1. DATABASE CONNECTIVITY (Neon — cloud Postgres)
// // // // // // // ==========================================
// // // // // // final _pgEndpoint = Endpoint(
// // // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // // //   port: 5432,
// // // // // //   database: 'neondb',
// // // // // //   username: 'neondb_owner',
// // // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // // );

// // // // // // // Neon requires SSL — connections without it are rejected outright, unlike
// // // // // // // the local setup this replaces.
// // // // // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require, connectTimeout: const Duration(seconds: 10));

// // // // // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // // // // Neon's free tier auto-suspends the database after a period of
// // // // // // // inactivity — the first connection after a quiet spell can take a few
// // // // // // // seconds while it wakes back up, so this keeps retrying instead of
// // // // // // // giving up after one failed attempt.
// // // // // // Future<Connection> _openConnection() async {
// // // // // //   while (true) {
// // // // // //     try {
// // // // // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // // // // //     } catch (e) {
// // // // // //       print("DB connection failed, retrying in 3s: $e");
// // // // // //       print("  (If this persists, check your internet connection and the project status on the Neon dashboard.)");
// // // // // //       await Future.delayed(const Duration(seconds: 3));
// // // // // //     }
// // // // // //   }
// // // // // // }

// // // // // // Future<void> connectDB() async {
// // // // // //   conn = await _openConnection();
// // // // // //   print("Connected to PostgreSQL (Query Client)");
// // // // // //   listenConn = await _openConnection();
// // // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // // }

// // // // // // // Runs a query; if it fails because the connection has gone stale,
// // // // // // // reopens just the query connection and retries the action once before giving up.
// // // // // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // // // // //   try {
// // // // // //     return await action();
// // // // // //   } catch (e) {
// // // // // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // // // // //     conn = await _openConnection();
// // // // // //     return await action();
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // // ==========================================
// // // // // // Future<void> connectMQTT() async {
// // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
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
// // // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // // ==========================================
// // // // // // Future<void> startPostgresListenBridge() async {
// // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // //       final builder = MqttClientPayloadBuilder();
// // // // // //       builder.addString(payload);

// // // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // //     } else {
// // // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // //     }
// // // // // //   });
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // // ==========================================
// // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // // //     parameters: {'username': username.trim()},
// // // // // //   ));

// // // // // //   if (result.isNotEmpty) {
// // // // // //     final row = result.first;
// // // // // //     String dbPassword = row[2].toString();

// // // // // //     if (dbPassword == password) {
// // // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // // //     }
// // // // // //   }
// // // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // // }

// // // // // // // ------------------------------------------
// // // // // // // TABLE: machine_sensor_data
// // // // // // // (id, amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // // // // // // This is the live telemetry table the Dashboard now reads from — it
// // // // // // // replaces the old data_list table/endpoint pair entirely. Rows are
// // // // // // // expected to be written by the sensor/device pipeline (e.g. via the
// // // // // // // Postgres LISTEN/NOTIFY -> MQTT bridge above), not by this app's UI.
// // // // // // // ------------------------------------------

// // // // // // // Query Function to select all rows from target table machine_sensor_data
// // // // // // Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
// // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // //     'SELECT id, amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at FROM machine_sensor_data ORDER BY id ASC'
// // // // // //   ));

// // // // // //   return result.map((row) {
// // // // // //     final map = row.toColumnMap();
// // // // // //     return {
// // // // // //       "id": map["id"],
// // // // // //       "amb_temp": map["amb_temp"],
// // // // // //       "tm1_fet": map["tm1_fet"],
// // // // // //       "tm1_ret": map["tm1_ret"],
// // // // // //       "tm2_fet": map["tm2_fet"],
// // // // // //       "tm2_ret": map["tm2_ret"],
// // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // //     };
// // // // // //   }).toList();
// // // // // // }

// // // // // // // ------------------------------------------
// // // // // // // SEPARATE TABLE: machine_data
// // // // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // This is a completely independent table/endpoint pair from
// // // // // // // machine_sensor_data above — it powers the Log Entry form only. The
// // // // // // // dashboard reads machine_sensor_data.
// // // // // // // ------------------------------------------

// // // // // // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // // // status: 1 = Start, 0 = Stop
// // // // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // // // // // ) async {
// // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // //     Sql.named('''
// // // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2, @status)
// // // // // //       RETURNING *
// // // // // //     '''),
// // // // // //     parameters: {
// // // // // //       "motor_type": motorType,
// // // // // //       "machine_id": machineId,
// // // // // //       "test_id": testId,
// // // // // //       "operation_name": operationName,
// // // // // //       "field_1": field1,
// // // // // //       "field_2": field2,
// // // // // //       "status": status,
// // // // // //     },
// // // // // //   ));

// // // // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // // // }

// // // // // // // Query Function to select all rows from target table machine_data
// // // // // // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// // // // // //   final result = await _withRetry(() => conn.execute(
// // // // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, status, created_at FROM machine_data ORDER BY id ASC'
// // // // // //   ));

// // // // // //   return result.map((row) {
// // // // // //     final map = row.toColumnMap();
// // // // // //     return {
// // // // // //       "id": map["id"],
// // // // // //       "motor_type": map["motor_type"],
// // // // // //       "machine_id": map["machine_id"],
// // // // // //       "test_id": map["test_id"],
// // // // // //       "operation_name": map["operation_name"],
// // // // // //       "field_1": map["field_1"],
// // // // // //       "field_2": map["field_2"],
// // // // // //       "status": map["status"],
// // // // // //       "created_at": map["created_at"]?.toString(),
// // // // // //     };
// // // // // //   }).toList();
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // // ==========================================
// // // // // // Future<void> main() async {
// // // // // //   // Only Postgres is required for login/dashboard/form routes to work,
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
// // // // // //   // SEPARATE TABLE ROUTES: machine_data
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
// // // // // //   print("Server engine operational on http://Neon:3000");

// // // // // //   // Login, the form, and the dashboard never depend on this — it's purely
// // // // // //   // for the live MQTT telemetry bridge, so it runs in the background and
// // // // // //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// // // // // //   unawaited(_startRealtimeBridgeInBackground());
// // // // // // }

// // // // // // Future<void> _startRealtimeBridgeInBackground() async {
// // // // // //   try {
// // // // // //     await connectMQTT();
// // // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // //       await startPostgresListenBridge();
// // // // // //     } else {
// // // // // //       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
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
// // // // //     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

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
// // // // //     "created_at": row["created_at"]?.toString(),
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
// // // // //   // sort comparator to parse `created_at` as a DateTime instead of `id`.
// // // // //   final rows = await _withRetry(
// // // // //     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
// // // // //   );

// // // // //   return rows.map(_sensorRowToJson).toList();
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
// // // //     // 'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';
// // // //       'mongodb://localhost:27017/Railway';
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
// // // // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // // // Completely independent from machine_sensor_data above — it powers the Log
// // // // // Entry form only. The dashboard reads machine_sensor_data.
// // // // // ------------------------------------------

// // // // // Inserts a new document into machine_data.
// // // // // status: 1 = Start, 0 = Stop
// // // // Future<Map<String, dynamic>> insertMachineRecord(
// // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // // // ) async {
// // // //   final doc = {
// // // //     "motor_type": motorType,
// // // //     "machine_id": machineId,
// // // //     "test_id": testId,
// // // //     "operation_name": operationName,
// // // //     "field_1": field1,
// // // //     "field_2": field2,
// // // //     "status": status,
// // // //     "created_at": DateTime.now().toUtc(),
// // // //   };

// // // //   final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

// // // //   return {
// // // //     "success": result.isSuccess,
// // // //     "record": {
// // // //       "id": (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString(),
// // // //       ...doc,
// // // //       "created_at": doc["created_at"].toString(),
// // // //     }.toString(),
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
// // // //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// // // //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // //       }

// // // //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
// // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
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
// // SECURITY NOTE: this mirrors the pattern in the original Postgres file
// // (credentials hardcoded in source), but since this URI has now been
// // pasted into a chat, treat the password as compromised — rotate it in
// // Atlas ("Database Access" -> edit user -> new password) and, ideally,
// // load the URI from an environment variable instead of committing it:
// //   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
// const String _mongoUri =
//     'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// // Opens a single connection, retrying every 3s until it succeeds — same
// // resilience behavior as the old _openConnection() for Neon (Atlas free
// // tier doesn't auto-suspend the way Neon's does, but a transient network
// // blip on first boot is still worth retrying through).
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

// // Runs a query; if it fails because the connection has gone stale,
// // reopens the connection and retries the action once before giving up.
// Future<T> _withRetry<T>(Future<T> Function() action) async {
//   try {
//     return await action();
//   } catch (e) {
//     print("Query failed ($e). Reconnecting to MongoDB and retrying...");
//     db = await _openConnection();
//     return await action();
//   }
// }

// // ==========================================
// // 2. MQTT CLIENT PUBLISHER
// // ==========================================
// Future<void> connectMQTT() async {
//   mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
//   mqttClient.port = 1883;
//   mqttClient.logging(on: false);
//   mqttClient.keepAlivePeriod = 20;
//   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

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
// // Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// // is a Change Stream on the collection, which watches for inserts/updates in
// // (near) real time. Change Streams require the deployment to be a replica
// // set — Atlas clusters (including the free M0 tier) already are one, so
// // this works without extra setup.
// //
// Future<void> startMongoChangeStreamBridge() async {
//   final collection = db.collection('machine_sensor_data');
//   // First positional arg is an aggregation pipeline to filter/shape events
//   // (empty list = no filtering, receive every change). `fullDocument:
//   // 'updateLookup'` makes update events include the complete document
//   // instead of just the changed fields.
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
//     // ASSUMPTION: the `users` collection has a `password` field (the old
//     // Postgres code read column index 2 positionally). Rename this key to
//     // match your actual document shape if it differs.
//     final dbPassword = row['password']?.toString() ?? '';

//     if (dbPassword == password) {
//       return {"success": true, "message": "Login successful", "username": username};
//     }
//   }
//   return {"success": false, "message": "Invalid username or password"};
// }

// // ------------------------------------------
// // COLLECTION: machine_sensor_data
// // (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // This is the live telemetry collection the Dashboard reads from. Rows are
// // expected to be written by the sensor/device pipeline (e.g. via whatever
// // replaces the old MQTT->Postgres path on the device side), not by this
// // app's UI.
// // ------------------------------------------

// // Decodes the creation time embedded in a Mongo ObjectId: the first 4
// // bytes (8 hex chars) of every ObjectId are a big-endian Unix timestamp in
// // seconds. Decoding it manually here (rather than relying on whatever
// // `.timestamp`/`.getTimestamp()` helper a given mongo_dart version does or
// // doesn't expose) keeps this working regardless of the installed package
// // version.
// DateTime? _timestampFromObjectId(ObjectId id) {
//   try {
//     final hex = id.oid;
//     final seconds = int.parse(hex.substring(0, 8), radix: 16);
//     return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
//   } catch (_) {
//     return null;
//   }
// }

// // Resolves the "true" creation time for a machine_sensor_data row.
// // Prefers the document's own `createdAt` field, but falls back to the
// // timestamp embedded in the Mongo `_id` (every ObjectId encodes its
// // creation second) whenever `createdAt` is missing, null, or unparsable —
// // which is exactly the case you're hitting: some rows from the sensor
// // pipeline come through with `createdAt: null`. The ObjectId is generated
// // by the driver/server at insert time regardless of what the sensor
// // payload did or didn't include, so this always has a value.
// DateTime? _sensorTimestamp(Map<String, dynamic> row) {
//   final explicit = _asDateTime(row['createdAt']);
//   if (explicit != null) return explicit;

//   final id = row['_id'];
//   if (id is ObjectId) return _timestampFromObjectId(id);

//   return null;
// }

// // Turns a raw Mongo document into the JSON shape the Flutter app expects.
// // `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// // app just uses it as an opaque, ascending-over-time sort/display key —
// // ObjectId hex strings sort lexicographically in the same order they were
// // created, so ascending string sort == chronological order.
// Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
//   return {
//     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
//     "amb_temp": row["amb_temp"],
//     "tm1_fet": row["tm1_fet"],
//     "tm1_ret": row["tm1_ret"],
//     "tm2_fet": row["tm2_fet"],
//     "tm2_ret": row["tm2_ret"],
//     // See _sensorTimestamp: uses the document's createdAt when present,
//     // otherwise derives it from the ObjectId so this is never null even
//     // for rows the sensor pipeline wrote without a timestamp.
//     "created_at": _sensorTimestamp(row)?.toIso8601String(),
//   };
// }

// // Query Function to select all rows from target collection machine_sensor_data
// Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
//   // Sort ascending by _id (chronological) — same intent as the old
//   // `ORDER BY id ASC`.
//   //
//   // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
//   // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
//   // strings aren't numeric, so that parse will yield 0 for every row and
//   // the client-side sort becomes a no-op — which is harmless *only because*
//   // this query already returns rows in the correct chronological order. If
//   // you ever change this query to sort differently, update the Flutter
//   // sort comparator to parse `created_at` (sourced from Mongo's `createdAt`)
//   // as a DateTime instead of `id`.
//   final rows = await _withRetry(
//     () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
//   );

//   return rows.map(_sensorRowToJson).toList();
// }

// // ------------------------------------------
// // COLLECTION: vfddatas
// // (machineId, outputCurrent, outputVoltage, outputRPM, outputFrequency,
// //  outputPower, createdAt, updatedAt)
// // A separate telemetry stream from a VFD (Variable Frequency Drive) unit —
// // written by its own external pipeline, same as machine_sensor_data. Powers
// // the Dashboard's 5-tab VFD chart (Current / Voltage / RPM / Frequency /
// // Power), one series per tab.
// // ------------------------------------------

// // Turns a raw Mongo vfddatas document into the JSON shape the Flutter app
// // expects. Mirrors _sensorRowToJson's approach: `_id` -> `id` (hex string),
// // and createdAt is normalized to an ISO string so the client never has to
// // deal with Mongo's native DateTime/BSON encoding.
// Map<String, dynamic> _vfdRowToJson(Map<String, dynamic> row) {
//   return {
//     "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
//     "machineId": row["machineId"]?.toString(),
//     "outputCurrent": row["outputCurrent"],
//     "outputVoltage": row["outputVoltage"],
//     "outputRPM": row["outputRPM"],
//     "outputFrequency": row["outputFrequency"],
//     "outputPower": row["outputPower"],
//     // Same createdAt-with-ObjectId-fallback treatment as
//     // machine_sensor_data, in case a future writer omits createdAt too.
//     "created_at": (_asDateTime(row["createdAt"]) ??
//             (row["_id"] is ObjectId ? _timestampFromObjectId(row["_id"] as ObjectId) : null))
//         ?.toIso8601String(),
//   };
// }

// // Query Function to select all rows from target collection vfddatas, sorted
// // ascending by _id (chronological) — same intent as machine_sensor_data's
// // fetch above, so the Flutter line charts plot oldest-to-newest, left to
// // right, with no client-side re-sort needed.
// Future<List<Map<String, dynamic>>> fetchVfdDataFromDB() async {
//   final rows = await _withRetry(
//     () => db.collection('vfddatas').find(where.sortBy('_id')).toList(),
//   );

//   return rows.map(_vfdRowToJson).toList();
// }

// // ------------------------------------------
// // SESSION SCOPING: machine_data (Start/Stop) -> machine_sensor_data window
// // ------------------------------------------
// // A "session" is one Start (status=1) + its matching Stop (status=0) for a
// // given (motor_type, test_id) pair. The dashboard shows only the sensor
// // readings whose created_at falls between that Start and Stop — or, if no
// // Stop has been logged yet, everything from Start up to now (a live/running
// // session).

// // Best-effort conversion since `created_at` may come back from Mongo as a
// // native DateTime (for docs this app wrote) or as a String (for docs written
// // by an external device/sensor pipeline that this app doesn't control).
// DateTime? _asDateTime(dynamic v) {
//   if (v == null) return null;
//   if (v is DateTime) return v;
//   return DateTime.tryParse(v.toString());
// }

// // Returns the distinct (motor_type, test_id) combinations seen in
// // machine_data, most-recently-active first, each tagged with whether its
// // latest event was a Start (still running) or a Stop (completed) — this is
// // what populates the Dashboard's session-picker dropdown.
// Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
//   final rows = await _withRetry(
//     () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
//   );

//   // Dart Maps preserve insertion order, and we insert in descending-recency
//   // order, so `seen.values` naturally comes out most-recent-first with one
//   // entry per (motor_type, test_id).
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

// // Finds the latest Start for (motor_type, test_id), its matching Stop (if
// // any), and every machine_sensor_data reading recorded in that window.
// Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
//   final sessionDocs = await _withRetry(
//     () => db
//         .collection('machine_data')
//         .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
//         .toList(),
//   );

//   // Latest Start: first status==1 doc when walking newest -> oldest.
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

//   // Matching Stop: earliest status==0 doc that occurs after startTime, i.e.
//   // the first Stop encountered walking oldest -> newest starting right
//   // after the Start.
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

//   // Filtered (and sorted) in application code rather than via a Mongo
//   // query/sort, because machine_sensor_data is written by an external
//   // pipeline this app doesn't control and some rows come through with a
//   // null/missing `createdAt` — sorting server-side on that field alone
//   // would misplace those rows. _sensorTimestamp() falls back to the
//   // ObjectId's embedded creation time for exactly those rows, so every
//   // row gets a usable timestamp before sorting/filtering.
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

// // ------------------------------------------
// // DAY-WISE RANGE FILTER: machine_data (Start/Stop, any motor/test) ->
// // combined machine_sensor_data window
// // ------------------------------------------
// // Same Start(status=1)/Stop(status=0) session concept as
// // fetchSessionSensorData above, but instead of one caller-specified
// // (motor_type, test_id), this builds EVERY session across the whole
// // machine_data collection, keeps only the ones whose Start falls inside
// // the requested [from, to] day range, and returns the combined
// // machine_sensor_data readings across all of those sessions' windows —
// // which is what powers the Dashboard's "SESSION LOG · DATE RANGE" table.
// Future<Map<String, dynamic>> fetchSensorDataInRange(DateTime from, DateTime to) async {
//   final machineRows = await _withRetry(
//     () => db.collection('machine_data').find(where.sortBy('created_at')).toList(),
//   );

//   // Walk chronologically, matching each Start with the next Stop for the
//   // SAME (motor_type, test_id) key. A Start with no later Stop yet is left
//   // open (stop_time stays null -> that session's sensor window runs to
//   // "now" when queried below).
//   final openStarts = <String, Map<String, dynamic>>{};
//   final sessions = <Map<String, dynamic>>[];

//   for (final row in machineRows) {
//     final motorType = row['motor_type']?.toString() ?? '';
//     final testId = row['test_id']?.toString() ?? '';
//     if (motorType.isEmpty || testId.isEmpty) continue;
//     final key = '$motorType\u0000$testId';
//     final status = row['status'];

//     if (status == 1) {
//       // A fresh Start replaces any still-open Start for this same key —
//       // keeps this robust even against back-to-back Starts with no Stop
//       // logged in between.
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
//   // Anything still open at the end of the collection is a running session.
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

//   // Keep only sessions whose Start landed inside the requested day range.
//   final matched = sessions.where((s) {
//     final st = s["start_time"] as DateTime?;
//     if (st == null) return false;
//     return !st.isBefore(from) && !st.isAfter(to);
//   }).toList()
//     ..sort((a, b) => (a["start_time"] as DateTime).compareTo(b["start_time"] as DateTime));

//   // Same "pull everything once, sort by resolved timestamp, then filter in
//   // application code" approach as fetchSessionSensorData — necessary
//   // because some machine_sensor_data rows arrive with a null createdAt.
//   final allSensorRows = await _withRetry(() => db.collection('machine_sensor_data').find().toList());
//   allSensorRows.sort((a, b) {
//     final ta = _sensorTimestamp(a);
//     final tb = _sensorTimestamp(b);
//     if (ta == null && tb == null) return 0;
//     if (ta == null) return -1;
//     if (tb == null) return 1;
//     return ta.compareTo(tb);
//   });

//   // Combine every matched session's window into one deduplicated,
//   // chronologically-sorted list (a reading that falls inside two
//   // overlapping sessions is only included once).
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
// // (motor_type, machine_id, test_id, operation_name, field_1, field_2, field_3, status)
// // Completely independent from machine_sensor_data above — it powers the Log
// // Entry form only. The dashboard reads machine_sensor_data.
// // ------------------------------------------

// // Inserts a new document into machine_data.
// // status: 1 = Start, 0 = Stop
// //
// // FIX: previously this returned {"success": result.isSuccess, ...} but the
// // route handler ignored that flag entirely and always answered the client
// // with HTTP 201 — so a failed/rejected insert still looked like a success
// // to the Flutter app (it shows the "Started"/"Stopped" animation and adds
// // the row to Active Sessions) even though nothing was written to MongoDB.
// // Now this throws when the driver reports the write didn't succeed, so the
// // route's existing try/catch turns that into a real error response instead
// // of a fake 201.
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
//     // Log the full WriteResult server-side (write errors, write concern
//     // errors, etc. all show up in result.toString()) so this is
//     // diagnosable from the server console, not just a generic 500 on the
//     // client.
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

// // Query Function to select all rows from target collection machine_data
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
//   // Only MongoDB is required for login/dashboard/form routes to work,
//   // so that's the only thing we block server startup on.
//   await connectDB();

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

//   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
//   router.get('/get-sensor-data', (Request request) async {
//     try {
//       final logs = await fetchSensorDataFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   // GET Endpoint targeting vfddatas — powers the Dashboard's 5-tab VFD
//   // chart (Current / Voltage / RPM / Frequency / Power).
//   router.get('/get-vfd-data', (Request request) async {
//     try {
//       final logs = await fetchVfdDataFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   // ------------------------------------------
//   // SEPARATE COLLECTION ROUTES: machine_data
//   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
//   // ------------------------------------------
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
//       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
//       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

//       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty || field3.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
//       }

//       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, field3, status);

//       // FIX: this used to unconditionally return 201 regardless of what
//       // `result` actually said. insertMachineRecord() now throws instead
//       // of returning success:false, so by the time we get here the insert
//       // is confirmed — but we still check explicitly rather than trusting
//       // that invariant blindly, so a future change to insertMachineRecord
//       // can't silently reintroduce the same bug.
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

//   // GET Endpoint targeting machine_data
//   router.get('/get-machine-records', (Request request) async {
//     try {
//       final logs = await fetchMachineRecordsFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   // ------------------------------------------
//   // SESSION-SCOPED ROUTES
//   // Power the Dashboard's session picker + session-windowed sensor view.
//   // ------------------------------------------

//   // Lists distinct (motor_type, test_id) sessions, most recently active
//   // first — populates the Dashboard's dropdown.
//   router.get('/get-machine-sessions', (Request request) async {
//     try {
//       final sessions = await fetchMachineSessionsFromDB();
//       return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   // Returns machine_sensor_data readings between a session's Start and
//   // Stop (or Start-to-now if it's still running), for one motor_type +
//   // test_id. e.g. /get-session-sensor-data?motor_type=Motor+1&test_id=TST-1
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

//   // Day-wise range filter: every machine_data Start/Stop session whose
//   // Start falls within [from, to] (YYYY-MM-DD, inclusive), plus the
//   // combined machine_sensor_data readings across all of those sessions'
//   // windows. Powers the Dashboard's "SESSION LOG · DATE RANGE" table.
//   // e.g. /get-sensor-data-range?from=2026-07-01&to=2026-07-04
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

//   // Login, the form, and the dashboard never depend on this — it's purely
//   // for the live MQTT telemetry bridge, so it runs in the background and
//   // can never block (or re-introduce a multi-minute delay on) the routes above.
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
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

late Db db;
late MqttServerClient mqttClient;

// ==========================================
// 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// ==========================================
// SECURITY NOTE: rotate this password in Atlas ("Database Access" -> edit
// user -> new password) and load the URI from an environment variable
// instead of committing it:
//   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
const String _mongoUri =
    'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway';

Future<Db> _openConnection() async {
  while (true) {
    try {
      final database = await Db.create(_mongoUri);
      await database.open();
      return database;
    } catch (e) {
      print("DB connection failed, retrying in 3s: $e");
      print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}

Future<void> connectDB() async {
  db = await _openConnection();
  print("Connected to MongoDB (database: ${db.databaseName})");
}

// ------------------------------------------
// RECONNECT GUARD
// ------------------------------------------
// FIX: previously every failing query independently called
// `db = await _openConnection()`. Under concurrent load, multiple requests
// failing at the same instant each raced to open their OWN new connection,
// stomping over `db` mid-reconnect and immediately hitting the dead socket
// again -> the "Broken pipe" / "No master connection" burst seen in the
// logs. Now there is at most ONE reconnect in flight at a time; anyone else
// who fails while it's happening just awaits the SAME future instead of
// starting another one.
Future<Db>? _reconnectFuture;

Future<Db> _reconnect() {
  final inFlight = _reconnectFuture;
  if (inFlight != null) return inFlight;

  final future = _openConnection().then((newDb) {
    db = newDb;
    print("Reconnected to MongoDB.");
    _reconnectFuture = null;
    return newDb;
  }).catchError((e) {
    _reconnectFuture = null;
    throw e;
  });

  _reconnectFuture = future;
  return future;
}

// Runs a query; retries through a shared reconnect with backoff instead of
// giving up after a single attempt, since a reconnect storm (many requests
// failing at once) previously meant the "one retry" often landed on a
// connection that hadn't stabilized yet.
Future<T> _withRetry<T>(Future<T> Function() action, {int maxAttempts = 3}) async {
  var attempt = 0;
  while (true) {
    try {
      return await action();
    } catch (e) {
      attempt++;
      if (attempt >= maxAttempts) {
        print("Query failed after $attempt attempts ($e). Giving up.");
        rethrow;
      }
      print("Query failed ($e). Reconnecting to MongoDB and retrying (attempt $attempt)...");
      await _reconnect();
      await Future.delayed(Duration(milliseconds: 300 * attempt));
    }
  }
}

// ------------------------------------------
// KEEPALIVE
// ------------------------------------------
// Atlas / the hosting network can silently close an idle socket. Pinging
// periodically keeps the connection warm so the FIRST real request after a
// quiet period doesn't discover a dead socket. If the ping itself fails,
// that's a signal to proactively reconnect rather than waiting for a user
// request to trip over it.
Timer? _keepAliveTimer;

void _startKeepAlive() {
  _keepAliveTimer?.cancel();
  _keepAliveTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
    try {
      await db.serverStatus();
    } catch (e) {
      print("Keepalive ping failed ($e), reconnecting...");
      try {
        await _reconnect();
      } catch (e2) {
        print("Keepalive reconnect attempt failed: $e2");
      }
    }
  });
}

// ==========================================
// 2. MQTT CLIENT PUBLISHER
// ==========================================
Future<void> connectMQTT() async {
  mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
  mqttClient.port = 1883;
  mqttClient.logging(on: false);
  mqttClient.keepAlivePeriod = 20;
  mqttClient.connectTimeoutPeriod = 8000;

  try {
    print('Connecting to MQTT Broker...');
    await mqttClient.connect();
    print('Connected to MQTT Broker successfully!');
  } catch (e) {
    print('MQTT Connection failure: $e');
    mqttClient.disconnect();
  }
}

// ==========================================
// 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// ==========================================
Future<void> startMongoChangeStreamBridge() async {
  final collection = db.collection('machine_sensor_data');
  final stream = collection.watch(
    <Map<String, Object>>[],
    changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
  );

  print("MongoDB change stream actively watching collection: machine_sensor_data");

  stream.listen((event) {
    final doc = event.fullDocument;
    if (doc == null) return;

    final payload = jsonEncode(_sensorRowToJson(doc));
    print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(payload);

      mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
      print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
    } else {
      print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
    }
  }, onError: (e) {
    print("[MQTT BRIDGE ERROR] Change stream error: $e");
  });
}

// ==========================================
// 4. BUSINESS LOGIC DATABASE QUERIES
// ==========================================
Future<Map<String, dynamic>> loginUser(String username, String password) async {
  final row = await _withRetry(
    () => db.collection('Users').findOne(where.eq('username', username.trim())),
  );

  if (row != null) {
    final dbPassword = row['password']?.toString() ?? '';

    if (dbPassword == password) {
      return {"success": true, "message": "Login successful", "username": username};
    }
  }
  return {"success": false, "message": "Invalid username or password"};
}

// ------------------------------------------
// COLLECTION: machine_sensor_data
// ------------------------------------------
DateTime? _timestampFromObjectId(ObjectId id) {
  try {
    final hex = id.oid;
    final seconds = int.parse(hex.substring(0, 8), radix: 16);
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  } catch (_) {
    return null;
  }
}

DateTime? _sensorTimestamp(Map<String, dynamic> row) {
  final explicit = _asDateTime(row['createdAt']);
  if (explicit != null) return explicit;

  final id = row['_id'];
  if (id is ObjectId) return _timestampFromObjectId(id);

  return null;
}

Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
  return {
    "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
    "amb_temp": row["amb_temp"],
    "tm1_fet": row["tm1_fet"],
    "tm1_ret": row["tm1_ret"],
    "tm2_fet": row["tm2_fet"],
    "tm2_ret": row["tm2_ret"],
    "created_at": _sensorTimestamp(row)?.toIso8601String(),
  };
}

Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
  final rows = await _withRetry(
    () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
  );

  return rows.map(_sensorRowToJson).toList();
}

// ------------------------------------------
// COLLECTION: vfddatas
// ------------------------------------------
Map<String, dynamic> _vfdRowToJson(Map<String, dynamic> row) {
  return {
    "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
    "machineId": row["machineId"]?.toString(),
    "outputCurrent": row["outputCurrent"],
    "outputVoltage": row["outputVoltage"],
    "outputRPM": row["outputRPM"],
    "outputFrequency": row["outputFrequency"],
    "outputPower": row["outputPower"],
    "created_at": (_asDateTime(row["createdAt"]) ??
            (row["_id"] is ObjectId ? _timestampFromObjectId(row["_id"] as ObjectId) : null))
        ?.toIso8601String(),
  };
}

Future<List<Map<String, dynamic>>> fetchVfdDataFromDB() async {
  final rows = await _withRetry(
    () => db.collection('vfddatas').find(where.sortBy('_id')).toList(),
  );

  return rows.map(_vfdRowToJson).toList();
}

// ------------------------------------------
// SESSION SCOPING
// ------------------------------------------
DateTime? _asDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

Future<List<Map<String, dynamic>>> fetchMachineSessionsFromDB() async {
  final rows = await _withRetry(
    () => db.collection('machine_data').find(where.sortBy('created_at', descending: true)).toList(),
  );

  final seen = <String, Map<String, dynamic>>{};
  for (final row in rows) {
    final motorType = row['motor_type']?.toString() ?? '';
    final testId = row['test_id']?.toString() ?? '';
    if (motorType.isEmpty || testId.isEmpty) continue;
    final key = '$motorType\u0000$testId';
    seen.putIfAbsent(key, () => {
          "motor_type": motorType,
          "test_id": testId,
          "last_status": row['status'],
          "is_active": row['status'] == 1,
          "last_activity": _asDateTime(row['created_at'])?.toIso8601String(),
        });
  }
  return seen.values.toList();
}

Future<Map<String, dynamic>> fetchSessionSensorData(String motorType, String testId) async {
  final sessionDocs = await _withRetry(
    () => db
        .collection('machine_data')
        .find(where.eq('motor_type', motorType).eq('test_id', testId).sortBy('created_at', descending: true))
        .toList(),
  );

  Map<String, dynamic>? startDoc;
  for (final d in sessionDocs) {
    if (d['status'] == 1) {
      startDoc = d;
      break;
    }
  }
  if (startDoc == null) {
    return {"found": false, "motor_type": motorType, "test_id": testId};
  }
  final startTime = _asDateTime(startDoc['created_at']);

  DateTime? stopTime;
  for (final d in sessionDocs.reversed) {
    if (d['status'] == 0) {
      final t = _asDateTime(d['created_at']);
      if (t != null && startTime != null && t.isAfter(startTime)) {
        stopTime = t;
        break;
      }
    }
  }

  final allSensorRows = await _withRetry(
    () => db.collection('machine_sensor_data').find().toList(),
  );

  allSensorRows.sort((a, b) {
    final ta = _sensorTimestamp(a);
    final tb = _sensorTimestamp(b);
    if (ta == null && tb == null) return 0;
    if (ta == null) return -1;
    if (tb == null) return 1;
    return ta.compareTo(tb);
  });

  final windowed = allSensorRows.where((row) {
    final t = _sensorTimestamp(row);
    if (t == null) return false;
    if (startTime != null && t.isBefore(startTime)) return false;
    if (stopTime != null && t.isAfter(stopTime)) return false;
    return true;
  }).map(_sensorRowToJson).toList();

  return {
    "found": true,
    "motor_type": motorType,
    "test_id": testId,
    "start_time": startTime?.toIso8601String(),
    "stop_time": stopTime?.toIso8601String(),
    "is_active": stopTime == null,
    "sensor_data": windowed,
  };
}

Future<Map<String, dynamic>> fetchSensorDataInRange(DateTime from, DateTime to) async {
  final machineRows = await _withRetry(
    () => db.collection('machine_data').find(where.sortBy('created_at')).toList(),
  );

  final openStarts = <String, Map<String, dynamic>>{};
  final sessions = <Map<String, dynamic>>[];

  for (final row in machineRows) {
    final motorType = row['motor_type']?.toString() ?? '';
    final testId = row['test_id']?.toString() ?? '';
    if (motorType.isEmpty || testId.isEmpty) continue;
    final key = '$motorType\u0000$testId';
    final status = row['status'];

    if (status == 1) {
      openStarts[key] = row;
    } else if (status == 0) {
      final start = openStarts.remove(key);
      if (start != null) {
        sessions.add({
          "motor_type": motorType,
          "test_id": testId,
          "machine_id": start["machine_id"],
          "operation_name": start["operation_name"],
          "start_time": _asDateTime(start["created_at"]),
          "stop_time": _asDateTime(row["created_at"]),
        });
      }
    }
  }
  for (final start in openStarts.values) {
    sessions.add({
      "motor_type": start["motor_type"],
      "test_id": start["test_id"],
      "machine_id": start["machine_id"],
      "operation_name": start["operation_name"],
      "start_time": _asDateTime(start["created_at"]),
      "stop_time": null,
    });
  }

  final matched = sessions.where((s) {
    final st = s["start_time"] as DateTime?;
    if (st == null) return false;
    return !st.isBefore(from) && !st.isAfter(to);
  }).toList()
    ..sort((a, b) => (a["start_time"] as DateTime).compareTo(b["start_time"] as DateTime));

  final allSensorRows = await _withRetry(() => db.collection('machine_sensor_data').find().toList());
  allSensorRows.sort((a, b) {
    final ta = _sensorTimestamp(a);
    final tb = _sensorTimestamp(b);
    if (ta == null && tb == null) return 0;
    if (ta == null) return -1;
    if (tb == null) return 1;
    return ta.compareTo(tb);
  });

  final combined = <Map<String, dynamic>>[];
  final seenIds = <String>{};
  for (final session in matched) {
    final st = session["start_time"] as DateTime?;
    final sp = session["stop_time"] as DateTime?;
    for (final row in allSensorRows) {
      final t = _sensorTimestamp(row);
      if (t == null) continue;
      if (st != null && t.isBefore(st)) continue;
      if (sp != null && t.isAfter(sp)) continue;
      final json = _sensorRowToJson(row);
      final id = json["id"]?.toString() ?? '';
      if (id.isNotEmpty && !seenIds.add(id)) continue;
      combined.add(json);
    }
  }
  combined.sort((a, b) {
    final ta = DateTime.tryParse(a["created_at"]?.toString() ?? '');
    final tb = DateTime.tryParse(b["created_at"]?.toString() ?? '');
    if (ta == null && tb == null) return 0;
    if (ta == null) return -1;
    if (tb == null) return 1;
    return ta.compareTo(tb);
  });

  return {
    "from": from.toIso8601String(),
    "to": to.toIso8601String(),
    "sessions": matched
        .map((s) => {
              "motor_type": s["motor_type"],
              "test_id": s["test_id"],
              "machine_id": s["machine_id"],
              "operation_name": s["operation_name"],
              "start_time": (s["start_time"] as DateTime?)?.toIso8601String(),
              "stop_time": (s["stop_time"] as DateTime?)?.toIso8601String(),
              "is_active": s["stop_time"] == null,
            })
        .toList(),
    "sensor_data": combined,
  };
}

// ------------------------------------------
// SEPARATE COLLECTION: machine_data
// ------------------------------------------
Future<Map<String, dynamic>> insertMachineRecord(
  String motorType, String machineId, String testId, String operationName, String field1, String field2, String field3, int status
) async {
  final doc = {
    "motor_type": motorType,
    "machine_id": machineId,
    "test_id": testId,
    "operation_name": operationName,
    "field_1": field1,
    "field_2": field2,
    "field_3": field3,
    "status": status,
    "created_at": DateTime.now().toUtc(),
  };

  final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

  if (!result.isSuccess) {
    print("[INSERT FAILED] machine_data insert did not succeed: $result");
    throw Exception('Database did not confirm the write (isSuccess=false) — nothing was saved.');
  }

  final insertedId = (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString();
  print("[INSERT OK] machine_data id=$insertedId motor_type=$motorType test_id=$testId status=$status");

  return {
    "success": true,
    "record": {
      "id": insertedId,
      ...doc,
      "created_at": doc["created_at"].toString(),
    },
  };
}

Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
  final rows = await _withRetry(
    () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
  );

  return rows.map((row) {
    return {
      "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
      "motor_type": row["motor_type"],
      "machine_id": row["machine_id"],
      "test_id": row["test_id"],
      "operation_name": row["operation_name"],
      "field_1": row["field_1"],
      "field_2": row["field_2"],
      "field_3": row["field_3"],
      "status": row["status"],
      "created_at": row["created_at"]?.toString(),
    };
  }).toList();
}

// ==========================================
// 5. MAIN SERVICE DRIVER Entrypoint
// ==========================================
Future<void> main() async {
  await connectDB();
  _startKeepAlive();

  final router = Router();

  router.post('/login', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      String username = body['username']?.toString() ?? '';
      String password = body['password']?.toString() ?? '';

      if (username.isEmpty || password.isEmpty) {
        return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
      }

      final result = await loginUser(username, password);
      return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.get('/get-sensor-data', (Request request) async {
    try {
      final logs = await fetchSensorDataFromDB();
      return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.get('/get-vfd-data', (Request request) async {
    try {
      final logs = await fetchVfdDataFromDB();
      return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.post('/add-machine-record', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());

      String motorType = body['motor_type']?.toString() ?? '';
      String machineId = body['machine_id']?.toString() ?? '';
      String testId = body['test_id']?.toString() ?? '';
      String operationName = body['operation_name']?.toString() ?? '';
      String field1 = body['field_1']?.toString() ?? '';
      String field2 = body['field_2']?.toString() ?? '';
      String field3 = body['field_3']?.toString() ?? '';
      int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

      if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty || field3.isEmpty) {
        return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
      }

      final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, field3, status);

      final success = result["success"] == true;
      return Response(
        success ? 201 : 500,
        body: jsonEncode(result),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      print("[/add-machine-record] Insert failed: $e");
      return Response.internalServerError(
        body: jsonEncode({"success": false, "message": e.toString()}),
        headers: {"Content-Type": "application/json"},
      );
    }
  });

  router.get('/get-machine-records', (Request request) async {
    try {
      final logs = await fetchMachineRecordsFromDB();
      return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.get('/get-machine-sessions', (Request request) async {
    try {
      final sessions = await fetchMachineSessionsFromDB();
      return Response.ok(jsonEncode(sessions), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.get('/get-session-sensor-data', (Request request) async {
    try {
      final motorType = request.url.queryParameters['motor_type'] ?? '';
      final testId = request.url.queryParameters['test_id'] ?? '';

      if (motorType.isEmpty || testId.isEmpty) {
        return Response(400, body: jsonEncode({"message": "motor_type and test_id are required"}), headers: {"Content-Type": "application/json"});
      }

      final result = await fetchSessionSensorData(motorType, testId);
      return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.get('/get-sensor-data-range', (Request request) async {
    try {
      final fromStr = request.url.queryParameters['from'] ?? '';
      final toStr = request.url.queryParameters['to'] ?? '';
      if (fromStr.isEmpty || toStr.isEmpty) {
        return Response(400, body: jsonEncode({"message": "from and to (YYYY-MM-DD) are required"}), headers: {"Content-Type": "application/json"});
      }

      DateTime parseDay(String s, {required bool endOfDay}) {
        final parts = s.split('-').map(int.parse).toList();
        return endOfDay
            ? DateTime.utc(parts[0], parts[1], parts[2], 23, 59, 59, 999)
            : DateTime.utc(parts[0], parts[1], parts[2]);
      }

      final from = parseDay(fromStr, endOfDay: false);
      final to = parseDay(toStr, endOfDay: true);

      final result = await fetchSensorDataInRange(from, to);
      return Response.ok(jsonEncode(result), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
  await io.serve(handler, '0.0.0.0', 3000);
  print("Server engine operational on http://MongoDB:3000");

  unawaited(_startRealtimeBridgeInBackground());
}

Future<void> _startRealtimeBridgeInBackground() async {
  try {
    await connectMQTT();
    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      await startMongoChangeStreamBridge();
    } else {
      print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
    }
  } catch (e) {
    print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
  }
}