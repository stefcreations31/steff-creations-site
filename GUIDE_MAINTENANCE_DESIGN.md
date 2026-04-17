# Guide de Maintenance - Système de Design

## RÈGLES D'OR

### 1. TOUJOURS Utiliser les Variables CSS

❌ **MAUVAIS**:
```css
.nouveau-composant {
    padding: 2rem;
    margin-bottom: 4rem;
    font-size: 1.25rem;
    max-width: 1200px;
}
```

✅ **BON**:
```css
.nouveau-composant {
    padding: var(--space-md);
    margin-bottom: var(--space-lg);
    font-size: var(--text-xl);
    max-width: var(--container-default);
}
```

---

## VARIABLES DISPONIBLES

### Spacing (Espacement)

```css
var(--space-xs)   /* 0.5rem = 8px   - Très petit */
var(--space-sm)   /* 1rem = 16px    - Petit */
var(--space-md)   /* 2rem = 32px    - Moyen */
var(--space-lg)   /* 4rem = 64px    - Grand */
var(--space-xl)   /* 6rem = 96px    - Très grand */
var(--space-2xl)  /* 8rem = 128px   - Extra grand */
```

**Quand utiliser quoi**:
- `--space-xs`: Gap entre icône et texte, margin small
- `--space-sm`: Padding de bouton, gap dans flex
- `--space-md`: Padding de card, margin entre éléments
- `--space-lg`: Gap de grid, margin entre sections importantes
- `--space-xl`: Margin header, padding section mobile
- `--space-2xl`: Padding section desktop

### Containers (Largeur max)

```css
var(--container-narrow)   /* 900px  - Texte, formulaires */
var(--container-default)  /* 1200px - Contenu standard */
var(--container-wide)     /* 1400px - Grilles, galleries */
```

**Quand utiliser quoi**:
- `--container-narrow`: Formulaires, texte long, articles
- `--container-default`: Stats, estimations, contact
- `--container-wide`: Products grid, services, galleries

### Padding Container

```css
var(--container-padding)  /* max(2rem, 5vw) - Auto-adaptatif */
```

**Usage**: TOUJOURS pour le padding horizontal des sections

### Typographie (Tailles de texte)

```css
var(--text-xs)    /* 0.75rem = 12px   - Badges, labels */
var(--text-sm)    /* 0.875rem = 14px  - Descriptions */
var(--text-base)  /* 1rem = 16px      - Texte normal */
var(--text-lg)    /* 1.125rem = 18px  - Sous-titres */
var(--text-xl)    /* 1.25rem = 20px   - Titres cards */
var(--text-2xl)   /* 1.5rem = 24px    - Icônes, highlights */
var(--text-3xl)   /* 2rem = 32px      - Titres sections mobile */
var(--text-4xl)   /* 2.5rem = 40px    - Titres sections desktop */
var(--text-5xl)   /* 3rem = 48px      - Hero, gros titres */
```

**Quand utiliser quoi**:
- `--text-xs`: Badges produits, catégories, labels
- `--text-sm`: Descriptions produits/services
- `--text-base`: Paragraphes, texte courant
- `--text-lg`: Sous-titres, citations
- `--text-xl`: Titres de cards (produits, services)
- `--text-2xl`: Icônes moyennes, prix
- `--text-3xl`: Titres de sections sur mobile
- `--text-4xl`: Titres de sections sur desktop
- `--text-5xl`: Hero title, compteurs, très gros texte

---

## EXEMPLES DE COMPOSANTS

### Créer une nouvelle Card

```css
.ma-card {
    /* Structure */
    background: var(--noir-surface);
    border: 1px solid var(--or-subtle);
    max-width: var(--container-default);
    margin: 0 auto;

    /* Spacing */
    padding: var(--space-md);
    margin-bottom: var(--space-lg);

    /* Transitions */
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.ma-card:hover {
    border-color: var(--or);
    transform: translateY(-5px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

.ma-card-title {
    font-family: 'Cinzel', serif;
    font-size: var(--text-xl);
    color: var(--blanc);
    margin-bottom: var(--space-sm);
}

.ma-card-description {
    font-family: 'Jost', sans-serif;
    font-size: var(--text-sm);
    color: var(--gris);
    line-height: 1.8;
}
```

### Créer une nouvelle Section

```css
.ma-section {
    /* Spacing uniforme */
    padding: var(--space-2xl) var(--container-padding);

    /* Container */
    max-width: var(--container-wide);
    margin: 0 auto;

    /* Background optionnel */
    background: var(--noir-profond);
}

.ma-section-header {
    text-align: center;
    margin-bottom: var(--space-xl);
}

.ma-section-title {
    font-family: 'Cinzel', serif;
    font-size: var(--text-4xl);
    color: var(--blanc);
    letter-spacing: 0.1em;
    margin-bottom: var(--space-md);
}

.ma-section-subtitle {
    font-family: 'Jost', sans-serif;
    font-size: var(--text-sm);
    color: var(--or);
    letter-spacing: 0.4em;
    text-transform: uppercase;
}
```

### Créer un nouveau Bouton

```css
.mon-bouton {
    /* Typography */
    font-family: 'Jost', sans-serif;
    font-size: var(--text-xs);
    font-weight: 500;
    letter-spacing: 0.2em;
    text-transform: uppercase;

    /* Spacing */
    padding: var(--space-sm) var(--space-lg);

    /* Style */
    background: linear-gradient(135deg, var(--or) 0%, var(--or-clair) 100%);
    color: var(--noir);
    border: none;
    cursor: pointer;

    /* Animation */
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.mon-bouton:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(201, 162, 39, 0.3);
}
```

