# 使用 AMD64 的 Node.js 22.14 基础镜像
FROM amd64/node:22.14 AS builder

WORKDIR /app

# 安装构建工具
RUN apt-get update && apt-get install -y python3 make g++

# 强制 npm 使用 x64 架构
RUN npm config set arch x64

# 复制依赖文件
COPY package.json package-lock.json ./

# 安装生产依赖（使用 --legacy-peer-deps 防止依赖冲突）
RUN npm install --production --force --legacy-peer-deps

# 如果有原生模块，尝试重新编译
RUN npm rebuild

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

EXPOSE 3000
CMD ["npm", "run", "start"]
