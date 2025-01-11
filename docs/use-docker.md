# Hướng dẫn Docker

## 1. Môi trường

Cài đặt:

-   Docker: https://docs.docker.com/engine/install/

## 2. Sử dụng Docker

Xem nội dung trong file `Dockerfile`

## 3. Workflow trong `Dockerfile`

Trong file `Dockerfile` bao gồm 2 phần:

### 3.1 Build project

```Dockerfile
# Stage 1: Build
FROM node:20-alpine AS build

# Cài đặt pnpm
RUN npm install -g pnpm

# Tạo thư mục làm việc
WORKDIR /app

# Copy file package.json và pnpm-lock.yaml để cài đặt dependencies
COPY package.json pnpm-lock.yaml ./

# Cài đặt dependencies
RUN pnpm install

# Copy toàn bộ mã nguồn
COPY . .

# Nhận biến môi trường từ build arguments
ARG VITE_API_URL
ARG VITE_APP_NAME
ENV VITE_API_URL=${VITE_API_URL}
ENV VITE_APP_NAME=${VITE_APP_NAME}

# Build dự án
RUN pnpm build
```

**GHI CHÚ**

-   Các biến môi trường dùng trong dự án lưu ở file `.env` cần được khai báo vào file `Dockerfile`, để quá trình build sẽ đóng gói cả giá trị của các biến env này vào image.
-   Ví dụ: Nếu trong code sử dụng 2 biến env là `VITE_API_URL` & `VITE_APP_NAME`, ta phải khai báo `ARG` và `ENV` trong file `Dockerfile`

```Javascript
// File .env

VITE_API_URL=https://api.example.com
VITE_APP_NAME=MyApp-Production
```

```Javascript
//File App.tsx

function App() {
    const appName = import.meta.env.VITE_APP_NAME;
    const appUrl = import.meta.env.VITE_API_URL;

    return (
        <div>
            <p>App Name: {appName}</p>
            <p>App URL: {appUrl}</p>
        </div>

    );
}

export default App;
```

```Javascript
// File Dockerfile
// Nhận biến môi trường từ build arguments

ARG VITE_API_URL
ARG VITE_APP_NAME

ENV VITE_API_URL=${VITE_API_URL}
ENV VITE_APP_NAME=${VITE_APP_NAME}
```

### 3.2. Đóng gói folder build xong thành Docker image

Với mỗi dự án, folder build ra có thể là `/dist (Vite+ReactJS)`, `/build (NestJS)`, `/.next (NextJS)`, chú ý sửa lại path tương ứng

```Dockerfile
# Stage 2: Production
FROM nginx:stable-alpine

# Copy file build từ stage build
COPY --from=build /app/dist /usr/share/nginx/html

# Expose cổng 80
EXPOSE 80

# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### 3.3. Chạy image

Chạy: `docker run -d -p 5173:80 vite-reactjs:latest` \
Trong đó:

-   5173: Port public trên server
-   80: Port expose từ container Docker (`EXPOSE 80` trong file `Dockerfile`)
-   vite-reactjs: tên Docker image
-   latest: version của image (tags)
