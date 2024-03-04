# 1. データベースを構築する

## Mysqlへ接続する
```
mysql -u <ユーザー名> -p
```
＊テーブルを作成する権限があるユーザーで接続してください。

## データベースを構築する
1. データベースを作成する。
```sql
CREATE DATABASE internet_tv;
```

2. データベースを表示する
```sql
SHOW DATABASES;
```
＊データベースができているか確認します。

3. データベースを指定する
```sql
USE internet_tv;
```
＊今回使用するデータベースである　internet_tv　を指定します。
