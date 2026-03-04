# Correctifs de Sécurité Urgents - Stef Creations

**Date:** 4 mars 2026
**Priorité:** CRITIQUE
**Action requise:** IMMÉDIATE

---

## ⚠️ ACTIONS IMMÉDIATES (À FAIRE MAINTENANT)

### 1. Supprimer le Mot de Passe en Commentaire

**Fichier:** `admin/index.html` ligne 984

**AVANT:**
```javascript
const DEFAULT_PASSWORD_HASH = '50456030af2e78995a200ceac54c9ff3abf2514beb88721255db3ecfb6d7a00f'; // Toulouse31.
```

**APRÈS:**
```javascript
const DEFAULT_PASSWORD_HASH = '50456030af2e78995a200ceac54c9ff3abf2514beb88721255db3ecfb6d7a00f';
```

---

### 2. Changer le Mot de Passe Immédiatement

1. Générer un nouveau mot de passe fort (16+ caractères, mixte)
2. Calculer son hash SHA-256
3. Mettre à jour `DEFAULT_PASSWORD_HASH`

**Outil pour générer le hash:**
```javascript
async function hashPassword(password) {
    const encoder = new TextEncoder();
    const data = encoder.encode(password);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

// Utilisation:
const newHash = await hashPassword('VotreNouveauMotDePasseForT2026!');
console.log(newHash);
```

---

### 3. Révoquer et Regénérer le Token GitHub

**Étapes:**
1. Aller sur GitHub.com > Settings > Developer settings > Personal access tokens
2. Révoquer le token actuel
3. Créer un nouveau token avec permissions minimales:
   - ✅ `public_repo` uniquement (pas `repo` complet)
   - ✅ Expiration: 90 jours maximum
4. Mettre à jour le token dans l'admin

---

## 🔒 CORRECTIFS DE CODE (À APPLIQUER CETTE SEMAINE)

### 4. Ajouter DOMPurify pour Prévenir XSS

**Étape 1:** Ajouter DOMPurify dans `index.html` (avant la balise `</head>`)

```html
<script src="https://cdn.jsdelivr.net/npm/dompurify@3.0.6/dist/purify.min.js"></script>
```

**Étape 2:** Modifier les utilisations de `innerHTML`

**Dans `index.html` ligne 4472:**
```javascript
// AVANT (DANGEREUX)
container.innerHTML = data.produits.map(p => `...`).join('');

// APRÈS (SÉCURISÉ)
const html = data.produits.map(p => `...`).join('');
container.innerHTML = DOMPurify.sanitize(html);
```

**Ligne 4521:**
```javascript
// AVANT
addressEl.innerHTML = data.address.replace(', ', '<br>');

// APRÈS
addressEl.innerHTML = DOMPurify.sanitize(data.address.replace(', ', '<br>'));
```

**Ligne 4531:**
```javascript
// AVANT
phonesEl.innerHTML = phonesHtml;

// APRÈS
phonesEl.innerHTML = DOMPurify.sanitize(phonesHtml);
```

**Ligne 4537:**
```javascript
// AVANT
emailEl.innerHTML = `<a href="mailto:${data.email}">${data.email}</a>`;

// APRÈS
const emailHtml = `<a href="mailto:${DOMPurify.sanitize(data.email)}">${DOMPurify.sanitize(data.email)}</a>`;
emailEl.innerHTML = DOMPurify.sanitize(emailHtml);
```

---

### 5. Ajouter Content Security Policy (CSP)

**Créer/Modifier `netlify.toml` à la racine du projet:**

```toml
# Configuration Netlify avec sécurité renforcée

[build]
  publish = "."

# Headers de sécurité
[[headers]]
  for = "/*"
  [headers.values]
    # Content Security Policy
    Content-Security-Policy = '''
      default-src 'self';
      script-src 'self' 'unsafe-inline' https://identity.netlify.com https://cdn.jsdelivr.net;
      style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
      font-src 'self' https://fonts.gstatic.com;
      img-src 'self' data: https:;
      connect-src 'self' https://api.github.com https://api.metals.live https://api.frankfurter.app;
      frame-src 'self' https://identity.netlify.com;
      base-uri 'self';
      form-action 'self';
    '''

    # HSTS - Force HTTPS
    Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload"

    # Empêcher le site d'être chargé dans une iframe
    X-Frame-Options = "SAMEORIGIN"

    # Empêcher le MIME-sniffing
    X-Content-Type-Options = "nosniff"

    # XSS Protection (pour les vieux navigateurs)
    X-XSS-Protection = "1; mode=block"

    # Contrôle du Referrer
    Referrer-Policy = "strict-origin-when-cross-origin"

    # Permissions Policy
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"

# Headers spécifiques pour l'admin
[[headers]]
  for = "/admin/*"
  [headers.values]
    # Admin nécessite plus de permissions pour GitHub API
    Content-Security-Policy = '''
      default-src 'self';
      script-src 'self' 'unsafe-inline' https://identity.netlify.com https://cdn.jsdelivr.net;
      style-src 'self' 'unsafe-inline';
      connect-src 'self' https://api.github.com;
      img-src 'self' data: https:;
    '''

# Redirections HTTPS forcées
[[redirects]]
  from = "http://*"
  to = "https://:splat"
  status = 301
  force = true
```

