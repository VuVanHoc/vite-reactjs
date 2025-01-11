# Github Actions

## 1. Mục đích

-   Sử dụng Github Actions để build & push Docker image của dự án lên [Dockerhub](https://hub.docker.com/)
-   Tự động deploy app sau khi build xong

## 2. Hướng dẫn sử dụng

-   Khai báo bằng file `.yml` trong thư mục `.github/workflows`
-   Có thể dùng 1 hoặc nhiều file `.yml` để khai báo workflows

### Ví dụ

Xem file `dev.yml` & `main.yml`, trong đó: `dev.yml` khai báo workflow áp dụng cho nhánh `dev`, `main.yml` áp dụng cho nhánh `main`

## 3. Giải thích cơ chế hoạt động

### 3.1. Khai báo workflow, branch áp dụng

```yml
name: Build and Push Docker Image on Dev branch

on:
    push:
        branches:
            - dev # Chạy khi có push vào nhánh dev
```

### 3.1 Build project

```yml
build:
    runs-on: ubuntu-latest

    steps:
        # Checkout code
        - name: Checkout code
          uses: actions/checkout@v3

        # Set up Node.js (pnpm requires Node.js)
        - name: Set up Node.js
          uses: actions/setup-node@v3
          with:
              node-version: 20

        # Install pnpm
        - name: Install pnpm
          run: npm install -g pnpm

        # Install dependencies
        - name: Install dependencies
          run: pnpm install

        # Build application
        - name: Build application
          env:
              VITE_API_URL: ${{ secrets.VITE_API_URL_DEV }}
              VITE_APP_NAME: ${{ secrets.VITE_APP_NAME_DEV }}
          run: pnpm build

        # Build Docker image
        - name: Log in to Docker Hub
          uses: docker/login-action@v2
          with:
              username: ${{ secrets.DOCKER_USERNAME }}
              password: ${{ secrets.DOCKER_PASSWORD }}

        - name: Build and push Docker image
          uses: docker/build-push-action@v4
          with:
              context: .
              push: true
              tags: your-dockerhub-username/vite-reactjs:latest
              build-args: |
                  VITE_API_URL=${{ secrets.VITE_API_URL_DEV }}
                  VITE_APP_NAME=${{ secrets.VITE_APP_NAME_DEV }}
```

**GHI CHÚ**

-   Giá trị các biến `secrets` được lưu trong phần Setting của repo trên Github.
-   Sử dụng action `docker/build-push-action@v4` để build & push image lên Dockerhub. Các biến `env` lưu ở `Secrets` & truyền vào quá trình build thông qua `build-args`

### 3.2 Deploy app
