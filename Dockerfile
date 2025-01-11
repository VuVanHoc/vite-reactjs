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

# Stage 2: Production
FROM nginx:stable-alpine

# Copy file build từ stage build
COPY --from=build /app/dist /usr/share/nginx/html

# Expose cổng 80
EXPOSE 80

# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]
