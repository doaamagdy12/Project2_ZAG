DROP DATABASE IF EXISTS Ramadan_Distributions;
CREATE DATABASE Ramadan_Distributions;
USE Ramadan_Distributions;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('Male','Female'),
    age INT,
    phone VARCHAR(11),
    address VARCHAR(200),
    role ENUM('Admin', 'Volunteer', 'Driver', 'Beneficiary') NOT NULL
);

CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    max_capacity INT,
    current_status ENUM('Open', 'Full', 'Maintenance'),
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Users(user_id)
);

CREATE TABLE Food_Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name ENUM('Dry', 'Fresh', 'Cooked'),
    required_storage_temp DECIMAL(5,2)
);

CREATE TABLE Inventory_Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    quantity_kg DECIMAL(10,2),
    warehouse_id INT NOT NULL,
    expiry_date DATE,
    category_id INT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (category_id) REFERENCES Food_Categories(category_id)
);

CREATE TABLE Donations_Log (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_name VARCHAR(100),
    amount_value DECIMAL(10,2),
    donation_type ENUM('Cash', 'Food'),
    org_type ENUM('Individual', 'Company', 'NGO')
);

CREATE TABLE Beneficiary_Details (
    beneficiary_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE,
    family_members_count INT,
    poverty_score INT CHECK (poverty_score BETWEEN 1 AND 10),
    last_received_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Volunteer_Skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    volunteer_id INT,
    skill_type ENUM('Cooking', 'Driving', 'Data Entry'),
    years_of_experience INT,
    FOREIGN KEY (volunteer_id) REFERENCES Users(user_id)
);

CREATE TABLE Training_Session (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    session_name VARCHAR(40),
    trainer_name VARCHAR(20),
    session_date DATE
);

CREATE TABLE Driver_Training (
    driver_id INT,
    session_id INT,
    PRIMARY KEY (driver_id, session_id),
    FOREIGN KEY (driver_id) REFERENCES Users(user_id),
    FOREIGN KEY (session_id) REFERENCES Training_Session(session_id)
);

CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    quantity_kg DECIMAL(10,2) NOT NULL,
    shipment_date DATE NOT NULL,
    destination VARCHAR(200),
    FOREIGN KEY (item_id) REFERENCES Inventory_Items(item_id)
);

CREATE INDEX idx_users_role_address
ON Users(role, address);

CREATE INDEX idx_beneficiary_poverty_last_received
ON Beneficiary_Details(poverty_score, last_received_date);

CREATE INDEX idx_inventory_category_expiry_warehouse
ON Inventory_Items(category_id, expiry_date, warehouse_id);

-- Trigger to prevent shipping expired food

DELIMITER $$

CREATE TRIGGER prevent_expired_food_shipment
BEFORE INSERT ON Shipments
FOR EACH ROW
BEGIN
    DECLARE exp_date DATE;

    SELECT expiry_date
    INTO exp_date
    FROM Inventory_Items
    WHERE item_id = NEW.item_id;

    IF exp_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot ship expired food item';
    END IF;

END$$

DELIMITER ;

INSERT INTO Users (full_name, gender, age, phone, address, role) VALUES
('Ahmed Ali', 'Male', 35, '01011112222', 'Cairo, Egypt', 'Admin'),
('Omar Farouk', 'Male', 38, '01066667777', 'Sharkia, Egypt', 'Driver'),
('Sara Mohamed', 'Female', 28, '01033334444', 'Sharkia, Egypt', 'Volunteer'),
('Hassan Said', 'Male', 40, '01055556666', 'Sharkia, Egypt', 'Driver'),
('Fatma Youssef', 'Female', 30, '01077778888', 'Minya Al-Qamh', 'Beneficiary'),
('Mohamed Tamer', 'Male', 45, '01099990000', 'Sharkia, Egypt', 'Driver'),
('Nour El-Din', 'Male', 25, '01022223333', 'Sharkia, Egypt', 'Volunteer'),
('Aisha Kamal', 'Female', 32, '01044445555', 'Minya Al-Qamh', 'Beneficiary'),
('Amir Ahmed', 'Male', 29, '01088889999', 'Sharkia, Egypt', 'Driver');

