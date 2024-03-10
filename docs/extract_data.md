# 4. データを抽出するクエリを書く


### 1. よく見られているエピソードを知りたいです。エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください

```sql
SELECT
  title AS 'エピソードタイトル',
  view_count AS '視聴数'
FROM
  episodes
ORDER BY
  view_count DESC
LIMIT 3;
```

### 2. よく見られているエピソードの番組情報やシーズン情報も合わせて知りたいです。エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください

```sql
SELECT
  p.name AS '番組タイトル',
  s.name AS 'シーズン数',
  e.number AS 'エピソード数',
  e.title AS 'エピソードタイトル',
  e.view_count AS '視聴数'
FROM
  programs AS p
  INNER JOIN seasons AS s
    ON p.id = s.program_id
  INNER JOIN episodes AS e
    ON s.id = e.season_id
ORDER BY
  view_count DESC
LIMIT 3;
```

### 3. 本日の番組表を表示するために、本日、どのチャンネルの、何時から、何の番組が放送されるのかを知りたいです。本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。なお、番組の開始時刻が本日のものを本日放送される番組とします

```sql
SELECT
  c.name AS 'チャンネル名',
  a.start_time AS '放送開始時刻',
  a.end_time AS '放送終了時刻',
  s.name AS 'シーズン数',
  e.number AS 'エピソード数',
  e.title AS 'エピソードタイトル',
  e.detail AS 'エピソード詳細'
FROM
  channels AS c
  INNER JOIN channel_programs AS cp
    ON c.id = cp.channel_id
  INNER JOIN seasons AS s
    ON  cp.program_id = s.program_id
  INNER JOIN episodes AS e
    ON s.id = e.season_id
  INNER JOIN archives AS a
    ON e.id = a.episode_id AND c.id = a.channel_id
WHERE DATE(a.start_time) = CURRENT_DATE
\G
```

### 4. ドラマというチャンネルがあったとして、ドラマのチャンネルの番組表を表示するために、本日から一週間分、何日の何時から何の番組が放送されるのかを知りたいです。ドラマのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得してください

```sql
SELECT
  a.start_time AS '放送開始時刻',
  a.end_time AS '放送終了時刻',
  s.name AS 'シーズン数',
  e.number AS 'エピソード数',
  e.title AS 'エピソードタイトル',
  e.detail AS 'エピソード詳細'
FROM
  channels AS c
  INNER JOIN channel_programs AS cp
    ON c.id = cp.channel_id
  INNER JOIN seasons AS s
    ON  cp.program_id = s.program_id
  INNER JOIN episodes AS e
    ON s.id = e.season_id
  INNER JOIN archives AS a
    ON e.id = a.episode_id AND c.id = a.channel_id
WHERE
  DATE(a.start_time) BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)
  AND c.name LIKE '%ドラマ%'
\G
```

### 5. (advanced) 直近一週間で最も見られた番組が知りたいです。直近一週間に放送された番組の中で、エピソード視聴数合計トップ2の番組に対して、番組タイトル、視聴数を取得してください

```sql
SELECT
  p.name AS '番組タイトル',
  a.view_count AS '視聴数'
FROM
  programs AS p
  INNER JOIN seasons AS s
    ON p.id = s.program_id
  INNER JOIN episodes AS e
    ON s.id = e.season_id
  INNER JOIN archives AS a
    ON e.id = a.episode_id
WHERE a.start_time >= DATE_SUB(CURRENT_DATE, INTERVAL 1 WEEK)
  AND a.start_time <= CURRENT_DATE
ORDER BY a.view_count DESC
LIMIT 2
\G
```

### 6. (advanced) ジャンルごとの番組の視聴数ランキングを知りたいです。番組の視聴数ランキングはエピソードの平均視聴数ランキングとします。ジャンルごとに視聴数トップの番組に対して、ジャンル名、番組タイトル、エピソード平均視聴数を取得してください。

```sql
SELECT
  g.name AS 'ジャンル名',
  p.name AS '番組タイトル',
  sub_query.avg_view_count AS '最大平均視聴数'
FROM
  genres AS g
  INNER JOIN (
    SELECT
      pg.genre_id,
      p.id AS program_id,
      p.name,
      AVG(e.view_count) AS avg_view_count
    FROM
      program_genres AS pg
      INNER JOIN programs AS p ON pg.program_id = p.id
      INNER JOIN seasons AS s ON p.id = s.program_id
      INNER JOIN episodes AS e ON s.id = e.season_id
    GROUP BY
      pg.genre_id,
      p.id,
      p.name
  ) AS sub_query ON g.id = sub_query.genre_id
  INNER JOIN (
    SELECT
      g.id AS genre_id,
      MAX(sub_query.avg_view_count) AS max_avg_view_count
    FROM
      genres AS g
      INNER JOIN (
        SELECT
          pg.genre_id,
          p.id AS program_id,
          AVG(e.view_count) AS avg_view_count
        FROM
          program_genres AS pg
          INNER JOIN programs AS p ON pg.program_id = p.id
          INNER JOIN seasons AS s ON p.id = s.program_id
          INNER JOIN episodes AS e ON s.id = e.season_id
        GROUP BY
          pg.genre_id,
          p.id
      ) AS sub_query ON g.id = sub_query.genre_id
    GROUP BY
      g.id
  ) AS max_avg_view ON g.id = max_avg_view.genre_id
  INNER JOIN programs AS p ON sub_query.program_id = p.id AND sub_query.avg_view_count = max_avg_view.max_avg_view_count
ORDER BY
  g.name;
```

上記の1~6のクエリを実行すると、それぞれの結果が抽出できます！

上記以外にもデータを抽出するクエリを書いてみましょう！
