CREATE USER IF NOT EXISTS 'replicant'@'%' identified by 'replicant_password';
GRANT replication slave ON *.* TO replicant;
flush privileges;

