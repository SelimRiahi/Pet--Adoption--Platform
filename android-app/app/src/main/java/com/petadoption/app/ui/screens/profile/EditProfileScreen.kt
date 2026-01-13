package com.petadoption.app.ui.screens.profile

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EditProfileScreen(
    onNavigateBack: () -> Unit,
    viewModel: EditProfileViewModel = viewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    
    var housingType by remember { mutableStateOf("") }
    var availableTime by remember { mutableStateOf("") }
    var experience by remember { mutableStateOf("") }
    var hasChildren by remember { mutableStateOf(false) }
    var hasOtherPets by remember { mutableStateOf(false) }
    var phoneNumber by remember { mutableStateOf("") }
    var address by remember { mutableStateOf("") }

    LaunchedEffect(Unit) {
        viewModel.loadProfile()
    }

    LaunchedEffect(uiState.user) {
        uiState.user?.let { user ->
            housingType = user.housingType ?: ""
            availableTime = user.availableTime?.toString() ?: ""
            experience = user.experience ?: ""
            hasChildren = user.hasChildren
            hasOtherPets = user.hasOtherPets
            phoneNumber = user.phoneNumber ?: ""
            address = user.address ?: ""
        }
    }

    LaunchedEffect(uiState.success) {
        if (uiState.success) {
            onNavigateBack()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Edit Profile") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.ArrowBack, "Back")
                    }
                }
            )
        }
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            if (uiState.isLoading) {
                CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            } else {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .verticalScroll(rememberScrollState())
                        .padding(16.dp)
                ) {
                    var housingExpanded by remember { mutableStateOf(false) }
                    ExposedDropdownMenuBox(
                        expanded = housingExpanded,
                        onExpandedChange = { housingExpanded = !housingExpanded }
                    ) {
                        OutlinedTextField(
                            value = housingType.replace("_", " ").capitalize(),
                            onValueChange = {},
                            readOnly = true,
                            label = { Text("Housing Type") },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = housingExpanded) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor()
                        )
                        ExposedDropdownMenu(
                            expanded = housingExpanded,
                            onDismissRequest = { housingExpanded = false }
                        ) {
                            listOf("apartment", "house_small", "house_large").forEach { option ->
                                DropdownMenuItem(
                                    text = { Text(option.replace("_", " ").capitalize()) },
                                    onClick = {
                                        housingType = option
                                        housingExpanded = false
                                    }
                                )
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    OutlinedTextField(
                        value = availableTime,
                        onValueChange = { availableTime = it },
                        label = { Text("Available Time (hours/day)") },
                        modifier = Modifier.fillMaxWidth()
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    var experienceExpanded by remember { mutableStateOf(false) }
                    ExposedDropdownMenuBox(
                        expanded = experienceExpanded,
                        onExpandedChange = { experienceExpanded = !experienceExpanded }
                    ) {
                        OutlinedTextField(
                            value = experience.capitalize(),
                            onValueChange = {},
                            readOnly = true,
                            label = { Text("Pet Experience") },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = experienceExpanded) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor()
                        )
                        ExposedDropdownMenu(
                            expanded = experienceExpanded,
                            onDismissRequest = { experienceExpanded = false }
                        ) {
                            listOf("none", "some", "expert").forEach { option ->
                                DropdownMenuItem(
                                    text = { Text(option.capitalize()) },
                                    onClick = {
                                        experience = option
                                        experienceExpanded = false
                                    }
                                )
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Has Children")
                        Switch(
                            checked = hasChildren,
                            onCheckedChange = { hasChildren = it }
                        )
                    }

                    Spacer(modifier = Modifier.height(8.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Has Other Pets")
                        Switch(
                            checked = hasOtherPets,
                            onCheckedChange = { hasOtherPets = it }
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    OutlinedTextField(
                        value = phoneNumber,
                        onValueChange = { phoneNumber = it },
                        label = { Text("Phone Number") },
                        modifier = Modifier.fillMaxWidth()
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    OutlinedTextField(
                        value = address,
                        onValueChange = { address = it },
                        label = { Text("Address") },
                        modifier = Modifier.fillMaxWidth()
                    )

                    if (uiState.error != null) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = uiState.error!!,
                            color = MaterialTheme.colorScheme.error
                        )
                    }

                    Spacer(modifier = Modifier.height(24.dp))

                    Button(
                        onClick = {
                            viewModel.updateProfile(
                                housingType = housingType.ifBlank { null },
                                availableTime = availableTime.toIntOrNull(),
                                experience = experience.ifBlank { null },
                                hasChildren = hasChildren,
                                hasOtherPets = hasOtherPets,
                                phoneNumber = phoneNumber.ifBlank { null },
                                address = address.ifBlank { null }
                            )
                        },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Save Changes")
                    }
                }
            }
        }
    }
}
