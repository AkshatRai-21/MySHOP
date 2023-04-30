# My SHOP

This is a Flutter app that utilizes Firebase Realtime Database and Firebase Storage to allow users to manage and share product data in real-time. 

The app allows users to create an account and login using Firebase Authentication. Once logged in, users can create, edit, and manage products by filling out user input forms. The app also includes animations to provide a smooth and engaging user experience.

## Features

- User authentication
- Real-time data storage and retrieval using Firebase Realtime Database
- Shared product database that allows products added by one user to be viewed by other users of the app
- Ability to upload and retrieve files associated with products using Firebase Storage
- Animations for a smooth and engaging user experience

## Requirements

- Flutter 2.0 or newer
- Android SDK version 21 or newer
- iOS 9.0 or newer
- Firebase account and project setup

## Setup

1. Clone this repository
2. Setup a Firebase project and enable Firebase Authentication, Firebase Realtime Database, and Firebase Storage
3. Download the `google-services.json` and `GoogleService-Info.plist` configuration files from Firebase and place them in the `android/app` and `ios/Runner` directories respectively
4. Run the following command to install dependencies: 

   ```
   flutter pub get
   ```

5. Run the app using:

   ```
   flutter run
   ```



## Credits

This app was developed by Akshat Rai. If you have any questions or suggestions, please contact me at raiakshat007@gmail.com.
