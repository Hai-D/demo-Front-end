# Stage 1: 使用 Node.js 镜像进行依赖安装和构建
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 优先复制包管理文件
COPY package.json yarn.lock* package-lock.json* ./

# 安装依赖（自动识别包管理器）
RUN npm install --legacy-peer-deps

# 复制所有源代码
COPY . .

# 构建应用（Next.js 15 需要严格模式处理）
RUN npm run build

# Stage 2: 使用 Nginx 镜像部署
FROM nginx:1.23-alpine

# 删除默认配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d

# 从 builder 阶段复制构建产物
COPY --from=builder /app/.next/static /usr/share/nginx/html/_next/static
COPY --from=builder /app/public /usr/share/nginx/html/

# 设置权限（Next.js 需要特定权限）
RUN chmod -R 755 /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]