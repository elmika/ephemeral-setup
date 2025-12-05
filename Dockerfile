# 1) Imagen base con Node (build + runtime en una sola).
FROM node:20-alpine

# 2) Carpeta de trabajo dentro del contenedor
WORKDIR /app

# 3) Copiamos package.json y package-lock.json primero (para cache de dependencias)
COPY package*.json ./

# 4) Instalamos dependencias (prod + dev, de momento)
RUN npm install

# 5) Copiamos el resto del código
COPY . .

# 6) Compilamos TypeScript a Javascript
RUN npm run build

# 7) Definimos la variable PORT esperada (Coud Run la sobreescribirá)
ENV PORT=3000

# 8) Exponemos el puerto (informativo)
EXPOSE 3000

#9 ) Comando de arranque en el contenedor
CMD ["npm", "run", "start"]
