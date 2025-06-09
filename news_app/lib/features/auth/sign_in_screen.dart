import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/core/constants/routes.dart';
import 'package:news_app/core/extensions/string_extensions.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';
import 'package:news_app/services/preferences_manager.dart';

import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null;
      _loading = true;
    });
    final prefs = PreferencesManager();
    final savedEmail = prefs.getString(PreferenceKeys.userEmail);
    final savedPassword = prefs.getString(PreferenceKeys.userPassword);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter email and password.';
        _loading = false;
      });
      return;
    }
    if (!email.isValidEmail) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
        _loading = false;
      });
      return;
    }
    if (savedEmail == null || savedPassword == null) {
      setState(() {
        _errorMessage = 'No account found. Please sign up first.';
        _loading = false;
      });
      return;
    }
    if (email != savedEmail || password != savedPassword) {
      setState(() {
        _errorMessage = 'Incorrect email or password.';
        _loading = false;
      });
      return;
    }
    await prefs.setBool(PreferenceKeys.isLoggedIn, true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(child: Image.asset('assets/images/logo.png', height: 60)),
                const SizedBox(height: 32),
                const Text(
                  'Welcome to Newst',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF363636),
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        title: 'Email',
                        controller: _emailController,
                        hint: 'username@gmail.com',
                      ),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                        title: 'Password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hint: '*************',
                      ),
                      const SizedBox(height: 8),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _errorMessage =
                                  'Password reset is not implemented in demo.';
                            });
                          },
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _signIn,
                          child:
                              _loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Sign In', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account ? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SignUpScreen()),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
