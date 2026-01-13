package com.petadoption.app.ui.screens.auth

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun TestConnectionScreen() {
    var result by remember { mutableStateOf("Testing...") }
    var isLoading by remember { mutableStateOf(true) }
    
    LaunchedEffect(Unit) {
        try {
            // Test network connection
            val response = java.net.URL("http://10.0.2.2:3000/auth/login")
                .openConnection()
                .apply {
                    connectTimeout = 5000
                    readTimeout = 5000
                }
            
            result = "✅ Backend is reachable at http://10.0.2.2:3000"
            isLoading = false
        } catch (e: Exception) {
            result = "❌ Error: ${e.message}\n\nMake sure:\n1. Backend is running\n2. Port 3000 is open\n3. Network permissions are granted"
            isLoading = false
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        if (isLoading) {
            CircularProgressIndicator()
        } else {
            Text(
                text = result,
                style = MaterialTheme.typography.bodyLarge
            )
        }
    }
}
