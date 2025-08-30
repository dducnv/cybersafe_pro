<h1 align="center"><img src="/assets/images/pro_app_logo.png.png" align="center" width="100" alt="CyberSafe Logo">CyberSafe - Trình Quản Lý Mật Khẩu Ngoại Tuyến</h1>

# CyberSafe là gì?

CyberSafe là một trình quản lý mật khẩu ngoại tuyến, CyberSafe lưu trữ các thông tin nhạy cảm như tài khoản và mật khẩu, mã xác thực 2 lớp (2FA) và được mã hoá với thuật toán mã hoá mạnh, các key mã hoá được sinh ra duy nhất cho từng thiết bị và một cách độc lập, ngoài gia ứng dụng còn được mã hoá file cơ sở dữ liệu SQLite với SQL Cipher, ứng dụng hoạt động ngoại tuyến cho phép bạn tạo file sao lưu và lưu bất ký đâu bạn cảm thấy an toàn, file sao lưu được thiết lập mặc định yêu cầu mã pin trước khi xuất nhằm đảm bảo an toàn khi file thất lạc.

# Bạn có thể cải đặt ở đâu?

Hiện tại ứng dụng đã có mặt trên Google Play Store với 2 phiên bản miễn phí giới hạn tính năng và phiên bản mua 1 lần dùng mãi mãi với đầy đủ chức năng

- [CyberSafe](https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cybersafe_lmt).
- [CyberSafe Pro](https://play.google.com/store/apps/details?id=com.duc_app_lab_ind.cyber_safe).

# Tại sao tôi lại tạo ra 2 phiên bản và yêu cầu trả phí?

- Việc tạo phiên bản trả phí nhằm tạo động lực và chi phí duy trì và phát triển ứng dụng, bản thưởng cung cấp các tính năng dây đủ và thiết yếu nhất nếu muốn ủng hộ nhà phát triển bạn có thể sử dụng bản trả phí
- Nếu bạn là 1 nhà phát triển và am hiểu với Flutter bạn có thể tải mã nguồn và chạy chương trình này với đầy đủ tính năng.

# Bạn setup nó như nào để chạy được?

Lưu ý: Ứng dụng đang chạy trên phiên bản Flutter 3.29.3

- Đầu tiên bạn hãy xem file .env.example hãy xoá đuôi .example và tạo các giá trị và flle yêu cầu.
- Sau đó chạy 3 lệnh sau
  `flutter pub get`
  `dart run build_runner clean`
  `dart run build_runner build --delete-conflicting-outputs`
- sau khi các câu lệnh hoàn thành chạy lệnh sau
  `flutter run`
