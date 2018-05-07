## 実習: CLIを作ってみる

- せっかくなので、実際に何か役に立つものを作ってみましょう
- ここからはまとまった演習時間になります
- 1時間30分位を想定。進捗があまりにも良ければ切り上げてOTPの話へ
- **作ったmix projectは、GitHubにrepositoryをつくってpushし、以下のissueにリンクを投稿しておいてください**
    - https://github.com/access-company/server_training/issues/3
    - 終了後、ざっと確認＆フォローアップします
    - 上記issueに質問等を投稿してもらっても構いません

### お題: HipChatに投稿するCLI

- Command Line Interface; CLI、要はターミナルから使えるアプリケーションです
    - `mix`もCLIといえます
- HipChatは普通Webブラウザから使いますが、HipChatはAPIを提供しているので、
  これを経由してターミナルから投稿できるツールを作ってみましょう

### 必要なもの

- HipChatのAPIは、[RESTful API](../basics/api_design.md)です。HTTP 1.1でリクエストを送れなければなりません
    - といっても、HTTPのクライアントサイドスタックをまるっと実装するのは骨が折れますね
    - ライブラリを使いましょう。手前味噌ですが今回は[ymtszw/hipchat_elixir](https://github.com/ymtszw/hipchat_elixir)を使います
        - 一部APIがJSONしか受け付けないので、[devinus/poison](https://github.com/devinus/poison)も導入しておく
- APIは、どんなHTTPリクエストでも受け付けてくれるわけではありません。登録済みのユーザであることを証明する認証情報が必要です
    - [HipChatのAPI Accessページ](https://access-jp.hipchat.com/account/api)を開きます
        - ログインorパスワード再入力が求められたら、入力してください
    - "Create new token"欄で、
        - Label欄を適当に入力。"HipChatCLI"など
        - Scopes欄の"Send Message"を選択
        - "Create"
    - 生成された"Token"文字列をコピー
    - APIトークンのたぐいは**秘密情報**です
        - 他人に知られて利用されるべきでないので、ソースコードには含めてはいけません
        - ここでは、`~/.config/hipchat_cli/token`のようなファイルに保存しておきましょう

          ```
          $ mkdir -p ~/.config/hipchat_cli
          $ echo "<コピーしたトークン>" > ~/.config/hipchat_cli/token
          ```

### 流れ

- ElixirでCLIを作る場合は、[`escript`](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html)という仕組みを使うことができます
    - Webアプリケーション開発ではそれほど登場しませんが
- まずは先程用意したmix projectを、`escript`としてビルドできるようにします
    - `mix.exs`に追加する設定は以下のような内容。詳しくは[document](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html)を読んでみましょう

    ```diff
    diff --git b/myapp/mix.exs a/myapp/mix.exs
    index d5b8dd5..589379e 100644
    --- b/myapp/mix.exs
    +++ a/myapp/mix.exs
    @@ -7,13 +7,15 @@ defmodule Myapp.Mixfile do
           version: "0.1.0",
           elixir: "~> 1.5",
           start_permanent: Mix.env == :prod,
    -      deps: deps()
    +      deps: deps(),
    +      escript: [main_module: Myapp],
         ]
       end
    @@ -21,7 +23,9 @@ defmodule Myapp.Mixfile do
       # Run "mix help deps" to learn about dependencies.
       defp deps do
         [
    -      {:mix_test_watch, "0.6.0"},
    +      {:mix_test_watch, "0.6.0", [only: :dev, runtime: false]},
    +      {:hipchat_elixir, "0.2.3"},
    +      {:poison, "2.2.0"},
           # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
         ]
       end
    ```

- `:main_module`に指定したmoduleは、`main/1`という関数を導入する必要があります
    - 最初は、単に"Hello world"などの文字列を表示して終了するだけ、といった内容から始めて、適宜`git commit`しながら進めていきましょう
    - 引数は`main/1`の引数には、「コマンドライン引数がリストとして」入ってきます

    ```diff
    diff --git b/myapp/lib/myapp.ex a/myapp/lib/myapp.ex
    index 6ea9d42..e6d7e1d 100644
    --- b/myapp/lib/myapp.ex
    +++ a/myapp/lib/myapp.ex
    @@ -3,6 +3,27 @@ defmodule Myapp do
       Documentation for Myapp.
       """
    +
    +  def main(_) do
    +    IO.puts("Hello world")
    +  end
    +
       @doc """
       Hello world.
    ```

- 必要な設定と関数のベースが用意できたら、`mix escript.build`で実行ファイルを生成できます

    ```
    $ mix escript.build
    Compiling 1 file (.ex)
    Generated myapp app
    Generated escript myapp with MIX_ENV=dev

    $ ./myapp
    Hello world
    ```

- ここまで来たら、`main/1`の中身を徐々に実装していきます
    - 上で作ったトークンファイルからAPIトークンを読み込む
    - コマンドラインからの引数(メッセージ内容)を受け取る
    - (対象とするHipChat roomのIDを調べておく。これも引数として受け取っても良い)
    - 両者を組み合わせて、`hipchat_elixir`が提供するmoduleの関数を使って実際にリクエストを送る

### 演習: 作ってみよう

- 詰まったらどんどん質問・アラートを上げてください。必要そうであれば適宜ヒント、叩き台を提示していきます
- この内容であれば、それほどのコード量にはならないはずです
- 模範解答というほどでもないですが、動作するコードを別ブランチにアップしておきます
- いい時間がたったら、そちらのブランチのコードと見比べつつ、振り返ります
    - https://github.com/access-company/server_training/blob/handson_example/myapp/mix.exs
    - (次のページの内容も既に含んでいることに注意して下さい)

---

- もしあまりにも簡単すぎるという人がいたら、どんどん改造してみてください
- 例えばこんなのどうでしょう
    - 引数の数が間違っているなら、正しい"Usage"を表示する
    - コマンドライン引数でなく、標準入力でメッセージを受け取れるようにしてみる
    - 投稿するだけでなく、履歴を取得できるようにしてみる
        - APIトークンのScopesに"View Messages"を追加する必要があります
    - メッセージをパイプで受けられるようにしてみる(筆者はこれを`escript`でやったことはありません！ できるかな？)
    - 「メッセージ」だけでなく「通知」も送れるようにしてみる
        - HTMLメッセージを送れたりします
        - APIトークンのScopesに"Send Notification"を追加する必要があります
