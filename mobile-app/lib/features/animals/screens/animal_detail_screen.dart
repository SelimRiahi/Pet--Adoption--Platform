import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/animal.dart';
import '../../../core/services/api_service.dart';
import '../../auth/bloc/auth_bloc.dart';

class AnimalDetailScreen extends StatefulWidget {
  final String animalId;

  const AnimalDetailScreen({super.key, required this.animalId});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  Map<String, dynamic>? _compatibility;
  bool _loadingCompatibility = false;
  Animal? _animal;
  bool _loadingAnimal = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnimal();
    _loadCompatibility();
  }

  Future<void> _loadAnimal() async {
    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.get('/animals/${widget.animalId}');
      setState(() {
        _animal = Animal.fromJson(response);
        _loadingAnimal = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingAnimal = false;
      });
    }
  }

  Future<void> _loadCompatibility() async {
    setState(() => _loadingCompatibility = true);
    try {
      final apiService = context.read<ApiService>();
      final authState = context.read<AuthBloc>().state;

      print('🔍 AuthState type: ${authState.runtimeType}');

      final userId = authState is AuthAuthenticated ? authState.user.id : null;

      print('🔍 UserId extracted: $userId');

      if (authState is AuthAuthenticated) {
        print('🔍 User object: ${authState.user}');
        print('🔍 User.id: ${authState.user.id}');
      }

      final endpoint = userId != null
          ? '/animals/${widget.animalId}/compatibility?userId=$userId'
          : '/animals/${widget.animalId}/compatibility';

      print('🔍 Calling endpoint: $endpoint');

      final response = await apiService.get(endpoint);
      setState(() {
        _compatibility = response;
        _loadingCompatibility = false;
      });
    } catch (e) {
      print('❌ Compatibility error: $e');
      setState(() => _loadingCompatibility = false);
    }
  }

  Future<void> _requestAdoption(Animal animal) async {
    try {
      final apiService = context.read<ApiService>();
      final authState = context.read<AuthBloc>().state;
      final userId = authState is AuthAuthenticated ? authState.user.id : null;

      print('📤 Requesting adoption for ${animal.name}, userId: $userId');

      final body = {
        'animalId': animal.id,
        'message': 'I would love to adopt ${animal.name}!',
      };

      if (userId != null) {
        body['userId'] = userId;
      }

      await apiService.post('/adoption-requests', body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adoption request submitted!')),
        );
        context.pop();
      }
    } catch (e) {
      print('❌ Adoption request error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal Details')),
      body: _loadingAnimal
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _animal == null
                  ? const Center(child: Text('Animal not found'))
                  : _buildAnimalDetails(_animal!),
    );
  }

  Widget _buildAnimalDetails(Animal animal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[200],
            child: animal.imageUrl != null
                ? Image.network(
                    animal.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.pets, size: 100);
                    },
                  )
                : const Icon(Icons.pets, size: 100),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and basic info
                Text(
                  animal.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${animal.breed} • ${animal.age.toInt()} years old',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                // Compatibility score
                if (_compatibility != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: _getCompatibilityColor(
                        _compatibility!['compatibility_score']),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Compatibility Score',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${_compatibility!['compatibility_score'].toStringAsFixed(1)}% - ${_compatibility!['recommendation']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (_loadingCompatibility)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                const SizedBox(height: 24),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  animal.description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Characteristics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _CharacteristicChip(
                  icon: Icons.pets,
                  label: 'Size: ${animal.size}',
                ),
                _CharacteristicChip(
                  icon: Icons.flash_on,
                  label: 'Energy: ${animal.energyLevel.toInt()}/10',
                ),
                _CharacteristicChip(
                  icon: Icons.child_care,
                  label: animal.goodWithChildren
                      ? 'Good with children'
                      : 'Not suitable for children',
                ),
                _CharacteristicChip(
                  icon: Icons.pets_outlined,
                  label: animal.goodWithPets
                      ? 'Good with other pets'
                      : 'Prefers to be alone',
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _requestAdoption(animal),
                    child: const Text('Request Adoption'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCompatibilityColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 65) return Colors.blue;
    if (score >= 45) return Colors.orange;
    return Colors.red;
  }
}

class _CharacteristicChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CharacteristicChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
