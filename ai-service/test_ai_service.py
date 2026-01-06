"""
Quick test script for AI service
"""
import requests
import json

# Test 1: Health Check
print("=" * 50)
print("TEST 1: Health Check")
print("=" * 50)
try:
    response = requests.get("http://localhost:5000/health")
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    print("✅ Health check passed!\n")
except Exception as e:
    print(f"❌ Error: {e}\n")

# Test 2: Single Prediction
print("=" * 50)
print("TEST 2: Single Prediction")
print("=" * 50)
test_data = {
    "user": {
        "housing_type": "apartment",
        "available_time": 4,
        "experience": "some",
        "has_children": True,
        "has_other_pets": False
    },
    "animal": {
        "species": "cat",
        "age": 3,
        "size": "small",
        "energy_level": 5,
        "good_with_children": True,
        "good_with_pets": True
    }
}

try:
    response = requests.post(
        "http://localhost:5000/predict",
        json=test_data,
        headers={"Content-Type": "application/json"}
    )
    print(f"Status: {response.status_code}")
    result = response.json()
    print(f"Compatibility Score: {result['compatibility_score']}")
    print(f"Recommendation: {result['recommendation']}")
    print("✅ Prediction test passed!\n")
except Exception as e:
    print(f"❌ Error: {e}\n")

# Test 3: Batch Prediction
print("=" * 50)
print("TEST 3: Batch Prediction")
print("=" * 50)
batch_data = {
    "user": {
        "housing_type": "house_large",
        "available_time": 8,
        "experience": "expert",
        "has_children": False,
        "has_other_pets": True
    },
    "animals": [
        {
            "id": "1",
            "species": "dog",
            "age": 2,
            "size": "large",
            "energy_level": 8,
            "good_with_children": True,
            "good_with_pets": True
        },
        {
            "id": "2",
            "species": "cat",
            "age": 5,
            "size": "small",
            "energy_level": 3,
            "good_with_children": True,
            "good_with_pets": True
        }
    ]
}

try:
    response = requests.post(
        "http://localhost:5000/predict/batch",
        json=batch_data,
        headers={"Content-Type": "application/json"}
    )
    print(f"Status: {response.status_code}")
    result = response.json()
    print(f"Number of predictions: {len(result['predictions'])}")
    for pred in result['predictions']:
        print(f"  Animal {pred['animal_id']}: {pred['compatibility_score']}% ({pred['recommendation']})")
    print("✅ Batch prediction test passed!\n")
except Exception as e:
    print(f"❌ Error: {e}\n")

print("=" * 50)
print("ALL TESTS COMPLETED!")
print("=" * 50)
