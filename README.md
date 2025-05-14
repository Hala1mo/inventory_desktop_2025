# 📦 Inventory Management System 2025 - Flutter Frontend

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.19.3-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/Provider-6.1.1-0D8ABC?style=for-the-badge)](https://pub.dev/packages/provider)
[![FL Chart](https://img.shields.io/badge/FL%20Chart-0.63.0-FFB300?style=for-the-badge)](https://pub.dev/packages/fl_chart)

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png" width="100%" />

</div>

<div align="center">
<p>A sleek desktop Flutter frontend that connects to the Spring Boot Inventory Management System 2025 backend, enabling powerful and responsive inventory control, visualization, and tracking.</p>
</div>

<div align="center">

### 🔄 Synchronized With Backend

This frontend is fully compatible with the Spring Boot backend documented in the [Inventory Management System 2025 - Backend](https://github.com/yourusername/inventory-management-2025) repository.

- Built for real-time inventory operations  
- Seamless communication via RESTful APIs  
- Designed for warehouse-scale performance  

</div>

## 📋 Project Overview

This Flutter desktop application provides a user-friendly interface for managing inventory products, locations, and movements. It integrates with a RESTful Spring Boot backend to deliver real-time inventory data, analytics, and tracking across multiple locations.

## 🏗️ Architecture

The frontend follows a structured **Provider-based architecture**:

- **Views:** UI screens and widgets  
- **Providers:** State management logic  
- **Controllers:** Bridge between UI and services  
- **Services:** REST API communication  
- **Models:** Data classes for domain objects  
- **Widgets:** Reusable UI components  

## 🔧 Tech Stack

- **Framework:** Flutter 3.19.3  
- **Language:** Dart 3.3.0  
- **State Management:** Provider 6.1.1  
- **API Communication:** http 1.1.0  
- **Visualization:** fl_chart  
- **UI:** Custom dark-themed responsive layout  

## 🚀 Features

### Dashboard

<!-- Dashboard Screenshot -->
<img src="![image](https://github.com/user-attachments/assets/c04d8f70-94bb-4ce4-b0df-6b66cc2d1ce2)
" alt="Dashboard" width="800"/>

- Total product & location counts  
- Inventory movement stats  
- Product category pie chart  
- Location inventory bar chart  
- Refreshable in real-time  

### Product Management

<!-- Products Screenshot -->
<img src="screenshots/products.png" alt="Product Management" width="800"/>

<!-- Product Detail Screenshot -->
<img src="screenshots/product_detail.png" alt="Product Detail" width="800"/>

- Searchable, filterable product list  
- Add/edit forms with validation  
- Product detail view  
- Category and status filtering  

### Location Management

<!-- Locations Screenshot -->
<img src="screenshots/locations.png" alt="Location Management" width="800"/>

<!-- Location Detail Screenshot -->
<img src="screenshots/location_detail.png" alt="Location Detail" width="800"/>

- Searchable list with filters  
- Location inventory breakdown  
- Add/edit with country/city fields  

### Inventory Movements

<img src="screenshots/movements.png" alt="Inventory Movements" width="800"/>

<!-- Movement Detail Screenshot -->
<img src="screenshots/movement_detail.png" alt="Movement Detail" width="800"/>

- IN / OUT / TRANSFER support  
- Filter by movement type, product, location  
- Add/edit with validation and rules  

## 📡 API Integration

| Module                | Endpoints Used                                               |
|----------------------|--------------------------------------------------------------|
| ProductService        | `/api/products`, `/api/products/product-balances/{id}`      |
| LocationService       | `/api/locations`, `/api/locations/{id}/inventory`           |
| ProductMovementService| `/api/productMovement`                                      |
| ReportsService        | `/api/reports/dashboard-stats`, `/api/reports/productDistribution` |

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK 3.0+  
- Dart 3.0+  
- A running backend (Spring Boot Inventory API)  

### Instructions

# Clone the repository
git clone https://github.com/yourusername/inventory-management-flutter.git

# Navigate to project directory
cd inventory-management-flutter

# Install dependencies
flutter pub get

# Configure backend URL in AppConstants.dart
# static const String serverUrl = 'http://localhost:8080';

# Run the application
flutter run -d windows  # For Windows
flutter run -d macos    # For macOS
flutter run -d linux    # For Linux



## 📈 Analytics

* **Real-time dashboard statistics**
* **Product distribution by category**
* **Location-wise product quantity**
* **Product balances by ID/location**

## 💡 Advanced Capabilities

* **Provider Pattern:** For clean state management
* **Custom Widgets:** Modular, reusable UI components
* **Error Handling:** With user feedback
* **Validation:** Form and input constraints
* **Responsive Design:** Desktop-optimized layouts

## 👩‍💻 Author

### Hala Abdel Halim

<p>Frontend developed with ❤️ using Flutter for <strong>ERPMax Solutions</strong><br>
<em>Flutter Developer - Specializing in Desktop and Mobile Applications</em></p>

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png" width="100%" />
