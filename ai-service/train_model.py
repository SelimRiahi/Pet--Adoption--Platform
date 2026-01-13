"""
AI Model Training Script
Trains a compatibility prediction model using Decision Tree and Logistic Regression
"""

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score
import joblib
import json

def generate_synthetic_data(n_samples=5000):
    """
    Generate synthetic training data for pet-user compatibility
    
    Features:
    User: housing_type (0=apartment, 1=house_small, 2=house_large), 
          available_time (0-10 hours), 
          experience (0=none, 1=some, 2=expert),
          has_children (0/1), 
          has_other_pets (0/1)
    
    Animal: species (0=cat, 1=dog, 2=other),
            age (0-20 years),
            size (0=small, 1=medium, 2=large),
            energy_level (0-10),
            good_with_children (0/1),
            good_with_pets (0/1)
    
    Output: compatibility_score (0-100)
    """
    
    np.random.seed(42)
    
    data = {
        # User features
        'housing_type': np.random.randint(0, 3, n_samples),
        'available_time': np.random.uniform(0, 10, n_samples),
        'experience': np.random.randint(0, 3, n_samples),
        'has_children': np.random.randint(0, 2, n_samples),
        'has_other_pets': np.random.randint(0, 2, n_samples),
        
        # Animal features
        'species': np.random.randint(0, 3, n_samples),
        'age': np.random.uniform(0, 20, n_samples),
        'size': np.random.randint(0, 3, n_samples),
        'energy_level': np.random.uniform(0, 10, n_samples),
        'good_with_children': np.random.randint(0, 2, n_samples),
        'good_with_pets': np.random.randint(0, 2, n_samples),
    }
    
    df = pd.DataFrame(data)
    
    # Calculate compatibility score based on rules
    compatibility = np.zeros(n_samples)
    
    for i in range(n_samples):
        score = 50  # Base score
        
        # Housing compatibility - BIGGER IMPACT
        if df.loc[i, 'size'] == 2:  # Large animal
            if df.loc[i, 'housing_type'] == 2:  # Large house
                score += 20
            elif df.loc[i, 'housing_type'] == 1:  # Small house
                score += 5
            else:  # Apartment
                score -= 25
        elif df.loc[i, 'size'] == 1:  # Medium animal
            if df.loc[i, 'housing_type'] >= 1:  # Any house
                score += 10
            else:  # Apartment
                score -= 5
        else:  # Small animal
            score += 5  # Good for any housing
        
        # Time availability vs energy level - CRITICAL MATCH
        energy = df.loc[i, 'energy_level']
        time = df.loc[i, 'available_time']
        
        if energy > 7:  # High energy animal
            if time >= 6:
                score += 15
            elif time >= 4:
                score -= 5
            else:
                score -= 20
        elif energy > 4:  # Medium energy
            if time >= 4:
                score += 10
            else:
                score -= 10
        else:  # Low energy animal
            if time < 4:
                score += 10
            else:
                score += 5
        
        # Experience match - MORE VARIATION
        exp = df.loc[i, 'experience']
        species = df.loc[i, 'species']
        
        if exp == 2:  # Expert
            score += 15
        elif exp == 1:  # Some experience
            if species == 1:  # Dog
                score += 5
            else:
                score += 10
        else:  # No experience
            if species == 1 and energy > 6:  # High energy dog
                score -= 20
            elif species == 1:  # Any dog
                score -= 10
            else:  # Cat or other
                score += 0
        
        # Children compatibility - STRICT
        if df.loc[i, 'has_children'] == 1:
            if df.loc[i, 'good_with_children'] == 1:
                score += 25
            else:
                score -= 40  # Deal breaker
        
        # Other pets compatibility - STRICT
        if df.loc[i, 'has_other_pets'] == 1:
            if df.loc[i, 'good_with_pets'] == 1:
                score += 20
            else:
                score -= 35  # Deal breaker
        
        # Age factor - MORE NUANCED
        age = df.loc[i, 'age']
        if age < 1:  # Puppy/kitten
            if exp >= 1:
                score += 5
            else:
                score -= 15  # Hard for beginners
        elif age > 7:  # Senior
            score += 10  # Generally easier
        elif age > 3:  # Adult
            score += 5
        
        # Species-specific adjustments
        if species == 0:  # Cats
            score += 8  # Generally independent
        elif species == 1:  # Dogs
            if exp == 0:
                score -= 5  # Need more attention
        
        # Add controlled randomness for variation
        score = score + np.random.normal(0, 8)
        
        # Normalize to 0-100
        compatibility[i] = np.clip(score, 0, 100)
    
    df['compatibility_score'] = compatibility
    
    return df

def train_models(df):
    """Train both Decision Tree and Logistic Regression models"""
    
    # Prepare features and target
    feature_cols = ['housing_type', 'available_time', 'experience', 'has_children', 
                    'has_other_pets', 'species', 'age', 'size', 'energy_level', 
                    'good_with_children', 'good_with_pets']
    
    X = df[feature_cols]
    y = df['compatibility_score']
    
    # Split data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Scale features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Train Decision Tree Regressor
    print("Training Decision Tree Regressor...")
    dt_model = DecisionTreeRegressor(max_depth=10, min_samples_split=20, random_state=42)
    dt_model.fit(X_train, y_train)
    
    dt_predictions = dt_model.predict(X_test)
    dt_mse = mean_squared_error(y_test, dt_predictions)
    dt_r2 = r2_score(y_test, dt_predictions)
    
    print(f"Decision Tree - MSE: {dt_mse:.2f}, R²: {dt_r2:.4f}")
    
    # For comparison, let's also track a Logistic Regression approach
    # (We'll use it as a classifier for high/low compatibility)
    print("\nTraining Logistic Regression (Classification)...")
    y_train_class = (y_train >= 60).astype(int)  # 1 if high compatibility
    y_test_class = (y_test >= 60).astype(int)
    
    lr_model = LogisticRegression(max_iter=1000, random_state=42)
    lr_model.fit(X_train_scaled, y_train_class)
    
    lr_accuracy = lr_model.score(X_test_scaled, y_test_class)
    print(f"Logistic Regression - Accuracy: {lr_accuracy:.4f}")
    
    # Save models
    print("\nSaving models...")
    joblib.dump(dt_model, 'decision_tree_model.pkl')
    joblib.dump(lr_model, 'logistic_regression_model.pkl')
    joblib.dump(scaler, 'scaler.pkl')
    
    # Save feature names for reference
    with open('feature_names.json', 'w') as f:
        json.dump(feature_cols, f)
    
    # Save model metrics
    metrics = {
        'decision_tree': {
            'mse': float(dt_mse),
            'r2_score': float(dt_r2)
        },
        'logistic_regression': {
            'accuracy': float(lr_accuracy)
        }
    }
    
    with open('model_metrics.json', 'w') as f:
        json.dump(metrics, f, indent=2)
    
    print("\nModels trained and saved successfully!")
    print(f"Using Decision Tree as primary model (R² score: {dt_r2:.4f})")
    
    return dt_model, lr_model, scaler

if __name__ == '__main__':
    print("Generating synthetic training data...")
    df = generate_synthetic_data(5000)
    
    print(f"Generated {len(df)} samples")
    print(f"Compatibility score range: {df['compatibility_score'].min():.2f} - {df['compatibility_score'].max():.2f}")
    print(f"Mean compatibility: {df['compatibility_score'].mean():.2f}")
    
    # Save dataset for reference
    df.to_csv('training_data.csv', index=False)
    print("\nTraining data saved to training_data.csv")
    
    # Train models
    train_models(df)
    
    print("\n✅ Training complete! Models ready for deployment.")