### Créer une nouvelle Grid

```css
.ma-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: var(--space-lg);
    max-width: var(--container-wide);
    margin: 0 auto;
    padding: 0 var(--container-padding);
}

/* Responsive */
@media (max-width: 1400px) {
    .ma-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .ma-grid {
        grid-template-columns: 1fr;
        gap: var(--space-md);
    }
}
```

---

## AJOUTER DES ANIMATIONS

### Transition Standard

```css
transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
```

**Usage**: Hover effects, changements d'état

### Transition Rapide

```css
transition: all 0.2s ease;
```

**Usage**: Petits changements, feedback immédiat

### Animation Entrée (Fade In Up)

```css
opacity: 0;
animation: fadeInUp 1s ease forwards;

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
```

### Animation Hover Subtile

```css
.element:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}
```

---

## RESPONSIVE: MODIFIER LES BREAKPOINTS

### Structure Actuelle

```css
/* Desktop Large */
@media (max-width: 1400px) {
    :root {
        --container-padding: 3rem;
    }
}

/* Tablette */
@media (max-width: 1024px) {
    /* Grids passent en moins de colonnes */
}

/* Mobile */
@media (max-width: 768px) {
    :root {
        --space-xl: 4rem;
        --space-2xl: 5rem;
        --container-padding: 1.5rem;
    }
}
```

### Ajouter un nouveau Breakpoint

```css
/* Exemple: 1600px pour très grands écrans */
@media (min-width: 1600px) {
    :root {
        --container-padding: 8vw;
    }
    .products-grid {
        grid-template-columns: repeat(4, 1fr);
    }
}
```

---

## MODIFIER LES COULEURS

### Couleurs Existantes

```css
--noir: #0A0A0A;
--noir-profond: #050505;
--noir-surface: #111111;
--noir-elevated: #1A1A1A;
--or: #C9A227;
--or-clair: #D4AF37;
--or-pale: #E8D5A3;
--or-subtle: rgba(201, 162, 39, 0.15);
--creme: #F5F0E8;
--blanc: #FAFAFA;
--gris: rgba(255, 255, 255, 0.6);
--gris-fonce: rgba(255, 255, 255, 0.4);
```

### Ajouter une nouvelle Couleur

```css
:root {
    /* ... couleurs existantes ... */

    /* Nouvelle couleur */
    --ma-couleur: #HEXCODE;
    --ma-couleur-subtle: rgba(R, G, B, 0.15);
}
```

### Usage

```css
.mon-element {
    color: var(--ma-couleur);
    background: var(--ma-couleur-subtle);
}
```

---

## ERREURS COURANTES À ÉVITER

### ❌ NE PAS FAIRE

```css
/* Valeurs en dur */
.element {
    padding: 32px;
    font-size: 20px;
    max-width: 1200px;
}

/* Transitions trop rapides */
.element {
    transition: all 0.1s;
}

/* Trop de clamp() */
.element {
    font-size: clamp(1rem, 5vw, 3rem);
    padding: clamp(1rem, 3vw, 5rem);
}

/* max-width sans margin auto */
.element {
    max-width: 1200px;
    /* Pas centré! */
}

/* Spacing incohérent */
.element {
    padding: 35px 28px;
    margin-bottom: 47px;
}
```

### ✅ FAIRE

```css
/* Variables CSS */
.element {
    padding: var(--space-md);
    font-size: var(--text-xl);
    max-width: var(--container-default);
}

/* Transitions fluides */
.element {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Tailles fixes avec media queries */
.element {
    font-size: var(--text-4xl);
}
@media (min-width: 769px) {
    .element {
        font-size: clamp(2.5rem, 5vw, 4rem);
    }
}

/* Toujours centrer */
.element {
    max-width: var(--container-default);
    margin: 0 auto;
}

/* Spacing du système */
.element {
    padding: var(--space-md);
    margin-bottom: var(--space-lg);
}
```

---

## CHECKLIST AVANT DE COMMITTER

Avant de commit des changements CSS, vérifier:

- [ ] Toutes les valeurs utilisent des variables CSS
- [ ] Les transitions sont cohérentes (0.3s cubic-bezier)
- [ ] Les containers ont max-width + margin: 0 auto
- [ ] Le responsive est testé sur 3 breakpoints minimum
- [ ] Pas de valeurs "magiques" (23px, 47px, etc.)
- [ ] Typographie respecte l'échelle définie
- [ ] Spacing utilise le système 8px
- [ ] Animations sont fluides (60 fps)
- [ ] Code est commenté si complexe

---

## RESSOURCES

### Tester le Design

```bash
# Ouvrir le site
start index.html

# DevTools
F12 > Toggle Device Toolbar

# Tester les largeurs
1920px, 1440px, 1280px, 1024px, 768px, 480px
```

### Vérifier les Variables

```javascript
// Console DevTools
getComputedStyle(document.documentElement)
    .getPropertyValue('--space-md')
// Résultat: 2rem
```

### Générer une nouvelle Variable de Couleur

```javascript
// Convertir HEX en RGBA
function hexToRgba(hex, alpha = 0.15) {
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}

hexToRgba('#C9A227', 0.15);
// rgba(201, 162, 39, 0.15)
```

---

## SUPPORT

Pour toute question sur le système de design:

1. Consulter `REFONTE_DESIGN_COMPLETE.md`
2. Consulter `GUIDE_TEST_ALIGNEMENTS.md`
3. Inspecter les composants existants
4. Suivre les patterns établis

**Philosophie**: Cohérence > Créativité

Un design cohérent avec un système strict est toujours meilleur qu'un design "créatif" mais incohérent.
