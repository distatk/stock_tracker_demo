import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TestUtils {
  static QueryResult createMockQueryResponse({
    required String queryCharacterNames,
    required Map<String, dynamic>? data,
    bool isLoading = false,
    String? errorMessage,
  }) {
    final options = QueryOptions(
      document: gql(queryCharacterNames),
    );
    return QueryResult(
      options: options,
      source: isLoading ? QueryResultSource.loading : QueryResultSource.network,
      data: data,
      exception: errorMessage != null
          ? OperationException(
              graphqlErrors: [
                GraphQLError(message: errorMessage),
              ],
            )
          : null,
    );
  }

  static void setScreenSize(
    WidgetTester tester,
    double width,
    double height,
    double pixelDensity,
  ) {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = pixelDensity;

    addTearDown(() => clearScreenSize(tester));
  }

  static void clearScreenSize(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  static void setScreenSizePhone(
    WidgetTester tester, {
    bool landscape = false,
  }) {
    landscape
        ? setScreenSize(tester, 2400, 1080, 3)
        : setScreenSize(tester, 1080, 2400, 3);
  }

  static Future<void> pumpWidget(
    WidgetTester tester,
    Widget widget, {
    List<NavigatorObserver>? navigators,
    List<SingleChildWidget>? providers,
    bool pumpOnce = false,
  }) async {
    await loadAppFonts();
    final observers = navigators ?? <NavigatorObserver>[];
    // Fake provider
    final actualProviders =
        providers ?? <Provider>[Provider<int>.value(value: 1)];

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: actualProviders,
          child: MaterialApp(
            home: Scaffold(body: widget),
            navigatorObservers: observers,
            onGenerateRoute: (settings) => MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => Container(),
            ),
          ),
        ),
      );
      if (pumpOnce) {
        await tester.pump();
      } else {
        await tester.pumpAndSettle();
      }
    });
  }
}
