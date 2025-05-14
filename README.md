<div align="center">
📱 Inventory Management System - Flutter Desktop
Show Image
Show Image
Show Image
Show Image
<p align="center">
  <img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png" width="100%" />
</p>
</div>
<div align="center">
<p>A modern desktop inventory management application built with Flutter that provides an intuitive interface for managing products, locations, and inventory movements with real-time analytics and reporting.</p>
</div>
📋 Project Overview
This Flutter desktop application serves as the frontend for our comprehensive inventory management system. It provides a sleek, responsive interface that connects to our Spring Boot backend API, allowing users to efficiently manage inventory across multiple locations. The application features a modern dark-themed UI with interactive charts, data filtering, and comprehensive inventory tracking capabilities.
🏗️ Architecture
The application follows the Provider pattern architecture with:

Views Layer: UI screens and widgets for user interaction
Providers Layer: State management and business logic
Controllers Layer: Interface between UI and services
Services Layer: API communication with backend
Models Layer: Domain entities and data structures
Widgets Layer: Reusable UI components

🔧 Tech Stack

Frontend Framework: Flutter 3.19.3
Programming Language: Dart 3.3.0
State Management: Provider 6.1.1
HTTP Client: HTTP 1.1.0
Charts: FL Chart
UI Components: Custom-built widgets

🎨 UI Components
Screen Organization
┌─────────────────────────────────────────────────────────┐
│ CustomAppBar                                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐          ┌─────────────────────┐   │
│  │                 │          │                     │   │
│  │   Navigation    │          │      Main View      │   │
│  │     Panel       │          │                     │   │
│  │                 │          │                     │   │
│  │                 │          │                     │   │
│  │                 │          │                     │   │
│  └─────────────────┘          └─────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
Key UI Components

Dashboard: Interactive statistics cards, pie chart, and bar chart
Data Tables: Filterable product, location, and movement listings
Detail Dialogs: Comprehensive information displays
Form Components: Intuitive data entry with validation
Filter Panels: Powerful data filtering options
Charts: Visual representation of inventory metrics

🚀 Key Features
Dashboard
FeatureDescriptionStatistics CardsDisplay key metrics with dynamic iconsCategory DistributionPie chart showing product distribution by categoryProduct QuantityBar chart showing quantity by locationQuick ActionsDropdown for common operationsReal-time UpdatesPull-to-refresh functionality
Product Management
FeatureDescriptionProduct ListingFilterable table with searchProduct DetailsComprehensive view with stock levelsAdd/Edit ProductForm with validation and image supportCategory FilteringFilter by product categoryStatus TrackingActive/Draft status management
Location Management
FeatureDescriptionLocation ListingSearchable table with country/city filtersLocation DetailsView with products and quantitiesAdd/Edit LocationForm with country/city selectionInventory OverviewSee all products at specific locationGeographic FilteringFilter by country or city
Inventory Movements
FeatureDescriptionMovement TypesSupport for IN, OUT, and TRANSFER operationsMovement HistoryComplete list with filtering optionsMovement DetailsComprehensive view of transactionAdd/Edit MovementIntuitive form with business rule validationFilter OptionsFilter by product, location, or movement type
📱 Screen Showcase
Dashboard
The dashboard provides an at-a-glance overview of inventory status with:

Total product count
Location count
Movement statistics (in, out, transfer)
Category distribution pie chart
Location inventory bar chart

Show Image
Products Screen
Manage all product information with filtering and search capabilities:

List view with essential information
Quick actions for viewing and editing
Detailed product view with inventory levels
Add/edit forms with validation

Show Image
Locations Screen
Track all warehouse and storage locations:

Location cards with details
Location filtering by country/city
Detailed view showing all products at location
Add/edit location forms with country/city selection

Show Image
Movements Screen
Comprehensive inventory movement management:

Movement history with type indicators
Filtering by movement type, product, location
Detailed movement view with full transaction info
Add/edit movement forms with business rule validation

Show Image
🔄 API Integration
The application seamlessly connects to the Spring Boot backend through RESTful API calls:
Service ModuleEndpoints UsedProductService/api/products, /api/products/product-balances/{id}LocationService/api/locations, /api/locations/{id}/inventoryProductMovementService/api/productMovementReportsService/api/reports/dashboard-stats, /api/reports/productDistribution
🛠️ Setup & Installation
Prerequisites

Flutter SDK 3.0+
Dart 3.0+
Desktop environment (Windows, macOS, or Linux)
Backend API running

Configuration

Clone the repository:
git clone https://github.com/yourusername/inventory-management-flutter.git
cd inventory-management-flutter

Install dependencies:
flutter pub get

Configure API connection in AppConstants.dart:
dartstatic const String serverUrl = 'http://localhost:8081';

Run the application:
flutter run -d windows  # For Windows
flutter run -d macos    # For macOS
flutter run -d linux    # For Linux


💡 Advanced Features

Provider Architecture: Clean state management with Provider
Dynamic Filtering: Advanced filtering capabilities for all data views
Responsive Design: Adapts to different screen sizes
Error Handling: Robust error handling and user feedback
Data Validation: Client-side validation before API calls
Custom Widgets: Reusable UI components for consistent design

👨‍💻 Author
Hala Abdel Halim
<p>Developed with 💻 and ☕ for <strong>ERPMax Solutions</strong><br>
<em>Flutter Developer specializing in Desktop and Mobile Applications</em></p>
<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png" width="100%" />
</div>
