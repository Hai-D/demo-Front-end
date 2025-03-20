# 使用官方 Node.js 22.14.0 作为基础镜像
FROM node:22.14.0-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm ci --only=production

# 复制项目文件
COPY . .

# 构建前端项目（如果有）
RUN npm run build

# 运行应用
CMD ["npm", "start"]
