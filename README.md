# Firefly Chat App

Firefly Chat is a modern real-time messaging app built with Flutter on the front-end and Node.js (Fastify) on the back-end. It allows users to communicate through instant messages, with support for image uploads, JWT-secured authentication, and real-time presence tracking over WebSockets.

<div align="center">
    <img src="https://1drv.ms/i/c/0852b71d1fb2ccf4/IQQpho9QgcFYTqqO3xhHGo1hAelVS3vXuIt-sydh7Ii6nDY?height=1024" alt="login_screen" height="320" />
    <img src="https://1drv.ms/i/c/0852b71d1fb2ccf4/IQTTsU0nB6H0SZF4mlwMtl93AcXv5KaIi8aMdYOV9wRM5kY?height=1024" alt="friends_screen" height="320" />
    <img src="https://1drv.ms/i/c/0852b71d1fb2ccf4/IQTiWTZ4O4OiRpeo8bb30XaGAWSV3Ce7mZZBFoEQSSRzcfk?height=1024" alt="drawer_open" height="320" />
    <img src="https://1drv.ms/i/c/0852b71d1fb2ccf4/IQQOUH8VVSDdR7Lu9bBBDMBcAdhBVX3mNo_rFLpnlvnBmKY?height=1024" alt="notification_screen" height="320" />
    <img src="https://1drv.ms/i/c/0852b71d1fb2ccf4/IQSm8Wd3MrWOQLbQiito3zj7AaULx-jENq__e3zKxs9aaiA?height=1024" alt="chat_screen" height="320" />
</div>

## 📱 Features
- User authentication using JWT
- Real-time messaging with WebSocket
- Image upload from gallery with preview
- Online user presence tracking
- Message history per room
- Notifications
- Support for multiple chat rooms (in progress)

## 🛠️ Technologies Used
- Front-end (Flutter)
- Flutter with Dart
- State management with Provider
- Native WebSocket (dart:io) communication
- image_picker for image selection
- HTTP for REST API integration
- Responsive UI with Material 3 and animations

## Back-end (Node.js + Fastify)
- Fastify for HTTP and WebSocket server
- @fastify/websocket for real-time communication
- Event-based WebSocket architecture (new_message, message, etc.)
- Database integration (PostgreSQL)

## ⚙️ How to Run

1. Install the Flutter SDK: https://docs.flutter.dev/get-started/install
2. Clone this repository
3. Install dependencies:

```bash
  flutter pub get
```

```bash
  flutter run
```

## 🔐 Authentication

Authentication is handled via JWT. The token is used in both REST API calls and during the WebSocket handshake, passed in the header as:

```http
  Authorization: Bearer <token>
```

### 🚧 In Development
- Push notifications
- Message search
- Typing indicators
- Voice/video calls (future plan)

## 📄 License
This project is licensed under the MIT License. You are free to use, modify, and share it.

Feel free to reach out for collaboration or feedback!
