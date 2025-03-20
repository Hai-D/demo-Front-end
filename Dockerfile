# 使用 AMD64 的 Node.js 22.14 基础镜像（基于 Debian/Bullseye）
FROM amd64/node:22.14 AS builder

# 设置工作目录
WORKDIR /app

# 安装构建工具
RUN apt-get update && apt-get install -y python3 make g++

# 复制依赖文件
COPY package.json package-lock.json ./

# 安装生产依赖（使用 --legacy-peer-deps 防止依赖冲突）
RUN npm install --production --force --legacy-peer-deps

# 复制源码并构建 Next.js 应用
COPY . .
RUN npm run build

# 生产环境镜像
FROM amd64/node:22.14 AS runner

WORKDIR /app

# 复制构建产物
COPY --from=builder /app/.next .next
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/public public

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "run", "start"]
