import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/core/constants/routes.dart';
import 'package:news_app/core/extensions/string_extensions.dart';
import 'package:news_app/features/profile/widgets/country_picker_bottom_sheet.dart';
import 'package:news_app/features/profile/widgets/edit_personal_info.dart';
import 'package:news_app/features/profile/widgets/language_picker_bottom_sheet.dart';
import 'package:news_app/features/profile/models/country_model.dart';
import 'package:news_app/features/profile/widgets/profile_image_widget.dart';
import 'package:news_app/features/terms_and_conditions/terms_and_condtions_screen.dart';
import 'package:news_app/services/preferences_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static final prefs = PreferencesManager();

  //TODO: create showModalBottomSheet widget

  void _openCountryPicker(BuildContext context) async {
    await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CountryPickerBottomSheet(),
    );
  }

  void _openLanguagePicker(context) async {
     await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const LanguagePickerBottomSheet(),
    );
  }

  _openPersonalInfoEdit(context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditPersonalInfo(),
    );
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
                          prefs
                              .getString(PreferenceKeys.userEmail)
                              ?.extractNameFromEmail ??
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
              onTap: ()=>_openPersonalInfoEdit(context),
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
              leading: Icon(Icons.logout,color: Theme.of(context).primaryColor,),
              title: Text('Log out',style: TextStyle(color: Theme.of(context).primaryColor),),
              trailing: Icon(Icons.navigate_next,color: Theme.of(context).primaryColor,),
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
