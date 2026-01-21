// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/testing.dart';
// import 'package:ipo_lens/features/open-ipos/Provider/open_ipos_provider.dart';
// import 'package:ipo_lens/main.dart';
// import 'package:ipo_lens/utils/consts/app_preference.dart';
// import 'package:ipo_lens/utils/theme/theme_provider.dart';
// import 'package:ipo_lens/utils/providers/bottom_nav_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   testWidgets('App boots to Open IPOs tab', (WidgetTester tester) async {
//     TestWidgetsFlutterBinding.ensureInitialized();
//     SharedPreferences.setMockInitialValues({});
//     await AppPreference.initMySharedPreferences();

//     final client = MockClient((request) async {
//       final body = jsonEncode({
//         'success': true,
//         'status_code': 200,
//         'message': 'ok',
//         'timestamp': null,
//         'data': {
//           'endpoint': request.url.toString(),
//           'total_records': 0,
//           'data': <dynamic>[],
//         },
//       });

//       return http.Response(
//         body,
//         200,
//         headers: const {'content-type': 'application/json'},
//       );
//     });

//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => ThemeProvider()),
//           ChangeNotifierProvider(create: (_) => BottomNavProvider()),
//           Provider<http.Client>(
//             create: (_) => client,
//             dispose: (_, c) => c.close(),
//           ),
//           ChangeNotifierProvider(
//             create: (context) => OpenIposProvider(
//               client: context.read<http.Client>(),
//               baseUrl: 'http://example.com',
//             ),
//           ),
//         ],
//         child: const MyApp(),
//       ),
//     );

//     await tester.pumpAndSettle();
//     expect(find.text('Open IPOs'), findsOneWidget);
//   });
// }
