
Flutter Chat Application
========================

This repository contains a simple and lightweight chat application built using the Flutter framework with local data persistence through SQLite. The project implements user authentication, one-to-one messaging, and message history, all stored locally on the device. It is designed with an offline-first architecture, making it functional even without an internet connection.

Features
--------
- User registration and login (locally stored)
- One-to-one chat functionality
- Local message storage using SQLite
- Recent messages and timestamps for each user chat
- Proper alignment of messages (user vs. others)
- Clean and minimal user interface

Prerequisites
-------------
Before running this application, ensure the following tools are installed on your development environment:
- Flutter SDK (latest stable version)
- Dart SDK (bundled with Flutter)
- Git
- An IDE such as Android Studio or Visual Studio Code
- Android Emulator or connected device for testing

Getting Started
---------------

1. Clone the Repository
   git clone https://github.com/your-username/flutter_chat_app.git
   cd flutter_chat_app

2. Install Dependencies
   flutter pub get

3. Run the Application
   flutter run -d android   # Android devices
   flutter run -d chrome    # Web (if enabled)
   flutter run -d windows   # Windows desktop (optional)

   The application initializes the local SQLite database on first launch. No external configuration is required.

Project Structure
-----------------
lib/
├── main.dart                    # Application entry point
├── screens/
│   ├── auth_screen.dart         # Sign up / login screen
│   ├── chat_screen.dart         # Main chat interface
│   └── home_screen.dart         # Displays list of chat partners
├── services/
│   └── auth_service.dart        # Authentication logic
├── database/
│   └── database_helper.dart     # SQLite operations and schema
└── widgets/
    └── chat_message.dart        # Message display component

Dependencies
------------
The following Flutter packages are utilized in the project:

- sqflite: SQLite plugin for Flutter
- path_provider: Provides access to commonly used paths
- path: Utility functions for manipulating paths
- provider: State management
- flutter: Flutter SDK
- cupertino_icons: iOS-style icons

All dependencies are listed in the pubspec.yaml file.

Data Management
---------------
The application uses an SQLite database with two primary tables: users and messages. It uses foreign key constraints with ON DELETE CASCADE to ensure referential integrity—deleting a user automatically deletes associated messages.

The message query system retrieves chat partners with the most recent message and timestamp using optimized SQL queries.

License
-------
This project is licensed under the MIT License. See the LICENSE file for more information.

Contribution
------------
Contributions are welcome. To contribute:

1. Fork the repository.
2. Create a feature branch: git checkout -b feature/YourFeatureName
3. Commit your changes: git commit -m 'Add new feature'
4. Push to the branch: git push origin feature/YourFeatureName
5. Open a pull request.

Contact
-------
For issues, suggestions, or questions, please open an issue on GitHub or contact me on roylimin18@gmail.com.
