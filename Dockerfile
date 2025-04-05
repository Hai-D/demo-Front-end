FROM node:21-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./  
RUN npm install --legacy-peer-deps             
COPY . .
RUN npm run build 

# 生产镜像
FROM nginx:1.23-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/.next/static /usr/share/nginx/html/_next/static
COPY --from=builder /app/public /usr/share/nginx/html/static
RUN chmod -R 777 \
    /var/cache/nginx \
    /var/run \
    /etc/nginx/conf.d && \
    chown -R nginx:root /usr/share/nginx/html
EXPOSE 80
USER root
CMD ["nginx", "-g", "daemon off;"]