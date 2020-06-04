# ship_html_conversion
概要:

「船ページ変換くん for wiki」はStar Citizen JP Wiki（https://starcitizen.fandom.com/ja/wiki/Starcitizen_Wiki）専用ツールです。
Star Citizen公式サイトにある好きな船ページのURLを入力する事で、データを再整理しWikiのフォーマットに適したHTMLを生成します。


使用方法:

1. HTML化したい船ページのURLをコピーします（例: https://robertsspaceindustries.com/pledge/ships/rsi-aurora/Aurora-ES）

2. 本アプリを起動し、上部のテキストスペースに入力してから右下にある「HTMLを生成」ボタンをクリックします。

3. 中央部のテキストスペースに生成されたHTMLが表示されるので、コピーします。

4. Star Citizen JP Wiki（https://starcitizen.fandom.com/ja/wiki/Starcitizen_Wiki）へアクセスし、新規ページを作成します。（白紙のページを選択してください）

5. 編集画面に移行し、「ソースモード」に切り替えてください。

6. 本アプリで生成したHTMLを"全て"そのまま貼り付けると、手入力が必要な部分以外が完成します。


出来ないこと:

本アプリは公式サイトのデータから必要な文字列を抽出し変換している為、当然ながら公式サイトに無いデータは空の状態で出力されてしまいます。

手入力が必要なwiki情報
・価格（公式サイトにて購入状態にある場合は自動で入力されます）
・ベッド数
・機体の解説
・ページのタグ



バグ等を見つけた際は「HiRO.JP#8533」（Discord）まで、ご連絡ください。

