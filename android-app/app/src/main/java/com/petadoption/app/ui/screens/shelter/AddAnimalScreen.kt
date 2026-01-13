package com.petadoption.app.ui.screens.shelter

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
fun AddAnimalScreen(
    onNavigateBack: () -> Unit,
    viewModel: AddAnimalViewModel = viewModel()
) {
    val uiState by viewModel.uiState.collectAsState()

    var name by remember { mutableStateOf("") }
    var species by remember { mutableStateOf("dog") }
    var breed by remember { mutableStateOf("") }
    var age by remember { mutableStateOf("") }
    var size by remember { mutableStateOf("medium") }
    var energyLevel by remember { mutableStateOf(5f) }
    var description by remember { mutableStateOf("") }
    var goodWithChildren by remember { mutableStateOf(true) }
    var goodWithPets by remember { mutableStateOf(true) }

    LaunchedEffect(uiState.success) {
        if (uiState.success) {
            onNavigateBack()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Add New Animal") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    titleContentColor = MaterialTheme.colorScheme.onPrimary
                ),
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            Icons.Default.ArrowBack,
                            contentDescription = "Back",
                            tint = MaterialTheme.colorScheme.onPrimary
                        )
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Name
            OutlinedTextField(
                value = name,
                onValueChange = { name = it },
                label = { Text("Name *") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // Species
            var speciesExpanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(
                expanded = speciesExpanded,
                onExpandedChange = { speciesExpanded = it }
            ) {
                OutlinedTextField(
                    value = species.replaceFirstChar { it.uppercase() },
                    onValueChange = {},
                    readOnly = true,
                    label = { Text("Species *") },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = speciesExpanded) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .menuAnchor()
                )
                ExposedDropdownMenu(
                    expanded = speciesExpanded,
                    onDismissRequest = { speciesExpanded = false }
                ) {
                    listOf("dog", "cat", "bird", "rabbit", "other").forEach { option ->
                        DropdownMenuItem(
                            text = { Text(option.replaceFirstChar { it.uppercase() }) },
                            onClick = {
                                species = option
                                speciesExpanded = false
                            }
                        )
                    }
                }
            }

            // Breed
            OutlinedTextField(
                value = breed,
                onValueChange = { breed = it },
                label = { Text("Breed *") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // Age
            OutlinedTextField(
                value = age,
                onValueChange = { age = it },
                label = { Text("Age (years) *") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // Size
            var sizeExpanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(
                expanded = sizeExpanded,
                onExpandedChange = { sizeExpanded = it }
            ) {
                OutlinedTextField(
                    value = size.replaceFirstChar { it.uppercase() },
                    onValueChange = {},
                    readOnly = true,
                    label = { Text("Size *") },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = sizeExpanded) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .menuAnchor()
                )
                ExposedDropdownMenu(
                    expanded = sizeExpanded,
                    onDismissRequest = { sizeExpanded = false }
                ) {
                    listOf("small", "medium", "large").forEach { option ->
                        DropdownMenuItem(
                            text = { Text(option.replaceFirstChar { it.uppercase() }) },
                            onClick = {
                                size = option
                                sizeExpanded = false
                            }
                        )
                    }
                }
            }

            // Energy Level
            Column {
                Text("Energy Level: ${energyLevel.toInt()}/10")
                Slider(
                    value = energyLevel,
                    onValueChange = { energyLevel = it },
                    valueRange = 1f..10f,
                    steps = 8
                )
            }

            // Good with Children
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Good with Children")
                Switch(
                    checked = goodWithChildren,
                    onCheckedChange = { goodWithChildren = it }
                )
            }

            // Good with Other Pets
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Good with Other Pets")
                Switch(
                    checked = goodWithPets,
                    onCheckedChange = { goodWithPets = it }
                )
            }

            // Description
            OutlinedTextField(
                value = description,
                onValueChange = { description = it },
                label = { Text("Description *") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(120.dp),
                maxLines = 5
            )

            // Error message
            uiState.error?.let { error ->
                Text(
                    text = error,
                    color = MaterialTheme.colorScheme.error,
                    style = MaterialTheme.typography.bodySmall
                )
            }

            // Submit button
            Button(
                onClick = {
                    if (name.isNotEmpty() && breed.isNotEmpty() && age.isNotEmpty() && description.isNotEmpty()) {
                        viewModel.addAnimal(
                            name = name,
                            species = species,
                            breed = breed,
                            age = age.toIntOrNull() ?: 0,
                            size = size,
                            energyLevel = energyLevel.toInt(),
                            description = description,
                            goodWithChildren = goodWithChildren,
                            goodWithPets = goodWithPets
                        )
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                enabled = !uiState.isLoading && name.isNotEmpty() && breed.isNotEmpty() && 
                          age.isNotEmpty() && description.isNotEmpty()
            ) {
                if (uiState.isLoading) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(24.dp),
                        color = MaterialTheme.colorScheme.onPrimary
                    )
                } else {
                    Text("Add Animal")
                }
            }
        }
    }
}
