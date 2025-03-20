# 使用一个稳定的基础镜像
FROM node:22.14.0-slim

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 清理缓存并安装生产依赖
RUN npm cache clean --force \
  && npm install --only=production \
  && npm run build \
  || (echo "npm install failed, trying npm ci"; npm ci --only=production)

# 复制应用的源代码
COPY . .

# 设置默认的命令来运行前端
CMD ["npm", "start"]
