# 构建阶段
FROM node:21-alpine AS builder

WORKDIR /app

# 阶段1：安装依赖
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps --unsafe-perm

# 阶段2：构建应用
COPY . .
RUN npm run build

# 生产阶段
FROM node:21-alpine
WORKDIR /app

# 复制构建产物
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./

# 安装生产依赖
RUN npm install --production --legacy-peer-deps

# 设置环境变量
ENV NEXT_PUBLIC_API_URL=http://route-yeasty-nightingale-hardenfeng-dev.apps.rm1.0a51.p1.openshiftapps.com

# 运行配置
EXPOSE 3000
CMD ["npm", "start"]
