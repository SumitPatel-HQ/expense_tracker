# Expense tracker

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)](https://sqlite.org)
[![Provider](https://img.shields.io/badge/Provider-6.1.5-blueviolet?style=flat)](https://pub.dev/packages/provider)

Expense tracker is a Flutter application that records and organizes daily expenses in a local SQLite database.

## Table of contents

- [Features](#features)
- [Directory structure](#directory-structure)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Install dependencies](#install-dependencies)
  - [Run the application](#run-the-application)
- [Build release artifacts](#build-release-artifacts)
- [Development branches](#development-branches)
- [Planned features](#planned-features)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Expense records.** Add, edit, view, and delete expenses. Each entry stores a title, numerical amount, category, date, and optional description.
- **Input checks.** The form rejects blank titles and negative numbers.
- **Live search.** Typing in the search bar matches text in the title, category name, or description.
- **Category filtering.** Filter expenses by Travel, Food, Utilities, Housing, Shopping, Entertainment, Education, or Work.
- **Sorting.** Sort the list by newest date, oldest date, lowest amount, or highest amount.
- **Total calculation.** The top card shows the sum of all stored expenses.
- **User session.** The login screen accepts a name and email, saves the record to SQLite, and sets a login flag in SharedPreferences.
- **Local storage.** Data is saved in a local SQLite database with indexes on the category and date columns.

## Directory structure

```
lib/
├── database/
│   ├── app_database.dart          # Database open, migration, and table creation
│   ├── expense_database.dart      # SQL queries for expenses
│   └── user_database.dart         # SQL queries for the user profile
├── models/
│   ├── category.dart              # Category enum and name mappings
│   ├── expense.dart               # Expense data class and map serialization
│   └── user_profile.dart          # UserProfile data class
├── providers/
│   ├── expense_provider.dart      # Expense list state, filter, search, and sort logic
│   └── user_provider.dart         # Session status and active profile state
├── screens/
│   ├── expense_form_screen.dart   # Add and edit form with date picker
│   ├── home_screen.dart           # Main dashboard with expense feed
│   ├── login_screen.dart          # Name and email entry screen
│   └── profile_screen.dart        # User profile display and logout action
└── main.dart                      # App entry point, theme setup, and provider tree
```

## Getting started

### Prerequisites

Install the following tools:
- Flutter SDK 3.10.8 or newer
- Dart SDK
- Android Studio or VS Code with Flutter and Dart extensions
- An Android device, emulator, or iOS simulator

### Install dependencies

Clone the repository and fetch packages:

```bash
git clone https://github.com/SumitPatel-HQ/expense_traker.git
cd expense_traker
flutter pub get
```

Run checks to confirm your local tools are configured:

```bash
flutter doctor
```

### Run the application

Start the app on an active emulator or device:

```bash
flutter run
```

To target a specific platform:

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

## Build release artifacts

### Android

Generate an APK:

```bash
flutter build apk --release
```

Generate an Android App Bundle for Google Play:

```bash
flutter build appbundle --release
```

Output files are written to `build/app/outputs/flutter-apk/` and `build/app/outputs/bundle/release/`.

### iOS

Generate an iOS release build:

```bash
flutter build ios --release
```

## Development branches

The repository uses the following branch structure:

- `master`: Stable production code.
- `develop`: Integration branch for daily development.
- `feature/<name>`: Topic branches for individual features.

Pull requests should target the `develop` branch.

## Planned features

- [ ] Bar and pie charts for category breakdowns
- [ ] Monthly budget caps with spending notifications
- [ ] CSV and PDF export options
- [ ] Dark theme toggle
- [ ] Cloud sync and backup
- [ ] Currency selector

## Contributors

- Sumit ([@SumitPatel-HQ](https://github.com/SumitPatel-HQ))
- Ashish ([@ashish-dev](https://github.com/ashish-dev))
- Saumil ([@saumil196](https://github.com/saumil196))

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
