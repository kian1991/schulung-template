---
title: "Installation PMM"
---

1. user zu docker group: ```sudo usermod -aG docker $USER```
2. Maria DBBare Metal install: https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/installing-mariadb/binary-packages/installing-mariadb-deb-files

 ```bash
 curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
 sudo apt update
 sudo apt install mariadb-server mariadb-client
 ```

curl -fsSL https://www.percona.com/get/pmm | /bin/bash

3. PMM Client Installation: https://docs.percona.com/percona-monitoring-and-management/3/install-pmm/install-pmm-client/package_manager.html

```bash
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo dpkg -i percona-release_latest.generic_all.deb
sudo percona-release enable pmm3-client

sudo apt update
sudo apt install -y pmm-client
```

```bash
pmm-admin config --server-insecure-tls \
--server-url=https://admin:okapi23@127.0.0.1:443
```

https://docs.percona.com/percona-monitoring-and-management/3/install-pmm/install-pmm-client/connect-database/mysql/mysql.html

peroformanceschema config: https://docs.percona.com/percona-monitoring-and-management/3/install-pmm/install-pmm-client/connect-database/mysql/mysql.html#__tabbed_3_2\

```bash
CREATE USER 'pmm'@'localhost' IDENTIFIED BY 'okapi23' WITH MAX_USER_CONNECTIONS 10;
GRANT SELECT, PROCESS, REPLICATION CLIENT, RELOAD ON *.* TO 'pmm'@'localhost';
```
