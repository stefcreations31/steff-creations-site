# Correctif - Problème de Synchronisation Admin

**Date:** 4 mars 2026
**Problème:** Les modifications faites dans l'admin ne s'affichent pas sur le site

---

## 🔍 Diagnostic

### Problèmes Identifiés

1. **Cache Navigateur - produits.json** (PRINCIPAL)
   - Fichier: `index.html:4463`
   - Le fichier `produits.json` est chargé SANS cache busting
   - Les autres fichiers (`contact.json`, `histoire.json`) ont bien le cache busting

2. **Absence de Headers Cache pour les JSON**
   - Fichier: `netlify.toml`
   - Pas de headers spécifiques pour empêcher le cache des fichiers `/data/*.json`

3. **Délai de Déploiement GitHub Pages**
   - Après publication, GitHub Pages peut prendre 1-5 minutes pour se mettre à jour
   - Pas de feedback visuel sur ce délai

---

## ✅ Solutions à Appliquer

### Correctif 1: Ajouter Cache Busting sur produits.json

**Fichier:** `index.html` ligne 4463

**AVANT:**
```javascript
const response = await fetch('/data/produits.json');
```

**APRÈS:**
```javascript
const response = await fetch('/data/produits.json?v=' + Date.now());
```

---

### Correctif 2: Configurer les Headers Cache dans netlify.toml

**Fichier:** `netlify.toml`

**AJOUTER après la ligne 17:**
```toml
# Pas de cache pour les fichiers de données
[[headers]]
  for = "/data/*.json"
  [headers.values]
    Cache-Control = "no-cache, no-store, must-revalidate"
    Pragma = "no-cache"
    Expires = "0"

# Cache long pour les images
[[headers]]
  for = "/images/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.jpeg"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.jpg"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.png"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

# Cache modéré pour HTML/CSS/JS
[[headers]]
  for = "/*.html"
  [headers.values]
    Cache-Control = "public, max-age=3600, must-revalidate"

[[headers]]
  for = "/*.css"
  [headers.values]
    Cache-Control = "public, max-age=86400, must-revalidate"

[[headers]]
  for = "/*.js"
  [headers.values]
    Cache-Control = "public, max-age=86400, must-revalidate"
```

---

### Correctif 3: Améliorer le Feedback de Publication

**Fichier:** `admin/index.html` - Fonction `publishChanges` (ligne 1336)

**REMPLACER la fonction complète par:**

```javascript
async function publishChanges() {
    const config = getConfig();
    if (!config.token) {
        showToast('Configurez GitHub dans l\'onglet Configuration', 'error');
        document.querySelector('[data-tab="config"]').click();
        return;
    }

    const statusText = document.getElementById('status-text');
    statusText.textContent = 'Publication en cours...';

    try {
        // Publication des fichiers
        statusText.textContent = 'Publication produits...';
        await updateGitHubFile(config, 'data/produits.json', JSON.stringify({ produits: products }, null, 2), 'Mise a jour produits');

        statusText.textContent = 'Publication contact...';
        await updateGitHubFile(config, 'data/contact.json', JSON.stringify(contact, null, 2), 'Mise a jour contact');

        statusText.textContent = 'Publication marges...';
        await updateGitHubFile(config, 'data/marges.json', JSON.stringify(marges, null, 2), 'Mise a jour marges');

        statusText.textContent = 'Publication histoire...';
        await updateGitHubFile(config, 'data/histoire.json', JSON.stringify(histoire, null, 2), 'Mise a jour histoire');

        // Succès
        hasChanges = false;
        document.getElementById('status-bar').classList.remove('has-changes');
        statusText.textContent = 'Publie avec succes!';
        statusText.classList.remove('warning');
        document.getElementById('status-actions').style.display = 'none';
        localStorage.removeItem(DATA_KEY);

        showToast('Modifications publiees! Le site se met a jour dans 1-2 minutes...', 'success');

        // Afficher un message d'information sur le délai
        setTimeout(() => {
            showToast('GitHub Pages met a jour le site. Actualisez dans 1-2 min.', 'info');
        }, 2000);

    } catch (error) {
        console.error('Erreur publication:', error);
        statusText.textContent = 'Erreur de publication';
        showToast('Erreur: ' + error.message, 'error');
    }
}
```

---

### Correctif 4: Ajouter un Bouton "Forcer l'Actualisation"

**Fichier:** `admin/index.html`

**1. Ajouter dans la section Configuration (après le bouton "Tester la connexion"):**

```html
<div style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid #333;">
    <h4 style="color: var(--gris); margin-bottom: 1rem;">Actualisation du site</h4>
    <p style="color: var(--gris); font-size: 0.9rem; margin-bottom: 1rem;">
        Si vos modifications ne s'affichent pas sur le site, utilisez ces options:
    </p>
    <button class="btn btn-secondary" onclick="clearSiteCache()" style="width: 100%;">
        Vider le cache et recharger le site
    </button>
    <button class="btn btn-secondary" onclick="forceDeploy()" style="width: 100%; margin-top: 0.5rem;">
        Forcer le redéploiement GitHub Pages
    </button>
</div>
```

**2. Ajouter les fonctions JavaScript (avant la dernière balise `</script>`):**

```javascript
// Vider le cache du site
function clearSiteCache() {
    if (confirm('Cela va ouvrir le site dans un nouvel onglet en mode sans cache. Continuer?')) {
        // Ouvrir le site avec hard refresh
        const siteUrl = `https://${getConfig().owner}.github.io/${getConfig().repo}/`;
        window.open(siteUrl + '?nocache=' + Date.now(), '_blank');
        showToast('Site ouvert dans un nouvel onglet. Faites Ctrl+Shift+R pour un hard refresh.', 'info');
    }
}

