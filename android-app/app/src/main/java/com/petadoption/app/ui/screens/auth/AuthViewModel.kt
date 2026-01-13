package com.petadoption.app.ui.screens.auth

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.petadoption.app.data.model.User
import com.petadoption.app.data.remote.ApiClient
import com.petadoption.app.data.repository.AuthRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class AuthUiState(
    val isLoading: Boolean = false,
    val isAuthenticated: Boolean = false,
    val user: User? = null,
    val error: String? = null
)

class AuthViewModel(
    private val authRepository: AuthRepository = AuthRepository()
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(AuthUiState())
    val uiState: StateFlow<AuthUiState> = _uiState.asStateFlow()
    
    fun login(email: String, password: String) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            
            val result = authRepository.login(email, password)
            result.fold(
                onSuccess = { authResponse ->
                    ApiClient.setAuthToken(authResponse.access_token)
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        isAuthenticated = true,
                        user = authResponse.user,
                        error = null
                    )
                },
                onFailure = { exception ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        error = exception.message ?: "Login failed"
                    )
                }
            )
        }
    }
    
    fun register(email: String, password: String, name: String, role: String) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)
            
            try {
                println("DEBUG: Starting registration for $email")
                val result = authRepository.register(email, password, name, role)
                println("DEBUG: Registration result received")
                
                result.fold(
                    onSuccess = { authResponse ->
                        println("DEBUG: Registration successful")
                        ApiClient.setAuthToken(authResponse.access_token)
                        _uiState.value = _uiState.value.copy(
                            isLoading = false,
                            isAuthenticated = true,
                            user = authResponse.user,
                            error = null
                        )
                    },
                    onFailure = { exception ->
                        println("DEBUG: Registration failed: ${exception.message}")
                        exception.printStackTrace()
                        _uiState.value = _uiState.value.copy(
                            isLoading = false,
                            error = exception.message ?: "Registration failed"
                        )
                    }
                )
            } catch (e: Exception) {
                println("DEBUG: Unexpected error in register: ${e.message}")
                e.printStackTrace()
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = "Unexpected error: ${e.message}"
                )
            }
        }
    }
}
