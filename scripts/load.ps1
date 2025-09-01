# Gera carga por 2 minutos com 50 conexões
# Requer Docker Desktop rodando
docker run --rm -it williamyeh/hey -z 2m -c 50 http://host.docker.internal:8080/