import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/features/profile/models/language_model.dart';
import 'package:news_app/services/preferences_manager.dart';

class LanguagePickerBottomSheet extends StatefulWidget {
  final String? selectedCode;

  const LanguagePickerBottomSheet({super.key, this.selectedCode});

  @override
  State<LanguagePickerBottomSheet> createState() =>
      _LanguagePickerBottomSheetState();
}

class _LanguagePickerBottomSheetState extends State<LanguagePickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final PreferencesManager prefs = PreferencesManager();

  late List<Language> _filteredLanguages;
  String? _selectedLanguageCode;

  final List<Language> _languages = [
    Language('English', 'en'),
    Language('Arabic', 'ar'),
    Language('French', 'fr'),
    Language('German', 'de'),
    Language('Spanish', 'es'),
    Language('Hindi', 'hi'),
    Language('Japanese', 'ja'),
    Language('Chinese', 'zh'),
    Language('Russian', 'ru'),
    Language('Portuguese', 'pt'),
  ];

  @override
  void initState() {
    super.initState();
    _filteredLanguages = _languages;
    _selectedLanguageCode =
        widget.selectedCode ?? prefs.getString(PreferenceKeys.selectedLanguage);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLanguages = _languages
          .where((lang) => lang.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _selectLanguage(String languageCode) {
    prefs.setString(PreferenceKeys.selectedLanguage, languageCode);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for a language',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredLanguages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final curlanguage = _filteredLanguages[index];
                  return ListTile(
                    title: Text(curlanguage.name, style: theme.bodyMedium),
                    trailing: Radio<String>(
                      value: curlanguage.code,
                      groupValue: _selectedLanguageCode,
                      onChanged: (_) {
                        _selectedLanguageCode = curlanguage.code;
                        setState(() { 
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLanguageCode != null) {
                    _selectLanguage(_selectedLanguageCode!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language saved successfully!')),
                    );
                  }
              
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
