drop database hms;
create database hms;
use hms;
CREATE TABLE users (
    user_sr_no INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(15),
    last_name VARCHAR(15),
    email_id VARCHAR(50) NOT NULL UNIQUE,
    phone_no VARCHAR(10) NOT NULL UNIQUE,  
    password VARCHAR(255) NOT NULL,
    gender enum('M','F','other'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role_as_a enum('doctor','patient','receptionist'),
    CHECK (LENGTH(phone_no) = 10 AND phone_no NOT REGEXP '[^0-9]') 
);

CREATE TABLE doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    education VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone_no VARCHAR(10) NOT NULL UNIQUE,  
    email VARCHAR(100) UNIQUE NOT NULL,
    joining_date DATE DEFAULT(CURRENT_DATE),
    consultation_fee DECIMAL(10, 2),
    time_slot_begin TIME NOT NULL,
    time_slot_end TIME NOT NULL,
    experience INT,
    rating decimal(2,1),
    CHECK (LENGTH(phone_no) = 10 AND phone_no NOT REGEXP '[^0-9]') 
);
CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_no VARCHAR(10) NOT NULL UNIQUE,
    email VARCHAR(100),
    address VARCHAR(255),
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    emergency_contact_name VARCHAR(100),
    emergency_contact_number VARCHAR(15),
    registration_date DATE DEFAULT(CURRENT_DATE),
    CHECK (LENGTH(phone_no) = 10 AND phone_no NOT REGEXP '[^0-9]') 
);
CREATE TABLE receptionist (
    receptionist_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each receptionist
    first_name VARCHAR(100) NOT NULL,                -- First name of the receptionist
    last_name VARCHAR(100) NOT NULL,                 -- Last name of the receptionist
    phone_no VARCHAR(10) NOT NULL UNIQUE,                      		 -- Contact number
    email VARCHAR(100) NOT NULL unique,                              -- Email (could be in users table)
    hire_date DATE DEFAULT(CURRENT_DATE),             -- Date the receptionist was hired
    shift ENUM('Morning', 'Evening', 'Night'),       -- Work shift of the receptionist
    salary DECIMAL(10, 2),                           -- Salary of the receptionist
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Timestamp for last update
	CHECK (LENGTH(phone_no) = 10 AND phone_no NOT REGEXP '[^0-9]')
);

CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason VARCHAR(255),
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT(CURRENT_TIMESTAMP),
    updated_at TIMESTAMP DEFAULT(CURRENT_TIMESTAMP),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,		-- both are same appointment-patient_id but for sake of understanding used both
    description TEXT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    billing_date DATE DEFAULT(CURRENT_DATE),
    payment_status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);
CREATE TABLE final_bills (
	bill_id INT PRIMARY KEY ,
	appointment_id INT NOT NULL,
	patient_id INT NOT NULL,		-- both are same appointment-patient_id but for sake of understanding used both
    advance_paid Decimal(10,2) default(0),
    pending_amount Decimal(10,2) ,
    paid_amount DECIMAL(10,2),
    refund DECIMAL(10,2),
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
) ;
CREATE TABLE room (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL,
    room_type ENUM('General', 'ICU', 'Private', 'Semi-Private'),
    status ENUM('Available', 'Occupied') DEFAULT 'Available',
    daily_rate DECIMAL(10, 2) NOT NULL
);
CREATE TABLE admission (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    room_id INT NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    status ENUM('Admitted', 'Discharged') DEFAULT 'Admitted',
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (room_id) REFERENCES room(room_id)
);
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,                        -- Foreign key linked to appointments table
    doctor_id INT,                             -- Foreign key linked to doctors table
    patient_id INT,                            -- Foreign key linked to patients table
    prescription_date DATE NOT NULL,
    symptoms TEXT NOT NULL,
    cause TEXT,
    lab_tests TEXT,
    hospitalization_needed ENUM('YES', 'NO') DEFAULT 'NO',
    type_of_hospitalization ENUM('ICU', 'General Ward', 'None') DEFAULT 'None',
    surgery_needed ENUM('YES', 'NO') DEFAULT 'NO',
    dietary_precautions TEXT,
    remark_on_lab_test TEXT , 
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

create table medicinal_prescription (
	prescription_id INT Primary Key,
    medicine_name TEXT NOT NULL,
    dosage TEXT NOT NULL,
    remark TEXT,
    date_of_prescription DATE DEFAULT(CURRENT_DATE),
    foreign key(prescription_id) references prescriptions(prescription_id) 
);

