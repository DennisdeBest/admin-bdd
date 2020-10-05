# admin-bdd

Dépôt git du cours d'Admin-BDD.

## Auteur

Yann LE COZ - Bordeaux Ynov Campus

## Sommaire

- [**05-10**](#05-10)
  - [TP4](#TP4)
    - [Part 1](#Part-1)
    - [Part 2](#Part-2)

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
    ```bach
    # apt-get install vi -yq
    ```
  - **Édition du crontab**
    ```zsh
    0 17 * * 1 mysqldump -u root -p password --all-databases | gzip -9 -c > /backups/backup_"$(date +%Y-%m-%d)".sql.gz
    ```
- **Démarrage du service**
  ```bach
  # service cron start
  [ ok ] Starting periodic command scheduler: cron.
  ```
