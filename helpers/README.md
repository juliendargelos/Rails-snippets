# Helpers

> Les fichiers sont à placer dans `app/helpers`

## ApplicationHelper

Contient des méthodes utiles dans les vues.

#### `title`

Permet de facilement ajouter un titre aux pages.

- Dans un layout:
	<title>Nom du site<%= ' - ' + yield(:title) if content_for?(:title) %></title>

- Dans une vue:
	<% title 'Page 1' %>

## AssetsHelpers

Contient des constantes et méthodes utiles pour gérer les assets dans les vues.

### Constantes
- `ASSETS` Répertoire des assets (`app/assets`)
- `STYLESHEETS` Répertoire des feuilles de style (`app/assets/stylesheets`)
- `JAVASCRIPTS` Répertoire des scripts javascript (`app/assets/javascripts`)
- `IMAGES` Répertoire des images (`app/assets/images`)

### Méthodes

#### `current_asset_name`
Retourne le nom de l'asset courant selon la forme définie dans [`config/initializers/assets.rb`](https://github.com/juliendargelos/Rails-snippets/tree/master/initializers).
Ainsi les trois méthodes qui suivent n'ont de sens que si `config/initializers/assets.rb` est utilisé.

#### `current_asset`
Fournit le nom de l'asset courant et des attributs au bloc passé en paramètre, puis retourne le retour du block lui-même si le fichier existe. Prend quatre paramètres:
- `directory`: Le répertoire où se trouve le type d'asset concerné (par exemple la valeur de `STYLESHEET` ou `JAVASCRIPT`)
- `attributes`: Des attributs à utiliser pour surchager ceux qui seront passés au bloc
- `type`: Le type d'asset concerné: `css` ou `js`
- `&block`: Le block à utiliser pour le retour

```ruby
# Le controleur courant est "users" et l'action courante est "show"
current_asset STYLESHEET, {media: screen}, :css do |asset, attributes|
	stylesheet_link_tag asset, attributes
end
# '<link rel="stylesheet" href="/assets/users-show.self-2717328c26bcad773e8024db51d8a2e6fde887c25bb67f1ed2f36a34d42e0fd8.css?body=1" media="screen" data-turbolinks-track="true">'
```
Par défaut, les attributs contiendront `media: all` (pour css uniquement) et `'data-turbolinks-track' => true` si turbolinks est activé.

Il n'est pas très utile d'utiliser directement cette méthode; les deux suivantes sont plus évidentes.

#### `current_stylesheet`
Retourne une balise `link` pour la feuille de style courante:
	<%= current_stylesheet %>
	<!-- '<link rel="stylesheet" href="/assets/users-show.self-2717328c26bcad773e8024db51d8a2e6fde887c25bb67f1ed2f36a34d42e0fd8.css?body=1" media="all" data-turbolinks-track="true">' !-->

Peut prendre des attributs (par défaut: `{}`) et un type d'assets (par défaut: `sass`) en paramètres.

#### `current_javascript`
Retourne une balise `script` pour le script courant. Ajoute également les scripts utiles à turbolinks si il est activé.
	<%= current_javascript %>
	<!-- '<script type="javascript" src="/assets/users-show.self-2717328c26bcad773e8024db51d8a2e6fde887c25bb67f1ed2f36a34d42e0fd8.js?body=1" data-turbolinks-track="true"></script>' !-->

Peut prendre des attributs (par défaut: `{}`) et un type d'assets (par défaut: `js`) en paramètres.

#### `enable_turbolinks`
Active turbolinks dans la vue courante.

#### `disable_turbolinks`
Désactive turbolinks dans la vue courante.

#### `turbolinks_enabled?`
Retourne `true` si turbolinks est activé, `false` sinon (par défaut `false`)