INSERT INTO Warehouses (name, location, max_capacity, current_status, supervisor_id) VALUES
('Main Warehouse', 'Sharkia, Belbes', 10000, 'Open', 1),
('Zagazig Warehouse', 'Sharkia, Zagazig', 5000, 'Full', 1),
('Cold Storage 2', 'Sharkia, 10th District', 3000, 'Maintenance', 1);

INSERT INTO Food_Categories (category_name, required_storage_temp) VALUES
('Dry', 25.00),
('Fresh', 4.00),
('Cooked', 60.00);

INSERT INTO Inventory_Items (name, quantity_kg, warehouse_id, expiry_date, category_id) VALUES
('Rice', 1000, 1, '2026-06-30', 1),
('Pasta', 500, 1, '2026-07-15', 1),
('Chicken', 200, 2, '2026-03-14', 2),
('Beef', 150, 2, '2026-03-20', 2),
('Cooked Lentils', 50, 3, '2026-03-14', 3);

INSERT INTO Donations_Log (donor_name, amount_value, donation_type, org_type) VALUES
('Ali Hassan', 5000, 'Cash', 'Individual'),
('ABC Company', 200, 'Cash', 'Company'),
('Helping Hands NGO', 1000, 'Food', 'NGO'),
('Fatma Youssef', 300, 'Cash', 'Individual'),
('Omar Farouk', 1500, 'Food', 'Individual'),
('MSA Company', 1000, 'Cash', 'Company'),
('ORG Company', 2000, 'Cash', 'Company'),
('Sara Mohamed', 500, 'Cash', 'Individual'),
('Nour El-Din', 800, 'Food', 'Individual');


INSERT INTO Beneficiary_Details (user_id, family_members_count, poverty_score, last_received_date) VALUES
(5, 5, 9, '2026-02-20'),
(8, 3, 7, '2026-03-05');

INSERT INTO Volunteer_Skills (volunteer_id, skill_type, years_of_experience) VALUES
(3, 'Cooking', 5),
(3, 'Data Entry', 2),
(7, 'Driving', 3);

INSERT INTO Training_Session (session_name, trainer_name, session_date) VALUES
('Safety First', 'Ahmed Ali', '2026-03-05'),
('Emergency Handling', 'Sara Mohamed', '2026-03-06');

INSERT INTO Driver_Training (driver_id, session_id) VALUES
(4, 1),   -- Hassan Said attended Safety First
(6, 1),   -- Mohamed Tamer attended Safety First
(4, 2);   -- Hassan Said attended Emergency Handling

-- 1
SELECT II.name
FROM Inventory_Items II
JOIN Food_Categories FC ON II.category_id = FC.category_id
JOIN Warehouses W ON II.warehouse_id = W.warehouse_id
WHERE FC.category_name = 'Fresh'
  AND W.name = 'Zagazig Warehouse'
  AND II.expiry_date <= '2026-03-15';

-- 2
SELECT U.full_name
FROM Users U
LEFT JOIN Driver_Training DT
    ON U.user_id = DT.driver_id AND DT.session_id = 1
WHERE U.role = 'Driver'
  AND DT.session_id IS NULL;

-- 3
SELECT U.full_name
FROM Users U
JOIN Beneficiary_Details BD ON U.user_id = BD.user_id
WHERE U.role = 'Beneficiary'
  AND U.address = 'Minya Al-Qamh'
  AND BD.poverty_score > 8
  AND BD.last_received_date < '2026-02-26';

-- 4
SELECT
    (SELECT SUM(D.amount_value)
     FROM Donations_Log D
     WHERE D.donation_type = 'Cash'
       AND D.org_type = 'Company') AS total_donations_companies,

    (SELECT SUM(D.amount_value)
     FROM Donations_Log D
     WHERE D.donation_type = 'Cash'
       AND D.org_type = 'Individual') AS total_donations_individuals;
