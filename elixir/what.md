## Elixir とは

- レッツゴー公式 => https://elixir-lang.org/

> Elixir is a dynamic, functional language designed for building scalable and maintainable applications.

- 動的型付け
- 関数型
- [Scalable][dist]なアプリケーションを書ける
- [Maintainable](https://skirino.github.io/slides/advice_for_new_graduates.html)なアプリケーションを書ける
- [José Valim](https://github.com/josevalim)が創始者。Plataformatec社が中心的にサポートしている

[dist]: ../basics/distribution.html

> Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain.

- [Erlang VM](http://www.erlang.org/)を活用する
- 低遅延で、
- [分散された][dist]、
- 障害耐性を持ったシステムを実行できるVM
- Ericsson社が開発し、1998年からOSS

---

### Erlangとの **相互運用性; interoperability**

- ElixirプログラムはErlang VM(BEAM)用のバイトコード(.beamファイル)にコンパイルされ、Erlang VMで実行される
- コンパイルされたbeamファイルはErlang由来のものと同等で、同時に組み合わせて実行できる
- Erlang VMではコードの管理単位は **module** というが、ElixirプログラムからErlangのmoduleを呼び出したりすることも可能
- 似たような関係性を持つ言語やVMはほかにもある
    - 例) ScalaプログラムはJVM向けにコンパイルされ、Javaプログラムと組み合わせて実行できる

---

### その他の言語的特徴

- 文法の見た目は多少Rubyに似ているが、**似ているだけ**
- 強力なパターンマッチ構文
- Erlang VMをそのまま使うので、Erlang VMの特長を受け継ぐ
    - 軽量プロセス
    - メッセージパッシング
    - OTP(軽量プロセスの階層構造、クラッシュの局所化、自動復旧機構)
    - 分散コンピューティング
- コンパイル時にコード自動生成など、様々な処理を行える環境が整っている(metaprogramming)

---

### ツールチェーン

- 言語同梱ツール
    - `mix` - ビルドツール兼タスクランナー
    - `iex` - REPL
    - `ex_unit` - テストライブラリ
- hex.pm - パッケージ管理
- `ex_doc` - ドキュメント生成ツール
    - hexdocs.pm - オンラインドキュメント
