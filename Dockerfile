# as allows you to specify the name of the phase
# first build phase will copy the app, install deps
# and run npm build to then output to a build dir
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
# this container needs a port mapped to port 80
# tells AWS ELB which port to map to automatically
# locally this does nothing
EXPOSE 80
# copy from the builder phase which is what --from does
# take the output dir and put it in the /usr/share/ngnix file
COPY --from=builder /app/build /usr/share/nginx/html


