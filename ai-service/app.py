"""
AI Microservice - Flask API
Exposes the trained ML model for compatibility prediction
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np
import os

app = Flask(__name__)
CORS(app)

# Load trained model
MODEL_PATH = 'decision_tree_model.pkl'
SCALER_PATH = 'scaler.pkl'

if not os.path.exists(MODEL_PATH):
    print("ERROR: Model not found! Please run 'python train_model.py' first.")
    exit(1)

model = joblib.load(MODEL_PATH)
print("✅ Model loaded successfully")

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'model': 'decision_tree'}), 200

@app.route('/predict', methods=['POST'])
def predict():
    """
    Predict compatibility score between user and animal
    
    Expected JSON payload:
    {
        "user": {
            "housing_type": "apartment" | "house_small" | "house_large",
            "available_time": 0-10,
            "experience": "none" | "some" | "expert",
            "has_children": boolean,
            "has_other_pets": boolean
        },
        "animal": {
            "species": "cat" | "dog" | "other",
            "age": 0-20,
            "size": "small" | "medium" | "large",
            "energy_level": 0-10,
            "good_with_children": boolean,
            "good_with_pets": boolean
        }
    }
    
    Returns:
    {
        "compatibility_score": 0-100,
        "recommendation": "excellent" | "good" | "moderate" | "low"
    }
    """
    
    try:
        data = request.get_json()
        
        if not data or 'user' not in data or 'animal' not in data:
            return jsonify({'error': 'Invalid input format'}), 400
        
        user = data['user']
        animal = data['animal']
        
        # Convert categorical variables to numerical
        housing_map = {'apartment': 0, 'house_small': 1, 'house_large': 2}
        experience_map = {'none': 0, 'some': 1, 'expert': 2}
        species_map = {'cat': 0, 'dog': 1, 'other': 2}
        size_map = {'small': 0, 'medium': 1, 'large': 2}
        
        # Prepare features in correct order
        features = np.array([[
            housing_map.get(user.get('housing_type', 'apartment'), 0),
            float(user.get('available_time', 5)),
            experience_map.get(user.get('experience', 'none'), 0),
            int(user.get('has_children', False)),
            int(user.get('has_other_pets', False)),
            species_map.get(animal.get('species', 'cat'), 0),
            float(animal.get('age', 2)),
            size_map.get(animal.get('size', 'medium'), 1),
            float(animal.get('energy_level', 5)),
            int(animal.get('good_with_children', True)),
            int(animal.get('good_with_pets', True))
        ]])
        
        # Make prediction
        score = float(model.predict(features)[0])
        score = max(0, min(100, score))  # Ensure score is within 0-100
        
        # Determine recommendation level
        if score >= 80:
            recommendation = 'excellent'
        elif score >= 65:
            recommendation = 'good'
        elif score >= 45:
            recommendation = 'moderate'
        else:
            recommendation = 'low'
        
        return jsonify({
            'compatibility_score': round(score, 2),
            'recommendation': recommendation
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/predict/batch', methods=['POST'])
def predict_batch():
    """
    Predict compatibility scores for multiple user-animal pairs
    
    Expected JSON payload:
    {
        "user": { ... },
        "animals": [ { ... }, { ... }, ... ]
    }
    
    Returns array of predictions sorted by compatibility score
    """
    
    try:
        data = request.get_json()
        
        if not data or 'user' not in data or 'animals' not in data:
            return jsonify({'error': 'Invalid input format'}), 400
        
        user = data['user']
        animals = data['animals']
        
        predictions = []
        
        for animal in animals:
            # Reuse single prediction logic
            result = predict_single(user, animal)
            predictions.append({
                'animal_id': animal.get('id'),
                'compatibility_score': result['compatibility_score'],
                'recommendation': result['recommendation']
            })
        
        # Sort by compatibility score (highest first)
        predictions.sort(key=lambda x: x['compatibility_score'], reverse=True)
        
        return jsonify({'predictions': predictions}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def predict_single(user, animal):
    """Helper function for single prediction"""
    housing_map = {'apartment': 0, 'house_small': 1, 'house_large': 2}
    experience_map = {'none': 0, 'some': 1, 'expert': 2}
    species_map = {'cat': 0, 'dog': 1, 'other': 2}
    size_map = {'small': 0, 'medium': 1, 'large': 2}
    
    features = np.array([[
        housing_map.get(user.get('housing_type', 'apartment'), 0),
        float(user.get('available_time', 5)),
        experience_map.get(user.get('experience', 'none'), 0),
        int(user.get('has_children', False)),
        int(user.get('has_other_pets', False)),
        species_map.get(animal.get('species', 'cat'), 0),
        float(animal.get('age', 2)),
        size_map.get(animal.get('size', 'medium'), 1),
        float(animal.get('energy_level', 5)),
        int(animal.get('good_with_children', True)),
        int(animal.get('good_with_pets', True))
    ]])
    
    score = float(model.predict(features)[0])
    score = max(0, min(100, score))
    
    if score >= 80:
        recommendation = 'excellent'
    elif score >= 65:
        recommendation = 'good'
    elif score >= 45:
        recommendation = 'moderate'
    else:
        recommendation = 'low'
    
    return {
        'compatibility_score': round(score, 2),
        'recommendation': recommendation
    }

if __name__ == '__main__':
    print("🚀 Starting AI Microservice...")
    print("📊 Model: Decision Tree Regressor")
    print("🌐 API available at http://localhost:5000")
    print("\nEndpoints:")
    print("  GET  /health - Health check")
    print("  POST /predict - Single prediction")
    print("  POST /predict/batch - Batch predictions")
    app.run(host='0.0.0.0', port=5000, debug=True)
