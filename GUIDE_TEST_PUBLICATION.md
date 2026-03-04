# Guide de Test de Publication - Admin Stef Creations

**Date:** 4 mars 2026
**Objectif:** Vérifier que la publication depuis l'admin fonctionne correctement

---

## ⏱️ Avant de Commencer

**Attendez 3-4 minutes** après le push pour que GitHub Pages se mette à jour avec les derniers correctifs.

**URL de l'admin:** https://xn--bijouteriestefcrations-q8b.fr/admin

**Mot de passe par défaut:** Toulouse31.

⚠️ **IMPORTANT:** Ce mot de passe doit être changé IMMÉDIATEMENT après le test pour des raisons de sécurité!

---

## 📋 Test 1: Vérification de l'Admin

### Étape 1: Accéder à l'Admin
1. Ouvrir un navigateur
2. Aller sur: https://xn--bijouteriestefcrations-q8b.fr/admin
3. ✅ Vérifier que la page de login s'affiche

### Étape 2: Se Connecter
1. Entrer le mot de passe: `Toulouse31.`
2. Cliquer sur "Se connecter"
3. ✅ Vérifier que le dashboard admin s'affiche

### Étape 3: Vérifier les Onglets
1. ✅ Onglet "Produits" (actif par défaut)
2. ✅ Onglet "Contact"
3. ✅ Onglet "Histoire"
4. ✅ Onglet "Marges Or"
5. ✅ Onglet "Configuration"

**Si tout s'affiche:** ✅ L'admin est fonctionnel, passez au test 2

**Si erreur:** ❌ Ouvrir la console (F12) et noter l'erreur

---

## 📋 Test 2: Configuration GitHub

### Étape 1: Aller dans Configuration
1. Cliquer sur l'onglet "Configuration"
2. ✅ Vérifier que les champs GitHub sont visibles

### Étape 2: Vérifier les Valeurs
Les champs doivent contenir:
- **Owner:** stefcreations31
- **Repository:** steff-creations-site
- **Token:** (votre token personnel GitHub)

### Étape 3: Tester la Connexion
1. Cliquer sur "Tester la connexion"
2. ✅ Vérifier qu'un toast vert "Connexion GitHub réussie!" s'affiche

**Si succès:** ✅ GitHub est bien configuré, passez au test 3

**Si erreur:** ❌ Vérifier que:
- Le token GitHub est valide
- Le repository existe
- Le token a les permissions `public_repo`

---

## 📋 Test 3: Modification Simple (Contact)

### Étape 1: Aller dans Contact
1. Cliquer sur l'onglet "Contact"
2. ✅ Vérifier que les champs se chargent avec les données actuelles

### Étape 2: Faire une Modification de Test
1. Dans le champ "Email", ajouter " - TEST" à la fin
   - Exemple: `contact@example.com - TEST`
2. Cliquer sur "Sauvegarder"
3. ✅ Vérifier qu'un toast vert "Contact sauvegardé localement" s'affiche

### Étape 3: Vérifier la Barre de Statut
En bas de la page:
1. ✅ Vérifier que le texte affiche "Modifications non publiées" en orange
2. ✅ Vérifier qu'un bouton "Publier les modifications" apparaît

**Screenshot attendu:**
```
[⚠️ Modifications non publiées] [Publier les modifications]
```

---

## 📋 Test 4: Publication

### Étape 1: Lancer la Publication
1. Cliquer sur "Publier les modifications"
2. ✅ Observer les messages qui défilent:
   - "Publication produits..."
   - "Publication contact..."
   - "Publication marges..."
   - "Publication histoire..."
   - "Publié avec succès!"

### Étape 2: Vérifier les Toasts
Deux toasts doivent apparaître:
1. **Toast vert:** "Modifications publiées! Le site se met à jour dans 1-2 minutes..."
2. **Toast bleu (nouveau!):** "GitHub Pages met à jour le site. Actualisez dans 1-2 min."

✅ Vérifier que les deux toasts s'affichent

### Étape 3: Vérifier la Barre de Statut
1. ✅ Le texte doit afficher "Publié avec succès!"
2. ✅ Le bouton "Publier" doit avoir disparu

---

## 📋 Test 5: Vérification sur le Site

