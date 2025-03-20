# 选择合适的基础镜像
FROM node:22.14.0-slim

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装生产环境依赖
RUN npm install --only=production || npm ci --only=production

# 复制代码
COPY . .

# 构建前端
RUN npm run build

# 设置运行命令
CMD ["npm", "start"]
