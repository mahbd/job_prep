import 'package:flutter/material.dart';
import 'package:job_prep/constants.dart';

import '../widget/mac_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blueGrey[100],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Register User',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 9, 89),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                MacTextField(
                  controller: _firstNameController,
                  isLoading: _isLoading,
                  prefixIcon: const Icon(Icons.person),
                  hintText: "First Name",
                ),
                const SizedBox(height: 16),
                MacTextField(
                  controller: _emailController,
                  isLoading: _isLoading,
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email",
                ),
                const SizedBox(height: 16),
                MacTextField(
                  controller: _usernameController,
                  isLoading: _isLoading,
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Username",
                ),
                const SizedBox(height: 16),
                MacTextField(
                  controller: _passwordController,
                  isLoading: _isLoading,
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Password",
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
                const SizedBox(height: 16),
                MacTextField(
                  controller: _confirmPasswordController,
                  isLoading: _isLoading,
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Confirm Password",
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
                  onPressed: () {
                    if (_usernameController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _isLoading) {
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Register', style: TextStyle(fontSize: 20)),
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
                      'Already have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(NamedRoutes.login);
                      },
                      child: const Text(
                        ' Login',
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