### Étape 1: Attendre
⏱️ **Attendre 2 minutes** pour que GitHub Pages se mette à jour

### Étape 2: Utiliser le Nouveau Bouton
Dans l'admin, onglet "Configuration":
1. Cliquer sur "Vider le cache et recharger le site"
2. ✅ Un nouvel onglet doit s'ouvrir avec le site
3. Dans le nouvel onglet, faire **Ctrl+Shift+R** (Windows) ou **Cmd+Shift+R** (Mac)

### Étape 3: Vérifier la Modification
1. Descendre jusqu'à la section "Contact" du site
2. ✅ Vérifier que l'email affiche bien " - TEST" à la fin

**Si visible:** ✅ La synchronisation fonctionne parfaitement!

**Si pas visible:**
1. Attendre encore 1 minute
2. Faire à nouveau Ctrl+Shift+R
3. Si toujours pas visible, passer au test 6

---

## 📋 Test 6: Forçage de Déploiement (Si Nécessaire)

### Si la modification n'apparaît toujours pas après 5 minutes:

1. Retourner dans l'admin
2. Aller dans "Configuration"
3. Cliquer sur "Forcer le redéploiement GitHub Pages"
4. Confirmer l'action
5. ✅ Toast vert: "Redéploiement forcé! Le site se met à jour dans 2-3 minutes."
6. Attendre 3 minutes
7. Recharger le site avec Ctrl+Shift+R
8. ✅ La modification doit maintenant être visible

---

## 📋 Test 7: Annulation de la Modification de Test

### Étape 1: Retirer le " - TEST"
1. Dans l'admin, onglet "Contact"
2. Supprimer le " - TEST" de l'email
3. Cliquer sur "Sauvegarder"

### Étape 2: Publier
1. Cliquer sur "Publier les modifications"
2. Attendre les toasts de confirmation

### Étape 3: Vérifier
1. Attendre 2 minutes
2. Recharger le site (Ctrl+Shift+R)
3. ✅ L'email doit être revenu à la normale

---

## 📋 Test 8: Modification d'un Produit

### Étape 1: Aller dans Produits
1. Cliquer sur l'onglet "Produits"
2. ✅ La liste des produits s'affiche

### Étape 2: Modifier un Produit
1. Cliquer sur "Modifier" sur le premier produit
2. Dans le modal, changer le prix de "Sur demande" à "Sur demande - TEST"
3. Cliquer sur "Sauvegarder"
4. ✅ Le modal se ferme
5. ✅ La barre de statut indique "Modifications non publiées"

### Étape 3: Publier et Vérifier
1. Cliquer sur "Publier les modifications"
2. Attendre les toasts
3. Attendre 2 minutes
4. Utiliser "Vider le cache et recharger"
5. Sur le site, aller dans "Boutique"
6. ✅ Le premier produit doit afficher "Sur demande - TEST"

### Étape 4: Annuler
1. Remettre le prix à "Sur demande"
2. Publier à nouveau
3. Vérifier sur le site

---

## 📋 Test 9: Vérification Console Développeur

