# 指定 AMD64 作为目标架构
FROM --platform=linux/amd64 node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制源代码
COPY . .

# 构建 Next.js 应用
RUN npm run build

# 生产环境使用轻量级镜像
FROM --platform=linux/amd64 node:18-alpine AS runner

# 设置工作目录
WORKDIR /app

# 复制构建产物
COPY --from=builder /app ./

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=3000

# 运行应用
CMD ["npm", "run", "start"]