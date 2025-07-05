# 🏆 Auction App - Flutter MVVM Auction System

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-yellow.svg)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg)

## 📽️ Demo Video

[🎬 Watch Demo](https://drive.google.com/file/d/1R_uzsegd8aKpBbLZDNDqsyJeakQGWW1E/view?usp=drive_link)



## 📱 About the App

**Auction App** is a full-featured Flutter application that simulates a real-time auction system with user authentication, bid tracking, and administrative controls. Designed with a focus on responsiveness, usability, and scalability, this app was developed as an individual university semester project using clean MVVM architecture.



## ✅ Problem It Solves

In many traditional and digital auction platforms, users struggle with real-time bid validation and transparency. This app offers a seamless and dynamic bidding experience while keeping both users and administrators in control of their data, timelines, and bid results.


## 🔑 Core Features

- 🔐 **User Authentication**
    - Sign up / login with Firebase Auth
    - Forgot/reset password support
    - Secure logout functionality

- 📦 **Auction Management (CRUD)**
    - Users can create, update, read, and delete auctions
    - Image uploading using `image_picker` + `cloudinary`
    - Bids can only be placed if auction is open and bid is valid

- 💰 **Smart Bidding System**
    - Bid placed only if it's higher than the current highest bid
    - Live validation with informative dialog feedback
    - If a user deletes a bid, the previous highest bid is automatically recalculated and updated

- 🛠️ **Admin Panel Features**
    - Admins can view all bids on each auction
    - Winning bid is clearly displayed at the end of auction

- 🧠 **MVVM Architecture**
    - Clean and scalable structure with clear separation of concerns
    - Uses GetX for efficient and reactive state management

- 🎨 **UI/UX Design**
    - Fully responsive interface
    - Visually appealing with attention to layout and feedback dialogs



## 📚 Tech Stack

- 🐦 Flutter 3.x
- 🔥 Firebase Firestore
- 🔐 Firebase Auth
- ⚙️ GetX (state management)
- 🖼️ Image Picker
- ☁️ Cloudinary for image storage
- 📦 MVVM Architecture
- 🌍 Intl package for formatting



## 📦 Dependencies Used

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.7.2
  firebase_core: ^3.13.1
  firebase_auth: ^5.5.4
  cloudinary: ^1.2.0
  image_picker: ^1.1.2
  cloudinary_sdk: ^5.0.0+1
  cloud_firestore: ^5.6.8
  intl: ^0.20.2
  superellipse_shape: ^0.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

```

## 🧑‍💻 Developer Info

This project was developed entirely by me as part of my university coursework. I handled everything from UI design to architecture planning, Firebase integration, and business logic — with clean, testable code.

If you’re looking for a passionate mobile developer with hands-on experience in Flutter, Firebase, and scalable architectures like MVVM — I’d be thrilled to bring value to your team!


## 🙌 Let's Connect

📧 Email: [ayeshasiddiqa1087@gmail.com]  
🔗 GitHub: [https://github.com/ayesh-ayesha]



