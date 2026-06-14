#!/bin/bash

# 確保腳本如果在執行中遇到錯誤會立即停止
set -e

# 1. 互動式安全輸入密碼（使用 -s 參數，輸入時螢幕不會顯示字元）
read -s -p "請設定 MariaDB Root 密碼: " ROOT_PWD
echo ""
read -s -p "請設定 Nextcloud 資料庫連線密碼: " DB_PWD
echo ""

# 檢查使用者是否有輸入內容，若留白則退出
if [ -z "$ROOT_PWD" ] || [ -z "$DB_PWD" ]; then
    echo "錯誤：密碼不可為空白，請重新執行腳本。"
    exit 1
fi

# 2. 自動檢查並設定外接硬碟資料夾權限
echo "正在檢查外接硬碟路徑與權限 (/mnt/nextcloud_data)..."
if [ ! -d "/mnt/nextcloud_data" ]; then
    echo "找不到路徑，正在自動建立 /mnt/nextcloud_data..."
    sudo mkdir -p /mnt/nextcloud_data
fi
# 將資料夾權限賦予 Docker 內部的 Nextcloud 使用者 (UID: 33)
sudo chown -R 33:33 /mnt/nextcloud_data

# 3. 利用 Here-Doc 動態產生寫入使用者密碼的 docker-compose.yml
echo "正在產生 docker-compose.yml 檔案..."
cat << EOF > docker-compose.yml
services:
  db:
    image: mariadb:10.11
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${ROOT_PWD}
      - MYSQL_PASSWORD=${DB_PWD}
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    depends_on:
      - db
    volumes:
      - nextcloud_main:/var/www/html
      # 將外接硬碟綁定給 Nextcloud 的核心設定
      - /mnt/nextcloud_data:/var/www/html/data
    environment:
      - MYSQL_PASSWORD=${DB_PWD}
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db

volumes:
  db_data:
  nextcloud_main:
EOF

echo "docker-compose.yml 產生成功！"

# 4. 自動執行 Docker Compose
echo "正在啟動 Docker 容器..."
docker compose up -d