import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../../auth/bloc/auth_bloc.dart';

class AdoptionRequestsScreen extends StatefulWidget {
  const AdoptionRequestsScreen({super.key});

  @override
  State<AdoptionRequestsScreen> createState() => _AdoptionRequestsScreenState();
}

class _AdoptionRequestsScreenState extends State<AdoptionRequestsScreen> {
  List<dynamic> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _loading = true);
    try {
      final apiService = context.read<ApiService>();
      final authState = context.read<AuthBloc>().state;
      final userId = authState is AuthAuthenticated ? authState.user.id : null;

      // Send userId as query parameter so backend knows which user's requests to fetch
      final endpoint = userId != null
          ? '/adoption-requests?userId=$userId'
          : '/adoption-requests';
      final response = await apiService.get(endpoint);

      setState(() {
        _requests = response;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
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
      appBar: AppBar(title: const Text('My Adoption Requests')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? const Center(child: Text('No adoption requests yet'))
              : RefreshIndicator(
                  onRefresh: _loadRequests,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final request = _requests[index];
                      final animal = request[
                          'animalId']; // Backend returns 'animalId' not 'animal'
                      final status = request['status'];
                      final score = request['compatibilityScore'];

                      // Skip if animal data is missing
                      if (animal == null) {
                        return const SizedBox.shrink();
                      }

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
                                    child: Text(
                                      animal['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _StatusChip(status: status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  '${animal['breed'] ?? 'Unknown'} • ${animal['age'] ?? '?'} years'),
                              if (score != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                        'Compatibility: ${score.toStringAsFixed(0)}%'),
                                  ],
                                ),
                              ],
                              if (request['shelterNotes'] != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Notes: ${request['shelterNotes']}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
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
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
