import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score

# Export data to CSV
data=pd.read_csv('JAVA_CAC2_Project_data.csv')

# Split the data into training and testing sets
X = data.drop(columns=['Emergency Funds'])
y = data['Emergency Funds']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Scale the features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train the linear regression model
regression_model = LinearRegression()
regression_model.fit(X_train_scaled, y_train)

# Make predictions on the testing set
y_pred = regression_model.predict(X_test_scaled)

# Calculate R-squared score
r2 = r2_score(y_test, y_pred)
print(f"R-squared Score: {r2}")

# Function to get user input and predict emergency fund
def predict_emergency_fund():
    # Get user input for features
    monthly_income = float(input("Enter Monthly Income: "))
    monthly_expenses = float(input("Enter Monthly Expenses: "))
    existing_savings = float(input("Enter Existing Savings: "))
    debt_obligations = float(input("Enter Debt Obligations: "))
    risk_factor = input("Enter Risk Factor (Low/Medium/High): ")
    household_size = int(input("Enter Household Size: "))
    
    # Encode risk factor
    risk_factor_encoder = {'Low': 0, 'Medium': 1, 'High': 2}
    risk_factor_encoded = risk_factor_encoder.get(risk_factor.capitalize(), None)
    
    if risk_factor_encoded is None:
        print("Invalid Risk Factor. Please enter Low, Medium, or High.")
        return
    
    # Prepare input data for prediction
    user_input = pd.DataFrame({
        'Monthly Income': [monthly_income],
        'Monthly Expenses': [monthly_expenses],
        'Existing Savings': [existing_savings],
        'Debt Obligations': [debt_obligations],
        'Risk Factors': [risk_factor_encoded],
        'Household Size': [household_size]
    })
    
    # Scale input data
    user_input_scaled = scaler.transform(user_input)
    
    # Predict emergency fund
    predicted_emergency_fund = regression_model.predict(user_input_scaled)[0]
    print(f"Predicted Emergency Fund: {predicted_emergency_fund:.2f}")
    
    return predicted_emergency_fund

# Call the function to predict emergency fund based on user input
predicted_emergency_fund = predict_emergency_fund()

# Function to suggest insurance type based on predicted emergency funds
def suggest_insurance_type(predicted_emergency_fund):
    if predicted_emergency_fund >= 15000:
        return 'Comprehensive Health Insurance'
    elif predicted_emergency_fund >= 10000:
        return 'Standard Health Insurance'
    elif predicted_emergency_fund >= 5000:
        return 'Basic Health Insurance'
    else:
        return 'No Health Insurance Needed'

# Call the function to suggest insurance type based on predicted emergency funds
insurance_type = suggest_insurance_type(predicted_emergency_fund)
print(f"Predicted Insurance Type: {insurance_type}")
