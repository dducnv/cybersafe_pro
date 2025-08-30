<h1 align="center">
  <img src="/assets/images/pro_app_logo.png" width="100" alt="CyberSafe Logo">
  <br>
  <b>CyberSafe - Offline Password Manager</b>
</h1>

---

## 🚀 Introduction

**CyberSafe** is a powerful offline password manager designed to securely store sensitive information such as accounts, passwords, and 2FA codes. All your data is encrypted using advanced algorithms, with unique encryption keys generated independently for each device, ensuring maximum security.

- **Enhanced Security:** The SQLite database is encrypted using SQLCipher.
- **Offline Operation:** All data is stored locally on your device, with no Internet dependency.
- **Secure Backup:** Supports exporting backup files protected by a PIN code, keeping your data safe even if the backup file is lost.

---

## 📲 Download the App

CyberSafe is available on Google Play Store in two versions:

- [CyberSafe (Free, limited features)](https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cybersafe_lmt)
- [CyberSafe Pro (Full features, one-time purchase)](https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cyber_safe)

---

## 💡 Why two versions?

- **Free version:** Experience basic features suitable for general needs.
- **Paid version:** Unlock all advanced features and support the developer to maintain and improve the app.
- **For Developers:** If you’re familiar with Flutter, you can download the source code and run the app with full functionality.

---

## ⚙️ Setup & Running from Source

**Requirement:** Flutter 3.29.3

1. **Environment setup:**

   - Rename `.env.example` to `.env` and fill in the required values as specified by the project.

2. **Install dependencies and build the project:**

   ```sh
   flutter pub get
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

---

## 🛡️ Key Features

- Store and encrypt account info, passwords, 2FA codes, and private notes.
- App lock with PIN and biometrics.
- Automatically lock the app when idle.
- Database protection using SQLCipher.
- Export backup files protected by a PIN.
- Fully offline operation.
- Modern and easy-to-use interface.

---

## 🤝 Contribution & Contact

- If you have ideas or want to contribute, please open an Issue or Pull Request.
- For questions or feedback, contact: [contact.ducnv@gmail.com]
