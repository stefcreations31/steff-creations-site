# Guide de Test - Vérification Alignements Desktop

## ÉTAPES DE VÉRIFICATION

### 1. NAVIGATION (80px fixe)

**Comment tester**:
- Ouvrir DevTools (F12)
- Inspecter la barre de navigation
- Vérifier `height: 80px`
- Scroller la page
- La hauteur doit rester 80px

**Points à vérifier**:
- Logo parfaitement centré verticalement
- Liens menu alignés avec le logo
- Aucun saut lors du scroll

---

### 2. HERO SECTION (100vh, min 700px)

**Comment tester**:
- Mesurer la hauteur de la section hero
- Doit faire exactement la hauteur du viewport
- Sur écran < 700px de haut, doit faire 700px minimum

**Points à vérifier**:
- Titre centré verticalement et horizontalement
- Boutons espacés de 2rem (32px)
- Description max-width 500px centrée

---

### 3. SECTIONS (padding uniforme)

**Comment tester**:
- Inspecter chaque section
- Vérifier `padding: 8rem var(--container-padding)`
- Sur desktop > 1400px: padding horizontal = max(2rem, 5vw)
- Sur desktop 1400px: padding horizontal = 3rem

**Sections à vérifier**:
- Stats Section
- Atelier Section
- Services Section
- Products Section
- Estimation Section

**Points à vérifier**:
- Toutes les sections ont le même padding vertical
- Contenu centré avec max-width cohérent
- Pas de débordement horizontal

---

### 4. GRILLES

#### Products Grid

**Tests Desktop 1920px**:
```
Ouvrir DevTools
Passer en mode responsive
Définir largeur: 1920px
```

**Vérifications**:
- 3 colonnes sur écrans larges
- Gap de 4rem (64px) entre les cards
- Cards parfaitement alignées
- Pas de décalage visuel

**Tests Desktop 1440px**:
```
Largeur: 1440px
```

**Vérifications**:
- 2 colonnes
- Gap toujours 4rem
- Container padding réduit à 3rem

#### Stats Grid

**Vérifications**:
- 4 colonnes sur desktop
- Gap de 6rem (96px)
- Séparateurs verticaux entre les items
- Chiffres et labels alignés

#### Services Grid

**Vérifications**:
- 3 colonnes égales
- Gap de 2rem (32px)
- Cards même hauteur
- Icônes centrées

---

### 5. PRODUCT CARDS

**Hover Effects à tester**:

1. **Bordure Gradient**:
   - Survoler une card
   - Bordure dorée doit apparaître progressivement
   - Animation fluide en 0.3s

2. **Shimmer Effect**:
   - Observer l'image de la card
   - Effet de brillance doit passer de gauche à droite
   - Subtil et élégant

**Points à vérifier**:
- Badge positionné à 1rem du coin
- Padding interne de 2rem
- Nom produit taille 1.25rem
- Description taille 0.875rem
- Prix visible et lisible

---

### 6. CATEGORY BUTTONS

**Tests interactifs**:

1. Cliquer sur un bouton de catégorie
2. Observer l'animation du trait doré en bas
3. Le trait doit s'animer du centre vers 80% de largeur
4. Transition fluide en 0.3s

**Points à vérifier**:
- Padding: 1rem horizontal, 2rem vertical
- Gap de 0.5rem entre icône et texte
- Bordure plus visible sur hover
- Background subtle au survol

---

### 7. TYPOGRAPHIE

**Échelle à vérifier**:

```css
Hero Title (desktop):     clamp(3rem, 10vw, 7rem)
Section Titles:           2.5rem (40px)
Product Names:            1.25rem (20px)
Service Titles:           1.25rem (20px)
Body Text:                1rem (16px)
Small Text:               0.875rem (14px)
Tiny Text:                0.75rem (12px)
```

**Comment vérifier**:
- Inspecter chaque élément
- Comparer avec l'échelle ci-dessus
- Aucun texte ne doit utiliser de taille aléatoire

---

### 8. SPACING VERTICAL

**Mesurer avec DevTools**:

1. **Entre sections**: 8rem (128px)
2. **Section Header margin-bottom**: 6rem (96px)
3. **Entre éléments moyens**: 2rem (32px)
4. **Entre petits éléments**: 1rem (16px)

**Points à vérifier**:
- Respiration visuelle cohérente
- Pas d'espaces trop serrés ou trop larges
- Hiérarchie claire

