# 2. テーブルを設計、構築する

## テーブルを設計する

### ER図
<img width="361" alt="スクリーンショット 2024-03-07 174027" src="https://github.com/RyunosukeMatsuoka/internet_tv/assets/152969864/1981f6bc-a42e-4008-977b-c99a2a0f8af7">

### テーブル設計
テーブル：channels
| カラム名 | データ型    | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| -------- | ----------- | --- | --- | -------- | ------------ | -------------- |
| id       | smallint    | 〇  | -   | 〇       | -            | YES            |
| name     | VARCHAR(30) | -   | 〇  | 〇       | -            | -              |

テーブル：programs
| カラム名 | データ型     | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| -------- | ------------ | --- | --- | -------- | ------------ | -------------- |
| id       | bigint(20)   | 〇  | -   | 〇       | -            | YES            |
| name     | VARCHAR(30)  | -   | 〇  | 〇       | -            | -              |
| detail   | VARCHAR(100) | -   | -   | 〇       | -            | -              |

テーブル：genres
| カラム名 | データ型    | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| -------- | ----------- | --- | --- | -------- | ------------ | -------------- |
| id       | smallint    | 〇  | -   | 〇       | -            | YES            |
| name     | VARCHAR(30) | -   | 〇  | 〇       | -            | -              |

テーブル：seasons
| カラム名   | データ型    | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| ---------- | ----------- | --- | --- | -------- | ------------ | -------------- |
| id         | bigint(20)  | 〇  | -   | 〇       | -            | YES            |
| program_id | bigint(20)  | -   | -   | 〇       | -            | -              |
| name       | VARCHAR(30) | -   | -   | 〇       | -            | -              |

- 外部キー制約：program_id に対して、programs テーブルの id カラムから設定

テーブル：episodes
| カラム名     | データ型     | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| ------------ | ------------ | --- | --- | -------- | ------------ | -------------- |
| id           | bigint(20)   | 〇  | -   | 〇       | -            | YES            |
| season_id    | bigint(20)   | -   | -   | -        | -            | -              |
| number       | INTERGER     | -   | -   | 〇       | -            | -              |
| title        | VARCHAR(50)  | -   | -   | 〇       | -            | -              |
| detail       | VARCHAR(300) | -   | -   | 〇       | -            | -              |
| length       | TIME         | -   | -   | 〇       | -            | -              |
| release_date | DATE         | -   | -   | 〇       | -            | -              |
| view_count   | bigint(20)   | -   | -   | 〇       | 0            | -              |

- 外部キー制約：season_id に対して、season テーブルの id カラムから設定

テーブル：archives
| カラム名   | データ型   | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| ---------- | ---------- | --- | --- | -------- | ------------ | -------------- |
| id         | bigint(20) | 〇  | -   | 〇       | -            | YES            |
| channel_id | smallint   | -   | -   | 〇       | -            | -              |
| episode_id | bigint(20) | -   | -   | 〇       | -            | -              |
| start_time | DATETIME   | -   | -   | 〇       | -            | -              |
| end_time   | DATETIME   | -   | -   | 〇       | -            | -              |
| view_count | bigint(20) | -   | -   | 〇       | 0            | -              |

- 外部キー制約：channel_id に対して、channel テーブルの id カラムから設定
- 外部キー制約：episode_id に対して、episode テーブルの id カラムから設定

テーブル：channel_programs
| カラム名   | データ型   | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| ---------- | ---------- | --- | --- | -------- | ------------ | -------------- |
| id         | bigint(20) | 〇  | -   | 〇       | -            | YES            |
| channel_id | smallint   | -   | -   | 〇       | -            | -              |
| program_id | bigint(20) | -   | -   | 〇       | -            | -              |

- 外部キー制約：channel_id に対して、channel テーブルの id カラムから設定
- 外部キー制約：program_id に対して、programs テーブルの id カラムから設定

テーブル：program_genres
| カラム名   | データ型   | PK  | UK  | NOT NULL | デフォルト値 | AUTO_INCREMENT |
| ---------- | ---------- | --- | --- | -------- | ------------ | -------------- |
| id         | bigint(20) | 〇  | -   | 〇       | -            | YES            |
| program_id | bigint(20) | -   | -   | 〇       | -            | -              |
| genre_id   | smallint   | -   | -   | 〇       | -            | -              |

- 外部キー制約：program_id に対して、programs テーブルの id カラムから設定
- 外部キー制約：genre_id に対して、genres テーブルの id カラムから設定

## テーブルを構築する

テーブル設計をもとに、SQL文を書き、テーブルを構築します。

テーブル：channels
```sql
CREATE TABLE channels (
  id SMALLINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE KEY
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：programs
```sql
CREATE TABLE programs (
  id BIGINT(20) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE KEY,
  detail VARCHAR(100) NOT NULL
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：genres
```sql
CREATE TABLE genres (
  id SMALLINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE KEY
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：seasons
```sql
CREATE TABLE seasons (
  id BIGINT(20) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  program_id BIGINT(20) NOT NULL,
  name VARCHAR(30) NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs(id)
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：episodes
```sql
CREATE TABLE episodes (
  id BIGINT(20) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  season_id BIGINT(20),
  number INT NOT NULL,
  title VARCHAR(50) NOT NULL,
  detail VARCHAR(300) NOT NULL,
  length TIME NOT NULL,
  release_date DATE NOT NULL,
  view_count BIGINT(20) NOT NULL DEFAULT 0,
    FOREIGN KEY (season_id) REFERENCES seasons(id)
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：archives
```sql
CREATE TABLE archives (
  id BIGINT(20) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  channel_id SMALLINT NOT NULL,
  episode_id BIGINT(20) NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  view_count BIGINT(20) NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES channels(id),
    FOREIGN KEY (episode_id) REFERENCES episodes(id)
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：channel_programs
```sql
CREATE TABLE channel_programs (
  id BIGINT(20) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  channel_id SMALLINT NOT NULL,
  program_id BIGINT(20) NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES channels(id),
    FOREIGN KEY (program_id) REFERENCES programs(id)
) DEFAULT CHARACTER SET=utf8mb4;
```

テーブル：program_genres
```sql
CREATE TABLE program_genres (
  id BIGINT(20) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  program_id BIGINT(20) NOT NULL,
  genre_id SMALLINT NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id)
) DEFAULT CHARACTER SET=utf8mb4;
```

上記のSQL文を一つずつ実行していきます。
（internet_tv を指定した上で実行します。）

コピペすると簡単にできます！

最後に、テーブルができているか確認します。
```sql
SHOW TABLES;
```
