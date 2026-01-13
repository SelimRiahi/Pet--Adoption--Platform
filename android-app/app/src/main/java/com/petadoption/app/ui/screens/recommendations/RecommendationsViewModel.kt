package com.petadoption.app.ui.screens.recommendations

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.model.Animal
import com.petadoption.app.data.remote.ApiClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class Recommendation(
    val animal: Animal,
    @SerialName("compatibility_score")
    val compatibilityScore: Double,
    val recommendation: String? = null
)

@Serializable
data class RecommendationsResponse(
    val predictions: List<Recommendation>
)

data class RecommendationsUiState(
    val isLoading: Boolean = false,
    val recommendations: List<Recommendation> = emptyList(),
    val error: String? = null
)

class RecommendationsViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(RecommendationsUiState())
    val uiState: StateFlow<RecommendationsUiState> = _uiState.asStateFlow()

    init {
        loadRecommendations()
    }

    fun loadRecommendations() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            
            try {
                val response = ApiClient.apiService.getRecommendations()
                
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    recommendations = response.predictions
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message ?: "Failed to load recommendations"
                )
            }
        }
    }
}
