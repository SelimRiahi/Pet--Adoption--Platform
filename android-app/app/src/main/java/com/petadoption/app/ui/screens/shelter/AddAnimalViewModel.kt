package com.petadoption.app.ui.screens.shelter

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.model.CreateAnimalRequest
import com.petadoption.app.data.remote.ApiClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class AddAnimalUiState(
    val isLoading: Boolean = false,
    val success: Boolean = false,
    val error: String? = null
)

class AddAnimalViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(AddAnimalUiState())
    val uiState: StateFlow<AddAnimalUiState> = _uiState.asStateFlow()

    fun addAnimal(
        name: String,
        species: String,
        breed: String,
        age: Int,
        size: String,
        energyLevel: Int,
        description: String,
        goodWithChildren: Boolean,
        goodWithPets: Boolean
    ) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)

            try {
                val request = CreateAnimalRequest(
                    name = name,
                    species = species,
                    breed = breed,
                    age = age,
                    gender = "male", // Default
                    size = size,
                    description = description,
                    energyLevel = energyLevel,
                    goodWithChildren = goodWithChildren,
                    goodWithPets = goodWithPets
                )

                ApiClient.apiService.createAnimal(request)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    success = true
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message ?: "Failed to add animal"
                )
            }
        }
    }
}
