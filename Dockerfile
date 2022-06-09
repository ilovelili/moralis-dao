# Stage 0, compile
FROM node:16 as builder

WORKDIR /app

COPY nginx.conf /nginx.conf
COPY yarn.lock /app/
COPY package*.json /app/

RUN yarn

COPY ./ /app/

RUN yarn
RUN yarn build

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.15

COPY --from=builder /app/build/ /usr/share/nginx/html
# Copy the default nginx.conf provided by tiangolo/node-frontend
COPY --from=builder /nginx.conf /etc/nginx/conf.d/default.conf