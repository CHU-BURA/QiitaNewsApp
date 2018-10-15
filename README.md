# QiitaNewsApp

## このアプリについて
- ジャンル : ニュースアプリ

Qiitaで発信されている最新記事、ストックしている記事を本アプリで閲覧できるようにする。
また、特定のワードで検索絞り込みを可能とする。


## アプリの要件
- Qiitaで発信されている記事一覧を表示する。
	- アプリ起動時に記事更新を行う
	- 記事一覧には作成日時・ユーザ名・プロフィール画像・記事タイトルを表示する
- 特定のキーワードを含む記事一覧を表示する(記事検索)。
	- 記事検索結果一覧は記事一覧と同様の内容で表示する
	- 検索対象を絞り込めるように検索オプションを設ける
- 指定した時間に、通知を使用してユーザに確認するよう促す。
	- 指定した時間になったら、通知を表示する
	- 特定の時間経過後に通知を表示させたいため「ローカル通知」を利用する
	- アプリ内で通知のON/OFFを切り替えられるようにする
	- 通知設定は、アプリで通知時間を設定可能にする
- 記事元となるデータ取得
	- データの取得には、QiitaAPI (https://qiita.com/api/v2/docs) を使用する
	- Codableを用いたデータモデルを作成する


## 環境
  - Xcode 9.3
  - Swift 4.1

## 開発に用いた使用技術
- ライブラリ
	- **SDWebImage 4.0**
		- 簡易に書けるライブラリを使うべきだと感じた
		- UIImageに変換する手間がない
		- 一度ダウンロードした画像を一定期間保管しておくキャッシュの機能も搭載されている
	- **SVProgressHUD 2.2.5**
		- タスク進行中であること(ローディングのアニメーション)を簡易に書ける
		- ある程度のカスタマイズが簡易であった(文字を入れるなど)
- クラス
	- **SFSafariViewController**
		- Qiitaで発信されている記事一覧の表示部分
		- 画面レイアウトのフォーマットが決まっているため実装工数的にも削減できると感じたため
		- 機能面でもSafariと同等の機能が搭載されているため十分だと感じたため
	- **NSURLSession**
		- データ取得時の通信処理に使用する
	- **UserNotifications**
		- アプリ内のローカル通知設定で使用
- レイアウト
	- 各記事のレイアウトにはTableViewCellのカスタムクラスとxibファイルを使用
	- StoryboardRefarence

## 実装時に意識したこと
- 可読性
	- コメント・インデント
	- StoryboardRefarenceやクラスの拡張(extension)
- シンプルかつ画面操作が直感的でわかりやすい

## 改善点・反省点
- ライブラリの選択
	- 適切なライブラリを選択するという意味で他のライブラリと性能面での比較が疎かになっていた。

- SDWebImageの取得
	- キャッシュからの取得をする必要があった

- 共通化処理
	- エラー発生時のアラート表示などは共通で使用できるようにまとめるべきであった。
