FROM node:24-alpine AS build
# Demarre un environnement temporaire dans lequel on a tous les outils pour construire l'application voulue
WORKDIR /app
# On Choisit le dossier app comme repertoire pour le code source
COPY package.json package-lock.json ./
# On copie la liste des dépendances dans le dossier /app
RUN npm ci
# On lance la commande clean install pour installer les dépendances d'une application
COPY tsconfig.json ./
# On copie le fichier de configuration qu'on utilise pour compiler app.ts dans /app
COPY src ./src
# On copie le dossier src pour le mettre dans un dossier /src
RUN npm run build

FROM node:24-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist

USER node
CMD ["node", "dist/index.js"]