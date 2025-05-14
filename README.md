Inventory Management System
Overview
This Inventory Management System is a modern desktop application built with Flutter that connects to a Spring Boot backend API. The system helps businesses track and manage their product inventory across multiple locations, enabling users to monitor product movements, maintain accurate stock levels, and generate inventory reports - all through an intuitive, responsive interface.
Show Image
Features
Core Functionality

Product Management: Create, view, update, and delete product information
Location Management: Manage multiple warehouses or storage locations
Movement Tracking: Record product transfers between locations, incoming stock, and outgoing inventory
Real-time Inventory Reports: View current stock levels across all locations

Dashboard

Summary statistics showing key inventory metrics (total inventory, locations, movements)
Visual representations of inventory distribution by category
Product quantity by location visualization using charts
Quick access to common actions

Responsive UI

Modern dark-themed interface
Interactive data tables with filtering capabilities
Form validation to ensure data integrity
Clean, intuitive user flows

Technical Implementation
Architecture

Frontend: Flutter desktop application
Backend: Spring Boot RESTful API
Database: MySQL

Database Schema
The application uses the following data model:

Product Table

product_id (Primary Key)
name
description
code
price
category
status
image_url
created_at


Location Table

location_id (Primary Key)
name
address
city
country


ProductMovement Table

movement_id (Primary Key)
product_id (Foreign Key)
from_location (Foreign Key, can be NULL)
to_location (Foreign Key, can be NULL)
quantity
timestamp
notes
movement_type (IN, OUT, TRANSFER)



API Endpoints
The application communicates with the backend through RESTful API endpoints:

Products: /api/products
Locations: /api/locations
Product Movements: /api/productMovement
Reports: /api/reports

Installation and Setup
Prerequisites

Flutter (latest stable version)
Java Development Kit (JDK) 11 or higher
MySQL 8.0+
Git

Backend Setup

Clone the repository:

bashgit clone https://github.com/yourusername/inventory-management.git
cd inventory-management/backend

Configure database connection in application.properties:

propertiesspring.datasource.url=jdbc:mysql://localhost:3306/inventory_db
spring.datasource.username=your_username
spring.datasource.password=your_password

Build and run the Spring Boot application:

bash./mvnw spring-boot:run

The API will be available at http://localhost:8080

Frontend Setup

Navigate to the frontend directory:

bashcd ../frontend

Install dependencies:

bashflutter pub get

Update the API base URL in lib/AppConstants.dart if needed:

dartstatic const String serverUrl = 'http://localhost:8080';

Run the application:

bashflutter run -d windows  # For Windows
flutter run -d macos    # For macOS
flutter run -d linux    # For Linux
Usage Guide
Product Management
Users can add new products with details such as name, code, price, and category.
Show Image
Adding a Product:

Navigate to the Products page
Click "Add Product"
Fill in the product details (name, code, price, category, description)
Click "Save Product" or "Save as draft" for incomplete entries

Location Management
The system allows management of multiple storage locations or warehouses.
Show Image
Adding a Location:

Navigate to the Locations page
Click "Add Location"
Enter location details (name, address, city, country)
Click "Save Location"

Inventory Movements
Track the movement of products between locations or in/out of the system.
Show Image
Recording a Movement:

Navigate to the Movements page
Click "Add Movement"
Select movement type (IN, OUT, or TRANSFER)
Choose product, quantity, and location(s)
Add optional notes
Click "Save Product Movement"

Inventory Reports
View current inventory levels across all locations.
Show Image
The system provides comprehensive reporting capabilities:

Stock levels by location
Product movement history
Inventory valuation
Category distribution

Additional Features
Dashboard Analytics
The dashboard provides key metrics and visual representation of inventory distribution:

Total products in inventory
Total locations
Movement statistics (incoming, outgoing, transfers)
Product category distribution via pie chart
Product quantity by location via bar chart

Show Image
Data Filtering
All data views include filtering capabilities to quickly find specific information:

Filter products by category or status
Filter locations by country or city
Filter movements by type, product, or location

Detailed Views
Each entity has a detailed view with comprehensive information:

Product Details: Shows current stock levels across locations, basic information, and image
Location Details: Displays all products stored at the location with quantities
Movement Details: Provides complete information about each inventory transaction

Future Improvements
Planned enhancements for future versions:

User authentication and role-based access control
Barcode/QR code scanning integration
Mobile application companion
Advanced reporting and analytics
Low stock alerts and notifications
Multi-language support

Architecture
The application follows a clean architecture pattern:

Models: Data classes representing core business entities
Services: Handle API communication with the backend
Controllers: Manage business logic between views and services
Providers: State management for reactive UI updates
Widgets: Reusable UI components for consistent interface
