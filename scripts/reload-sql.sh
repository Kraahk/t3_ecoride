#!/bin/bash

# Couleurs ANSI
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


SQL_FILE="./sql/init.sql"

#  le fichier existe ?
if [ ! -f "$SQL_FILE" ]; then
  echo -e "${RED}[ERREUR] Fichier $SQL_FILE introuvable.${NC}"
  exit 1
fi
echo -e "${YELLOW}[INFO] Reloading PostgreSQL ::: $SQL_FILE...${NC}"



# 
docker compose exec -T postgres psql -U postgres -d ecoride < "$SQL_FILE"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}[OK] PostgreSQL rechargée.${NC}"
else
  echo -e "${RED}[ERROR] Erreur pendant le reload.${NC}"
  exit 1
fi


echo "[P] Pulling DB schema into Prisma..."
npx prisma db pull

echo "[R] Regenerating Prisma client..."
npx prisma generate

echo "[R]] Restarting app container..."
docker compose restart app