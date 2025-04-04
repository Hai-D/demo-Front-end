# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app

# 优先复制包管理文件以提高缓存效率
COPY package*.json ./

# 安装依赖（兼容 npm/yarn）
RUN npm install --legacy-peer-deps --unsafe-perm

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# Stage 2: Runtime
FROM nginx:1.23-alpine

# 解决警告 1: 处理入口点配置
# 保留默认配置目录结构，仅覆盖必要配置
RUN rm -f /etc/nginx/conf.d/default.conf && \
    mkdir -p /etc/nginx/conf.d/custom

# 复制自定义配置到正确位置
COPY nginx.conf /etc/nginx/conf.d/custom/app.conf

# 解决警告 2: 权限设置
# 设置符合 OpenShift 随机用户的安全权限
RUN chmod -R g+rwX,o= \
    /var/cache/nginx \
    /var/run \
    /etc/nginx/conf.d && \
    chown -R nginx:root /usr/share/nginx/html

# 从构建阶段复制内容
COPY --from=builder --chown=nginx:root /app/.next/static /usr/share/nginx/html/_next/static
COPY --from=builder --chown=nginx:root /app/public /usr/share/nginx/html/

# 解决错误: 使用非 root 用户
USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]