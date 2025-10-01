# Fam Assignment - Flutter

## 📱 APK Download

👉 [Download APK](https://drive.google.com/file/d/14exloO99-AjZZooFjWWcnknwHHi0c2QX/view?usp=drive_link)

---

## 📖 Project Overview

This project implements a **standalone container** that renders a list of **Contextual Cards** using the FamPay API.

* Cards are rendered dynamically from JSON API response.
* Designed as a **Plug-and-Play component**: can be inserted into any screen independently.
* Figma designs used as reference for card layouts.
* Fully supports deep links, swipe-to-refresh, and card dismissal/reminder functionality.

---

## ⚡ Features

* ✅ API-driven contextual card rendering  
* ✅ Deep link handling for cards, CTAs, and text entities  
* ✅ HC3 (Big Display Card) → Long press actions (Remind Later, Dismiss Now)  
* ✅ Swipe down to refresh  
* ✅ Loading and error states  
* ✅ Reusable, modular MVVM architecture  
* ✅ Matches Figma design closely  

---

## 📂 Project Structure

```

lib/
│── data/             # API services, network layer
│── models/           # Data models for API schema
│── repository/       # Repository layer for data handling
│── res/              # App resources (colors, styles, constants)
│── utils/            # Helpers and utilities
│── view/             # UI screens
│── view_model/       # State management (Provider / controllers)
│── widgets/          # Reusable UI components (Cards, etc.)
│── main.dart         # Entry point

````

This structure follows **MVVM pattern**:

* **Model** → `models/`  
* **View** → `view/`, `widgets/`  
* **ViewModel** → `view_model/`  
* **Repository + Data** → API and local data access  

---

## 🛠️ Tech Stack

* **Flutter** (Dart)  
* **Provider** for state management  
* **HTTP** for API calls  
* **MVVM architecture** for clean separation of concerns  

---

## 🚀 Getting Started

### 1️⃣ Clone the repo

```bash
git clone https://github.com/Vanshgaba8/fam_assignment.git
cd fam_assignment
````

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the app

```bash
flutter run
```

---

## 📡 API Reference

* API: [FamPay Mock API](https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage)
* Design: [Figma Reference](https://www.figma.com/file/AvK2BRGwMTv4kQab5ymJ0K/AAL3-Android-assignment-Design-Specs)

---

## 🎥 Demo / Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/9afba09a-0daa-4225-947a-9ff1d72ab2b4" alt="Screenshot 1" width="300"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/94b50c6e-bfb3-4fb7-a6c3-a6fecaf5f180" alt="Screenshot 2" width="300"/>
</p>

---

## 👨‍💻 Author

**Vansh Gaba**

---

