import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/core/widgets/custom_text_form_field.dart';
import 'package:news_app/services/preferences_manager.dart';

class EditPersonalInfo extends StatefulWidget {
  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final prefs = PreferencesManager();

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    _nameController.text = prefs.getString(PreferenceKeys.userName) ?? '';
    _emailController.text = prefs.getString(PreferenceKeys.userEmail) ?? '';
    _phoneController.text = prefs.getString(PreferenceKeys.userPhone) ?? '';
    setState(() {});
  }

  void _saveProfile() async {
    if (formKey.currentState!.validate()) {
      await prefs.setString(PreferenceKeys.userName, _nameController.text);
      await prefs.setString(PreferenceKeys.userEmail, _emailController.text);
      await prefs.setString(PreferenceKeys.userPhone, _phoneController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Padding(
        padding: EdgeInsets.only(
          top: 24,
          right: 16,
          left: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Text(
                'Profile Info',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                hint: 'User Name',
                title: 'User Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                hint: 'name@email.com',
                title: 'Email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                hint: '010111111',
                title: 'Phone',
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveProfile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile saved successfully!')),
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
