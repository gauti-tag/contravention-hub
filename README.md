# MMGG PAIEMENTS USSD GUINEE

Cette application gère les opérations de paiements effectuées via USSD concernant la CNI, les contraventions, etc.
Ces principales fonctionnalités sont listées ci-dessous:

- Initier les paiements via API de la plate-forme Mobile Money
- Sauvegarder les transactions effectuées
- Notifier les utilisateurs via SMS après réception du statut de la transaction

## Dépendances:

- [Ruby 2.6.0](https://www.ruby-lang.org/en/)
- [Rails 6.0](https://rubyonrails.org/)
- [Redis](https://redis.io/)
- [PostgreSQL 13](https://www.postgresql.org/)
- [Docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

## Démarrer

Pour démarrer l'application:

- Cloner le dépôt.
- Déployer le fichier master.key joint dans le dossier config. Le contenu du fichier doit être la valeur de la variable d'environnement RAILS_MASTER_KEY.
- Mettre à jour les fichiers suivants selon l'environnement d'exécution de l'application (`développement`, `preprod`, `production`) :
  - _.env_ (voir le modèle dans le fichier .example.env)
  - _docker-compose.yml_
- Générer les containers et démarrer les services:
  Les containers peuvent être lancer en utlisant les commandes de **docker-compose** ou avec l'utilitaire Make (voir fichier Makefile).
- Lancer les migrations de la BD avec la commande `make migrate`.

## Exploitation

- **Intégration API Sender SMS - 12-01-2023**: Mettre à jour les credentials et endpoints selon l'environnement dans le fichier .env (Voir .example.env):

  - `PUSHER_SMS_URL` => L'url SMS API,
  - `SMS_LOGIN` => l'identifiant d’authentification à l’API,
  - `SMS_PASSWORD` => mot de passe d’authentification à l’API,
  - `SMS_SERVICE_ID` => Nom du service pour lequel les SMS sont envoyés,
  - `SMS_SENDER` => Nom de l’ expéditeur du SMS devant apparaitre sur le téléphone de l’abonné.

## Livraison && Déploiement

- **déploiement-au-18-10-2023**: Ajout d'un nouveau service `DECLARATION`
  - Exécution de fichier de migration en attente: `$ bundle exec rails db:migrate`
  - Exécution du fichier seed.rb pour insertion en base : `$ bundle exec rails db:seed`

- **déploiement-au-06-01-2023**: Ajout d'une variable d'environnement `SERVER_FILE_URL`. (Voir fichier .exemple.env)

- **déploiement-au-19-12-2022**: Veuillez effectuer ces actions après le déploiement:

  - Rédemarrer le container: `$ docker-compose restart`
  - Suprimer la base de donnée: `$ bundle exec rails db:drop`
  - Créer une nouvelle base de donnée: `$ bundle exec rails db:create`
  - Exécuter les fichiers de migrations: `$ bundle exec rails db:migrate`
  - Exécution du fichier seed.rb pour insertion en base : `$ bundle exec rails db:seed`

- **déploiement-au-24-11-2022**: Veuillez effectuer ces actions après le déploiement:
  - Exécution de fichier de migration en attente: `$ bundle exec rails db:migrate`
  - Exécution du fichier seed.rb pour insertion en base : `$ bundle exec rails db:seed`
