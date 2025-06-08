import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/core/constants/routes.dart';
import 'package:news_app/features/profile/bottom_sheets/country_picker_bottom_sheet.dart';
import 'package:news_app/features/profile/bottom_sheets/language_picker_bottom_sheet.dart';
import 'package:news_app/features/profile/models/country_model.dart';
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
    if(selectedLanguage != null){
      prefs.setString(PreferenceKeys.selectedLanguage, selectedLanguage.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile Info'),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text('Personal Info'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Icon(Icons.navigate_next),
            onTap: () => _openLanguagePicker(context),
          ),
          ListTile(
            leading: Icon(Icons.flag_outlined),
            title: Text('Country'),
            trailing: Icon(Icons.navigate_next),
            onTap: () => _openCountryPicker(context),
          ),
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
    );
  }
}
