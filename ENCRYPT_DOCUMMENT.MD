# TÀI LIỆU HỆ THỐNG MÃ HÓA CYBERSAFE PRO

## 1. Tổng quan

`EncryptAppDataService` là dịch vụ trung tâm quản lý toàn bộ quá trình mã hóa/giải mã dữ liệu trong ứng dụng CyberSafe Pro. Service này được thiết kế để bảo vệ thông tin nhạy cảm như mật khẩu, thông tin tài khoản và mã TOTP.

### Đặc điểm chính:
- Sử dụng mô hình Singleton với instance duy nhất truy cập toàn cục
- Triển khai nhiều lớp mã hóa khác nhau cho từng loại dữ liệu
- Hỗ trợ cơ chế bảo vệ khóa trong bộ nhớ (Orchestration Key)
- Có cơ chế cache key để tối ưu hiệu suất
- Hỗ trợ tạo/khôi phục backup dữ liệu
- Có cơ chế chuyển đổi dữ liệu từ phiên bản cũ

## 2. Cấu trúc và Cấu hình

### EncryptionConfig
Lớp cấu hình chứa các hằng số cơ bản:
- `PBKDF2_ITERATIONS`: 20,000 (số vòng lặp cho thuật toán PBKDF2)
- `KEY_SIZE_BYTES`: 32 (kích thước khóa)
- `MIN_PIN_LENGTH`: 6 (độ dài tối thiểu của PIN)
- `MAX_BACKUP_SIZE_MB`: 50 (kích thước tối đa của file backup)
- `RETRY_DELAY`: 1 giây (thời gian chờ giữa các lần thử lại)
- `MAX_RETRY_ATTEMPTS`: 3 (số lần thử lại tối đa)
- `KEY_CACHE_DURATION`: 15 phút (thời gian cache khóa)

### Enum KeyType
Định nghĩa các loại khóa mã hóa:
- `info`: Mã hóa thông tin chung
- `password`: Mã hóa mật khẩu
- `totp`: Mã hóa mã TOTP
- `pinCode`: Mã hóa mã PIN

## 3. Cơ chế Hoạt động

### 3.1 Khởi tạo và Quản lý Khóa

#### Device Key
- Device Key là khóa gốc, được tạo ngẫu nhiên khi ứng dụng được cài đặt
- Được lưu trữ an toàn trong SecureStorage
- Được sử dụng làm cơ sở để tạo ra các khóa mã hóa khác

#### Orchestration Key
- Được tạo dựa trên thông tin thiết bị, thời gian và chữ ký ứng dụng
- Không được lưu trữ, chỉ tồn tại trong bộ nhớ khi ứng dụng đang chạy
- Được dùng để bảo vệ (XOR) các khóa mã hóa khi lưu trong bộ nhớ
- Bị xóa khi ứng dụng chuyển sang chế độ nền (background)

#### Encryption Keys
- Được tạo từ Device Key bằng thuật toán PBKDF2
- Các loại: info key, password key, TOTP key, pinCode key
- Được lưu trong SecureStorage và cache trong bộ nhớ (có bảo vệ)

### 3.2 Luồng Khởi tạo

1. **Khởi tạo Orchestration Key**: Tạo khóa để bảo vệ các khóa khác trong bộ nhớ
2. **Kiểm tra tài khoản cũ/mới**: Xác định xem người dùng là từ phiên bản cũ hay mới
3. **Kiểm tra Device Key**: Xác định xem Device Key đã tồn tại chưa
4. **Tạo Device Key (nếu cần)**: Tạo mới Device Key nếu chưa có
5. **Chuyển đổi dữ liệu cũ** (nếu có): Chuyển đổi dữ liệu từ phiên bản cũ sang mới
6. **Tải trước các khóa**: Tạo và cache các khóa mã hóa để sử dụng

## 4. Các Phương thức Chính

### 4.1 Khởi tạo và Quản lý Khóa

#### `initialize()`
- **Mục đích**: Khởi tạo toàn bộ hệ thống mã hóa khi ứng dụng khởi động
- **Hoạt động**: Khởi tạo orchestration key, kiểm tra và tạo device key, chuyển đổi dữ liệu cũ (nếu cần)

#### `_initializeOrchestrationKey()`
- **Mục đích**: Tạo orchestration key dựa trên thông tin thiết bị
- **Hoạt động**: Kết hợp thông tin thiết bị, timestamp và chữ ký ứng dụng để tạo khóa

#### `_generateOrchestrationKey()`
- **Mục đích**: Tạo orchestration key
- **Hoạt động**: Kết hợp thông tin thiết bị với timestamp và chữ ký ứng dụng, hash bằng SHA-256

#### `_getDeviceKey()`
- **Mục đích**: Lấy device key từ storage hoặc cache
- **Hoạt động**: Kiểm tra cache trước, nếu không có thì đọc từ SecureStorage

#### `_generateEncryptionKey()`
- **Mục đích**: Tạo hoặc lấy khóa mã hóa dựa trên loại
- **Hoạt động**: Kiểm tra cache, nếu không có thì tạo mới từ device key bằng PBKDF2

