## 発展: パッケージの導入

- 時間が余ったら触れる予定

---

- `mix`は、プロジェクトが依存するライブラリパッケージの管理も担当してくれます
  - Ruby でいうところの bundler のようなモノです。rubygems に当たるのが hex です
- 試しにパッケージを一つ導入してみましょう
- ここでは、コードに変更があった場合に自動でテストを実行する[`mix test.watch`](https://github.com/lpil/mix-test.watch)というツールを導入してみます
- `mix.exs`を編集しましょう

```diff
diff --git a/myapp/mix.exs b/myapp/mix.exs
index 881a5a9..d5b8dd5 100644
--- a/myapp/mix.exs
+++ b/myapp/mix.exs
@@ -21,7 +21,7 @@ defmodule Myapp.Mixfile do
   # Run "mix help deps" to learn about dependencies.
   defp deps do
     [
-      # {:dep_from_hexpm, "~> 0.3.0"},
+      {:mix_test_watch, "0.6.0", [only: :dev, runtime: false]},
       # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
     ]
   end
```

- 保存して、ターミナルから以下のコマンドを実行します
  - `[only: :dev, runtime: false]`というおまじないは、コンパイル時環境変数によって導入したパッケージの挙動を制御するものです
  - もし興味が湧いたら、[こちらから](https://hexdocs.pm/mix/Mix.Tasks.Deps.html)

```
$ mix deps.get
Resolving Hex dependencies...
Dependency resolution completed:
  file_system 0.2.4
  mix_test_watch 0.6.0
* Getting mix_test_watch (Hex package)
* Getting file_system (Hex package)
```

- `mix deps.get`がプロジェクトが依存するパッケージを取得してくるコマンドになります
  - 直接指定した`mix_test_watch`だけでなく、間接的に依存することになった`file_system`というパッケージも取得されたことがわかります
  - このような依存性ツリーの解決を`mix`が担当してくれます
- `deps/`ディレクトリ以下にコードが取得されてくるとともに、`mix.lock`ファイルが生成されます
- `mix.lock`ファイルはすべての依存パッケージの具体的なバージョンが記録されます。**このファイルはコミットしておきましょう**
  - 次回以降は、あるいは別の環境でこのプロジェクトを clone して開発する場合は、
    `mix.lock`に記録されているバージョンを取得することになるので、開発者間でパッケージバージョンが異なる、といった問題も防げます

---

- ちなみに、`mix test.watch`と実行してみましょう

```
$ mix test.watch

03:29:38.724 [info]  Compiling file system watcher for Mac...

03:29:40.163 [info]  Done.
==> file_system
Compiling 7 files (.ex)
Generated file_system app
==> mix_test_watch
Compiling 12 files (.ex)
Generated mix_test_watch app

Running tests...
==> file_system
Compiling 7 files (.ex)
Generated file_system app
==> mix_test_watch
Compiling 12 files (.ex)
Generated mix_test_watch app
==> myapp
Compiling 1 file (.ex)
Generated myapp app
..

Finished in 0.03 seconds
2 tests, 0 failures

Randomized with seed 181121

```

- 依存パッケージがすべてコンパイルされたあと、テストが実行され、そのままプログラムが実行されたままになることがわかります
- この状態で、エディタ上でプロジェクトの何らかのファイルを編集・保存すると、
  その変更を検知して自動でテストが再実行されます
  - 便利ですのでこのまま利用してみても良いでしょう
  - このような、変更検知＆自動ビルド・テスト実行を行うツールはいろいろな言語に存在します
