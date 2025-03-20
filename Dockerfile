# 1. 使用 Node.js 作为基础镜像
FROM node:22.14 AS builder

# 2. 设置工作目录
WORKDIR /usr/app

# 3. 复制 package.json 和 package-lock.json
COPY package.json package-lock.json ./

# 4. 安装生产环境依赖（使用 --force 忽略潜在依赖问题）
RUN npm install --production --force

# 5. 复制项目文件
COPY ./ ./

# 6. 构建 Next.js 应用
RUN npm run build

# 7. 生产环境运行容器
FROM node:22.14 AS runner

# 8. 设置工作目录
WORKDIR /app

# 9. 复制构建后的应用
COPY --from=builder /app/.next .next
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/public public

# 10. 运行 Next.js 应用
CMD ["npm", "run", "start"]


FROM node:22.14-alpine
WORKDIR /app
COPY package.json .
RUN apk add --no-cache ffmpeg opus pixman cairo pango giflib ca-certificates \
    && apk add --no-cache --virtual .build-deps python g++ make gcc .build-deps curl git pixman-dev cairo-dev pangomm-dev libjpeg-turbo-dev giflib-dev \
    && npm install \
    && apk del .build-deps
COPY . .
CMD ["npm", "start"]