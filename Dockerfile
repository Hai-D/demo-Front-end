# 构建阶段
FROM node:21-alpine AS builder

# 创建专用用户并赋予权限
RUN adduser -D -u 1001 nextjs && \
    mkdir -p /app/node_modules && \
    chown -R nextjs:nextjs /app

# 切换到非 root 用户
USER nextjs

WORKDIR /app
COPY package.json package-lock.json ./

# 修复权限并安装依赖
RUN npm config set cache ./.npm-cache --global && \
    npm install --legacy-peer-deps --unsafe-perm

COPY . .
RUN npm run build

# 生产阶段
FROM node:21-alpine
WORKDIR /app
COPY --from=builder --chown=nextjs:nextjs /app/.next ./.next
COPY --from=builder --chown=nextjs:nextjs /app/public ./public
COPY --from=builder --chown=nextjs:nextjs /app/package*.json ./
# 设置环境变量
ENV NEXT_PUBLIC_API_URL=http://route-yeasty-nightingale-hardenfeng-dev.apps.rm1.0a51.p1.openshiftapps.com

USER nextjs
EXPOSE 3000
CMD ["npm", "start"]