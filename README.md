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

### TP6

Vous pouvez au contenu de mon travail pour le TP6 en cliquant [ici](https://github.com/ianlcz/admin-bdd/blob/master/12-10/TP6/).

## 19-10

### TP7

- **Création du `docker-compose.yml`**

  ```
  version: "3.8"

  services:
    maria-1-TP7:
      image: mariadb:latest
      hostname: maria-1-TP7
      ports:
        - 3306
        - 4444
        - 4567
        - 4568
      environment:
        - MYSQL_ROOT_PASSWORD=password
      command: --wsrep-new-cluster
      volumes:
        - ./maria-1-TP7:/var/lib/mysql
        - ./config/node1.cnf:/etc/mysql/mariadb.conf.d/node1.cnf

    maria-2-TP7:
      image: mariadb:latest
      hostname: maria-2-TP7
      links:
        - maria-1-TP7
      ports:
        - 3306
        - 4444
        - 4567
        - 4568
      environment:
        - MYSQL_ROOT_PASSWORD=password
      volumes:
        - ./maria-2-TP7:/var/lib/mysql
        - ./config/node2.cnf:/etc/mysql/mariadb.conf.d/node2.cnf

    maria-3-TP7:
      image: mariadb:latest
      hostname: maria-3-TP7
      links:
        - maria-1-TP7
      ports:
        - 3306
        - 4444
        - 4567
        - 4568
      environment:
        - MYSQL_ROOT_PASSWORD=password
      volumes:
        - ./maria-3-TP7:/var/lib/mysql
        - ./config/node3.cnf:/etc/mysql/mariadb.conf.d/node3.cnf
  ```

- **Création des fichiers de config**

  - **`./config/node1.cnf`**
    ```
    [mariadb]
    wsrep_cluster_address="gcomm://maria-1-TP7,maria-2-TP7,maria-3-TP7"
    wsrep_provider="/usr/lib/libgalera_smm.so"
    binlog_format=ROW
    default_storage_engine=InnoDB
    innodb_autoinc_lock_mode=2
    innodb_doublewrite=1
    query_cache_size=0
    wsrep_on=ON
    wsrep_node_address="maria-1-TP7"
    wsrep_node_name="Node1"
    ```
  - **`./config/node2.cnf`**
    ```
    [mariadb]
    wsrep_cluster_address="gcomm://maria-1-TP7,maria-2-TP7,maria-3-TP7"
    wsrep_provider="/usr/lib/libgalera_smm.so"
    binlog_format=ROW
    default_storage_engine=InnoDB
    innodb_autoinc_lock_mode=2
    innodb_doublewrite=1
    query_cache_size=0
    wsrep_on=ON
    wsrep_node_address="maria-2-TP7"
    wsrep_node_name="Node2"
    ```
  - **`./config/node3.cnf`**

    ```
    [mariadb]
    wsrep_cluster_address="gcomm://maria-1-TP7,maria-2-TP7,maria-3-TP7"
    wsrep_provider="/usr/lib/libgalera_smm.so"
    binlog_format=ROW
    default_storage_engine=InnoDB
    innodb_autoinc_lock_mode=2
    innodb_doublewrite=1
    query_cache_size=0
    wsrep_on=ON
    wsrep_node_address="maria-3-TP7"
    wsrep_node_name="Node3"
    ```

## 26-10 & 02-11

Vous pouvez accéder au contenu de mon TP en cliquant [ici](https://github.com/ianlcz/admin-bdd/blob/master/26-10/TP8)

### PART 1

#### docker-compose.yml

```yml
version: "3.8"

services:
  mariadb:
    image: mariadb:latest
    hostname: mariadb
    ports:
      - 3306
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - ./mariadb:/var/lib/mysql
      - ./scripts:/docker-entrypoint-initdb.d
  prometheus:
    image: prom/prometheus:latest
    hostname: prometheus
    depends_on:
      - mysql-exporter
    ports:
      - 9090:9090
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml:ro
  mysql-exporter:
    image: prom/mysqld-exporter:latest
    hostname: mysql-exporter
    depends_on:
      - mariadb
    ports:
      - 9104:9104
    environment:
      DATA_SOURCE_NAME: "root:password@(mariadb:3306)/test"
```

#### Le fichier ./config/prometheus.yml

```yml
scrape_configs:
  - job_name: prometheus
    scrape_interval: 5s
    static_configs:
      - targets: ["localhost:9090", "mysql-exporter:9104"]
```

#### Le fichier ./scripts/mariadb.sql

```sql
CREATE USER 'root'@'%' IDENTIFIED BY 'password';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'root'@'%';
GRANT SELECT ON performance_schema.* TO 'root'@'%';
```

### PART 2

#### Les requêtes SQL

````
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 678
Server version: 10.5.6-MariaDB-1:10.5.6+maria~focal mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> use test
Database changed
MariaDB [test]> CREATE TABLE students 
    -> (
    -> id INT PRIMARY KEY,
    -> firstname VARCHAR(255),
    -> lastname VARCHAR(255)
    -> );
Query OK, 0 rows affected (0.024 sec)

MariaDB [test]> INSERT INTO students VALUES 
    -> (
    -> 1, "Yann", "Le Coz"
    -> );
Query OK, 1 row affected (0.032 sec)

MariaDB [test]> UPDATE students
    -> SET firstname = "Michel"
    -> WHERE lastname = "Le Coz"
    -> ;
Query OK, 1 row affected (0.008 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [test]> DELETE FROM `students`
    -> WHERE id = 1;
Query OK, 1 row affected (0.003 sec)

MariaDB [test]> TRUNCATE TABLE `students`;
Query OK, 0 rows affected (0.029 sec)

MariaDB [test]> exit
Bye
root@mariadb:/# exit
exit
````

#### Graphique de toutes les opérations de lectures et d'écritures

![alt text](https://media.discordapp.net/attachments/772811914136387614/772841874913755186/unknown.png?width=1780&height=1086 "Graph 1")

#### Graphique de la variation du taux d'opérations de lectures et d'écritures en prenant en compte la moyenne sur les 5 dernières minutes

![alt text](https://media.discordapp.net/attachments/772811914136387614/772842672733290526/unknown.png?width=1780&height=1086 "Graph 2")
