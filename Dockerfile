FROM node:21-alpine

WORKDIR /app

# 安装依赖
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 创建并切换到非 root 用户
RUN adduser -D -u 1001 nextjs
USER nextjs

# 设置环境变量
ENV NEXT_PUBLIC_API_URL=http://route-yeasty-nightingale-hardenfeng-dev.apps.rm1.0a51.p1.openshiftapps.com

# 安装生产依赖
RUN npm install --legacy-peer-deps

EXPOSE 3000
CMD ["npm", "start"]
