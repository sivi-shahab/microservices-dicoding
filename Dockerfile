# 1. Gunakan base image Node.js versi 14
FROM node:14

# 2. Tentukan working directory di dalam container
WORKDIR /app

# 3. Salin seluruh source code ke working directory container
COPY . .

# Add this to your Dockerfile
#ENV HTTP_PROXY=http://10.190.21.24:3128
#ENV HTTPS_PROXY=http://10.190.21.24:3128

# 4. Set environment variable untuk production dan database host
ENV NODE_ENV=production \
    DB_HOST=item-db

# And before npm commands, you might want to explicitly set npm config
#RUN npm config set proxy http://10.190.21.24:3128 \
#    && npm config set https-proxy http://10.190.21.24:3128

# 5. Install dependencies khusus production dan build aplikasi
RUN npm install --production --unsafe-perm && npm run build

# 6. Ekspos port yang digunakan oleh aplikasi
EXPOSE 8080

# 7. Jalankan server ketika container berjalan
CMD ["npm", "start"]