---

### 6. Améliorer la Sécurité du Stockage du Token

**Dans `admin/index.html`, fonction `saveConfig`:**

```javascript
// AVANT
function saveConfig() {
    const config = {
        owner: document.getElementById('github-owner').value,
        repo: document.getElementById('github-repo').value,
        token: document.getElementById('github-token').value
    };
    localStorage.setItem(CONFIG_KEY, JSON.stringify(config));
}

// APRÈS
function saveConfig() {
    const token = document.getElementById('github-token').value;

    // Validation du format du token GitHub
    if (token && !token.match(/^(ghp_|github_pat_)[a-zA-Z0-9]{36,}$/)) {
        showToast('Format de token GitHub invalide', 'error');
        return;
    }

    const config = {
        owner: document.getElementById('github-owner').value.trim(),
        repo: document.getElementById('github-repo').value.trim(),
        token: token
    };

    // Avertissement si le token est stocké
    if (token) {
        console.warn('⚠️ Token GitHub stocké localement. Ne partagez jamais ce navigateur.');
    }

    localStorage.setItem(CONFIG_KEY, JSON.stringify(config));
    showToast('Configuration sauvegardée (token sensible)', 'warning');
}
```

---

### 7. Ajouter Rate Limiting sur l'Authentification

**Dans `admin/index.html`, ajouter avant la fonction `handleLogin`:**

```javascript
// Rate limiting pour l'authentification
const LOGIN_ATTEMPTS_KEY = 'stef-login-attempts';
const MAX_ATTEMPTS = 5;
const LOCKOUT_TIME = 15 * 60 * 1000; // 15 minutes

function checkLoginAttempts() {
    const attempts = JSON.parse(localStorage.getItem(LOGIN_ATTEMPTS_KEY) || '{"count": 0, "timestamp": 0}');
    const now = Date.now();

    // Reset si plus de 15 minutes
    if (now - attempts.timestamp > LOCKOUT_TIME) {
        localStorage.setItem(LOGIN_ATTEMPTS_KEY, JSON.stringify({count: 0, timestamp: now}));
        return true;
    }

    // Bloqué si trop de tentatives
    if (attempts.count >= MAX_ATTEMPTS) {
        const remainingTime = Math.ceil((LOCKOUT_TIME - (now - attempts.timestamp)) / 60000);
        showToast(`Trop de tentatives. Réessayez dans ${remainingTime} minutes.`, 'error');
        return false;
    }

    return true;
}

function recordFailedLogin() {
    const attempts = JSON.parse(localStorage.getItem(LOGIN_ATTEMPTS_KEY) || '{"count": 0, "timestamp": 0}');
    attempts.count++;
    attempts.timestamp = Date.now();
    localStorage.setItem(LOGIN_ATTEMPTS_KEY, JSON.stringify(attempts));
}

function resetLoginAttempts() {
    localStorage.setItem(LOGIN_ATTEMPTS_KEY, JSON.stringify({count: 0, timestamp: 0}));
}
```

**Modifier la fonction `handleLogin`:**

```javascript
async function handleLogin(e) {
    e.preventDefault();

    // Vérifier le rate limiting
    if (!checkLoginAttempts()) {
        return;
    }

    const password = document.getElementById('login-password').value;
    const hash = await hashPassword(password);

    if (hash === getPasswordHash()) {
        document.getElementById('login-page').classList.add('hidden');
        document.getElementById('main-app').classList.remove('hidden');
        await loadAllData();
        resetLoginAttempts(); // Reset en cas de succès
    } else {
        recordFailedLogin(); // Enregistrer l'échec

        const attempts = JSON.parse(localStorage.getItem(LOGIN_ATTEMPTS_KEY));
        const remaining = MAX_ATTEMPTS - attempts.count;

        if (remaining > 0) {
            showToast(`Mot de passe incorrect. ${remaining} tentative(s) restante(s).`, 'error');
        }
    }

    document.getElementById('login-password').value = '';
}
```

