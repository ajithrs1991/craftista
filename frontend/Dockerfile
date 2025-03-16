FROM node:23.10-bullseye-slim
COPY frontend/ /frontend
WORKDIR /frontend
RUN npm install
EXPOSE 3000
ENTRYPOINT ["node", "app.js"]
