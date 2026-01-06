# AI Microservice

Machine learning-based compatibility prediction service for pet adoption.

## Features

- **Decision Tree Regressor**: Primary model for compatibility scoring
- **Synthetic Training Data**: 5000+ samples with realistic patterns
- **REST API**: Flask-based endpoints for predictions
- **Batch Predictions**: Score multiple animals for a user at once

## Model Details

### Input Features (11 total)

**User Profile:**

- `housing_type`: apartment, house_small, house_large
- `available_time`: 0-10 hours per day
- `experience`: none, some, expert
- `has_children`: boolean
- `has_other_pets`: boolean

**Animal Characteristics:**

- `species`: cat, dog, other
- `age`: 0-20 years
- `size`: small, medium, large
- `energy_level`: 0-10
- `good_with_children`: boolean
- `good_with_pets`: boolean

### Output

- `compatibility_score`: 0-100 (continuous)
- `recommendation`: excellent (80+), good (65-79), moderate (45-64), low (<45)

## Setup

1. **Create virtual environment:**

```bash
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac
```

2. **Install dependencies:**

```bash
pip install -r requirements.txt
```

3. **Train the model:**

```bash
python train_model.py
```

This generates:

- `decision_tree_model.pkl` - Trained model
- `logistic_regression_model.pkl` - Alternative classifier
- `scaler.pkl` - Feature scaler
- `training_data.csv` - Synthetic dataset
- `model_metrics.json` - Performance metrics

4. **Start the API:**

```bash
python app.py
```

API runs at `http://localhost:5000`

## API Endpoints

### Health Check

```bash
GET /health
```

### Single Prediction

```bash
POST /predict
Content-Type: application/json

{
  "user": {
    "housing_type": "apartment",
    "available_time": 4,
    "experience": "some",
    "has_children": true,
    "has_other_pets": false
  },
  "animal": {
    "species": "cat",
    "age": 3,
    "size": "small",
    "energy_level": 5,
    "good_with_children": true,
    "good_with_pets": true
  }
}
```

Response:

```json
{
  "compatibility_score": 78.45,
  "recommendation": "good"
}
```

### Batch Prediction

```bash
POST /predict/batch

{
  "user": { ... },
  "animals": [
    { "id": 1, ... },
    { "id": 2, ... }
  ]
}
```

Returns sorted array by compatibility score.

## Model Performance

Typical metrics (on synthetic data):

- **R² Score**: ~0.85-0.90
- **MSE**: ~50-80

## Technology Stack

- Python 3.9+
- scikit-learn (ML)
- Flask (API)
- NumPy, Pandas (Data processing)
