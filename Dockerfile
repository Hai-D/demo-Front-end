# 使用基于 CentOS 的 Node.js 镜像，指定 amd64 架构
FROM --platform=linux/amd64 node:20

# 设置工作目录
WORKDIR /app

# 安装必要的依赖
RUN yum update -y && yum install -y \
    glibc \
    libstdc++ \
    && yum clean all

# 复制 package.json 和 package-lock.json（如果存在）
COPY package*.json ./

# 安装项目依赖
RUN npm install --production

# 复制 Next.js 项目文件
COPY . .

# 构建 Next.js 应用
RUN npm run build

# 设置容器端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]