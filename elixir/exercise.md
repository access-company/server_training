# 練習問題

## 1. Enum, Stream, Recursion

### 1-1. I wanna be the Euler (easy)

フィボナッチ数列のうち、3,000,000 以下でかつ3の倍数であるものの総和を求めよ。

### 1-2. Make fun of boring CSV work (normal)

1. 各行が 0 以上 65,535 以下のランダムな4つの整数からなる、100万行のCSVファイルを作れ。
2. 上記のCSVファイルに登場する `101` を `lOl` に変換した新しいCSVファイルを作れ。

### 1-3. Prime stream (hard)

1. 素数のストリームを作れ。
2. 隣り合う素数で差が30であるようなもののうち最小の組を求めよ。

extra. 隣り合う素数で差が100であるようなもののうち最小の組を求めよ。

### 1-4. Tail recursion (easy)

自然数 `n` を引数にとり、 `n` の階乗を求める関数を末尾再帰な再帰関数として実装し、200の階乗を求めよ。

### 1-5. Collatz (easy)

自然数 `n` に対し、最初に1になるまでに[コラッツ関数](https://www.wikiwand.com/en/Collatz_conjecture)が何回適用されるかを求める関数を作り、6,171にその関数を適用せよ。

## 2. Process and concurrency

### 2-1. Programmer's manner (normal)

以下の条件を満たす key-value store を process として実装せよ。

- `{:put, key, value}` というメッセージを受け取ったら `key` をキーとする箇所の値を `value` に置き換える
- `{:get, key, caller}` というメッセージを同じ `key` に対して3回受け取ったら `key` をキーとする箇所の値を `caller` にメッセージとして投げる。
  - 1回目、2回目にこのメッセージを受け取った際は `nil` をメッセージとして投げる
  - 4回目以降は3回目と同様にそのキーの箇所の値をメッセージとして投げる

### 2-2. Make it crash (normal)

atom を動的に大量に作ることで、10秒以内に ErlangVM を crash させよ。

(`erl_crash.dump` の生成には時間がかかるが、その時間は crash した後なので考慮に入れなくてよい)

### 2-3. Sleep sort (hard)

スリープソートを実装し、 `shuffled = Enum.shuffle(1..300)` をソートせよ。

※スリープソートとは、各要素に対してその値の大きさに比例した時間スリープした後に append するという方法で配列(今回はリスト)をソートするアルゴリズムの俗称である。
