echo "rebuilding containers"
docker compose build --no-cache

sleep 1

echo "running dev enviroment"

docker compose up
