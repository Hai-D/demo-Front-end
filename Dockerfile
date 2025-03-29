# 使用 Node 官方的轻量版镜像
FROM node:22-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json 文件
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制全部源代码
COPY . .

# 执行构建命令
RUN npm run build

# 暴露端口（Next.js 默认3000端口）
EXPOSE 3000

# 启动应用
CMD ["npm", "start"]
