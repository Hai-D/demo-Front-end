# 使用 Node.js 22.14 完整版
FROM arm64v8/node:22-bullseye

# 设置工作目录
WORKDIR /usr/app

# 复制 package.json 和 package-lock.json
COPY package.json package-lock.json ./

# 安装生产依赖，使用 --force 防止安装失败
RUN npm install --omit=dev --force

# 复制项目文件
COPY ./ ./

# 构建 Next.js 应用
RUN npm run build

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "run", "start"]
