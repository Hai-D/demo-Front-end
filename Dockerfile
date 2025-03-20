# 使用官方 Node.js LTS 版本作为基础镜像，指定 amd64 架构
FROM --platform=linux/amd64 node:22.14.0-slim

# 设置工作目录
WORKDIR /app

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    libc6 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# 复制 package.json 和 package-lock.json（如果存在）
COPY package*.json ./

# 安装项目依赖
RUN npm install --production

# 复制 Next.js 项目文件
COPY . .

# 构建 Next.js 应用
RUN npm run build

# 设置容器端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]