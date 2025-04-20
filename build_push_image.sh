#!/bin/bash

# Hentikan eksekusi jika ada error
set -e

# 1. Variabel konfigurasi
DOCKER_USERNAME=${DOCKER_USERNAME:-"sivi4048"}  # Default ke username Anda, bisa di-override
IMAGE_NAME="item-app"
TAG="v1"

# 2. Build Docker image dari Dockerfile
echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} .

# Verifikasi apakah image berhasil dibuat
if [[ "$(docker images -q ${IMAGE_NAME}:${TAG})" == "" ]]; then
  echo "Error: Docker image '${IMAGE_NAME}:${TAG}' tidak ditemukan. Proses gagal."
  exit 1
fi

# 3. Lihat daftar Docker image lokal
echo "Listing local Docker images..."
docker images

# 4. Tag ulang image agar sesuai dengan format Docker Hub
echo "Tagging Docker image..."
docker tag ${IMAGE_NAME}:${TAG} ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}

# 5. Login ke Docker Hub
echo "Logging in to Docker Hub..."
read -p "Enter Docker Hub username [$DOCKER_USERNAME]: " INPUT_USERNAME
DOCKER_USERNAME=${INPUT_USERNAME:-$DOCKER_USERNAME}  # Gunakan input atau default

read -sp "Enter Docker Hub password: " DOCKER_PASSWORD
echo

# Login ke Docker Hub menggunakan --password-stdin untuk keamanan
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

# Bersihkan variabel password untuk keamanan
unset DOCKER_PASSWORD

# 6. Push image ke Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}

echo "Docker image successfully pushed to Docker Hub!"
