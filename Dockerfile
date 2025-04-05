# 构建阶段
FROM node:21-alpine AS builder

# 创建专用用户并设置工作目录权限
RUN adduser -D -u 1001 nextjs && \
    mkdir -p /app && \
    chown -R nextjs:nextjs /app

WORKDIR /app

# 阶段1：以 root 身份安装依赖
USER root
COPY package.json package-lock.json ./

# 设置项目本地缓存（关键修改：移除 --global）
RUN npm config set cache ./npm-cache && \
    npm install --legacy-peer-deps --unsafe-perm

# 阶段2：切换回非 root 用户进行构建
USER nextjs
COPY --chown=nextjs:nextjs . .
RUN npm run build

# 生产阶段
FROM node:21-alpine
WORKDIR /app

# 复制构建产物并设置所有权
COPY --from=builder --chown=nextjs:nextjs /app/.next ./.next
COPY --from=builder --chown=nextjs:nextjs /app/public ./public
COPY --from=builder --chown=nextjs:nextjs /app/package*.json ./
# 设置环境变量
ENV NEXT_PUBLIC_API_URL=http://route-yeasty-nightingale-hardenfeng-dev.apps.rm1.0a51.p1.openshiftapps.com
# 最终运行配置
USER nextjs
EXPOSE 3000
CMD ["npm", "start"]