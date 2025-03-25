FROM node:22.14.0 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV NEXT_PUBLIC_API_URL=http://route-head-primate-hardenfeng-dev.apps.rm1.0a51.p1.openshiftapps.com
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]