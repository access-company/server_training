## 文字列と Map; マップ

- このページの目標
  - 文字列の基礎を理解する
  - Map について知り、読み書きできるようになる

---

### 文字列

資料: [Binaries, strings, and charlists - Elixir](https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html)

- 文字列は、Web アプリケーション・プログラミングにおいて最も重要な値の種類です
- どんな言語でも、どこまでいってもついて回ります
- バックエンド、フロントエンドどちらでも登場します
- そして非常に奥の深いテーマなので、実は厳密に理解しようとすると難しいテーマでもあります

---

- Elixir ではダブルクオーテーション`""`で囲った値は String; 文字列です。これが基本です

```elixir
iex> string = "hello"
"hello"
```

- Elixir では、文字列は全て UTF-8 でエンコードされたバイナリ; binary(0 と 1 の羅列)です
  - ただし、Elixir で binary という場合、0 と 1 という値(1 bit)を直接並べて扱うのでなく、8 bits(= 1 byte, 0 から 255 まで)単位の値を並べて扱います
  - Byte 単位以外で区切られた値を扱うことも出来ますが、その場合各桁のサイズなどを明示的に書く必要があり、専用の構文があります
    - 普段あまり使わないので、ここでは触れません。資料のリンク先に紹介されています
- 他のエンコーディングの文字列を扱うことも出来ますが、ライブラリが必要です

---

- 知っている人もいるかもしれませんが、そもそも我々の扱う「文字」は 1 byte には収まらないケースが多いです。漢字など
- ですので 1 文字を表すのに 2 byte 以上を使うことがあります。その場合、隣接する byte 間の関係性を正しく解釈するためのルールが必要です。
  それがエンコーディングと言っているもので、UTF-8 はその 1 つというわけです

```elixir
iex> string = "hełło"
"hełło"
iex> byte_size(string)
7
iex> String.length(string)
5
```

- この例では`ł`という特殊文字が使われており、これは 1 byte には収まらず、2 byte 使っています
- よって`byte_size/1`という標準ライブラリが提供する関数で確認すると、全体の byte サイズとしては 7 になっています
- 一方、`String`モジュールが提供する表示上の文字列長を数える`String.length/1`関数では 5 と表示されます

---

- 実は文字列結合の演算子`<>`は、文字列のパターンマッチにも使えます！

```elixir
iex(1)> "hello " <> target = "hello world"
"hello world"
iex(2)> target
"world"
```

- ただし、List の場合と似て、先頭からのパターンマッチしか出来ないことに注意してください

```
iex(1)> verb <> " world" = "hello world"
** (ArgumentError) the left argument of <> operator inside a match should be always a literal binary as its size can't be verified, got: verb
    (elixir) lib/kernel.ex:1670: Kernel.invalid_concat_left_argument_error/1
    (elixir) lib/kernel.ex:1642: Kernel.wrap_concatenation/3
    (elixir) lib/kernel.ex:1621: Kernel.extract_concatenations/2
    (elixir) expanding macro: Kernel.<>/2
    iex:1: (file)
```

---

- より詳細な説明が資料リンク先にありますので、興味があれば見てみましょう

---

### Map; マップ

資料: [Keyword lists and maps - Elixir](https://elixir-lang.org/getting-started/keywords-and-maps.html)

- プログラミングにおいては、Key-value Store はよく登場します。識別子となる Key と、対応する Value からなるデータ構造です
  - 辞書型と言ったりもします。Key である単語から、Value である意味を引けるという意味で辞書になぞらえたものです
  - 言語によって用語が違います
    - Dict, Dictionary
    - Hash, HashMap, HashDict
    - Associative Array
  - 用語の違いは、説明しやすさのためであったり、内部実装を表現したものであったり、いろいろです
- Elixir では、基本的には**Map; マップ**をこの目的に使用します

```elixir
iex> map = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex> map[:a]
1
iex> map[2]
:b
iex> map[:c]
nil
```

- `%{}`で囲い、`=>`で Key と Value のペアを表します
- 値を読むときは`[]`で Key を指定します
- Atom の Key に対してのみ、`.`で指定することもできます

```elixir
iex> map.a
1
iex> map.c
** (KeyError) key :c not found in: %{2 => :b, :a => 1}
```

- 中身を更新する専用構文が用意されています

```elixir
iex> %{map | 2 => "two"}
%{2 => "two", :a => 1}
```

---

- Map ではどんな値も Key にでき、どんな値も Value にできます
- 1 つの Map 内にある Key は 1 つしか存在できません(Unique key)。あとから違う Value を指定した場合、上書きされます
- コード上の Key の順序は、内部的には維持されません。Key の順序に依存する処理を書いてしまわないよう注意
- Map もパターンマッチできます

```elixir
iex> %{} = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex> %{:a => a} = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex> a
1
iex> %{:c => c} = %{:a => 1, 2 => :b}
** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}
```

- 上記例の 1 行目、`%{}`は、「任意の Map」を意味します。「空の Map」ではないので注意してください
- Key を指定したパターンマッチはできますが、逆引き、つまり Value のみ指定したパターンマッチはできません

```
iex> %{key_with_one => 1} = %{:a => 1, 2 => :b}
** (CompileError) iex:3: cannot use variable key_with_one as map key inside a pattern. Map keys in patterns can only be literals (such as atoms, strings, tuples, etc) or an existing variable matched with the pin operator (such as ^some_var)
    (stdlib) lists.erl:1263: :lists.foldl/3
```

---

- Erlang/Elixir では、Key-Value Store のために keyword list というものも利用されます。資料リンク先には先にこちらが紹介されています
- その名の通り実体としてはリストで、中身が Key と Value を tuple で組み合わせた値になっているものです

```elixir
iex> list = [{:a, 1}, {:b, 2}]
[a: 1, b: 2]
iex> list == [a: 1, b: 2]
true
iex> list[:a]
1
```

- 専用の省略表記が用意されていることが、上の例からわかります
- 値を読む際は、Map 同様`[]`構文が使えます
- Key として Atom が使われている場合のみ、利用できます。というより、
  「**『Atom の Key と、任意の Value を組み合わせた tuple』のリスト**」を keyword list という特別な名前で呼んでいるだけで、通常のリストと特に変わりません
- Map の場合、Key は Unique でしたが、keyword list は単なる list なので Unique とは限りません
- Keyword list は、関数のオプションを指定する場合や、ユーザから REST API 経由で受け取ったパラメータのうち、予め許可したものをリストに納める場合など、
  「Key が予め特定種類に限られている」場合に利用するものです
  - Key も実行時に変化するようなデータを扱う場合は Map を使用しましょう
