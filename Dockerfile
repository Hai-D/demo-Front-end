# 使用 AMD64 的 Node.js 22.14 基础镜像
FROM node:22.14.0-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package.json package-lock.json ./

# 安装依赖
RUN npm install --frozen-lockfile

# 复制所有源代码
COPY . .

# 构建 Next.js 应用
RUN npm run build

# 生产环境镜像，使用更轻量级的 Node.js 22-alpine 运行时
FROM node:22.14.0-alpine

# 设置工作目录
WORKDIR /app

# 复制构建产物
COPY --from=builder /app ./

# 安装仅生产环境依赖
RUN npm install --production

# 开放端口
EXPOSE 3000

# 启动 Next.js 应用
CMD ["npm", "run", "start"]