---

### 9. RESPONSIVE BREAKPOINTS

#### Test 1400px
```
DevTools > Responsive > 1400px
```
- Products grid passe en 2 colonnes
- Container padding réduit à 3rem

#### Test 1280px
```
DevTools > Responsive > 1280px
```
- Toujours 2 colonnes products
- Navigation reste à 80px
- Sections bien proportionnées

#### Test 1024px (Tablette)
```
DevTools > Responsive > 1024px
```
- Products grid toujours 2 colonnes
- Services grid passe en 1 colonne
- Stats grid passe en 2x2

#### Test 768px (Mobile)
```
DevTools > Responsive > 768px
```
- Navigation passe à 70px
- Products grid en 1 colonne
- Spacing réduit (xl = 4rem, 2xl = 5rem)
- Container padding = 1.5rem

---

### 10. PERFORMANCE & ANIMATIONS

**Transitions à tester**:

1. **Product Card Hover**:
   - Durée: 0.3s
   - Easing: cubic-bezier(0.4, 0, 0.2, 1)
   - Mouvement vers le haut de 5px
   - Ombre progressive

2. **Button Hover**:
   - Durée: 0.3s
   - Changement de couleur fluide
   - Pas de saccades

3. **Category Button Active**:
   - Trait doré s'anime en 0.3s
   - Du centre vers 80% largeur

**Points à vérifier**:
- Aucune animation saccadée
- 60 fps maintenu (vérifier dans Performance tab)
- Pas de reflow visible

---

## CHECKLIST FINALE

### Desktop 1920px
- [ ] Navigation 80px fixe
- [ ] Hero 100vh centré
- [ ] Products grid 3 colonnes
- [ ] Stats grid 4 colonnes
- [ ] Services grid 3 colonnes
- [ ] Toutes sections padding uniforme
- [ ] Typographie cohérente
- [ ] Bordures gradient au hover
- [ ] Animations fluides

### Desktop 1440px
- [ ] Container padding 3rem
- [ ] Products grid 2 colonnes
- [ ] Tout reste aligné
- [ ] Pas de débordement

### Desktop 1280px
- [ ] Navigation proportionnée
- [ ] Grilles bien espacées
- [ ] Textes lisibles

### Tablette 1024px
- [ ] Services 1 colonne
- [ ] Stats 2x2
- [ ] Products 2 colonnes

### Mobile 768px
- [ ] Navigation 70px
- [ ] Products 1 colonne
- [ ] Spacing réduit
- [ ] Tout lisible

---

## OUTILS DE TEST

### DevTools
```
F12 > Toggle Device Toolbar
Tester les largeurs:
- 1920px (Desktop Large)
- 1440px (Desktop Standard)
- 1280px (Desktop Small)
- 1024px (Tablet)
- 768px (Mobile Large)
- 480px (Mobile)
- 380px (Mobile Small)
```

### Mesure des espacements
```
Inspecter élément
Onglet Computed
Vérifier padding/margin
```

### Performance
```
F12 > Performance
Record pendant 5 secondes
Analyser les 60 fps
```

---

## PROBLÈMES COURANTS À VÉRIFIER

### Navigation
- [ ] Pas de saut lors du scroll
- [ ] Logo toujours centré
- [ ] Hauteur fixe respectée

### Grilles
- [ ] Pas de card plus petite que les autres
- [ ] Gaps uniformes
- [ ] Alignement parfait

### Typographie
- [ ] Pas de texte trop petit (< 12px)
- [ ] Pas de texte coupé
- [ ] Hiérarchie claire

### Spacing
- [ ] Pas d'espaces inconsistants
- [ ] Respiration visuelle
- [ ] Padding uniforme

### Animations
- [ ] Pas de saccades
- [ ] Durée cohérente
- [ ] Easing fluide

---

## RÉSULTAT ATTENDU

Après ces tests, vous devez constater:

1. **Alignement parfait** sur tous les breakpoints desktop
2. **Spacing cohérent** partout
3. **Typographie harmonieuse** avec échelle claire
4. **Grilles bien proportionnées** sans décalage
5. **Animations fluides** sans ralentissement
6. **Navigation stable** qui ne bouge pas

Si un seul point ne fonctionne pas, consulter le fichier REFONTE_DESIGN_COMPLETE.md pour voir les changements appliqués.
