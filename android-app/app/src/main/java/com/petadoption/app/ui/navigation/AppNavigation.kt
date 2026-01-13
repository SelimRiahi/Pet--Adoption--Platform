package com.petadoption.app.ui.navigation

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.petadoption.app.data.remote.ApiClient
import com.petadoption.app.ui.screens.auth.LoginScreen
import com.petadoption.app.ui.screens.auth.RegisterScreen
import com.petadoption.app.ui.screens.home.HomeScreen
import com.petadoption.app.ui.screens.animal.AnimalDetailScreen
import com.petadoption.app.ui.screens.profile.ProfileScreen
import com.petadoption.app.ui.screens.profile.EditProfileScreen
import com.petadoption.app.ui.screens.recommendations.RecommendationsScreen
import com.petadoption.app.ui.screens.requests.AdoptionRequestsScreen
import com.petadoption.app.ui.screens.shelter.ShelterDashboardScreen
import com.petadoption.app.ui.screens.shelter.AddAnimalScreen

sealed class Screen(val route: String) {
    object Login : Screen("login")
    object Register : Screen("register")
    object Home : Screen("home")
    object AnimalDetail : Screen("animal/{animalId}") {
        fun createRoute(animalId: String) = "animal/$animalId"
    }
    object Profile : Screen("profile")
    object EditProfile : Screen("edit_profile")
    object Recommendations : Screen("recommendations")
    object AdoptionRequests : Screen("adoption_requests")
    object ShelterDashboard : Screen("shelter_dashboard")
    object AddAnimal : Screen("add_animal")
}

@Composable
fun AppNavigation(
    modifier: Modifier = Modifier,
    navController: NavHostController = rememberNavController()
) {
    NavHost(
        navController = navController,
        startDestination = Screen.Login.route,
        modifier = modifier
    ) {
        composable(Screen.Login.route) {
            LoginScreen(
                onNavigateToRegister = { navController.navigate(Screen.Register.route) },
                onLoginSuccess = { role ->
                    // Navigate to appropriate screen based on role
                    val destination = if (role == "shelter") {
                        Screen.ShelterDashboard.route
                    } else {
                        Screen.Home.route
                    }
                    navController.navigate(destination) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    }
                }
            )
        }
        
        composable(Screen.Register.route) {
            RegisterScreen(
                onNavigateToLogin = { navController.popBackStack() },
                onRegisterSuccess = { role ->
                    val destination = if (role == "shelter") {
                        Screen.ShelterDashboard.route
                    } else {
                        Screen.Home.route
                    }
                    navController.navigate(destination) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    }
                }
            )
        }
        
        composable(Screen.Home.route) {
            HomeScreen(
                onNavigateToAnimal = { animalId ->
                    navController.navigate(Screen.AnimalDetail.createRoute(animalId))
                },
                onNavigateToProfile = { navController.navigate(Screen.Profile.route) },
                onNavigateToRecommendations = { navController.navigate(Screen.Recommendations.route) },
                onNavigateToRequests = { navController.navigate(Screen.AdoptionRequests.route) }
            )
        }
        
        composable(Screen.ShelterDashboard.route) {
            ShelterDashboardScreen(
                onNavigateToProfile = { navController.navigate(Screen.Profile.route) },
                onNavigateToAddAnimal = { navController.navigate(Screen.AddAnimal.route) }
            )
        }
        
        composable(Screen.AddAnimal.route) {
            AddAnimalScreen(
                onNavigateBack = { navController.popBackStack() }
            )
        }
        
        composable(
            route = Screen.AnimalDetail.route,
            arguments = listOf(navArgument("animalId") { type = NavType.StringType })
        ) { backStackEntry ->
            val animalId = backStackEntry.arguments?.getString("animalId") ?: ""
            AnimalDetailScreen(
                animalId = animalId,
                onNavigateBack = { navController.popBackStack() }
            )
        }
        
        composable(Screen.Recommendations.route) {
            RecommendationsScreen(
                onNavigateBack = { navController.popBackStack() },
                onNavigateToAnimal = { animalId ->
                    navController.navigate(Screen.AnimalDetail.createRoute(animalId))
                }
            )
        }
        
        composable(Screen.AdoptionRequests.route) {
            AdoptionRequestsScreen(
                onNavigateBack = { navController.popBackStack() }
            )
        }
        
        composable(Screen.Profile.route) {
            ProfileScreen(
                onNavigateBack = { navController.popBackStack() },
                onLogout = {
                    // Clear auth token
                    ApiClient.clearAuthToken()
                    // Navigate back to login
                    navController.navigate(Screen.Login.route) {
                        popUpTo(0) { inclusive = true }
                    }
                },
                onNavigateToRequests = { 
                    navController.navigate(Screen.AdoptionRequests.route) 
                },
                onNavigateToEditProfile = {
                    navController.navigate(Screen.EditProfile.route)
                }
            )
        }
        
        composable(Screen.EditProfile.route) {
            EditProfileScreen(
                onNavigateBack = { navController.popBackStack() }
            )
        }
    }
}