create table pre_surgery_info (
	prescription_id INT Primary Key,
    surgery_type TEXT Not null,
    suggested_date date not null,
    suggested_time varchar(50) default("to be announced later"),
    advice TEXT,
    foreign key(prescription_id) references prescriptions(prescription_id) 
);

CREATE TABLE rating (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    rating_value INT CHECK (rating_value BETWEEN 1 AND 5),  
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),  
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)    
);
CREATE TABLE documents (
	patient_id INT NOT NULL,
	appointment_id int NOT NULL,
    prescription mediumblob NOT NULL,
    lab_test_reports mediumblob ,
    lab_bills mediumblob ,
    final_bill mediumblob,
    PRIMARY KEY (patient_id ,appointment_id),
	FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);
CREATE TABLE contact_support (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique ID for the support request
    user_sr_no INT NOT NULL,                            -- Foreign key referencing the users table
	email_id VARCHAR(50) NOT NULL UNIQUE,
    phone_no VARCHAR(10) NOT NULL UNIQUE,  
    subject VARCHAR(255) NOT NULL,                   -- Short description of the issue
    message TEXT NOT NULL,                           -- Detailed message or query from the user
    status ENUM('Pending', 'In Progress', 'Resolved') DEFAULT 'Pending',  -- Status of the support request
    support_agent_id INT,                            -- ID of the support agent handling the request
    response TEXT,                                   -- Response from the support team
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_sr_no) REFERENCES users(user_sr_no),
    FOREIGN KEY (email_id) REFERENCES users(email_id),
    FOREIGN KEY (phone_no) REFERENCES users(phone_no),
    FOREIGN KEY (support_agent_id) REFERENCES receptionist(receptionist_id)
);
    
DELIMITER //
CREATE TRIGGER update_doctor_average_rating AFTER INSERT ON rating
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(2, 1);
    
    SELECT AVG(rating_value) INTO avg_rating
    FROM rating
    WHERE doctor_id = NEW.doctor_id;
    
    UPDATE doctor
    SET average_rating = avg_rating
    WHERE id = NEW.doctor_id;
END;
//
DELIMITER ;

DELIMITER $$

CREATE TRIGGER set_default_status_before_insert
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    IF NEW.status IS NULL THEN
        SET NEW.status = 'Scheduled';
    END IF;
END$$

DELIMITER ;


DELIMITER //
CREATE TRIGGER update_final_bills_after_payment
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(10, 2);
    DECLARE total_pending DECIMAL(10, 2);

    -- Calculate the new paid amount and the new pending amount
    SELECT IFNULL(SUM(amount), 0)
    INTO total_paid
    FROM payment
    WHERE appointment_id = NEW.appointment_id AND patient_id = NEW.patient_id AND 
    status = "Paid";

    SELECT IFNULL(SUM(amount), 0)
    INTO total_pending
    FROM payment
    WHERE appointment_id = NEW.appointment_id AND patient_id = NEW.patient_id AND
    status = "Pending" ;

    UPDATE final_bills
    SET 
        paid_amount = total_paid,
        pending_amount = total_pending - (advance + total_paid) ,
        refund = IF(pending_amount < 0, ABS(pending_amount), 0) -- Calculate refund if any overpayment occurs
    WHERE appointment_id = NEW.appointment_id AND patient_id = NEW.patient_id;
END;
//
DELIMITER ;
DELIMITER //
CREATE EVENT update_room_status_on_discharge
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE room r
    JOIN admission a ON r.room_id = a.room_id
    SET r.status = 'Available'
    WHERE a.status = 'Admitted' AND a.discharge_date <= CURDATE();
END;
//
DELIMITER ;
SET GLOBAL event_scheduler = ON;
DELIMITER //

CREATE EVENT add_daily_room_charge
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO payment (appointment_id, patient_id, description, amount, billing_date, payment_status)
    SELECT 
        a.appointment_id,
        a.patient_id,
        CONCAT('Daily charge for room ', r.room_number),
        r.daily_rate,
        CURDATE(),
        'Pending'
    FROM admission a
    JOIN room r ON a.room_id = r.room_id
    WHERE a.status = 'Admitted'
      AND (a.discharge_date IS NULL OR a.discharge_date > CURDATE());
END;
//
DELIMITER ;

    



