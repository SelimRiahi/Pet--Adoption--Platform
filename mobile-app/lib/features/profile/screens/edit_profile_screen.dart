import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _housingType = 'apartment';
  double _availableTime = 5;
  String? _experience = 'none';
  bool _hasChildren = false;
  bool _hasOtherPets = false;

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            ProfileUpdateRequested({
              'housingType': _housingType,
              'availableTime': _availableTime,
              'experience': _experience,
              'hasChildren': _hasChildren,
              'hasOtherPets': _hasOtherPets,
            }),
          );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tell us about your lifestyle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _housingType,
                decoration: const InputDecoration(labelText: 'Housing Type'),
                items: const [
                  DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                  DropdownMenuItem(value: 'house_small', child: Text('Small House')),
                  DropdownMenuItem(value: 'house_large', child: Text('Large House')),
                ],
                onChanged: (value) => setState(() => _housingType = value),
              ),
              const SizedBox(height: 16),
              Text('Available Time: ${_availableTime.toInt()} hours/day'),
              Slider(
                value: _availableTime,
                min: 0,
                max: 10,
                divisions: 10,
                label: '${_availableTime.toInt()} hours',
                onChanged: (value) => setState(() => _availableTime = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _experience,
                decoration: const InputDecoration(labelText: 'Experience with Pets'),
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('No Experience')),
                  DropdownMenuItem(value: 'some', child: Text('Some Experience')),
                  DropdownMenuItem(value: 'expert', child: Text('Expert')),
                ],
                onChanged: (value) => setState(() => _experience = value),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('I have children'),
                value: _hasChildren,
                onChanged: (value) => setState(() => _hasChildren = value),
              ),
              SwitchListTile(
                title: const Text('I have other pets'),
                value: _hasOtherPets,
                onChanged: (value) => setState(() => _hasOtherPets = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
