import 'package:flutter/material.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/features/profile/models/country_model.dart';
import 'package:news_app/services/preferences_manager.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  final String? selectedCode;

  const CountryPickerBottomSheet({super.key, this.selectedCode});

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<Country> _filteredCountries;
  final prefs = PreferencesManager();
  String? _selectedCountryCode;

  final List<Country> _countries = [
    Country('Egypt', 'EG'),
    Country('United States', 'US'),
    Country('United Kingdom', 'GB'),
    Country('France', 'FR'),
    Country('Germany', 'DE'),
    Country('Saudi Arabia', 'SA'),
    Country('Japan', 'JP'),
    Country('India', 'IN'),
    Country('Canada', 'CA'),
    Country('Brazil', 'BR'),
  ];

  @override
  void initState() {
    super.initState();
    _filteredCountries = _countries;
    _selectedCountryCode =
        widget.selectedCode ?? prefs.getString(PreferenceKeys.selectedCountry);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _countries
          .where((c) => c.name.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _selectCountry(String countryCode) async {
    await prefs.setString(PreferenceKeys.selectedCountry, countryCode);
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for a country',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(country.name, style: theme.bodyMedium),
                      trailing: Radio<String>(
                        value: country.code,
                        groupValue: _selectedCountryCode,
                        onChanged: (_) {
                          _selectedCountryCode = country.code;
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedCountryCode != null) {
                    _selectCountry(_selectedCountryCode!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Country saved successfully!')),
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
