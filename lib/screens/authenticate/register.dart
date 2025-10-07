import 'package:flutter/material.dart';
import 'package:straysave/services/auth.dart';
import 'package:straysave/shared/constant.dart';
import 'package:straysave/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  final AuthService? authService;
  const Register({super.key, required this.toggleView, this.authService});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final AuthService _auth;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String username = '';
  String email = '';
  String phone = '';
  String password = '';
  String error = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String confirmPassword = '';
  String confirmError = '';

  @override
  void initState() {
    super.initState();
    _auth = widget.authService ?? AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Color(0xFFF8F9FA),
              elevation: 0.0,
              title: Text('Create Account'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Username',
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter a username'
                              : null,
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Email Address',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter an email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                              return 'Email not valid';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Phone Number',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter a phone number';
                            }
                            if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(val)) {
                              return 'Phone number not valid';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => phone = val);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              key: Key('passwordToggle'),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter a password';
                            }
                            if (val.length < 6) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Confirm Password',
                            suffixIcon: IconButton(
                              key: Key('conPasswordToggle'),
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Confirm your password';
                            }
                            if (val != password) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => confirmPassword = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Register'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              debugPrint(email);
                              debugPrint(password);
                              dynamic result = await _auth
                                  .registerWithEmailAndPassword(
                                    username,
                                    email,
                                    password,
                                    phone,
                                  );
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not register with those credentials';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                              ),
                              child: Text('Log in'),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
