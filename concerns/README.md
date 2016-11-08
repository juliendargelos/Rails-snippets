# Concerns

> Les fichiers sont à placer dans `app/models/concerns`

## HasDisallowedValues

Permet d'indiquer des valeurs interdites pour les propriétés spécifiées d'un modèle. Les propriétés sont vérifiées lors de la validation. Crée également une méthode `constraints` qui peut être utilisée dans le fichier `config/routes.rb` afin de spécifier des contraintes de route.

### Usage

#### Dans le modèle:
- Inclure le fichier:
```ruby
include HasDisallowedValues
```

- Indiquer les propriétés à contrôler et les valeurs interdites:
```ruby
disallow_values property: [:value1, 'value2']
```

- Il est possible d'indiquer plusieurs propriété d'un coup:
```ruby
disallow_values property1: [:value1, :value2], property2: [:value3, :value4]
```

- Il est également possible de spécifier un message d'erreur qui sera utilisé lors de la validation:
```ruby
disallow_values property: { values: [:value1, :value2], message: "La propriété :property ne peut pas prendre la valeur :value" }
# ":property" et ":value" seront remplacés par les valeurs correspondantes
```

#### Dans les routes:
Si une propriété est utilisée pour construire une route, il peut être utile de poser des contraintes directement dans les routes. Par exemple pour un utilisateur:
```ruby
resources :users, path: '/', param: :username
```

La route générée pour l'action show sera alors `/:username`, cela peut poser problème. On peut donc interdire des valeurs réservées dans le modèle:
```ruby
disallow_values username: [:login, :signup, :logout]
```

Puis les rajouter les contraintes dans les routes:
```ruby
resources :users, path: '/', param: :username, constraints: User.constraints
```

Si on veut ajouter une contrainte en particulier:
```ruby
resources :users, path: '/', param: :username, constraints: {username: User.constraints[:username]}
```

## HasSlug

Il est nécessaire d'avoir étendu la classe `String` avec la méthode `to_slug` qui se trouve [ici](https://github.com/juliendargelos/Rails-snippets/tree/master/concerns).
Indique qu'une des propriété du modèle a le rôle de slug unique. Le slug est généré à partir d'une propriété du modèle (par défaut `name`) et mis à jour à l'enregistrement de l'instance. La propriété utilisée par défaut pour enregistrer le slug est `slug`.
Le slug généré est unique, si un slug identique a déjà été trouvé dans la base de données, un incrément sera ajouté à la fin.

### Usage
- Inclure le fichier:
```ruby
include HasSlug
```

- Si nécessaire, indiquer les propriétés à utiliser pour générer (par défaut, `name`) et stocker (par défaut, `slug`) le slug:
```ruby
slug from: :title, to: :identifier
```

- Il est aussi possible de spécifier si le slug est en minuscule (par défaut oui), et le caractère délimiteur (par défaut: `-`)
```ruby
slug delimiter: '_', lowercase: false
```
