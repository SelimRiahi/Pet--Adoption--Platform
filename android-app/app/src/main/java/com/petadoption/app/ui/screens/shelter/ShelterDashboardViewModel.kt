package com.petadoption.app.ui.screens.shelter

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.model.AdoptionRequest
import com.petadoption.app.data.model.Animal
import com.petadoption.app.data.model.User
import com.petadoption.app.data.remote.ApiClient
import com.petadoption.app.data.repository.UpdateAdoptionStatusDto
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class ShelterDashboardUiState(
    val isLoading: Boolean = false,
    val requests: List<AdoptionRequest> = emptyList(),
    val animals: List<Animal> = emptyList(),
    val currentUser: User? = null,
    val error: String? = null
)

class ShelterDashboardViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(ShelterDashboardUiState())
    val uiState: StateFlow<ShelterDashboardUiState> = _uiState.asStateFlow()

    init {
        loadData()
    }

    fun loadData() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)

            try {
                // First get current user to get shelter ID
                val user = ApiClient.apiService.getProfile()
                val shelterId = user.id

                // Load adoption requests for this shelter
                val requests = ApiClient.apiService.getShelterAdoptionRequestsByShelter(shelterId)

                // Load animals belonging to this shelter
                val animals = ApiClient.apiService.getAnimalsByShelter(shelterId)

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    requests = requests,
                    animals = animals,
                    currentUser = user
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message ?: "Failed to load data"
                )
            }
        }
    }

    fun updateRequestStatus(requestId: String, status: String) {
        viewModelScope.launch {
            try {
                ApiClient.apiService.updateAdoptionStatus(
                    requestId,
                    UpdateAdoptionStatusDto(status)
                )

                // Reload data to reflect changes
                loadData()
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "Failed to update request"
                )
            }
        }
    }
}
