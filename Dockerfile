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
FROM nginx:1.25.3
WORKDIR /usr/share/nginx/html

# 复制构建后的 Next.js 产物
COPY --from=build /app/.next /usr/share/nginx/html
COPY --from=build /app/public /usr/share/nginx/html/public

# 复制 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 公开端口 80
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
