import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/animal.dart';
import '../../../core/services/api_service.dart';

// Events
abstract class AnimalsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnimalsLoadRequested extends AnimalsEvent {}

class AnimalLoadRequested extends AnimalsEvent {
  final String animalId;
  AnimalLoadRequested(this.animalId);
  @override
  List<Object?> get props => [animalId];
}

// States
abstract class AnimalsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnimalsInitial extends AnimalsState {}
class AnimalsLoading extends AnimalsState {}

class AnimalsLoaded extends AnimalsState {
  final List<Animal> animals;
  AnimalsLoaded(this.animals);
  @override
  List<Object?> get props => [animals];
}

class AnimalLoaded extends AnimalsState {
  final Animal animal;
  AnimalLoaded(this.animal);
  @override
  List<Object?> get props => [animal];
}

class AnimalsError extends AnimalsState {
  final String message;
  AnimalsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  final ApiService apiService;

  AnimalsBloc({required this.apiService}) : super(AnimalsInitial()) {
    on<AnimalsLoadRequested>(_onAnimalsLoadRequested);
    on<AnimalLoadRequested>(_onAnimalLoadRequested);
  }

  Future<void> _onAnimalsLoadRequested(
    AnimalsLoadRequested event,
    Emitter<AnimalsState> emit,
  ) async {
    emit(AnimalsLoading());
    try {
      final response = await apiService.get('/animals');
      final animals = (response as List)
          .map((json) => Animal.fromJson(json))
          .toList();
      emit(AnimalsLoaded(animals));
    } catch (e) {
      emit(AnimalsError(e.toString()));
    }
  }

  Future<void> _onAnimalLoadRequested(
    AnimalLoadRequested event,
    Emitter<AnimalsState> emit,
  ) async {
    emit(AnimalsLoading());
    try {
      final response = await apiService.get('/animals/${event.animalId}');
      final animal = Animal.fromJson(response);
      emit(AnimalLoaded(animal));
    } catch (e) {
      emit(AnimalsError(e.toString()));
    }
  }
}
