# Stage 1: Build Next.js 应用
FROM node:22.14.0 as builder
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./
RUN npm install

# 复制项目源代码
COPY . .

# 设置环境变量（构建时设置为 "/"，这样前端 axios 请求的 baseURL 将是相对路径）
ENV NEXT_PUBLIC_API_URL=/

# 构建 Next.js 应用并导出静态文件（确保在 next.config.js 中支持 export）
RUN npm run build && npm run start

# Stage 2: 使用 Nginx 部署
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# 删除默认的 Nginx 配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义的 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 将构建好的静态文件复制到 Nginx 静态文件目录
COPY --from=builder /app/out .

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
