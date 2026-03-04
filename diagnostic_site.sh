#!/bin/bash

# Script de diagnostic complet du site
# Identifie tous les problèmes d'affichage

SITE_URL="https://stefcreations31.github.io/steff-creations-site"

echo "=============================================="
echo "DIAGNOSTIC COMPLET DU SITE - STEF CREATIONS"
echo "=============================================="
echo ""

# Télécharger la page
echo "[1] Téléchargement de la page principale..."
curl -sL "$SITE_URL" > /tmp/steff_site.html
echo "✓ Page téléchargée ($(wc -l < /tmp/steff_site.html) lignes)"
echo ""

# Vérifier les sections principales
echo "[2] Vérification des sections HTML..."
sections=(
    "hero"
    "boutique"
    "savoir-faire"
    "atelier"
    "temoignages"
    "estimation"
    "faq"
    "histoire"
    "contact"
)

for section in "${sections[@]}"; do
    if grep -q "id=\"$section\"" /tmp/steff_site.html; then
        echo "✓ Section '$section' présente"
    else
        echo "✗ Section '$section' MANQUANTE"
    fi
done
echo ""

# Vérifier les éléments de chargement dynamique
echo "[3] Vérification des éléments dynamiques..."
elements=(
    "products-container"
    "contact-address"
    "contact-phones"
    "contact-email"
    "histoire-intro"
    "histoire-p1"
    "histoire-p2"
    "histoire-photo"
    "histoire-caption"
)

for element in "${elements[@]}"; do
    if grep -q "id=\"$element\"" /tmp/steff_site.html; then
        echo "✓ Element '$element' présent"
    else
        echo "✗ Element '$element' MANQUANT"
    fi
done
echo ""

# Vérifier les fichiers JSON
echo "[4] Vérification des fichiers de données..."
json_files=(
    "produits"
    "contact"
    "histoire"
    "marges"
)

for file in "${json_files[@]}"; do
    response=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/data/$file.json")
    if [ "$response" = "200" ]; then
        # Vérifier si le JSON est valide
        content=$(curl -sL "$SITE_URL/data/$file.json")
        if echo "$content" | python3 -m json.tool > /dev/null 2>&1; then
            echo "✓ $file.json accessible et valide"
        else
            echo "⚠ $file.json accessible mais JSON invalide"
        fi
    else
        echo "✗ $file.json non accessible (HTTP $response)"
    fi
done
echo ""

# Vérifier les fonctions JavaScript
echo "[5] Vérification des fonctions JavaScript..."
functions=(
    "loadProducts"
    "loadContact"
    "loadHistoire"
)

for func in "${functions[@]}"; do
    if grep -q "function $func\|async function $func" /tmp/steff_site.html; then
        echo "✓ Fonction '$func' présente"
    else
        echo "✗ Fonction '$func' MANQUANTE"
    fi
done
echo ""

# Vérifier l'appel des fonctions au chargement
echo "[6] Vérification de l'initialisation..."
if grep -q "loadProducts()\|loadContact()\|loadHistoire()" /tmp/steff_site.html; then
    echo "✓ Fonctions de chargement appelées"
else
    echo "✗ Fonctions de chargement NON appelées"
fi
echo ""

# Vérifier le contenu du JSON contact
echo "[7] Analyse détaillée du fichier contact.json..."
contact=$(curl -sL "$SITE_URL/data/contact.json")
echo "Contenu:"
echo "$contact" | python3 -m json.tool 2>/dev/null || echo "$contact"
echo ""

if echo "$contact" | grep -q '"phone"'; then
    echo "✓ Champ 'phone' présent"
else
    echo "✗ Champ 'phone' MANQUANT"
fi

if echo "$contact" | grep -q '"mobile"'; then
    echo "✓ Champ 'mobile' présent"
else
    echo "✗ Champ 'mobile' MANQUANT"
fi

if echo "$contact" | grep -q '"email"'; then
    echo "✓ Champ 'email' présent"
else
    echo "✗ Champ 'email' MANQUANT"
fi

if echo "$contact" | grep -q '"address"'; then
    echo "✓ Champ 'address' présent"
else
    echo "✗ Champ 'address' MANQUANT"
fi
echo ""

# Vérifier les images
echo "[8] Vérification de quelques images..."
images=(
    "IMG_2231.jpeg"
    "IMG_2232.jpeg"
    "IMG_2233.jpeg"
)

for img in "${images[@]}"; do
    response=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/$img")
    if [ "$response" = "200" ]; then
        echo "✓ Image $img accessible"
    else
        echo "✗ Image $img non accessible (HTTP $response)"
    fi
done
echo ""

# Vérifier les erreurs JavaScript potentielles
echo "[9] Recherche d'erreurs potentielles..."
if grep -q "console.error\|console.warn" /tmp/steff_site.html; then
    echo "⚠ Code contient des console.error/warn (normal pour la gestion d'erreurs)"
fi

if grep -q "try.*catch" /tmp/steff_site.html; then
    echo "✓ Gestion d'erreurs try/catch présente"
fi
echo ""

# Analyser la structure de données attendue vs réelle
echo "[10] Analyse de compatibilité des données..."

echo "Structure attendue par loadContact():"
grep -A 10 "async function loadContact" /tmp/steff_site.html | grep -E "data\.(phone|mobile|email|address)" | sed 's/^/  /'

echo ""
echo "Structure réelle de contact.json:"
curl -sL "$SITE_URL/data/contact.json" | python3 -c "import sys, json; data = json.load(sys.stdin); print('  ' + '\n  '.join([f'{k}: {v}' for k, v in data.items()]))" 2>/dev/null || echo "  Erreur de lecture"

echo ""
echo "=============================================="
echo "FIN DU DIAGNOSTIC"
echo "=============================================="
