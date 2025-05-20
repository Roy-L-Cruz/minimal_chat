# Minimal Chat App

A modern, lightweight chat application built with Flutter that supports user authentication, real-time messaging, and admin functionality.

## Features

- 🔐 User Authentication
  - Login/Register functionality
  - Secure password storage
  - Session management

- 💬 Chat Features
  - Real-time messaging
  - Chat history
  - User-to-user conversations
  - Message deletion
  - Modern UI with message bubbles

- 👑 Admin Panel
  - User management
  - Message management
  - Admin privileges
  - User role modification

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android SDK
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/minimal_chat.git
cd minimal_chat
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Default Admin Account

The app comes with a default admin account:
- Username: `bot`
- Password: `bot123`

## Database Schema

The app uses SQLite for local storage with the following schema:

### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  is_admin INTEGER DEFAULT 0
);
```

### Messages Table
```sql
CREATE TABLE messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sender_id INTEGER NOT NULL,
  receiver_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);
```

## Project Structure

```
lib/
├── db/
│   └── database_helper.dart
├── models/
│   ├── message.dart
│   └── chat_partner.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── admin_screen.dart
│   ├── chat_screen.dart
│   ├── chats_list_screen.dart
│   ├── login_screen.dart
│   ├── new_chat_screen.dart
│   └── register_screen.dart
└── main.dart
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- SQLite for the database
- All contributors who have helped shape this project
