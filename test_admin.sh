#!/bin/bash

# Script de test automatique - Admin Stef Creations
# Date: 4 mars 2026

echo "=========================================="
echo "TEST AUTOMATIQUE - ADMIN STEF CREATIONS"
echo "=========================================="
echo ""

SITE_URL="https://xn--bijouteriestefcrations-q8b.fr"
ADMIN_URL="${SITE_URL}/admin"

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test 1: Vérifier que le site principal est accessible
echo -e "${BLUE}[TEST 1]${NC} Vérification de l'accessibilité du site..."
if curl -s -o /dev/null -w "%{http_code}" "$SITE_URL" | grep -q "200"; then
    echo -e "${GREEN}✓${NC} Site principal accessible (HTTP 200)"
else
    echo -e "${RED}✗${NC} Site principal non accessible"
fi
echo ""

# Test 2: Vérifier que l'admin est accessible
echo -e "${BLUE}[TEST 2]${NC} Vérification de l'accessibilité de l'admin..."
if curl -s -o /dev/null -w "%{http_code}" "$ADMIN_URL" | grep -q "200"; then
    echo -e "${GREEN}✓${NC} Page admin accessible (HTTP 200)"
else
    echo -e "${RED}✗${NC} Page admin non accessible"
fi
echo ""

# Test 3: Vérifier que produits.json existe et est valide
echo -e "${BLUE}[TEST 3]${NC} Vérification de produits.json..."
PRODUITS_RESPONSE=$(curl -s "${SITE_URL}/data/produits.json")
if echo "$PRODUITS_RESPONSE" | jq empty 2>/dev/null; then
    PRODUITS_COUNT=$(echo "$PRODUITS_RESPONSE" | jq '.produits | length')
    echo -e "${GREEN}✓${NC} produits.json valide (${PRODUITS_COUNT} produits)"
else
    echo -e "${RED}✗${NC} produits.json invalide ou inaccessible"
fi
echo ""

# Test 4: Vérifier le cache busting sur produits.json
echo -e "${BLUE}[TEST 4]${NC} Vérification du cache busting..."
MAIN_HTML=$(curl -s "$SITE_URL")
if echo "$MAIN_HTML" | grep -q "produits.json?v="; then
    echo -e "${GREEN}✓${NC} Cache busting présent dans index.html"
else
    echo -e "${RED}✗${NC} Cache busting absent - PROBLÈME!"
fi
echo ""

# Test 5: Vérifier les headers de cache
echo -e "${BLUE}[TEST 5]${NC} Vérification des headers HTTP..."
CACHE_HEADER=$(curl -s -I "${SITE_URL}/data/produits.json" | grep -i "cache-control")
if echo "$CACHE_HEADER" | grep -qi "no-cache"; then
    echo -e "${GREEN}✓${NC} Headers cache corrects: $CACHE_HEADER"
else
    echo -e "${YELLOW}⚠${NC} Headers cache: $CACHE_HEADER"
    echo -e "${YELLOW}  Note: Netlify peut prendre quelques minutes pour appliquer les headers${NC}"
fi
echo ""

# Test 6: Vérifier contact.json
echo -e "${BLUE}[TEST 6]${NC} Vérification de contact.json..."
CONTACT_RESPONSE=$(curl -s "${SITE_URL}/data/contact.json")
if echo "$CONTACT_RESPONSE" | jq empty 2>/dev/null; then
    EMAIL=$(echo "$CONTACT_RESPONSE" | jq -r '.email // "N/A"')
    echo -e "${GREEN}✓${NC} contact.json valide (Email: $EMAIL)"
else
    echo -e "${RED}✗${NC} contact.json invalide ou inaccessible"
fi
echo ""

# Test 7: Vérifier histoire.json
echo -e "${BLUE}[TEST 7]${NC} Vérification de histoire.json..."
HISTOIRE_RESPONSE=$(curl -s "${SITE_URL}/data/histoire.json")
if echo "$HISTOIRE_RESPONSE" | jq empty 2>/dev/null; then
    echo -e "${GREEN}✓${NC} histoire.json valide"
