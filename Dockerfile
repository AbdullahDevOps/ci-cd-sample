FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
HEALTHCHECK --interval=10s --timeout=2s --retries=3 
CMD wget -qO- http://localhost/ || exit 1
