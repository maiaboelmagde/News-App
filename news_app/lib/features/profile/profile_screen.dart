import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/core/constants/routes.dart';
import 'package:news_app/core/extensions/string_extensions.dart';
import 'package:news_app/features/profile/widgets/country_picker_bottom_sheet.dart';
import 'package:news_app/features/profile/widgets/language_picker_bottom_sheet.dart';
import 'package:news_app/features/profile/models/country_model.dart';
import 'package:news_app/features/profile/widgets/profile_image_widget.dart';
import 'package:news_app/features/terms_and_conditions/terms_and_condtions_screen.dart';
import 'package:news_app/services/preferences_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static final prefs = PreferencesManager();

  void _openCountryPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CountryPickerBottomSheet(),
    );
    if (selected != null) {
      prefs.setString(PreferenceKeys.selectedCountry, selected.code);
    }
  }

  void _openLanguagePicker(context) async {
    final selectedLanguage = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const LanguagePickerBottomSheet(),
    );
    if (selectedLanguage != null) {
      prefs.setString(PreferenceKeys.selectedLanguage, selectedLanguage.code);
    }
  }

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    ProfileImageWidget(),
                    SizedBox(height: 8),
                    Text(
                      prefs.getString(PreferenceKeys.userName) ??
                      prefs.getString(PreferenceKeys.userEmail)?.extractNameFromEmail ??
                      'userName',
                    ),
                  ],
                ),
              ),
            ),
            
            Text('Profile Info'),
            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text('Personal Info'),
              trailing: Icon(Icons.navigate_next),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              trailing: Icon(Icons.navigate_next),
              onTap: () => _openLanguagePicker(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.flag_outlined),
              title: Text('Country'),
              trailing: Icon(Icons.navigate_next),
              onTap: () => _openCountryPicker(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.list_alt_outlined),
              title: Text('Terms & Conditions'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              trailing: Icon(Icons.navigate_next),
              onTap: () async {
                prefs.setBool(PreferenceKeys.isLoggedIn, false);
                Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}