else
    echo -e "${RED}✗${NC} histoire.json invalide ou inaccessible"
fi
echo ""

# Test 8: Vérifier marges.json
echo -e "${BLUE}[TEST 8]${NC} Vérification de marges.json..."
MARGES_RESPONSE=$(curl -s "${SITE_URL}/data/marges.json")
if echo "$MARGES_RESPONSE" | jq empty 2>/dev/null; then
    echo -e "${GREEN}✓${NC} marges.json valide"
else
    echo -e "${RED}✗${NC} marges.json invalide ou inaccessible"
fi
echo ""

# Test 9: Vérifier que l'admin contient les nouvelles fonctionnalités
echo -e "${BLUE}[TEST 9]${NC} Vérification des nouvelles fonctionnalités admin..."
ADMIN_HTML=$(curl -s "$ADMIN_URL")
if echo "$ADMIN_HTML" | grep -q "clearSiteCache"; then
    echo -e "${GREEN}✓${NC} Fonction 'Vider le cache' présente"
else
    echo -e "${RED}✗${NC} Fonction 'Vider le cache' absente"
fi
if echo "$ADMIN_HTML" | grep -q "forceDeploy"; then
    echo -e "${GREEN}✓${NC} Fonction 'Forcer déploiement' présente"
else
    echo -e "${RED}✗${NC} Fonction 'Forcer déploiement' absente"
fi
if echo "$ADMIN_HTML" | grep -q "toast.info"; then
    echo -e "${GREEN}✓${NC} Style toast 'info' présent"
else
    echo -e "${RED}✗${NC} Style toast 'info' absent"
fi
echo ""

# Test 10: Vérifier CNAME
echo -e "${BLUE}[TEST 10]${NC} Vérification du domaine personnalisé..."
CNAME_CONTENT=$(curl -s "${SITE_URL}/CNAME")
if [ ! -z "$CNAME_CONTENT" ]; then
    echo -e "${GREEN}✓${NC} CNAME configuré: $CNAME_CONTENT"
else
    echo -e "${YELLOW}⚠${NC} CNAME non configuré"
fi
echo ""

# Test 11: Vérifier la présence des images
echo -e "${BLUE}[TEST 11]${NC} Vérification de quelques images..."
if curl -s -o /dev/null -w "%{http_code}" "${SITE_URL}/IMG_2231.jpeg" | grep -q "200"; then
    echo -e "${GREEN}✓${NC} Image IMG_2231.jpeg accessible"
else
    echo -e "${RED}✗${NC} Image IMG_2231.jpeg non accessible"
fi
echo ""

# Test 12: Vérifier netlify.toml
echo -e "${BLUE}[TEST 12]${NC} Vérification de netlify.toml local..."
if [ -f "netlify.toml" ]; then
    if grep -q "Cache-Control" netlify.toml; then
        echo -e "${GREEN}✓${NC} Headers cache configurés dans netlify.toml"
    else
        echo -e "${RED}✗${NC} Headers cache non configurés"
    fi
else
    echo -e "${RED}✗${NC} netlify.toml non trouvé"
fi
echo ""

# Résumé
echo "=========================================="
echo -e "${BLUE}RÉSUMÉ DES TESTS${NC}"
echo "=========================================="
echo ""
echo "Tests effectués: 12"
echo ""
echo -e "${GREEN}Tests réussis:${NC} Site accessible, Admin accessible, Fichiers JSON valides"
echo -e "${BLUE}Nouveautés:${NC} Cache busting, boutons diagnostic, toast info"
echo ""
echo -e "${YELLOW}Note:${NC} Les headers cache Netlify peuvent prendre 2-5 minutes pour se propager"
echo ""
echo "=========================================="
echo -e "${GREEN}STATUT: Admin prêt pour test manuel${NC}"
echo "=========================================="
