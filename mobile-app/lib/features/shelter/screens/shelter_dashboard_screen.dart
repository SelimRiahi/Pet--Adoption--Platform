import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../auth/bloc/auth_bloc.dart';

class ShelterDashboardScreen extends StatefulWidget {
  const ShelterDashboardScreen({super.key});

  @override
  State<ShelterDashboardScreen> createState() => _ShelterDashboardScreenState();
}

class _ShelterDashboardScreenState extends State<ShelterDashboardScreen> {
  List<dynamic> _requests = [];
  List<dynamic> _animals = [];
  bool _loading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final apiService = context.read<ApiService>();
      final authState = context.read<AuthBloc>().state;

      if (authState is AuthAuthenticated) {
        final shelterId = authState.user.id;
        print('🏠 Loading data for shelter: $shelterId');

        // Load adoption requests for this shelter's animals
        final requestsResponse =
            await apiService.get('/adoption-requests/shelter/$shelterId');
        print('📋 Requests response: $requestsResponse');

        // Load animals belonging to this shelter
        final animalsResponse =
            await apiService.get('/animals/shelter/$shelterId');
        print('🐾 Animals response: $animalsResponse');

        setState(() {
          _requests = requestsResponse is List ? requestsResponse : [];
          _animals = animalsResponse is List ? animalsResponse : [];
          _loading = false;
        });

        print(
            '✅ Loaded ${_requests.length} requests and ${_animals.length} animals');
      }
    } catch (e) {
      print('❌ Error loading shelter data: $e');
      setState(() {
        _requests = [];
        _animals = [];
        _loading = false;
      });
    }
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    try {
      final apiService = context.read<ApiService>();
      final authState = context.read<AuthBloc>().state;
      final shelterId =
          authState is AuthAuthenticated ? authState.user.id : null;

      print('📝 Updating request $requestId to $status, shelterId: $shelterId');
      print('📝 AuthState: $authState');

      await apiService.patch('/adoption-requests/$requestId/status', {
        'status': status,
        if (shelterId != null) 'shelterId': shelterId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request ${status}!')),
        );
        _loadData(); // Reload data
      }
    } catch (e) {
      print('❌ Error updating request: $e');
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
      appBar: AppBar(
        title: const Text('Shelter Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tab selector
                Container(
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedTab == 0
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTab == 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'Adoption Requests (${_requests.length})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: _selectedTab == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTab == 1
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'My Animals (${_animals.length})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: _selectedTab == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _selectedTab == 0
                      ? _buildRequestsList()
                      : _buildAnimalsList(),
                ),
              ],
            ),
      floatingActionButton: _selectedTab == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push('/add-animal').then((_) => _loadData());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Animal'),
            )
          : null,
    );
  }

  Widget _buildRequestsList() {
    if (_requests.isEmpty) {
      return const Center(child: Text('No adoption requests yet'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          final animal = request['animalId'];
          final user = request['userId'];
          final status = request['status'];
          final score = request['compatibilityScore'];

          if (animal == null) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              animal['name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Requested by: ${user?['name'] ?? 'Unknown'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(status: status),
                    ],
                  ),
                  if (score != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text('Compatibility: ${score.toStringAsFixed(0)}%'),
                      ],
                    ),
                  ],
                  if (status == 'pending') ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _updateRequestStatus(
                                request['_id'], 'approved'),
                            icon: const Icon(Icons.check),
                            label: const Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateRequestStatus(
                                request['_id'], 'rejected'),
                            icon: const Icon(Icons.close),
                            label: const Text('Reject'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimalsList() {
    if (_animals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No animals yet'),
            SizedBox(height: 8),
            Text(
              'Add your first animal using the + button',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _animals.length,
        itemBuilder: (context, index) {
          final animal = _animals[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: animal['imageUrl'] != null
                      ? Image.network(
                          animal['imageUrl'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: Icon(Icons.pets, size: 48)),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animal['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${animal['breed']} • ${animal['age']} years',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: animal['status'] == 'available'
                              ? Colors.green[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          animal['status'] ?? 'unknown',
                          style: TextStyle(
                            fontSize: 10,
                            color: animal['status'] == 'available'
                                ? Colors.green[800]
                                : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
