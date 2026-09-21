FROM nginx:alpine

LABEL maintainer="JenkinsOps"
LABEL project="self-healing-cicd"

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]