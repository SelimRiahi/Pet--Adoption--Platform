package com.petadoption.app.ui.screens.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.repository.AnimalRepository
import com.petadoption.app.data.model.Animal
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class HomeUiState(
    val isLoading: Boolean = false,
    val animals: List<Animal> = emptyList(),
    val error: String? = null
)

class HomeViewModel(
    private val animalRepository: AnimalRepository = AnimalRepository()
) : ViewModel() {

    private val _uiState = MutableStateFlow(HomeUiState())
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    init {
        loadAnimals()
    }

    fun reload() {
        loadAnimals()
    }

    fun loadAnimals() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            
            animalRepository.getAnimals().fold(
                onSuccess = { animals ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        animals = animals,
                        error = null
                    )
                },
                onFailure = { exception ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        error = exception.message ?: "Failed to load animals"
                    )
                }
            )
        }
    }

    fun refresh() {
        loadAnimals()
    }
}
