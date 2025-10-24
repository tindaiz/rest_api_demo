# rest_api_demo
# Post Manager App (Flutter REST API Demo)

Ứng dụng Flutter mô phỏng **quản lý bài viết (Post Manager)** — minh họa cách gọi **REST API** sử dụng **cả hai thư viện `http` và `dio`**.  
Dự án này dùng **JSONPlaceholder API** để thực hành các phương thức HTTP cơ bản:  
`GET`, `POST`, `PUT`, `DELETE`, kèm theo **Interceptor** và **Tìm kiếm bài viết**.

---

## Table of Contents
- [Tính năng chính](#tính-năng-chính)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)

## Tính năng chính

| Tính năng | Mô tả | Thư viện sử dụng |
|------------|--------|------------------|
| **GET** | Lấy danh sách bài viết | `http`, `dio` |
| **POST** | Tạo bài viết mới | `http`, `dio` |
| **PUT** | Chỉnh sửa bài viết | `http`, `dio` |
| **DELETE** | Xóa bài viết | `http`, `dio` |
| **Interceptor** | Theo dõi request & response (log) | `dio` |
| **Search** | Lọc bài viết theo tiêu đề | Flutter Widget |

---

## Project Structure

The project follows a modular structure to separate concerns and improve maintainability. Below is the directory structure of the `lib/` folder:
```
lib/
│
├── main.dart              # Điểm khởi động ứng dụng
│
├── models/
│   └── post_model.dart    # Mô hình dữ liệu Post
│
├── services/
│   ├── api_http_service.dart  # Xử lý API bằng http package
│   └── api_dio_service.dart   # Xử lý API bằng dio + interceptor
│
├── screens/
│   ├── post_list_screen.dart  # Hiển thị danh sách & tìm kiếm
│   └── post_form_screen.dart  # Thêm, sửa, xóa bài viết
│
└── widgets/
    └── post_card.dart     # Giao diện 1 bài viết 
```
### File Descriptions
- `main.dart`: Initializes the Flutter app and sets up the root widget.
- `post_model.dart`: Defines the `Post` data model for JSON serialization.
- `api_http_service.dart`: Handles HTTP requests using the `http` package.
- `api_dio_service.dart`: Uses `dio` with interceptors for advanced API handling.
- `post_list_screen.dart`: Displays a list of posts with search functionality.
- `post_form_screen.dart`: Provides a form for creating, updating, or deleting posts.
- `post_card.dart`: A reusable widget for rendering individual post items.

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

