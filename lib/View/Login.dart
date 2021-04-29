import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hagglex/Utitls/form.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  bool isLoading = false;

  // Create storage
  final storage = new FlutterSecureStorage();

  String login() {
    return """
    mutation login(\$email: String!, \$password: String!) {
      login(data: {
        input: \$email,
        password: \$password,
      }) {
          user {
            _id
            email
          }
          token
        }
    }
    """;
  }

  //To Validate email
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  // To Validate Password
  String validatePassword(String value) {
    if (value.length >= 8) {
      return null;
    } else {
      return 'Min of 8 Characters';
    }
  }

  //To check fields during submit

  checkFields() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        isLoading = true;
      });
      form.save();
      return true;
    }
    return false;
  }

  // Handle Email Change
  void onChangedEmail(String value) {
    email = value;
  }

  // Handle Password Change
  void onChangedPassword(String value) {
    password = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1963),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28.0, 154.0, 41.0, 0.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60.0),
                FormFieldInput(
                    onchangedFunction: (value) => onChangedEmail(value),
                    validate: (value) => validateEmail(value),
                    label: 'Email Address',
                    errorText: 'Email is Required',
                    secureText: false),
                SizedBox(height: 20),
                FormFieldInput(
                    onchangedFunction: (value) => onChangedPassword(value),
                    validate: (value) => validatePassword(value),
                    label: 'Password (Min 8 Characters)',
                    errorText: 'Password is Required',
                    secureText: true),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forget Password?',
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    )
                  ],
                ),
                SizedBox(height: 60),
                Mutation(
                    options: MutationOptions(
                        documentNode: gql(login()),
                        fetchPolicy: FetchPolicy.noCache,
                        onCompleted: (data) async {
                          if (data != null) {
                            Navigator.pushNamed(context, '/dashboard');
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }),
                    builder: (runMutation, QueryResult result) {
                      return GestureDetector(
                        onTap: () async {
                          bool complete = await checkFields();
                          if (complete) {
                            runMutation({'email': email, 'password': password});
                            if (result.hasException) {
                              setState(() {
                                isLoading = false;
                              });
                              print('exception ${result.exception.toString()}');
                            }
                            if (result.data != null) {
                              await storage.write(
                                  key: 'token',
                                  value: result.data['login']['token']);
                              // print(result.data);
                              // print(result.data['login']['token']);
                              // print(result.data['user']);
                              // print(result.data['token']);
                            }
                          }
                        },
                        child: SizedBox(
                          child: Container(
                            height: 50.0,
                            // width: 303.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFFFC175),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLoading ? 'Please wait...' : 'LOGIN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New User? Create a new account',
                          style: TextStyle(color: Colors.white, fontSize: 11.0))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
