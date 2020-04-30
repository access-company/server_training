## 文法基礎

- このページの目標
  - 文法を学ぶための学習資料を把握する
  - `iex`で Elixir の文法や機能を試せるようになる
  - 基本的な値の種類とその表現を知り、読み書きできるようになる
- 所要時間: 15 分程度(`iex`を自由に触ってもらう時間を含む)

---

### 学習資料

- 文法は以下を教科書としましょう
  - [Official Introduction](https://elixir-lang.org/getting-started/introduction.html)
    - このガイドを抜粋して説明していきます
  - [Elixir School](https://elixirschool.com/ja/lessons/basics/basics/) (日本語あり)
  - Elixir 標準ライブラリの[API References](https://hexdocs.pm/elixir/api-reference.html)
  - 書籍では、[『プログラミング Elixir』](https://www.amazon.co.jp/dp/B01KFCXP04)が標準解説書です
    -  リンクは日本語翻訳版で、Elixir 1.4 くらいに準拠していたと思います。少し古いですがメジャーバージョンは同じなので文法はほぼ共通です
    - 社内にも何冊かあります。必要だと思ったら配属時に課長に言いましょう(図書費という予算がちゃんとあるので、たいていすぐ買えます)
- 本文書では特に抑えてほしい部分だけ明示していきます
- サーバ実習ではまとまった文量の Elixir コードを書く時間が確保してあるので、
  **今の段階で文法をすべて把握できなくても OK**
- むしろツールチェーンの利用方法、全体的なワークフローを抑えてください

---

### REPL: `iex`

- まず Elixir の REPL である`iex`を起動してみましょう。ターミナルを開いて、`iex`と入力します

```
$ iex
Erlang/OTP 20 [erts-9.3.3.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.9.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

- **[確認]** これが出来ない場合、インストールがうまくいっていません。時間をとるので確認します
- REPL は"Read-Eval-Print-Loop"の略で、入力されたコードをコンパイラと処理系(Elixir の場合 Erlang VM)が都度評価、結果を返す、という動作を繰り返します
  - 他の言語にもよくあります
- 一般的には文法のテストやちょっとした動作確認などに使うことが多いです
  - 一部の言語では REPL での評価を中心に開発するものもあったりします
- 最後の方で、本格的なアプリケーションプロジェクトを立ち上げる方法も解説しますが、まずは`iex`で文法等を試していきましょう
- REPL を終了させるには、`Ctrl + c`を**2 回**入力します

---

### 基本的な値

資料: [Basic types - Elixir](https://elixir-lang.org/getting-started/basic-types.html)

- 基本的な値の種類(型)は以下

```elixir
iex> 1          # integer
iex> 0x1F       # integer
iex> 1.0        # float
iex> true       # boolean
iex> :atom      # atom / symbol
iex> "elixir"   # string
iex> [1, 2, 3]  # list
iex> {1, 2, 3}  # tuple
```

- 適当に`iex`に打ち込んでみてください
- 文法(記号)を間違えると`iex`がどう反応するかも見てみてください
- 他の言語にないかもしれないものを以下解説します

---

- **Atom; アトム** は、`:`から始まる名前付きの値で、実体が VM 内でただ 1 つである、という特徴があります
- コンパイル時(コーディング時)に定まっている何らかの定数を表現するのに使うことが多いです
- 実体がただ 1 つなので、同じ Atom をプログラム内の複数箇所で使っても値はコピーされず、既存の Atom に対する参照のみが増えます
- 一度生成された Atom は VM から消えません(Garbage Collect されない)
  - よって動的に Atom を生成するべきではありません。動的な値には **String; 文字列** を使います

---

- **Tuple; タプル** は複数の値を組み合わせた値です
- 組み合わせる値の種類(型)は何でも構いません。組み合わせる数もいくつでも構いません
- ただし **List; リスト** と違って、「組み合わせ方」つまり tuple の長さはコンパイル時(コーディング時)に定めます。
  言い換えると、プログラマが何らかの「意味のある組み合わせ」を表現するために使うものです
  - 例えば float を 2 つ組み合わせて「座標」を表現したり
- 逆に、1 つの種類(型)の値がとにかく 0 個以上存在し、その数が実行時に増えたり減ったりする場合、List を使います

---

- コンパイル時(コーディング時)に性質(サイズや内容)を定める値か、実行時にそれらが変化しうる値か、
  という点はどんな言語でも意識する必要のあることですので覚えておきましょう

---

### 関数(無名関数)

資料: [Anonymous Functions](https://elixir-lang.org/getting-started/basic-types.html#anonymous-functions)

- 関数には、どこでも書ける無名関数; anonymous function と、モジュール; module に所属させる必要がある名前付き関数; named function があります
- REPL では無名関数をさっと試せます

```elixir
iex> add = fn a, b -> a + b end
#Function<12.71889879/2 in :erl_eval.expr/5>
iex> add.(1, 2)
3
```

- `fn` ~ `->` ~ `end`という文法です
  - 引数部分は`()`をつけてもつけなくてもいいことになっています。つまり`fn(a, b) -> a + b end`とも書けます
  - `#Function<12.71889879/2 in :erl_eval.expr/5>`などと言われていますが、識別用のハッシュ値を与えられた無名関数であるということです
  - `/2`というのは Erlang/Elixir の関数を指し示すときに使う表記法です。`/`のあとに引数の数を付けます
- 変数に束縛し、呼び出すことが出来ます
  - (おまけクイズ) 変数に束縛しないで呼び出すことも出来ます。どう書くでしょう？
- 無名関数を呼び出すのは`.()`というちょっと特徴的な文法になっています
  - 名前付き関数呼び出しの`()`を省略できるという Elixir の文法機能から生じる曖昧性を回避するための措置です
- 引数名さえも省略する書き方もあります

```elixir
iex> fun = &(&1 + 1)
#Function<6.71889879/1 in :erl_eval.expr/5>
iex> fun.(1)
2
```

- `&()`で  囲み、引数は`&n`で 1 から順に参照します。あとで高階関数の話が出てきますが、そこでこの省略記法を使うことがあります

---

- いろいろ作って遊んでみましょう
- 名前付き関数とモジュールについては後で触れます

---

### 演算子; Operators

資料: [Basic operators - Elixir](https://elixir-lang.org/getting-started/basic-operators.html)

- すでに`+`が上の例ででてきていますが、演算子(中置演算子; infix operators)があります
- リストの結合

```elixir
iex> [1, 2, 3] ++ [4, 5, 6]
[1, 2, 3, 4, 5, 6]
```

- 文字列の連結

```elixir
iex> "foo" <> "bar"
"foobar"
```

- 中置演算子も実体は関数で、ドキュメントでは[`++/2`](https://hexdocs.pm/elixir/Kernel.html#++/2)のように参照します
