# Используем минимальный образ Nginx для запуска приложения

FROM nginx:alpine
ARG PROJECT_DIR
# Копируем собранные файлы веб-приложения из предыдущего этапа
COPY build/web/ /usr/share/nginx/html

# Открываем порт 80 для веб-сервера Nginx
EXPOSE 80

CMD ["nginx-debug", "-g", "daemon off;"]