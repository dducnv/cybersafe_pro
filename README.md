<h1 align="center">
  <img src="/assets/images/pro_app_logo.png" width="100" alt="CyberSafe Logo">
  <br>
  <b>CyberSafe - Trình Quản Lý Mật Khẩu Ngoại Tuyến</b>
</h1>

---

## 🚀 Giới thiệu

**CyberSafe** là trình quản lý mật khẩu ngoại tuyến mạnh mẽ giúp bạn lưu trữ an toàn các thông tin nhạy cảm như tài khoản, mật khẩu và mã xác thực 2 lớp (2FA). Tất cả dữ liệu được mã hóa với thuật toán hiện đại, các key mã hóa được tạo riêng biệt cho từng thiết bị, đảm bảo tính bảo mật tối đa.

- **Bảo mật nâng cao:** Cơ sở dữ liệu SQLite được mã hóa bằng SQLCipher.
- **Hoạt động ngoại tuyến:** Dữ liệu hoàn toàn nằm trên thiết bị của bạn, không phụ thuộc vào Internet.
- **Sao lưu an toàn:** Hỗ trợ xuất file sao lưu với bảo vệ bằng mã PIN, đảm bảo an toàn ngay cả khi file bị thất lạc.

---

## 📲 Cài đặt ứng dụng

CyberSafe hiện đã có mặt trên Google Play Store với hai phiên bản:

- [CyberSafe (Miễn phí, giới hạn tính năng)](https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cybersafe_lmt)
- [CyberSafe Pro (Đầy đủ tính năng, mua một lần dùng mãi mãi)](https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cyber_safe)

---

## 💡 Tại sao có 2 phiên bản?

- **Phiên bản miễn phí:** Trải nghiệm các chức năng cơ bản, phù hợp với nhu cầu thông thường.
- **Phiên bản trả phí:** Mở khóa toàn bộ tính năng nâng cao, hỗ trợ nhà phát triển duy trì và phát triển ứng dụng.
- **Dành cho lập trình viên:** Nếu bạn là developer am hiểu Flutter, có thể tải mã nguồn và sử dụng đầy đủ chức năng.

---

## ⚙️ Hướng dẫn thiết lập & chạy mã nguồn

**Yêu cầu:** Flutter 3.35.7

1. **Thiết lập môi trường:**

   - Đổi tên file `.env.example` thành `.env`, điền các giá trị cần thiết theo yêu cầu dự án.

2. **Cài đặt và build project:**

   ```sh
   flutter pub get
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Chạy ứng dụng:**
   ```sh
   flutter run
   ```

---

## 🛡️ Tính năng nổi bật

- Lưu trữ và mã hóa thông tin tài khoản, mật khẩu, mã 2FA, ghi chú riêng tư.
- Khoá ứng dụng bằng mã PIN và sinh trắc học.
- Tự động khoá ứng dụng khi không sử dụng
- Bảo vệ cơ sở dữ liệu bằng SQLCipher.
- Xuất file sao lưu có bảo vệ bằng mã PIN.
- Hoạt động hoàn toàn ngoại tuyến.
- Giao diện hiện đại, dễ sử dụng.

---

## 🤝 Đóng góp & liên hệ

- Nếu bạn có ý tưởng hoặc muốn đóng góp, hãy mở Issue hoặc Pull Request.
- Mọi thắc mắc, góp ý vui lòng liên hệ qua email: [contact.ducnv@gmail.com]

## 📜 Ghi nhận

CyberSafe sử dụng và tham khảo một số phần mã nguồn mở:

dart-base32

- © @daegalus – MIT License
- https://github.com/Daegalus/dart-base32

dart-otp

- © @daegalus – MIT License
- https://github.com/Daegalus/dart-otp

Chân thành cảm ơn cộng đồng mã nguồn mở đã đóng góp cho sự phát triển của dự án.
