package com.petadoption.app.ui.screens.requests

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.model.AdoptionRequest
import com.petadoption.app.data.remote.ApiClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class AdoptionRequestsUiState(
    val isLoading: Boolean = false,
    val requests: List<AdoptionRequest> = emptyList(),
    val error: String? = null
)

class AdoptionRequestsViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(AdoptionRequestsUiState())
    val uiState: StateFlow<AdoptionRequestsUiState> = _uiState.asStateFlow()

    init {
        loadRequests()
    }

    fun reload() {
        loadRequests()
    }

    fun loadRequests() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)

            try {
                val requests = ApiClient.apiService.getMyAdoptionRequests()

                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    requests = requests
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message ?: "Failed to load requests"
                )
            }
        }
    }
}
