// Wait for the DOM content to be fully loaded
document.addEventListener("DOMContentLoaded", function() {
    // Get the elements in your HTML template that you want to update
    var emergencyFundElement = document.getElementById("emergencyFund");
    var insuranceRecommendationElement = document.getElementById("insuranceRecommendation");

    // Set the content of the elements with the calculated values
    emergencyFundElement.innerText = "Emergency Fund: " + emergencyFund;
    insuranceRecommendationElement.innerText = "Insurance Recommendation: " + insuranceRecommendation;
});
