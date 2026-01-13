package com.petadoption.app.ui.screens.animal

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.repository.AnimalRepository
import com.petadoption.app.data.repository.AdoptionRequestRepository
import com.petadoption.app.data.model.Animal
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class AnimalDetailUiState(
    val isLoading: Boolean = false,
    val animal: Animal? = null,
    val compatibilityScore: Double? = null,
    val error: String? = null,
    val isSubmitting: Boolean = false,
    val adoptionSuccess: Boolean = false
)

class AnimalDetailViewModel(
    private val animalRepository: AnimalRepository = AnimalRepository(),
    private val adoptionRepository: AdoptionRequestRepository = AdoptionRequestRepository()
) : ViewModel() {

    private val _uiState = MutableStateFlow(AnimalDetailUiState())
    val uiState: StateFlow<AnimalDetailUiState> = _uiState.asStateFlow()

    fun loadAnimal(id: String) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            
            animalRepository.getAnimalById(id).fold(
                onSuccess = { animal ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        animal = animal
                    )
                    // Calculate AI compatibility
                    calculateCompatibility(id)
                },
                onFailure = { exception ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        error = exception.message ?: "Failed to load animal"
                    )
                }
            )
        }
    }
    
    private fun calculateCompatibility(animalId: String) {
        viewModelScope.launch {
            try {
                val response = com.petadoption.app.data.remote.ApiClient.apiService.getAnimalCompatibility(animalId)
                _uiState.value = _uiState.value.copy(
                    compatibilityScore = response.compatibility_score
                )
            } catch (e: Exception) {
                // Silently fail - compatibility is optional
                println("Failed to calculate compatibility: ${e.message}")
            }
        }
    }

    fun submitAdoptionRequest(animalId: String, message: String) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isSubmitting = true)
            
            adoptionRepository.createAdoptionRequest(animalId, message).fold(
                onSuccess = {
                    _uiState.value = _uiState.value.copy(
                        isSubmitting = false,
                        adoptionSuccess = true
                    )
                },
                onFailure = { exception ->
                    _uiState.value = _uiState.value.copy(
                        isSubmitting = false,
                        error = exception.message ?: "Failed to submit adoption request"
                    )
                }
            )
        }
    }
}
