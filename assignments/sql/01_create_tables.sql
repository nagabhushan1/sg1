/* ===============================
   Database Initialization
   =============================== */

DROP DATABASE IF EXISTS hr;

CREATE DATABASE hr
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE hr;

/* ===============================
   Regions
   =============================== */

CREATE TABLE regions (
  region_id INT NOT NULL,
  region_name VARCHAR(25),
  CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
) ENGINE=InnoDB;

/* ===============================
   Countries
   =============================== */

CREATE TABLE countries (
  country_id CHAR(2) NOT NULL,
  country_name VARCHAR(40),
  region_id INT,
  CONSTRAINT country_c_id_pk PRIMARY KEY (country_id),
  CONSTRAINT countr_reg_fk
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
) ENGINE=InnoDB;

/* ===============================
   Locations
   =============================== */

CREATE TABLE locations (
  location_id INT NOT NULL,
  street_address VARCHAR(40),
  postal_code VARCHAR(12),
  city VARCHAR(30) NOT NULL,
  state_province VARCHAR(25),
  country_id CHAR(2),
  CONSTRAINT loc_id_pk PRIMARY KEY (location_id),
  CONSTRAINT loc_c_id_fk
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
) ENGINE=InnoDB;

/* ===============================
   Departments
   =============================== */

CREATE TABLE departments (
  department_id INT NOT NULL,
  department_name VARCHAR(30) NOT NULL,
  manager_id INT,
  location_id INT,
  CONSTRAINT dept_id_pk PRIMARY KEY (department_id),
  CONSTRAINT dept_loc_fk
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
) ENGINE=InnoDB;

/* ===============================
   Jobs
   =============================== */

CREATE TABLE jobs (
  job_id VARCHAR(10) NOT NULL,
  job_title VARCHAR(35) NOT NULL,
  min_salary INT,
  max_salary INT,
  CONSTRAINT job_id_pk PRIMARY KEY (job_id)
) ENGINE=InnoDB;

/* ===============================
   Employees
   =============================== */

CREATE TABLE employees (
  employee_id INT NOT NULL,
  first_name VARCHAR(20),
  last_name VARCHAR(25) NOT NULL,
  email VARCHAR(25) NOT NULL,
  phone_number VARCHAR(20),
  hire_date DATE NOT NULL,
  job_id VARCHAR(10) NOT NULL,
  salary DECIMAL(8,2),
  commission_pct DECIMAL(2,2),
  manager_id INT,
  department_id INT,
  CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id),
  CONSTRAINT emp_email_uk UNIQUE (email),
  CONSTRAINT emp_salary_min CHECK (salary > 0),
  CONSTRAINT emp_dept_fk
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
  CONSTRAINT emp_job_fk
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  CONSTRAINT emp_manager_fk
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
) ENGINE=InnoDB;

/* ===============================
   Department Manager FK
   =============================== */

ALTER TABLE departments
ADD CONSTRAINT dept_mgr_fk
FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

/* ===============================
   Job History
   =============================== */

CREATE TABLE job_history (
  employee_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  job_id VARCHAR(10) NOT NULL,
  department_id INT,
  CONSTRAINT jhist_emp_id_st_date_pk
    PRIMARY KEY (employee_id, start_date),
  CONSTRAINT jhist_date_interval CHECK (end_date > start_date),
  CONSTRAINT jhist_job_fk
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  CONSTRAINT jhist_emp_fk
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  CONSTRAINT jhist_dept_fk
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB;

/* ===============================
   View
   =============================== */

CREATE VIEW emp_details_view AS
SELECT
  e.employee_id,
  e.job_id,
  e.manager_id,
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON j.job_id = e.job_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id;
