# admin-bdd

Dépôt git du cours d'Admin-BDD.

## Auteur

Yann LE COZ - Bordeaux Ynov Campus

## Sommaire

- [**05-10**](#05-10)
  - [TP4](#TP4)
    - [Part 1](#Part-1)
    - [Part 2](#Part-2)
    - [Part 3](#Part-3)

## 05-10

### TP4

#### Part 1

Vous pouvez accéder à mon image Dockerfile en cliquant [ici](https://hub.docker.com/r/ianlcz/ybc-course-adminbdd-tp4-backup).

#### Part 2

- **Accès au container en mode interactif**

  ```zsh
  % docker run -d ianlcz/ybc-course-adminbdd-tp4-backup:0.2
  052cf707ad7798fab378624d681c5b7e5bd79ede960f72b744ac7054836d6266
  % docker ps
  CONTAINER ID        IMAGE                                       COMMAND                  CREATED             STATUS              PORTS                 NAMES
  052cf707ad77        ianlcz/ybc-course-adminbdd-tp4-backup:0.2   "docker-entrypoint.s…"   15 seconds ago      Up 14 seconds       3306/tcp, 33060/tcp   mystifying_curie
  % docker exec -it 052cf707ad77 bash
  ```

- **Utilisation de l'outil crontab**
  - **Installation de l'éditeur Vim**
    ```bash
    apt-get install vi -yq
    ```
  - **Édition du crontab**
    ```zsh
    0 17 * * 1 mysqldump -u root -p password --all-databases | gzip -9 -c > /backups/backup_"$(date +%Y-%m-%d)".sql.gz
    ```
- **Démarrage du service**

  ```bash
  service cron start
  [ ok ] Starting periodic command scheduler: cron.
  ```

#### Part 3

- **Création du fichier `/etc/logrotate.d/tp4`**

  ```bash
  vim /etc/logrotate.d/tp4
  ```
- **Ajout des lignes suivantes :**
  ```bash
  /backups/all_databases{
    rotate 5
    daily
    compress
    compresscmd bzip
    compressext .bz2
    postrotate
      mysqldump -u root -p password --all-databases | gzip -9 -c > all_
    endscript
  }
  ```

  ## 12-10
  ### TP5
  
  Vous pouvez accéder au fichier dump en cliquant [ici](https://github.com/ianlcz/admin-bdd/blob/master/12-10/TP5/backups/dump_file).

  De plus, j'ai dû modifier dans celui-ci `utf8mb4_0900_ai_ci` par `CHARSET=utf8 COLLATE=utf8_general_ci;`.
