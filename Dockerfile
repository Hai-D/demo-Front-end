# # 使用 AMD64 的 Node.js 22.14 基础镜像
# FROM node:22.14.0-alpine AS builder

# # 设置工作目录
# WORKDIR /app

# # 复制 package.json 和 package-lock.json
# COPY package.json package-lock.json ./

# # 安装依赖
# RUN npm install --frozen-lockfile

# # 复制所有源代码
# COPY . .

# # 构建 Next.js 应用
# RUN npm run build

# # 生产环境镜像，使用更轻量级的 Node.js 22-alpine 运行时
# FROM node:22.14.0-alpine

# # 设置工作目录
# WORKDIR /app

# # 复制构建产物
# COPY --from=builder /app ./

# # 安装仅生产环境依赖
# RUN npm install --production

# # 开放端口
# EXPOSE 3000

# # 启动 Next.js 应用
# CMD ["npm", "run", "start"]
# 使用 Node.js 基础镜像
FROM node:14-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目文件
COPY . .

# 定义构建参数并设置环境变量
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

# 构建 Next.js 应用
RUN npm run build

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "start"]