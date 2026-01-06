import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../auth/bloc/auth_bloc.dart';

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _species = 'dog';
  String _size = 'medium';
  double _energyLevel = 5;
  bool _goodWithChildren = true;
  bool _goodWithPets = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitAnimal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final apiService = context.read<ApiService>();
      final authState = context.read<AuthBloc>().state;
      final shelterId =
          authState is AuthAuthenticated ? authState.user.id : null;

      print('🐾 Creating animal, shelterId: $shelterId');
      print('🐾 AuthState: $authState');

      final animalData = {
        'name': _nameController.text,
        'species': _species,
        'breed': _breedController.text,
        'age': int.parse(_ageController.text),
        'size': _size,
        'energyLevel': _energyLevel.toInt(),
        'goodWithChildren': _goodWithChildren,
        'goodWithPets': _goodWithPets,
        'description': _descriptionController.text,
        if (_imageUrlController.text.isNotEmpty)
          'imageUrl': _imageUrlController.text,
        if (shelterId != null) 'shelterId': shelterId,
      };

      print('🐾 Animal data: $animalData');

      await apiService.post('/animals', animalData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Animal'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _species,
                      decoration: const InputDecoration(
                        labelText: 'Species *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'dog', child: Text('Dog')),
                        DropdownMenuItem(value: 'cat', child: Text('Cat')),
                        DropdownMenuItem(value: 'bird', child: Text('Bird')),
                        DropdownMenuItem(
                            value: 'rabbit', child: Text('Rabbit')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) =>
                          setState(() => _species = value ?? 'dog'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _breedController,
                      decoration: const InputDecoration(
                        labelText: 'Breed *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age (years) *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (int.tryParse(value!) == null)
                          return 'Must be a number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _size,
                      decoration: const InputDecoration(
                        labelText: 'Size *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'small', child: Text('Small')),
                        DropdownMenuItem(
                            value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'large', child: Text('Large')),
                      ],
                      onChanged: (value) =>
                          setState(() => _size = value ?? 'medium'),
                    ),
                    const SizedBox(height: 16),
                    Text('Energy Level: ${_energyLevel.toInt()}/10'),
                    Slider(
                      value: _energyLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _energyLevel.toInt().toString(),
                      onChanged: (value) =>
                          setState(() => _energyLevel = value),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Good with Children'),
                      value: _goodWithChildren,
                      onChanged: (value) =>
                          setState(() => _goodWithChildren = value),
                    ),
                    SwitchListTile(
                      title: const Text('Good with Other Pets'),
                      value: _goodWithPets,
                      onChanged: (value) =>
                          setState(() => _goodWithPets = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL (optional)',
                        border: OutlineInputBorder(),
                        hintText: 'https://example.com/image.jpg',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitAnimal,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add Animal'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
