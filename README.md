# Social Feed App

A Flutter social media application implementing MVC architecture with BLoC pattern for state management.

## Architecture Overview

### MVC + BLoC Pattern
The application follows MVC architecture with BLoC for state management:
- **Models**: Data entities and business logic
- **Views**: UI components and screens
- **Controllers**: Business logic and state coordination
- **BLoC**: Handles complex state management

## Project Structure
```
lib/
├── models/
│   └── entities/       # Data models
├── views/
│   ├── screens/        # Main screens
│   │   ├── auth/       # Authentication screens
│   │   ├── feed/       # Feed management
│   │   └── profile/    # Profile screens
│   └── widgets/        # Reusable components
├── controllers/        # Business logic
├── data/
│   ├── database/       # Database configuration
│   └── dao/           # Data Access Objects
├── services/          # Utility services
├── bloc/             # State management
└── config/           # App configuration
```

## Features

### Authentication
- Local authentication system
- Secure password handling
- Profile management
- Session persistence

### Feed Management
- Create, read, update, delete posts
- Image handling with local storage
- Like functionality with animations
- Post sorting (Recent, Popular, Trending)

### Profile Features
- Profile picture management
- User information updates
- Date handling and validation
- Image compression

## Technical Stack

### Core Dependencies
- **Database**: Floor (SQLite)
- **State Management**: BLoC Pattern
- **Navigation**: GoRouter
- **Image Handling**: CachedNetworkImage

### Key Technical Decisions

#### Local Storage
- Floor for type-safe database operations
- Local image storage for performance
- Cached network images

#### Performance
- Image compression
- Lazy loading
- Efficient post sorting
- Resource management

#### Security
- Password hashing
- Input validation
- Secure local storage

## Getting Started

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

Citations:
[1] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/2499385/fedddace-8b2f-40a5-b971-70320d46bf3a/paste.txt
[2] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/2499385/a3bcf2a9-a22d-4b28-ac80-debac3dbcb11/paste.txt
[3] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/2499385/5059f7ce-07b5-4dc7-b43c-a8d184a3563e/paste.txt