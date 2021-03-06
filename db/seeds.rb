unless Rails.env.test?
  {
    firstnames: {
      name:         'Prénoms',
      description:  "Outil de scoring prénoms\n"
    },
    geoscore: {
      name:         'GeoScore',
      description:  "Outil de scoring GeoScore\n"
    },
    insee: {
      name:         'Scoring INSEE',
      description:  "Scoring INSEE\n"
    }
  }.each { |k, v| Operation.where(ref: k).first_or_create(v) }


  {
    gold: {
      name:     'Gold',
      price:    100.00,
      visible:  true
    },
    silver: {
      name:     'Silver',
      price:    200.00,
      visible:  true
    },
    bronze: {
      name:     'Bronze',
      price:    300.00,
      visible:  true
    },
    free: {
      name:     'Essai gratuit',
      visible:  false
    }
  }.each { |k, v| Offer.where(ref: k).first_or_create(v) }


  Article.where(zone: 'doc').first_or_create(body: <<-eoh)
Titre de niveau 1
=================

Titre de niveau 2
-----------------

### Titre niveau 3

#### Titre niveau 4

##### Titre niveau 5

###### Titre niveau 6

#Un croisillon en début de ligne sera préservé s'il n'est pas suivi
d'un espace.

---


Trois caractères moins (`-`) consécutifs provoquent une séparation
(élément hr en HTML).

---


Un saut de ligne à l'intérieur d'un paragraphe
texte ne créé pas de nouveau paragraphe HTML.

Deux sauts de lignes consécutifs créent un nouveau paragraphe.

---


Les astérisques en début de ligne permettent de créer une liste :

* red
* green
  (on peut sauter des lignes dans le source)
* blue
  (le texte reste attaché à l'entrée courante)

On peut également créer des listes ordonnées :

1. red
2. green
3. blue

---


Une URI entre chevrons, <http://optifront.example/>, est automatiquement
transformée en lien.

---


On peut déclarer une *emphase*,
du texte en **strong**,
du `texte préformaté`,
ou encore ==hightlighted==.

Contrairement à la syntaxe Markdown originale, on peut utiliser des
underscores_entre_des_mots sans déclencher la création d'emphase.

---

Ajout d'une image inline :

![OptiFront](/assets/logo.png)

Avec attribut HTML "title" :

![OptiFront](/assets/logo.png "attribut title sur image")

---


Pour un bloc de texte préformaté, il faut englober le bloc entre deux
lignes constituées de trois caractères backticks (`)

```
class OffersPresenter
  extend Forwardable
  def_delegators :@offers, :any?, :each

  def initialize(offers)
    @offers = offers.map { |e| OfferPresenter.new(e) }
  end
end
```

---


Citations :


> > This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,
> > consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
> > Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.
> 
> Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse
> id sem consectetuer libero luctus adipiscing.

---


Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.  Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.  Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.
  eoh
end