---

### 8. Ajouter Validation des Données

**Dans `admin/index.html`, ajouter une fonction de validation:**

```javascript
// Validation et sanitization
function validateAndSanitize(data) {
    const errors = [];

    // Validation email
    if (data.email && !data.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        errors.push('Format email invalide');
    }

    // Validation téléphone
    if (data.phones) {
        data.phones.forEach((phone, i) => {
            if (!phone.match(/^[0-9\s\+\-\(\)\.]{8,20}$/)) {
                errors.push(`Format téléphone ${i+1} invalide`);
            }
        });
    }

    // Limitation de longueur
    if (data.address && data.address.length > 200) {
        errors.push('Adresse trop longue (max 200 caractères)');
    }

    // Sanitization des champs texte
    const sanitizeText = (text) => {
        return text
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#x27;')
            .trim();
    };

    if (data.address) data.address = sanitizeText(data.address);
    if (data.email) data.email = sanitizeText(data.email);

    return { valid: errors.length === 0, errors, data };
}

// Utiliser dans saveContact()
function saveContact() {
    const contactData = {
        address: document.getElementById('contact-address').value,
        phones: [
            document.getElementById('contact-phone1').value,
            document.getElementById('contact-phone2').value
        ].filter(p => p),
        email: document.getElementById('contact-email').value
    };

    // Validation
    const validation = validateAndSanitize(contactData);
    if (!validation.valid) {
        showToast('Erreurs: ' + validation.errors.join(', '), 'error');
        return;
    }

    contact = validation.data;
    markAsChanged();
    showToast('Contact sauvegardé localement', 'success');
}
```

---

## 📋 CHECKLIST DE DÉPLOIEMENT

Avant de pousser les modifications:

- [ ] ✅ Commentaire du mot de passe supprimé
- [ ] ✅ Nouveau mot de passe fort généré et hash mis à jour
- [ ] ✅ Token GitHub révoqué et régénéré avec permissions minimales
- [ ] ✅ DOMPurify ajouté et implémenté
- [ ] ✅ netlify.toml créé avec headers de sécurité
- [ ] ✅ Rate limiting ajouté sur l'authentification
- [ ] ✅ Validation des données implémentée
- [ ] ✅ Tests effectués en local
- [ ] ✅ Backup du site actuel créé

---

## 🧪 TESTS À EFFECTUER

### Test 1: Vérifier DOMPurify
```javascript
// Dans la console du navigateur sur le site
const testXSS = '<img src=x onerror=alert("XSS")>';
console.log(DOMPurify.sanitize(testXSS)); // Doit retourner: <img src="x">
```

### Test 2: Vérifier Rate Limiting
1. Essayer de se connecter 6 fois avec un mauvais mot de passe
2. Vérifier le message de blocage
3. Attendre 15 minutes et réessayer

### Test 3: Vérifier CSP
1. Ouvrir la console développeur (F12)
2. Vérifier qu'il n'y a pas d'erreurs CSP
3. Tester toutes les fonctionnalités (calculateur, admin, etc.)

### Test 4: Vérifier HTTPS
```bash
curl -I https://xn--bijouteriestefcrations-q8b.fr | grep -i strict
# Doit afficher: strict-transport-security: max-age=31536000
```

---

## 🚨 EN CAS DE PROBLÈME

Si le site ne fonctionne plus après les modifications:

1. **Désactiver temporairement CSP:**
   - Commenter la ligne CSP dans netlify.toml
   - Redéployer
   - Vérifier les erreurs dans la console

2. **Problème DOMPurify:**
   - Vérifier que le CDN est accessible
   - Vérifier qu'il n'y a pas de typo dans les fonction calls

3. **Problème Rate Limiting:**
   - Effacer localStorage: `localStorage.clear()`
   - Recharger la page

---

## 📞 SUPPORT

En cas de difficulté:
1. Vérifier les logs Netlify: https://app.netlify.com
2. Consulter la documentation: https://docs.netlify.com
3. Tester en local avant de pousser
4. Créer un backup de la branche avant modifications majeures

---

**IMPORTANT:** Ces correctifs ne remplacent pas une authentification backend robuste. Pour une sécurité optimale à long terme, migrer vers Netlify Identity est fortement recommandé.

---

**Date de création:** 4 mars 2026
**Dernière mise à jour:** 4 mars 2026
**Version:** 1.0