### Étape 1: Ouvrir la Console
1. Sur le site principal (pas l'admin)
2. Appuyer sur F12
3. Aller dans l'onglet "Network"
4. Recharger la page (F5)

### Étape 2: Vérifier le Cache Busting
1. Chercher "produits.json" dans la liste
2. Cliquer dessus
3. Dans l'onglet "Headers", regarder "Request URL"
4. ✅ L'URL doit contenir `?v=` suivi d'un timestamp
   - Exemple: `/data/produits.json?v=1709577840123`

### Étape 3: Vérifier les Headers de Cache
1. Toujours dans "Headers"
2. Chercher "Cache-Control" dans "Response Headers"
3. ✅ Doit afficher: `no-cache, no-store, must-revalidate`

**Si OK:** ✅ Le cache busting fonctionne!

---

## 📋 Test 10: Vérification Netlify

### Étape 1: Accéder à Netlify
1. Aller sur https://app.netlify.com
2. Se connecter avec le compte lié au site
3. Sélectionner le site "steff-creations-site"

### Étape 2: Vérifier les Déploiements
1. Aller dans "Deploys"
2. ✅ Le dernier déploiement doit être "Published"
3. ✅ Le commit doit être "Correctifs synchronisation admin..."

### Étape 3: Vérifier les Headers
1. Dans le menu, aller dans "Site settings"
2. Chercher "Headers"
3. ✅ Les headers de cache doivent être configurés

---

## ✅ Checklist Finale

Après tous les tests:

- [ ] ✅ L'admin se charge correctement
- [ ] ✅ La connexion fonctionne
- [ ] ✅ Test GitHub réussit
- [ ] ✅ Les modifications se sauvegardent
- [ ] ✅ La barre de statut s'affiche
- [ ] ✅ La publication envoie les données
- [ ] ✅ Les toasts vert ET bleu apparaissent
- [ ] ✅ Les modifications apparaissent sur le site (2-5 min)
- [ ] ✅ Le cache busting fonctionne (?v= dans l'URL)
- [ ] ✅ Les headers de cache sont corrects
- [ ] ✅ Le bouton "Vider cache" ouvre le site
- [ ] ✅ Le bouton "Forcer déploiement" fonctionne

---

## 🚨 Problèmes Possibles et Solutions

### Problème 1: "Token GitHub non configuré"
**Solution:**
1. Aller sur github.com/settings/tokens
2. Générer un nouveau token (classic)
3. Permissions: `public_repo` uniquement
4. Copier le token
5. Le coller dans l'admin, onglet Configuration
6. Cliquer sur "Sauvegarder la configuration"

### Problème 2: "Erreur de connexion GitHub"
**Solution:**
- Vérifier que le token est valide (pas expiré)
- Vérifier que owner = stefcreations31
- Vérifier que repo = steff-creations-site

### Problème 3: Modifications non visibles après 5 minutes
**Solution:**
1. Utiliser "Forcer le redéploiement"
2. Vérifier sur github.com/stefcreations31/steff-creations-site/actions
3. Vérifier qu'il n'y a pas d'erreur dans les Actions GitHub

### Problème 4: Toast bleu ne s'affiche pas
**Solution:**
- Vider le cache du navigateur
- Recharger l'admin (Ctrl+Shift+R)
- Si toujours pas: vérifier la console (F12)

### Problème 5: Images ne s'affichent pas
**Solution:**
- Vérifier que les images existent dans le repository
- Vérifier que les chemins sont corrects (commencent par `/`)
- Exemples: `/IMG_2231.jpeg` ou `/images/produit1.jpg`

---

## 📊 Temps Attendus

| Action | Délai Normal | Délai Maximum |
|--------|--------------|---------------|
| Sauvegarde locale | Instantané | 1 seconde |
| Publication vers GitHub | 5-10 secondes | 30 secondes |
| Build GitHub Actions | 30-60 secondes | 2 minutes |
| Déploiement GitHub Pages | 1-2 minutes | 5 minutes |
| Propagation CDN | 1 minute | 3 minutes |
| **Total** | **2-3 minutes** | **10 minutes** |

---

## 🎓 Résultat Attendu

Si tous les tests passent:

✅ **L'admin est 100% fonctionnel**
✅ **La synchronisation fonctionne**
✅ **Les correctifs de cache sont effectifs**
✅ **Le client peut gérer le site en autonomie**

---

## 🔒 IMPORTANT: Actions Post-Test

### IMMÉDIATEMENT après le test:

1. **Changer le mot de passe admin**
   - Onglet Configuration
   - Section "Changer le mot de passe admin"
   - Choisir un mot de passe FORT (16+ caractères)
   - Ne PAS le noter en clair

2. **Révoquer et regénérer le token GitHub**
   - Aller sur github.com/settings/tokens
   - Révoquer le token actuel
   - Créer un nouveau token avec:
     - Permissions: `public_repo` uniquement
     - Expiration: 90 jours
   - Mettre à jour dans l'admin

3. **Nettoyer le code**
   - Supprimer le commentaire du mot de passe ligne 984 de admin/index.html
   - Voir CORRECTIFS_SECURITE_URGENTS.md

---

**Bonne chance pour les tests!**

Si vous rencontrez un problème, notez:
1. L'action que vous faisiez
2. Le message d'erreur exact
3. Ce qui s'affiche dans la console (F12)
