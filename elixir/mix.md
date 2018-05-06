## 実習: Mix project, 初めてのテスト

- 文法を眺めるよりも前に、
    - 書いたコードを管理しやすい環境を整え、
    - 「テスト」を書いてコンパイル・実行を繰り返せるようにしましょう
- Elixirのプログラムは公式ツールの`mix`を使ってMix projectとして管理するのが一般的です

### Mix project

```
$ mix new ~/myapp
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/myapp.ex
* creating test
* creating test/test_helper.exs
* creating test/myapp_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd /Users/yumatsuzawa/myapp
    mix test

Run "mix help" for more commands.

$ cd ~/myapp
```

- パスは適当に変えてOKです
- 環境構築が正しくできていないとこの時点で何か問題が起こるかもしれません。アラートを上げてください

#### 中身をちょっと確認

> `mix.exs`

[import, lang:"elixir", mix.exs](../myapp/mix.exs)

- このファイル自体が[**モジュール; module**](https://elixirschool.com/ja/lessons/basics/modules/)を定義しています。(`Myapp.Mixfile`)
    - Elixirのmodule名はこのように`.`区切りで名前空間を構成できます
- `Myapp.Mixfile.project/0`という[関数](https://elixirschool.com/ja/lessons/basics/functions/#%E5%90%8D%E5%89%8D%E4%BB%98%E3%81%8D%E9%96%A2%E6%95%B0)が、
  主たる設定情報を宣言しています
    - `/0`というのはErlang/Elixirの関数を指し示すときに使う表記法です。`/`のあとに引数の数を付けます
    - `def`で定義されているのは **公開; public/exposed** 関数で、別のmoduleから呼び出して使えます
    - `defp`で定義されているのは **非公開; private** 関数で、同一module内部からしか使えません
- `project/0`関数は[**リスト; list**](https://elixirschool.com/ja/lessons/basics/collections/#%E3%83%AA%E3%82%B9%E3%83%88)を返しますが、
  ちょっと特殊な[**Keyword List, Keywords**](https://elixirschool.com/ja/lessons/basics/collections/#%E3%82%AD%E3%83%BC%E3%83%AF%E3%83%BC%E3%83%89%E3%83%AA%E3%82%B9%E3%83%88)というものになっています
    - リストは、 **配列; array** とは微妙に違います(具体的には内部実装が異なる)が、役割としては似ています
    - Keywordsは要はKey-value pairsです
    - Keywordsの実体は最初の要素が[**アトム; atom**](https://elixirschool.com/ja/lessons/basics/basics/#%E3%82%A2%E3%83%88%E3%83%A0)
      であるような[**タプル; tuple**](https://elixirschool.com/ja/lessons/basics/collections/#%E3%82%BF%E3%83%97%E3%83%AB)のリストです
        - したがって、

          ```elixir
          [{:key1, "value1"}, {:key2, "value2"}]
          ```

        - と書いていくのが正式なのですが、以下のように省略する記法が使われています

          ```elixir
          [key1: "value1", key2: "value2"]
          ```

- 生成したアプリケーションがErlang VM内で`:myapp`という名前を持つよう、`app: :myapp`という項目で定義しています

> `lib/myapp.ex`

[import, lang:"elixir", myapp.ex](../myapp/lib/myapp.ex)

- デフォルトでは、`lib/`以下のファイルが主たるソースコードとなります。今は`lib/myapp.ex`のみ
    - ここにあなたのアプリケーションで実行したい内容を実装していきます
- Atomを返すだけの`hello/0`が定義されている以外では、`@moduledoc`と`@doc`という
  [**module attributes**](https://elixirschool.com/ja/lessons/basics/modules/#%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E3%81%AE%E5%B1%9E%E6%80%A7)があります
    - 定数など、コンパイル時処理に用いる値を格納するのがmodule attributeですが、
      `@moduledoc`と`@doc`は特殊で、ソースコードドキュメントとして機能します
    - `ex_doc`という別ツールを使って、HTMLドキュメントに整形することができます

### 初めてのテスト

- 試しにこのプログラムを実行してみたくなったとき、どうしたらいいでしょうか。
    - まだこのプログラムは、ターミナルで対話的に何かを処理するとか、
      HTTPリクエストを処理するだとかいったリッチな機能は何一つ実装されていません
    - あるのは`Myapp.hello/0`だけです
- このように、アプリケーションの一部だけしかまだ実装していない、
  あるいは開発しているのはライブラリパッケージであって、別のアプリケーションに組み込まれないと機能を果たさない、
  といった状況でも、**実装されている細かな単位だけ実行しながら挙動を確かめられる**、便利な環境、ツールがあります
- それが**テスト; test**です

```
$ mix test
Compiling 1 file (.ex)
Generated myapp app
..

Finished in 0.04 seconds
2 tests, 0 failures

Randomized with seed 285458
```

- 「2つのテストが実行された」ようですが、一体何を実行したのでしょうか。テストファイルを見てみましょう

> `test/myapp_test.exs`

[import, lang:"elixir", myapp_test.exs](../myapp/test/myapp_test.exs)

- `test "greets the world" do`の行は、専用の構文のようにも見えますが、実は`test/2`という**マクロ; macro**です
    - Elixirではマクロを使ってDSLを作ることができます
        - ただしやりすぎるとユーザにとってはかえってわかりにくいので乱用は禁物です
    - マクロも関数と同様に`test/2`などと表します
    - 実はElixirの関数やマクロは`()`を省略することができ、ここでも省略されています
        - 一般に、関数では省略しません。DSL的に用いられるマクロでは省略することもあります
- この`test/2`の場合、第一引数は`"greets the world"`で、第二引数には`do ... end`までのブロックが入っています
    - 第一引数はテストの説明、
    - 第二引数は、実際に実行して欲しいコードをそのまま書くだけです！
- もう一つのテストは、実は`doctest Myapp`という行で指示されています
    - これは`Myapp` moduleの定義ファイル中のソースコードドキュメント内に、
      決まった形式で書かれた実行可能なコードが書かれている場合、それを実行して結果を確かめます
    - 該当箇所はこの部分です

      ```
      iex> Myapp.hello
      :world
      ```

### 失敗させてみよう

- "0 failures"と出ていましたので、テストでは何も失敗しなかったようです
- 失敗するとどうなるのでしょうか。`test/myapp_test.exs`を以下のように書き換えてみてください

```diff
diff --git a/myapp/test/myapp_test.exs b/myapp/test/myapp_test.exs
index c206d7f..58f3a97 100644
--- a/myapp/test/myapp_test.exs
+++ b/myapp/test/myapp_test.exs
@@ -3,6 +3,6 @@ defmodule MyappTest do
   doctest Myapp

   test "greets the world" do
-    assert Myapp.hello() == :world
+    assert Myapp.hello() == :goodbye
   end
 end
```

- 保存して、テストを実行してみましょう

```
$ mix test


  1) test greets the world (MyappTest)
     test/myapp_test.exs:5
     Assertion with == failed
     code:  assert Myapp.hello() == :goodbye
     left:  :world
     right: :goodbye
     stacktrace:
       test/myapp_test.exs:6: (test)

.

Finished in 0.04 seconds
2 tests, 1 failure

Randomized with seed 762492
```

- "1 failure"となりました。doctestの方は書き換えていないので成功しています
- 書き換えた方は、「実装は`:world`を返すのに、」「テストコードは`:goodbye`を期待している」ため、失敗しています
- 失敗した場合、どのような状況だったのかを教えてくれることもわかりました
- テストはこのように、 **あなたのElixirプログラムを簡単に、かつ繰り返し何度でも実行させられる、手軽で安全な環境、心強い味方** です

### ここまでのワークフロー

- Mix projectとしてElixirプログラムの管理単位を規定する
- (主に`lib/`以下に)moduleを実装していく
- テストコードで実際の動きを確かめる

## 演習: いじってみよう/怒らせてみよう

- 〜10分ほど
- 些細な事でも随時質問してOKです

1. テストコードでも、実装コードでも構いません。少しいじってみてください
    - [四則演算など](https://elixirschool.com/ja/lessons/basics/basics/#%E5%9F%BA%E6%9C%AC%E7%9A%84%E3%81%AA%E6%BC%94%E7%AE%97)、単純なコードでOKです
2. 何か間違ったコードを書いてみてください。 **コンパイラがどのようなエラーを表示してくるか** 見ておきましょう
    - 俗にコンパイラに**怒られる**といいます