#### `clearOrchestrationKey()`
- **Mục đích**: Xóa orchestration key khi ứng dụng vào nền
- **Hoạt động**: Đánh dấu key là chưa được khởi tạo, giúp bảo vệ khóa khỏi bị đọc từ bộ nhớ

### 4.2 Bảo vệ Khóa

#### `_protectKey()`
- **Mục đích**: Bảo vệ khóa khi lưu trong bộ nhớ
- **Hoạt động**: Thực hiện XOR giữa khóa và orchestration key

#### `_unprotectKey()`
- **Mục đích**: Khôi phục khóa đã được bảo vệ
- **Hoạt động**: Thực hiện XOR ngược lại để lấy khóa gốc

### 4.3 Mã hóa và Giải mã

#### `encryptInfo()` / `decryptInfo()`
- **Mục đích**: Mã hóa/giải mã thông tin chung (tên, email, ghi chú)
- **Hoạt động**: Sử dụng info key và thực hiện trong isolate để tránh block UI

#### `encryptPassword()` / `decryptPassword()`
- **Mục đích**: Mã hóa/giải mã mật khẩu
- **Hoạt động**: Sử dụng password key và thuật toán Fernet

#### `encryptTOTPKey()` / `decryptTOTPKey()`
- **Mục đích**: Mã hóa/giải mã khóa TOTP
- **Hoạt động**: Sử dụng TOTP key và thuật toán Fernet

#### `encryptPinCode()` / `decryptPinCode()`
- **Mục đích**: Mã hóa/giải mã mã PIN
- **Hoạt động**: Sử dụng pinCode key và thuật toán Fernet

### 4.4 Backup và Khôi phục

#### `createBackup()`
- **Mục đích**: Tạo bản sao lưu dữ liệu được mã hóa bằng PIN
- **Hoạt động**: Giải mã dữ liệu, tạo JSON, mã hóa bằng PIN, thêm checksum

#### `restoreBackup()`
- **Mục đích**: Khôi phục dữ liệu từ bản sao lưu
- **Hoạt động**: Giải mã dữ liệu bằng PIN, kiểm tra tính hợp lệ, mã hóa lại và lưu vào DB

### 4.5 Xoay khóa (Key Rotation)

#### `rotateKeys()`
- **Mục đích**: Thay đổi toàn bộ khóa mã hóa để tăng cường bảo mật
- **Hoạt động**: 
  1. Tạo Device Key mới và các Encryption Keys mới
  2. Giải mã dữ liệu với khóa cũ
  3. Mã hóa lại với khóa mới
  4. Xác thực dữ liệu sau khi mã hóa lại
  5. Lưu khóa mới và dữ liệu đã mã hóa lại

## 5. Lớp Hỗ trợ

### `_CachedKey`
- **Mục đích**: Lưu trữ khóa trong bộ nhớ với thời gian hết hạn
- **Hoạt động**: Lưu khóa và thời gian hết hạn, cung cấp phương thức kiểm tra hết hạn

### `_LRUCache`
- **Mục đích**: Cache khóa theo thuật toán Least Recently Used
- **Hoạt động**: Loại bỏ các khóa ít sử dụng nhất khi cache đầy

### `_TempEncryptionService`
- **Mục đích**: Service tạm thời để mã hóa dữ liệu khi rotate keys
- **Hoạt động**: Sử dụng khóa mới để mã hóa/giải mã mà không ảnh hưởng khóa chính

## 6. Cơ chế Bảo mật

1. **Mã hóa nhiều lớp**: Mỗi loại dữ liệu được mã hóa bằng khóa riêng
2. **Bảo vệ khóa trong bộ nhớ**: Sử dụng orchestration key để bảo vệ các khóa khi cache
3. **Xóa khóa khi không sử dụng**: Xóa orchestration key khi ứng dụng vào nền
4. **Isolate cho tác vụ nặng**: Sử dụng isolate cho mã hóa/giải mã để tránh block UI
5. **Tính năng retry**: Cơ chế thử lại với độ trễ tăng dần
6. **Kiểm tra tính toàn vẹn**: Sử dụng checksum khi backup/restore
7. **Cache thông minh**: Cache khóa theo LRU với thời gian hết hạn

## 7. Lưu ý và Thực tiễn

- **Cache thông minh**: Khóa chỉ được lưu trong bộ nhớ tạm thời và có bảo vệ
- **Xử lý ngoại lệ**: Toàn bộ hệ thống có xử lý ngoại lệ đầy đủ
- **Logging**: Có hệ thống log lỗi chi tiết
- **Tính linh hoạt**: Dễ dàng thay đổi thuật toán và cấu hình mã hóa
- **Hiệu suất**: Sử dụng isolate và cache để tối ưu hiệu suất

## 8. Luồng dữ liệu

```
Nhập dữ liệu → Mã hóa (encryptXXX) → Lưu vào Database → Đọc từ Database → Giải mã (decryptXXX) → Hiển thị
```

Orchestration Key bảo vệ các khóa mã hóa khi lưu trong bộ nhớ, đảm bảo rằng ngay cả khi attacker có thể truy cập vào memory dump của ứng dụng, họ cũng không thể dễ dàng đọc được các khóa mã hóa.
