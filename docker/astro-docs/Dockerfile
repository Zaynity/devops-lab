FROM node:23-slim
WORKDIR /app
COPY . .
RUN npm install && npm run build
EXPOSE 4321
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0"]