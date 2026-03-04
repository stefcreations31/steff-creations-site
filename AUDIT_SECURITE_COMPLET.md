# Audit de Sécurité Complet - Stef Creations

**Date:** 4 mars 2026
**Site:** https://xn--bijouteriestefcrations-q8b.fr
**Environnement:** GitHub Pages + Netlify CMS

---

## 🔴 Vulnérabilités Critiques

### 1. **Authentification Côté Client** (CRITIQUE)
**Fichier:** `admin/index.html:984-1025`

**Problème:**
- Le hash du mot de passe par défaut est codé en dur dans le JavaScript
- Le mot de passe par défaut est révélé en commentaire: `Toulouse31.`
- L'authentification est entièrement côté client (localStorage)
- Aucune protection côté serveur

**Code vulnérable:**
```javascript
const DEFAULT_PASSWORD_HASH = '50456030af2e78995a200ceac54c9ff3abf2514beb88721255db3ecfb6d7a00f'; // Toulouse31.
```

**Impact:**
- N'importe qui peut voir le mot de passe par défaut dans le code source
- Un attaquant peut contourner l'authentification en modifiant localStorage
- Pas de protection contre les attaques par force brute

**Recommandations:**
1. Implémenter une authentification backend réelle (OAuth, JWT, etc.)
2. Utiliser Netlify Identity ou un service d'authentification tiers
3. Ne JAMAIS stocker de mots de passe ou de hash en clair dans le code
4. Supprimer le commentaire révélant le mot de passe

---

### 2. **Token GitHub Exposé** (CRITIQUE)
**Fichier:** `admin/index.html:854, 1372, 1396`

**Problème:**
- Le token GitHub est stocké en clair dans localStorage
- Le token est transmis dans les requêtes API sans chiffrement supplémentaire
- Accès complet au repository via l'interface admin

**Code vulnérable:**
```javascript
localStorage.setItem(CONFIG_KEY, JSON.stringify(config));
// config contient { token: "ghp_xxxx...", owner: "...", repo: "..." }
```

**Impact:**
- Vol possible du token GitHub via XSS
- Accès non autorisé au repository
- Possibilité de modifier/supprimer tout le code source

**Recommandations:**
1. Utiliser GitHub Apps au lieu de Personal Access Tokens
2. Implémenter un proxy backend pour les appels API GitHub
3. Utiliser des tokens avec des permissions minimales (principe du moindre privilège)
4. Rotation régulière des tokens
5. Chiffrer les tokens avant stockage dans localStorage

---

### 3. **Cross-Site Scripting (XSS)** (ÉLEVÉ)
**Fichier:** `index.html:4468-4577`

**Problème:**
- Utilisation de `innerHTML` sans sanitization
- Les données JSON sont directement injectées dans le DOM
- Pas de Content Security Policy (CSP)

**Code vulnérable:**
```javascript
container.innerHTML = data.produits.map(...).join('');
addressEl.innerHTML = data.address.replace(', ', '<br>');
phonesEl.innerHTML = phonesHtml;
emailEl.innerHTML = `<a href="mailto:${data.email}">${data.email}</a>`;
```

**Impact:**
- Injection de code JavaScript malveillant via les données JSON
- Vol de cookies/tokens
- Redirection vers des sites malveillants
- Défiguration du site

**Recommandations:**
1. Utiliser `textContent` au lieu de `innerHTML` quand possible
2. Implémenter DOMPurify pour sanitizer les données
3. Ajouter une Content Security Policy (CSP) stricte
4. Valider et échapper toutes les entrées utilisateur

---

## 🟠 Vulnérabilités Moyennes

### 4. **Absence de HTTPS Strict**
**Impact:** Les requêtes peuvent être interceptées en cas de downgrade HTTP

**Recommandations:**
- Forcer HTTPS dans `netlify.toml`
- Ajouter HSTS (HTTP Strict Transport Security)

**Configuration suggérée:**
```toml
[[headers]]
  for = "/*"
  [headers.values]
    Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload"
```

---

### 5. **Absence de Content Security Policy (CSP)**
**Impact:** Vulnérable aux attaques XSS et injection de contenu

**Recommandations:**
Ajouter dans `netlify.toml`:
```toml
[[headers]]
  for = "/*"
  [headers.values]
    Content-Security-Policy = "default-src 'self'; script-src 'self' 'unsafe-inline' https://identity.netlify.com https://fonts.googleapis.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https://api.github.com https://api.metals.live https://api.frankfurter.app"
```

---

