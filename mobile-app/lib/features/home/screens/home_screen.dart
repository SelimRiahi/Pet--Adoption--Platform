import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/animal.dart';
import '../../animals/bloc/animals_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AnimalsBloc>().add(AnimalsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Adoption'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/recommendations'),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => context.push('/adoption-requests'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: BlocBuilder<AnimalsBloc, AnimalsState>(
        builder: (context, state) {
          if (state is AnimalsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnimalsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is AnimalsLoaded) {
            final animals = state.animals;

            if (animals.isEmpty) {
              return const Center(child: Text('No animals available'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AnimalsBloc>().add(AnimalsLoadRequested());
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  final animal = animals[index];
                  return _AnimalCard(animal: animal);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final Animal animal;

  const _AnimalCard({required this.animal});

  String _getEnergyIcon(double energyLevel) {
    if (energyLevel >= 8) {
      return '⚡⚡⚡';
    } else if (energyLevel >= 5) {
      return '⚡⚡';
    } else {
      return '⚡';
    }
  }

  Color _getSizeColor(String size) {
    switch (size.toLowerCase()) {
      case 'small':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'large':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.push('/animal/${animal.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey[300]!, Colors.grey[100]!],
                      ),
                    ),
                    child: animal.imageUrl != null
                        ? Image.network(
                            animal.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.pets,
                                    size: 50, color: Colors.grey),
                              );
                            },
                          )
                        : const Center(
                            child:
                                Icon(Icons.pets, size: 50, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10 : 8,
                          vertical: isTablet ? 6 : 4),
                      decoration: BoxDecoration(
                        color: _getSizeColor(animal.size),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        animal.size.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 12 : 10,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            const Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.name,
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isTablet ? 6 : 4),
                        Text(
                          animal.breed,
                          style: TextStyle(
                            fontSize: isTablet ? 15 : 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cake,
                                size: isTablet ? 16 : 14,
                                color: Colors.grey[600]),
                            SizedBox(width: isTablet ? 6 : 4),
                            Text(
                              '${animal.age.toInt()} yrs',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _getEnergyIcon(animal.energyLevel),
                          style: TextStyle(fontSize: isTablet ? 14 : 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
