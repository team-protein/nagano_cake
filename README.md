# ![top_cake](https://user-images.githubusercontent.com/75315945/108791686-0a7d7a00-75c3-11eb-866d-2714a73af64e.jpg)<br>ながのCAKE

長野県にある小さな洋菓子店、「ながのCAKE」の商品を通販するためのECサイト。<br>
元々近隣樹民が主な顧客だったが、昨年始めたInstagramから人気となり、全国から注文が来るようになった。<br>
InstagramのDMやメールで通販の注文を受けていたが、情報管理が煩雑になってきたため、管理機能を含んだ通販サイトを開設しようと思い至った。

# 通販について

・通販では注文に応じて製作する受注生産型としています。<br>
・現在通販での注文量は十分に対応可能な量のため、1日の受注量に制限は設けていません。<br>
・送料は１配送につき全国一律８００円。<br>
・友人や家族へのプレゼントなど、注文者の住所以外にも商品を発送することができます。<br>
・支払い方法はクレジットカード、銀行振込から選択できます。<br>

# 実装機能

## 顧客側
|機能名|説明|非ログイン時利用可否|
|---|---|---|
|ログイン|・メールアドレス、パスワードでログインできる。<br>・ログイン時のみ利用できる機能が利用可能になる。|○|
|ログアウト|・ログインしている状態からログアウト状態にする。<br>・ログイン時のみ利用できる機能が利用できなくなる。|×|
|商品一覧表示|・商品を一覧表示する。<br>・ジャンル検索、キーワード検索、詳細条件検索が可能。|⚪︎|
|商品詳細情報表示|・商品一覧画面で選択した商品の詳細情報を表示する。<br>・カート追加機能が表示されている。<br>・ブックマーク追加機能が表示されている。|⚪︎|
|カート|・カートの商品を編集削除できる。<br>・カートの商品を一覧表示できる。|×|
|注文|・カートの商品を購入することができる。<br>・支払い方法や発送先を設定することができる。|×|
|会員情報編集|・登録している情報を編集することができる。|×|
|退会|・退会手続きをすることができる。|×|
|配送先追加・編集|・登録している配送先を一覧で確認することができる。<br>・配送先の新規追加・修正・削除をすることができる。|×|
|注文履歴一覧表示|・過去の注文概要を一覧で確認することができる。|×|
|注文履歴詳細表示|・注文の詳細（注文商品や個数など）を確認することができる。|×|

## 管理者側
|機能名|説明|非ログイン時利用可否|
|---|---|---|
|ログイン|・メールアドレス、パスワードでログインできる。<br>・ログイン時のみ利用できる機能が利用できるようになる。|⚪︎|
|ログアウト|・ログインしている状態からログアウト状態にする。<br>・ログイン時のみ利用できる機能が利用できなくなる。|×|
|注文履歴一覧表示|・過去の注文概要を一覧で確認できる。<br>・売上推移をグラフで管理できる。|×|
|注文履歴詳細表示|・注文の詳細（注文商品や個数など）を確認することができる。<br>・注文ステータス、製作ステータスを変更することができる。|×|
|顧客一覧表示|・顧客情報を一覧で確認することができる。|×|
|顧客詳細情報表示|・顧客の詳細情報を確認することができる。<br>・顧客のステータス（有効/退会）を切り替えることができる。|×|
|商品一覧表示|・登録商品を一覧で確認することができる。|×|
|商品詳細情報表示|・商品の詳細情報を確認することができる|×|
|商品追加|・新商品を追加できる。|×|
|商品情報変更|・商品の登録情報を変更することができる。<br>・販売ステータスを変更することができる。|×|
|ジャンル設定|・ジャンルの追加、変更を行うことができる。|×|
|検索機能|・商品名、会員名で検索できる。|×|

# 使用方法

## インストール
$ git clone git@github.com:team-protein/nagano_cake.git (SSH)<br>
or <br>
$ git clone https://github.com/team-protein/nagano_cake.git (HTTPS) <br>
$ cd nagano_cake <br>
$ bundle install<br>
$ rails db:migrate<br>
$ rails db:seed<br>
$ rails s <br>

## テスト
ターミナル（もしくはコマンドプロンプト）で上記の作業を行った後、ローカルサーバーにアクセスしてご覧ください。

【管理者用アカウント：ログイン】<br>
メールアドレス：test@gmail.com<br>
パスワード：testpass<br>

【顧客用アカウント：ログイン】 <br>
メールアドレス：test1@test.com<br>
パスワード：password<br>
（登録画面にて新規登録も可能です。）

# 使用言語

・HTML&CSS<br>
・Ruby<br>
・JavaScript<br>
・フレームワーク<br>
 ⚪︎Ruby on Rails (5.2.4)

# Gem

・devise
・refile
・jquery-rails
・font-awesome-sass
・bootstrap
・dotenv-rails
・kaminari
・jp_prefecture
・enum_help
・rails-i18n
・haml-rails
・erb2haml
・devise-i18n
・devise-i18n-views
・gimei
・jquery-ui-rails
・miyabi
・faker
・capybara
・rspec-rails
・factory_bot_rails


# 作成者

チーム名【 プロテイン 】<br>
メンバー<br>
・[Fukiwake](https://github.com/Fukiwake)<br>
・[akf38](https://github.com/akf38)<br>
・[masutaniR](https://github.com/masutaniR)
