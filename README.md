## 画面遷移図
https://www.figma.com/file/E72TaxV84vVNq1x3CRlLJn/myapp?type=design&node-id=0%3A1&t=ujhaTlG7c1TpPggc-1

# ■ サービス概要
楽器を練習している人の
毎日の練習を効率化する
フレーズストックサービス

弾けないフレーズを放置してずっと弾けないままにしているプレーヤーに、そのフレーズを練習する機会を作る音楽フレーズの単語帳のようなサービスです。
## ■ユーザーが抱える課題
「昔チャレンジした曲のこの部分がずっと弾けないまま」、そういうフレーズが山積みになっている楽器奏者が多い。
## ■課題に対する仮説
- 弾けないフレーズが弾けるようになる前に次の曲に行ってしまう
- 弾けないフレーズを書き留めないためしばらくするとその存在自体忘れてしまう。
- 練習しても弾けるようにならないため挫折してしまう。
## ■解決方法

- 弾けないフレーズを忘れないようにリストをつくることでフレーズを忘れない。
- 弾くことが可能なBPMを記録していくことで、次に自分がどのスピードで練習すべきかがすぐわかる
- そもそもフレーズを採譜できないひともいるので、音声ファイルで簡易的にメモを取れるようにする。
- 弾くことが可能なBPMを記録していき、目的のBPMに近づくことで自分の成長を実感しモチベーションを維持させる。
- 他の人も同じフレーズが弾けなかったりなど、他のユーザーの中にも弾けない人がいることが確認できると、劣等感が緩和される。

## ■メインのターゲットユーザー

楽器を練習している男女。主にバンドの中で使用される楽器（ギター、ベース、ドラム、キーボード）の奏者を想定している。

社会人で趣味として、限られた時間の中で楽器を練習する人。

## ■実装予定の機能

- 一般ユーザー

- 練習中の楽曲を投稿できる

- spotifyの曲を再生範囲をAB区間指定したものを投稿できる

- spotifyの曲をAB区間再生できる

- 自分の演奏可能なBPMを登録できる

- 他のユーザーの投稿にコメントできる

- 他のユーザーの投稿をリストに加えることができる

- リアルタイム通知機能

- 管理ユーザー

- 一般ユーザーの検索、一覧、詳細、編集

- 曲の一覧、詳細、作成、編集、削除

- 管理ユーザーの一覧、詳細、作成、編集、削除

## ■なぜこのサービスを作りたいのか？

私自身楽器を弾くのですが、高校生の頃にコピーしたフレーズで弾けないものがどんどん溜まっていく一方でした。

なぜ弾けないのか考えたところ、単純に弾けないものにかける時間が足りないのが問題だったと思います。このサービスで弾けないフレーズをまとめ、練習時間を投稿したフレーズに当てることで演奏力の向上の目指します。

楽器の練習は、ゆっくりのBPM（テンポ）からスタートし、少しずつ目的のBPMに近づけていくのが王道です。

しかし、前回練習したときの演奏可能なBPMを忘れてしまうため、毎回適当なBPMから練習をはじめてしまい、いつまでたっても目的のBPMに近づくことはありませんでした。その結果、成長を感じず、モチベーションを維持できませんでした。

他の楽器を弾く人々も同様の悩みを抱えているようだったので、自分の上達を感じられる、フレーズの単語帳のようなものがあればいいなと思いこのサービスを考えました。も同様の悩みを抱えているようだったので、自分の上達を感じられる、フレーズの単語帳のようなものがあればいいなと思いこのサービスを考えました。

## ■スケジュール

企画~技術調査: 6/7〆切

README~ER図作成 6/15〆切

メイン機能実装6/16~7/10〆切

β版をRUNTEQ内リリース (MVP) : 7/20

本番リリース　7月下

## ■技術選定

- Rails6
- postgresql
- javascript
- MaterialUI,bootstrap
- heroku
- spotify api
- 
- API
- spotify api