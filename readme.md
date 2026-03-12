# Ramadan Distributions Database Project

## Overview
This project is a MySQL database for managing a Ramadan food distribution system. It stores information about users, warehouses, food categories, inventory items, donations, beneficiaries, volunteers, training sessions, and driver training records.

## Database Name
`Ramadan_Distributions`

## Main Tables
- **Users**: stores admins, volunteers, drivers, and beneficiaries.
- **Warehouses**: stores warehouse details and supervisors.
- **Food_Categories**: stores food types and required storage temperatures.
- **Inventory_Items**: stores food stock inside warehouses.
- **Donations_Log**: stores cash and food donations from individuals, companies, and NGOs.
- **Beneficiary_Details**: stores beneficiary family details, poverty score, and last received date.
- **Volunteer_Skills**: stores volunteer skills and experience.
- **Training_Session**: stores training session information.
- **Driver_Training**: stores which drivers attended which training sessions.

## Project Features
- Track users by role.
- Manage warehouse information and inventory.
- Store donation records.
- Track beneficiaries and their need level.
- Record volunteer skills.
- Track driver training attendance.

## Sample Queries Included
1. Find fresh food items expiring before a specific date in Zagazig Warehouse.
2. List drivers who have not completed the **Safety First** training.
3. Find families in **Minya Al-Qamh** with `poverty_score > 8` who have not received a box in the last 15 days.
4. Calculate total cash donations from **companies** and **individuals**.

## How to Run
1. Open MySQL Workbench, VS Code SQL extension, or any MySQL client.
2. Run the SQL script from top to bottom.
3. The script will:
   - Drop the old database if it exists.
   - Create the database.
   - Create all tables.
   - Insert sample data.
   - Execute the required queries.

## Expected Query Results
- **Query 1:** `Chicken`
- **Query 2:** `Omar Farouk`, `Amir Ahmed`
- **Query 3:** `Fatma Youssef`
- **Query 4:**
  - `total_donations_companies = 3200`
  - `total_donations_individuals = 5800`

## Notes
- The project uses MySQL syntax.
- Foreign keys are used to maintain relationships between tables.
- Sample data was adjusted to match the query requirements correctly.

## Author
Prepared as a SQL Database Project for the Ramadan Dis