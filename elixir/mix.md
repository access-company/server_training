## Mix project, 初めてのテスト

- このページの目標
  - Mix プロジェクトを作ってみて、基本的なディレクトリ構造を把握し、プロジェクトのコードを読めるようになる
  - テストコードを読み、書き、実行できるようになる

---

資料: [Introduction to Mix - Elixir](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)

- 業務アプリケーションのコードはたいてい何らかの形(ほぼ`git`)でバージョン管理されることになりますが、
  そのためには開発言語ごとにアプリケーションに必要なソースコードファイルや設定ファイルなどを管理できる単位が必要です
- Elixir アプリケーションは公式ツールの`mix`を使って Mix project という単位で管理するのが一般的です
- コードのテストも`mix`で実行することができます

---

### Mix project

- `mix`コマンドで新しいプロジェクトを作れます。適当な作業ディレクトリ内で実行してみましょう

```
$ mix new myapp
* creating README.md
* creating .formatter.exs
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

    cd myapp
    mix test

Run "mix help" for more commands.
$ cd myapp
```

- パスやアプリケーション名は適当に変えて OK です
- **[確認]** こちらもインストールが正しくできていないとこの時点で何か問題が起こります

---

- `mix.exs`の中身を見てみましょう

```elixir
defmodule Myapp.MixProject do
  use Mix.Project

  def project do
    [
      app: :myapp,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
```

- このファイル自体がモジュールを定義しています(`Myapp.MixProject`)
  - モジュール名はこのように`.`区切りで名前空間を構成できます
  - `mix`では、設定情報もこのように Elixir コードで定義します
    - `use Mix.Project`という宣言により、`mix`に必要な情報を与えるための手続きが裏で行われるようになります
    - ちょっと具体的に言うと、`mix`自身も実行されると Erlang VM 内で起動されるアプリケーションなのですが、
      そこにこの`mix.exs`ファイルと`Myapp.MixProject`というモジュールの存在を登録し、
      その後のコンパイル等の処理においてて必要な情報を収集できるようにしています
- `Myapp.MixProject.project/0`という関数が、主たる設定情報を宣言しています
  - `project/0`関数はすでに紹介した keyword list を返しています
- 生成したアプリケーションが Erlang VM 内で`:myapp`という名前を持つよう、`app: :myapp`という項目で名前を定義しています

---

- 次に`lib/myapp.ex`を見てみます

```elixir
defmodule Myapp do
  @moduledoc """
  Documentation for Myapp.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Myapp.hello()
      :world

  """
  def hello do
    :world
  end
end
```

- デフォルトでは、`lib/`以下のファイルが主たるソースコードとなります。今は`lib/myapp.ex`のみ
  - ここにあなたのアプリケーションで実行したい内容を実装していきます
- プロジェクトで実装しているコードを`iex`から試してみたい場合は、プロジェクトのディレクトリ内で`iex -S mix`を実行します。
  そのプロジェクトのモジュールがすべて REPL から利用できる状態で`iex`が立ち上がります

---

### 初めてのテスト

- 試しにこのプログラムを実行してみたくなったとき、どうしたらいいでしょうか。
  `iex -S mix`で手動で試してもいいのですが、繰り返し実行しやすい形がいいですね
  - まだこのプログラムは、ターミナルで対話的に何かを処理するとか、
    HTTP リクエストを処理するだとかいったリッチな機能は何一つ実装されていません
  - あるのは`Myapp.hello/0`だけです
- このように、アプリケーションの一部だけしかまだ実装していない、
  あるいは開発しているのはライブラリパッケージであって、別のアプリケーションに組み込まれないと機能を果たさない、
  といった状況でも、**実装されている細かな単位だけ実行しながら挙動を確かめられる**、便利な環境、ツールがあります
- それが**テスト; test**です。`mix test`で実行できます

```
$ mix test
Compiling 1 file (.ex)
Generated myapp app
..

Finished in 0.04 seconds
2 tests, 0 failures

Randomized with seed 285458
```

---

- 「2 つのテストが実行された」ようですが、一体何を実行したのでしょうか。
  テストファイルを見てみましょう。`test/myapp_test.exs`です

```elixir
defmodule MyappTest do
  use ExUnit.Case
  doctest Myapp

  test "greets the world" do
    assert Myapp.hello() == :world
  end
end
```

- `test "greets the world" do`の行は、専用の構文のようにも見えますが、実は`test/2`というマクロです
  - Elixir ではこのようにマクロを使って DSL を作ることができます
    - ただしやりすぎるとユーザにとってはかえってわかりにくいので乱用は禁物です
  - マクロも関数と同様に`test/2`などと表します
  - Elixir の関数やマクロは`()`を省略することができ、ここでも省略されています
    - 一般に、関数では省略しません。DSL 的に用いられるマクロでは省略することもあります
- この`test/2`の場合、第一引数は`"greets the world"`で、第二引数には`do ... end`までのブロックが入っています
  - 第一引数はテストの説明、
  - 第二引数は、実際に実行して欲しいコードをそのまま書くだけです！
- もう一つのテストは、実は`doctest Myapp`という行で指示されています

  - これは`Myapp` module の定義ファイル中のソースコードドキュメント内に、
    決まった形式で書かれた実行可能なコードが書かれている場合、それを実行して結果を確かめます
  - 該当箇所はこの部分です

    ```
    iex> Myapp.hello
    :world
    ```

---

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

- "1 failure"となりました。doctest の方は書き換えていないので成功しています
- 書き換えた方は、「実装は`:world`を返すのに、」「テストコードは`:goodbye`を期待している」ため、失敗しています
- 失敗した場合、どのような状況だったのかを教えてくれることもわかりました
- テストはこのように、 **あなたの Elixir プログラムを簡単に、かつ繰り返し何度でも実行させられる、手軽で安全な環境、心強い味方** です
