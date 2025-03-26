# 使用 Node.js 作为基础镜像来构建 Next.js 应用
FROM node:22.14.0 as build
WORKDIR /app

# 复制 package.json 和 package-lock.json，并安装依赖
COPY package*.json ./
RUN npm install

# 复制项目代码并进行构建
COPY . .
ENV NEXT_PUBLIC_API_URL=/api  
RUN npm run build

# 使用 Nginx 作为前端服务器
FROM nginx:stable-alpine

# 删除默认配置，替换为自定义配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制 Nginx 配置到正确路径
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 复制静态文件到Nginx根目录
COPY --from=builder /app/out /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

