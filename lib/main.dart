import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hagglex/View/Login.dart';
import 'package:hagglex/View/Signup.dart';
import 'package:hagglex/View/welcome.dart';
import 'package:hagglex/View/Verification.dart';
import 'package:hagglex/View/Dashboard.dart';
import 'package:hagglex/View/Setup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
//
// Create storage
final storage = new FlutterSecureStorage();

final HttpLink httpLink = HttpLink(
  uri: 'https://hagglex-backend-staging.herokuapp.com/graphql',
  headers: <String, String>{
    'Authorization': 'Bearer $tokenLink()',
  },
);

Future<String> tokenLink() async {
  // Read Token
  String value = await storage.read(key: 'token');
  return value;
}

setToken() {
  Future<String> token = tokenLink();
  if (token != null) {
    print(token);
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
      // OR
      // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    );
    final Link link = authLink.concat(httpLink);
    return link;
  } else
    return httpLink;
}

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
