## モジュールと関数

- このページの目標
  - モジュールと関数について知り、読めるようになる
  - 定義構文を知り、書けるようになる
- 所要時間: 15 分程度
  - ここまで累積で 90 分程度予定(環境構築に時間を取らない場合)

---

### モジュール

資料: [Modules and functions - Elixir](https://elixir-lang.org/getting-started/modules-and-functions.html)

- Elixir では関連する関数をグループ化して**Module; モジュール**として管理します
- グループ化の際には、関心の対象であるデータごとにモジュールを分けることが多いです
  - 例えば文字列を扱う関数群を`String`モジュールで管理する、など
  - これは「**データと、それを扱う関数**」がプログラムのほぼ全てである関数型言語の特性をよく表していると言えます
- `String`モジュールを例に取ると、

```elixir
iex> String.length("hello")
5
```

- 先ほども出てきたものですが、`length/1`が`String`モジュールに属する関数です
- `String`は、実は内部的には単なる Atom です。Atom はこのように Elixir 言語において、標準機能を実現するためにも多く使われています

---

- モジュールは`defmodule`マクロで定義します
  - `defmodule`や、このあと登場する`def`がマクロであるということは、最初はそれほど意識しなくて構いません

```elixir
defmodule Math do
end
```

- `Math`という名前を持ったモジュールがこれで定義されます。中身はまだありません
  - `iex`でも実行可能です

---

### (名前付き)関数

- `String.length/1`のような関数を**名前付き関数; named function**といい、Elixir プログラムの最も標準的な構成要素です
- `def`マクロで、モジュール内に定義します

```elixir
defmodule Math do
  def add(a, b) do
    a + b
  end
end
```

- `iex`でも実行できます。やってみてください
  - すでに`iex`上で`Math`モジュールを定義してあった場合、定義が上書きされます(再定義警告が出ると思います)
- このように定義すると、`Math.add(1, 2)`のように他の場所から呼び出せるようになるわけです
- 複雑な関数の処理を別の関数に分解するようなケースでは、同一モジュール内部からのみ参照可能なプライベート関数; private function を`defp`で定義できます

```elixir
defmodule Math do
  def add(a, b) do
    do_add(a, b)
  end

  defp do_add(a, b) do
      a + b
  end
end
```

---

- 無名関数と名前付き関数の違いは、
  - モジュールに属しているか
  - 呼び出す際の構文が、`name()`か`name.()`か、です
- それ以外はほとんど同様に扱えます。例えば、無名関数と同様、名前付き関数を別名の変数に束縛することもできます

```elixir
iex> sl = &String.length/1
&String.length/1
iex> sl.("hello")
5
```

- 末尾の`/n`はすでに触れましたが、`&`で始めるのが名前付き関数を値として扱う場合の構文です

---

- モジュールと関数を実装していく際には、他のモジュールの関数を利用することも頻繁にあります
  - Elixir では、モジュール名と関数名をフルネームで明記すれば、どこからでも利用可能です
    - 「継承」の概念は存在せず、したがって継承先でのみ使用できる関数(protected)，のような仕組みもありません
  - モジュール名を簡約表記するための`alias`や、マクロを使用可能にするための特別な宣言構文(`require`)などもあります
  - 詳しくは[alias, require, and import - Elixir](https://elixir-lang.org/getting-started/alias-require-and-import.html)参照
- モジュールをコンパイルする際のみに使用する値を格納する、module attribute という専用の仕組みがあり、`@name`で表記されます
  - ソースコードにドキュメントを書く際にも利用されます
  - 詳しくは[Module attributes - Elixir](https://elixir-lang.org/getting-started/module-attributes.html)参照

---

- ここまでで、Elixir コードを読むためのごく基本的な構文要素は紹介できました
- もちろん、省略した細かな内容も多くありますので、以降は公式ガイドを読み進め、検索しながら学んでいってください
  - 研修期間中はどんどん質問しましょう。都度講師が説明を展開するので、他のメンバも共有できます
