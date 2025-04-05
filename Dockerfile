# 构建阶段
FROM node:21-alpine AS builder
WORKDIR /app

# 安装依赖（包含构建时环境变量）
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# 生产阶段
FROM node:21-alpine
WORKDIR /app

# 安全配置
RUN adduser -D -u 1001 nextjs
USER nextjs

# 复制构建产物（包含环境变量）
COPY --from=builder --chown=nextjs:nextjs /app/.next ./.next
COPY --from=builder --chown=nextjs:nextjs /app/public ./public
COPY --from=builder --chown=nextjs:nextjs /app/package*.json ./

# 设置环境变量
ENV NEXT_PUBLIC_API_URL=http://route-yeasty-nightingale-hardenfeng-dev.apps.rm1.0a51.p1.openshiftapps.com

# 安装生产依赖（必须安装 next）
RUN npm install --production --legacy-peer-deps

EXPOSE 3000
CMD ["npm", "start"]
