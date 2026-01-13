package com.petadoption.app.ui.screens.profile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.model.User
import com.petadoption.app.data.model.UpdateProfileRequest
import com.petadoption.app.data.remote.ApiClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

data class EditProfileUiState(
    val isLoading: Boolean = false,
    val user: User? = null,
    val error: String? = null,
    val success: Boolean = false
)

class EditProfileViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(EditProfileUiState())
    val uiState: StateFlow<EditProfileUiState> = _uiState

    fun loadProfile() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            try {
                val user = ApiClient.apiService.getProfile()
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    user = user
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = "Failed to load profile: ${e.message}"
                )
            }
        }
    }

    fun updateProfile(
        housingType: String?,
        availableTime: Int?,
        experience: String?,
        hasChildren: Boolean,
        hasOtherPets: Boolean,
        phoneNumber: String?,
        address: String?
    ) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            try {
                val request = UpdateProfileRequest(
                    housingType = housingType,
                    availableTime = availableTime,
                    experience = experience,
                    hasChildren = hasChildren,
                    hasOtherPets = hasOtherPets,
                    phoneNumber = phoneNumber,
                    address = address
                )
                val updatedUser = ApiClient.apiService.updateProfile(request)
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    user = updatedUser,
                    success = true
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = "Failed to update profile: ${e.message}"
                )
            }
        }
    }
}
