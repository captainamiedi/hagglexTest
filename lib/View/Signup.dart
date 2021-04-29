import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hagglex/Utitls/form.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool phoneNumberIsValid = false;
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  final TextEditingController controller = TextEditingController();
  String email, password, username, refCode, phonenumber;

  Map userData = {
    'email': "",
    'password': '',
    'username': '',
    'phone_no': '',
    'ref_code': ''
  };

  String register() {
    return """
    mutation register(\$email: String!, \$password: String!, \$username: String!,
      \$phonenumber: String!, \$country: String!, \$currency: String!, \$referralCode: String
    ) {
      register(data: {
        email: \$email,
        password: \$password,
        username: \$username,
        phonenumber: \$phonenumber, 
        country: \$country, 
        currency: \$currency,
        referralCode: \$referralCode
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

  void directToVerification() {
    Navigator.pushNamed(context, '/verification');
  }

  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1963),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Card(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Create a new account',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle:
                                TextStyle(fontSize: 12.0, color: Colors.black)),
                        validator: (value) => value.isEmpty
                            ? 'Enter your Email'
                            : validateEmail(value),
                        onChanged: (value) => email = value,
                        onSaved: (newValue) => email = newValue,
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password (Min 8 characters)',
                            labelStyle:
                                TextStyle(fontSize: 12.0, color: Colors.black)),
                        obscureText: true,
                        validator: (value) =>
                            value.isEmpty ? 'Enter Password' : null,
                        onChanged: (value) => password = value,
                        onSaved: (newValue) => password = newValue,
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Create a Username',
                            labelStyle:
                                TextStyle(fontSize: 12.0, color: Colors.black)),
                        validator: (value) =>
                            value.isEmpty ? 'Enter your username' : null,
                        onChanged: (value) => username = value,
                        onSaved: (newValue) => username = newValue,
                      ),
                      SizedBox(height: 30),
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          phonenumber = number.phoneNumber;
                        },
                        onInputValidated: (bool value) {
                          // print(value);
                          setState(() {
                            phoneNumberIsValid = value;
                          });
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          backgroundColor: Color(0xFF2E1963),
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: controller,
                        formatInput: false,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        // inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                          phonenumber = number as String;
                        },
                        hintText: 'Enter your phone number',
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Referral code (optional)',
                            labelStyle: TextStyle(
                                fontSize: 12.0, color: Colors.black45)),
                        onChanged: (value) => refCode = value,
                        onSaved: (newValue) => refCode = newValue,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'By signing, you agree to Hagglex terms and privacy policy',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 60),
                      Mutation(
                          options: MutationOptions(
                            documentNode: gql(register()),
                            fetchPolicy: FetchPolicy.noCache,
                            onCompleted: (data) {
                              // print(data);
                              setState(() {
                                isLoading = false;
                              });
                              directToVerification();
                            },
                          ),
                          builder: (runMutation, QueryResult result) {
                            return GestureDetector(
                              onTap: () async {
                                bool complete = await checkFields();
                                if (complete && phoneNumberIsValid) {
                                  runMutation({
                                    'email': email,
                                    'password': password,
                                    'username': username,
                                    'phonenumber': phonenumber,
                                    'country': 'Nigeria',
                                    'currency': 'NGN',
                                    'referralCode': refCode
                                  });
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
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFF432B7B),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isLoading
                                            ? 'Please wait...'
                                            : 'SIGN UP',
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
                      SizedBox(height: 50),
                    ],
                  ),
                )),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
    // );
  }
}
