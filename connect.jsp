<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            align-items: center;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
        }
        p {
            color: #666;
            margin-bottom: 10px;
        }
        .button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            border-radius: 5px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head> 
<body>
    <%
        // Get form parameters
        String firstname = request.getParameter("firstName");
        String lastname = request.getParameter("lastName");
        String gender=request.getParameter("gender");
        String phone = request.getParameter("phoneNumber");
        String email = request.getParameter("email");

        int age = 0;
        int monthlyincome = 0;
        int monthexpenses = 0;
        int existingsavings = 0;
        int debtobligations = 0;
        int riskfactors = 0;
        int householdsize = 0;

        if (request.getParameter("age") != null) {
            age = Integer.parseInt(request.getParameter("age"));
        }
        if (request.getParameter("monthlyincome") != null) {
            monthlyincome = Integer.parseInt(request.getParameter("monthlyincome"));
        }
        if (request.getParameter("monthexpenses") != null) {
            monthexpenses = Integer.parseInt(request.getParameter("monthexpenses"));
        }
        if (request.getParameter("existingsavings") != null) {
            existingsavings = Integer.parseInt(request.getParameter("existingsavings"));
        }
        if (request.getParameter("debtobligations") != null) {
            debtobligations = Integer.parseInt(request.getParameter("debtobligations"));
        }
        if (request.getParameter("riskfactors") != null) {
            riskfactors = Integer.parseInt(request.getParameter("riskfactors"));
        }
        if (request.getParameter("householdSize") != null) {
            householdsize = Integer.parseInt(request.getParameter("householdSize"));
        }
        double funds = 121055.02517533161 + 10853.60987256 * monthlyincome - 2942.48302798 * debtobligations + 34191.03683668 * existingsavings - 616.7526238 * debtobligations + 628.52989311 * riskfactors - 503.33521104 * householdsize;

        DecimalFormat df = new DecimalFormat("###,###,###.##");
        String formattedFunds = df.format(funds);

        // Remove commas from formattedFunds
        String cleanFormattedFunds = formattedFunds.replace(",", "");
        // Parse cleanFormattedFunds back to double
        double fundsValue = Double.parseDouble(cleanFormattedFunds);




        // Determine insurance recommendation based on emergency fund
        String insuranceRecommendation;
        if (funds >= 1500000) {
            insuranceRecommendation = "Comprehensive Health Insurance";
        } else if (funds >= 1000000) {
            insuranceRecommendation = "Standard Health Insurance";
        } else if (funds >= 50000) {
            insuranceRecommendation = "Basic Health Insurance";
        } else {
            insuranceRecommendation = "No Health Insurance Needed";
        }


        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/funds";
        String dbUsername = "root";
        String dbPassword = "";

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            
            // Establish the database connection
            Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            
            // Prepare the SQL statement
            String sql = "Insert into userinformation(firstname, lastname, gender, phone, age,email) values (?, ?, ?, ?, ?, ?)";
            PreparedStatement userStatement = conn.prepareStatement(sql);
            userStatement.setString(1, firstname);
            userStatement.setString(2, lastname);
            userStatement.setString(3, gender);
            userStatement.setString(4, phone);
            userStatement.setInt(5, age);
            userStatement.setString(6, email);
            userStatement.executeUpdate();
            
            String fundsSql = "INSERT INTO emergency_funds (monthly_income, month_expenses, existing_savings, debt_obligation, risk_factors, household_size, emergency_fund) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement fundsStatement = conn.prepareStatement(fundsSql);
            fundsStatement.setInt(1, monthlyincome);
            fundsStatement.setInt(2, monthexpenses);
            fundsStatement.setInt(3, existingsavings);
            fundsStatement.setInt(4, debtobligations);
            fundsStatement.setInt(5, riskfactors);
            fundsStatement.setInt(6, householdsize);
            fundsStatement.setDouble(7, funds);
            fundsStatement.executeUpdate();
            
            // Close the database connection
            conn.close();
        } catch (SQLException e) {
            out.println("SQL Error: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            out.println("JDBC Driver Error: " + e.getMessage());
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
        
    %>
    <h2>User Registration Successful</h2>
    <p>Emergency Fund: <%= formattedFunds %></p>
    <p>Health Insurance Recommendation: <%= insuranceRecommendation %></p>
    <!-- Prompt for user to check email or view result -->
    <script>
        function showAlert() {
            // Show a popup with the calculated values
            alert("Emergency Fund: <%= formattedFunds %> \nInsurance Recommendation: <%= insuranceRecommendation %>");
        }
    </script>
    <!-- Prompt for user to check email or view result -->
    <p>Please check your email for updates or click the button to view result:</p>
    <button onclick="showAlert()">View Result</button>
            
</body>
</html>