📱 Inventory Management System - Flutter Desktop



📋 Project Overview

A modern desktop inventory management application built with Flutter, offering an intuitive interface for managing products, locations, and inventory movements with real-time analytics and reporting.

This app connects to a Spring Boot backend and features a dark-themed, responsive UI, supporting interactive charts, advanced filtering, and detailed tracking.

🏗️ Architecture

The application follows a layered architecture using the Provider pattern:

Views Layer: UI screens and widgets

Providers Layer: State management & business logic

Controllers Layer: Bridges UI with services

Services Layer: Backend API communication

Models Layer: Data structures & domain models

Widgets Layer: Reusable UI components

🔧 Tech Stack

Frontend: Flutter 3.19.3

Language: Dart 3.3.0

State Management: Provider 6.1.1

HTTP Client: HTTP 1.1.0

Charts: FL Chart

UI Components: Custom widgets

🎨 UI Layout

┌─────────────────────────────────────────────────────────┐
│ CustomAppBar                                            │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────────┐        ┌─────────────────────────┐ │
│ │ Navigation      │        │        Main View        │ │
│ │ Panel           │        │                         │ │
│ └─────────────────┘        └─────────────────────────┘ │
└─────────────────────────────────────────────────────────┘

Key Components

Dashboard: Metrics cards, pie chart, bar chart

Data Tables: Product/location/movement listings

Detail Dialogs: Detailed info displays

Forms: Validated data input

Filter Panels: Advanced filtering options

Charts: Visual insights

🚀 Features

Dashboard

Feature

Description

Statistics Cards

Key metrics & icons

Category Distribution

Pie chart by product category

Product Quantity

Bar chart by location

Quick Actions

Dropdown for common operations

Real-time Updates

Pull-to-refresh

Product Management

Filterable product listing

Detail view showing stock levels

Add/edit form with validation & image upload

Category & status filtering

Location Management

Searchable list with country/city filters

Detail view showing stock per location

Add/edit form with geographic selection

Inventory Movements

Support for IN, OUT, TRANSFER

Filterable movement history

Detail view with transaction info

Add/edit form with validations

📱 Screen Showcase

Dashboard

Product & location count

Movement stats

Visual charts for distribution and quantity

Products

List & detail views

Quick actions (view/edit)

Add/edit with validation

Locations

Cards with filtering

Stock view per location

Movements

History with indicators

Filters (type, product, location)

Add/edit forms

🔄 API Integration

Service

Endpoints

ProductService

/api/products, /api/products/product-balances/{id}

LocationService

/api/locations, /api/locations/{id}/inventory

ProductMovementService

/api/productMovement

ReportsService

/api/reports/dashboard-stats, /api/reports/productDistribution

🛠️ Setup & Installation

Prerequisites

Flutter SDK 3.0+

Dart SDK 3.0+

Desktop OS (Windows/macOS/Linux)

Backend server running

Steps

git clone https://github.com/yourusername/inventory-management-flutter.git
cd inventory-management-flutter
flutter pub get

Edit AppConstants.dart:

static const String serverUrl = 'http://localhost:8081';

Run:

flutter run -d windows  # or macos / linux

💡 Advanced Features

Provider-based state management

Rich filtering across screens

Responsive & adaptive layout

Client-side validation

Custom reusable widgets

Error handling & user feedback

👨‍💻 Author

Hala Abdel HalimDeveloped with 💻 and ☕ for ERPMax SolutionsFlutter Developer | Desktop & Mobile Apps Specialist
