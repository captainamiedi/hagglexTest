import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final formKey = GlobalKey<FormState>();
  int verificationCode;
  bool isLoading = false;

  void directToSetup() {
    Navigator.pushNamed(context, '/setup');
  }

  String verifyUser() {
    return """
    mutation verifyUser(\$code: Int!) {
      verifyUser(data: {
        code: \$code,
      }) {
          user {
            email
          }
        }
    }
    """;
  }

  checkFields() async {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        isLoading = true;
      });
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1963),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.fromLTRB(43.0, 63.0, 16.0, 0.0),
              Padding(
                padding: EdgeInsets.fromLTRB(43.0, 63.0, 16.0, 0.0),
                child: Container(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset('assets/backIcon.png'),
                  ),
                  // ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                child: Column(
                  children: [
                    Text(
                      'Verify your account',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 45),
                    Card(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/verify.png'),
                            ],
                          ),
                          SizedBox(height: 40),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 52.0),
                            child: Text(
                              'We just sent a verification code to your email. Please enter the code',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Verification Code',
                                      labelStyle: TextStyle(
                                          fontSize: 12.0, color: Colors.black)),
                                  validator: (value) => value.isEmpty
                                      ? 'Enter verification code'
                                      : null,
                                  onChanged: (value) =>
                                      verificationCode = int.parse(value),
                                  onSaved: (newValue) =>
                                      verificationCode = int.parse(newValue),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Mutation(
                                    options: MutationOptions(
                                      documentNode: gql(verifyUser()),
                                      fetchPolicy: FetchPolicy.noCache,
                                      onCompleted: (data) {
                                        if (data != null) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          directToSetup();
                                        }
                                        print(data);
                                      },
                                    ),
                                    builder: (runMutation, QueryResult result) {
                                      return GestureDetector(
                                        onTap: () async {
                                          // directToSetup();
                                          bool complete = await checkFields();
                                          if (complete) {
                                            runMutation(
                                                {'code': verificationCode});
                                            if (result.hasException) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              print(
                                                  'exception ${result.exception.toString()}');
                                            }
                                          }
                                        },
                                        child: SizedBox(
                                          child: Container(
                                            height: 50.0,
                                            // width: 303.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xFF432B7B),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  isLoading
                                                      ? 'Please wait...'
                                                      : 'VERIFY ME',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                SizedBox(height: 30),
                                Text(
                                  'This code will expire in 10 minutes',
                                  style: TextStyle(
                                      fontSize: 9.0, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 50),
                                Text(
                                  'Resend Code',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
          // ],
        ),
      ),
      // ),
    );
  }
}
