FROM node:16-alpine  # Use the version that works
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV NEXT_PUBLIC_API_URL=http://backend-service:8080
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]