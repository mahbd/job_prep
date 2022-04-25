import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_prep/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/mac_text_field.dart';
import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  Future<bool> login(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$api/token/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (res.statusCode == 200) {
        final response = jsonDecode(res.body);
        String access = response['access'];
        String refresh = response['refresh'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('access', access);
        prefs.setString('refresh', refresh);
        return true;
      } else {
        if (res.statusCode == 401) {
          setState(() {
            errors = 'Invalid username or password';
          });
        } else {
          setState(() {
            errors = 'Error logging in(${res.statusCode})';
          });
        }
      }
    } catch (e) {
      errors = 'Something went wrong';
    }
    return false;
  }

  String? errors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Container(
          height: 350,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blueGrey[100],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login User',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 9, 89),
                  ),
                ),
                const SizedBox(height: 16),
                // const Text('Username:', style: TextStyle(fontSize: 16)),
                MacTextField(
                  controller: _usernameController,
                  isLoading: _isLoading,
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                MacTextField(
                  controller: _passwordController,
                  isLoading: _isLoading,
                  hintText: 'Password',
                  errorText: errors,
                  prefixIcon: const Icon(Icons.lock),
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),
                MaterialButton(
                  onPressed: () async {
                    if (_usernameController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _isLoading) {
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    bool response = await login(
                        _usernameController.text, _passwordController.text);
                    setState(() {
                      _isLoading = false;
                    });
                    if (response) {
                      Navigator.pushReplacementNamed(context, NamedRoutes.home);
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Login', style: TextStyle(fontSize: 20)),
                  color: const Color.fromARGB(255, 0, 26, 255),
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, NamedRoutes.forgotPassword);
                      },
                      child: const Text(
                        ' Reset Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, NamedRoutes.register);
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