// Forcer le redéploiement
async function forceDeploy() {
    const config = getConfig();
    if (!config.token) {
        showToast('Configurez GitHub dans l\'onglet Configuration', 'error');
        return;
    }

    if (!confirm('Cela va créer un commit vide pour forcer GitHub Pages à redéployer. Continuer?')) {
        return;
    }

    try {
        // Créer un fichier .deploy avec timestamp pour forcer le redéploiement
        const timestamp = new Date().toISOString();
        const content = `Dernier deploiement: ${timestamp}`;

        await updateGitHubFile(
            config,
            '.deploy',
            content,
            `Force redeploy ${timestamp}`
        );

        showToast('Redéploiement forcé! Le site se met à jour dans 2-3 minutes.', 'success');

    } catch (error) {
        console.error('Erreur:', error);
        showToast('Erreur: ' + error.message, 'error');
    }
}
```

---

### Correctif 5: Ajouter un Toast de Type "Info"

**Fichier:** `admin/index.html` - Dans la section CSS

**AJOUTER dans les styles (chercher `.toast.success` et ajouter après):**

```css
.toast.info {
    background: rgba(52, 152, 219, 0.9);
    border-left: 4px solid #3498db;
}
```

---

## 📋 Checklist de Déploiement

- [ ] Modifier `index.html` ligne 4463 pour ajouter cache busting
- [ ] Modifier `netlify.toml` pour ajouter les headers de cache
- [ ] Modifier `admin/index.html` fonction `publishChanges` pour meilleur feedback
- [ ] Ajouter le bouton "Forcer l'actualisation" dans l'admin
- [ ] Ajouter les fonctions `clearSiteCache()` et `forceDeploy()`
- [ ] Ajouter le style CSS pour `.toast.info`
- [ ] Tester en local
- [ ] Pousser sur GitHub
- [ ] Attendre 2-3 minutes
- [ ] Tester la publication depuis l'admin

---

## 🧪 Procédure de Test

### Test 1: Vérifier le Cache Busting

1. Ouvrir la console développeur (F12) sur le site principal
2. Aller dans l'onglet "Network"
3. Recharger la page
4. Chercher `produits.json` dans les requêtes
5. Vérifier que l'URL contient `?v=` suivi d'un timestamp

### Test 2: Vérifier les Headers

1. Dans l'onglet Network, cliquer sur `produits.json`
2. Aller dans "Headers"
3. Vérifier que `Cache-Control` contient `no-cache, no-store`

### Test 3: Tester la Publication

1. Se connecter à l'admin
2. Modifier un produit (changer le titre par exemple)
3. Cliquer sur "Publier les modifications"
4. Attendre le message de succès
5. Attendre 2 minutes
6. Ouvrir le site dans un nouvel onglet
7. Faire Ctrl+Shift+R (hard refresh)
8. Vérifier que la modification apparaît

### Test 4: Tester le Forçage de Déploiement

1. Si les modifications n'apparaissent toujours pas
2. Aller dans Configuration
3. Cliquer sur "Forcer le redéploiement"
4. Attendre 3 minutes
5. Recharger le site avec Ctrl+Shift+R
6. La modification doit maintenant apparaître

---

## 🔧 Commandes de Diagnostic

### Vérifier le cache dans le navigateur

**Console JavaScript:**
```javascript
// Vérifier la version du fichier
fetch('/data/produits.json?v=' + Date.now())
  .then(r => r.json())
  .then(data => console.log('Version actuelle:', data))
```

### Vider le cache manuellement

**Dans le navigateur:**
1. Ouvrir DevTools (F12)
2. Clic droit sur le bouton de rechargement
3. Sélectionner "Vider le cache et effectuer une actualisation forcée"

OU

```
Windows/Linux: Ctrl + Shift + R
Mac: Cmd + Shift + R
```

---

## ⏱️ Délais Normaux

| Action | Délai attendu |
|--------|---------------|
| Push vers GitHub | Instantané |
| GitHub Actions Build | 30-60 secondes |
| GitHub Pages Deploy | 1-3 minutes |
| CDN Propagation | 1-5 minutes |
| **Total maximum** | **5-10 minutes** |

---

## 🚨 Si Ça Ne Marche Toujours Pas

### Vérification 1: GitHub Actions
1. Aller sur `github.com/[owner]/[repo]/actions`
2. Vérifier que le workflow "pages-build-deployment" est vert
3. Si rouge, cliquer dessus pour voir l'erreur

### Vérification 2: GitHub Pages Settings
1. Aller sur `github.com/[owner]/[repo]/settings/pages`
2. Vérifier que Source = "Deploy from a branch"
3. Vérifier que Branch = "main" et folder = "/ (root)"

### Vérification 3: Fichier CNAME
1. Vérifier que le fichier `CNAME` contient bien le bon domaine
2. Vérifier que les DNS pointent vers GitHub Pages

### Vérification 4: Logs Netlify
Si vous utilisez Netlify au lieu de GitHub Pages:
1. Aller sur app.netlify.com
2. Sélectionner le site
3. Aller dans "Deploys"
4. Vérifier le statut du dernier déploiement

---

## 📞 Support

**En cas de problème persistant:**

1. Vérifier les Actions GitHub pour les erreurs de build
2. Vérifier la console du navigateur pour les erreurs JavaScript
3. Tester avec un navigateur différent
4. Tester en navigation privée
5. Vider complètement le cache du navigateur

---

**Auteur:** Claude Code
**Version:** 1.0
**Date:** 4 mars 2026