### 6. **Exposition des Informations Sensibles**
**Fichier:** Requêtes API

**Problème:**
- Les appels à l'API GitHub révèlent la structure du repository
- Les messages d'erreur peuvent révéler des informations système

**Recommandations:**
- Implémenter une gestion d'erreur générique
- Ne pas exposer les détails techniques dans les messages d'erreur

---

### 7. **Absence de Rate Limiting**
**Impact:** Vulnérable aux attaques par force brute sur l'authentification

**Recommandations:**
- Implémenter un rate limiting côté client (temporaire)
- Ajouter un délai progressif après échecs de connexion
- Limiter les tentatives de connexion (max 5 par heure par exemple)

---

## 🟡 Vulnérabilités Mineures

### 8. **Manque de Validation des Données**
**Fichier:** `admin/index.html` - Toutes les fonctions de formulaire

**Recommandations:**
- Valider les formats d'email
- Valider les URLs
- Limiter la longueur des champs texte
- Valider les types de fichiers pour les uploads

---

### 9. **Absence de Logs d'Audit**
**Impact:** Impossible de tracer les modifications ou les tentatives d'intrusion

**Recommandations:**
- Logger toutes les authentifications (succès/échec)
- Logger toutes les modifications de contenu
- Utiliser un service externe pour les logs critiques

---

### 10. **Cookies Non Sécurisés**
**Problème:** Utilisation de localStorage au lieu de cookies HttpOnly

**Recommandations:**
- Migrer vers une authentification avec cookies HttpOnly
- Ajouter les flags Secure et SameSite

---

## ✅ Bonnes Pratiques Identifiées

1. ✅ Utilisation de HTTPS via GitHub Pages
2. ✅ Hashing du mot de passe avec SHA-256
3. ✅ Validation basique des formulaires
4. ✅ Séparation des données (fichiers JSON séparés)
5. ✅ Interface admin séparée du site public

---

## 📊 Score de Sécurité Global

| Catégorie | Score | Commentaire |
|-----------|-------|-------------|
| Authentification | 2/10 | Critique - Auth côté client uniquement |
| Autorisation | 3/10 | Pas de gestion des rôles |
| Gestion des données | 6/10 | Structure correcte mais XSS possible |
| Chiffrement | 5/10 | HTTPS OK mais tokens non chiffrés |
| Configuration | 4/10 | Manque CSP, HSTS, etc. |
| **TOTAL** | **4/10** | **Niveau de risque: ÉLEVÉ** |

---

## 🎯 Plan d'Action Prioritaire

### Phase 1 - Urgent (Cette semaine)
1. ⚠️ Supprimer le commentaire révélant le mot de passe
2. ⚠️ Changer le mot de passe par défaut immédiatement
3. ⚠️ Révoquer et regénérer le token GitHub actuel
4. ⚠️ Implémenter DOMPurify pour sanitizer les innerHTML

### Phase 2 - Important (Ce mois)
1. 🔒 Migrer vers Netlify Identity pour l'authentification
2. 🔒 Ajouter CSP et HSTS
3. 🔒 Implémenter un proxy pour l'API GitHub
4. 🔒 Ajouter rate limiting sur l'authentification

### Phase 3 - Améliorations (Prochain trimestre)
1. 📈 Système de logs et audit
2. 📈 Tests de sécurité automatisés
3. 📈 Monitoring et alertes
4. 📈 Documentation de sécurité

---

## 🛠️ Outils de Test Recommandés

1. **OWASP ZAP** - Scanner de vulnérabilités web
2. **Burp Suite** - Test d'intrusion
3. **Snyk** - Analyse des dépendances
4. **Mozilla Observatory** - Test des headers de sécurité
5. **Google Lighthouse** - Audit général

---

## 📚 Ressources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Content Security Policy Guide](https://content-security-policy.com/)
- [Netlify Identity Documentation](https://docs.netlify.com/visitor-access/identity/)
- [GitHub Apps vs Personal Tokens](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps)

---

## 📝 Notes Finales

Ce site présente des vulnérabilités critiques qui nécessitent une action immédiate. L'authentification côté client et le token GitHub exposé constituent des risques majeurs pour la sécurité du site et du repository.

**Recommandation principale:** Migrer vers une solution d'authentification robuste comme Netlify Identity avant de mettre le site en production avec des données réelles.

---

**Auditeur:** Claude Code (Sonnet 4.5)
**Contact:** Pour toute question sur cet audit, consulter la documentation OWASP ou engager un expert en sécurité web.
