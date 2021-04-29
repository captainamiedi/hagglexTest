import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hagglex/View/Login.dart';
import 'package:hagglex/View/Signup.dart';
import 'package:hagglex/View/welcome.dart';
import 'package:hagglex/View/Verification.dart';
import 'package:hagglex/View/Dashboard.dart';
import 'package:hagglex/View/Setup.dart';

final HttpLink httpLink = HttpLink(
  uri: 'https://hagglex-backend-staging.herokuapp.com/graphql',
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: httpLink,
  ),
);
// final policies = Policies(
//   fetch: FetchPolicy.noCache,
// );
// GraphQLCache cache;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GraphQLProvider(
    child: CacheProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Welcome(),
          '/login': (context) => Login(),
          '/signup': (context) => Signup(),
          '/verification': (content) => Verification(),
          '/dashboard': (content) => Dashboard(),
          '/setup': (context) => Setup()
        },
      ),
    ),
    // ),
    client: client,
  ));
}
