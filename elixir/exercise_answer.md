# 練習問題解答

そのまま iex にコピペして動くように行末に `\` を挿入してある。

### 1-1. I wanna be the Euler (easy)

<details>
<summary>解答例</summary>
<p>

```elixir
Stream.unfold({0, 1}, fn {n1, n2} -> {n1, {n2, n1 + n2}} end) \
|> Stream.filter(fn n -> rem(n, 3) == 0 end) \
|> Stream.take_while(fn n -> n <= 3_000_000 end) \
|> Enum.sum()
# => 2550408
```

</p>
</details>

### 1-2. Make fun of boring CSV work (normal)

実際の業務でもCSVを扱うことが割とある。

<details><summary>1.</summary>
<p>
100万行なのでそこそこ時間がかかる。

```elixir
Stream.repeatedly(fn -> :rand.uniform(65_536) - 1 end) \
|> Stream.chunk_every(4) \
|> Stream.take(1_000_000) \
|> Stream.map(fn values_list -> Enum.join(values_list, ",") <> "\n" end) \
|> Stream.into(File.stream!("numbers.csv")) \
|> Stream.run()
```

出来たファイルは巨大なので、中身を確認したいときはエディタで開くのではなく `less` や `more` 等のコマンドを使うと良い。

</p>
</details>

<details><summary>2.</summary>
<p>
 `File.stream!` はその扱い方でよしなに read/write が決まってくれるので便利。最後の `Stream.run/1` を忘れずに。

```elixir
File.stream!("numbers.csv") \
|> Stream.map(&Regex.replace(~R/101/, &1, "lOl")) \
|> Stream.into(File.stream!("lols.csv")) \
|> Stream.run()
```

</p>
</details>

### 1-3. Prime stream (hard)

<details><summary>1.</summary>
<p>
 `Stream.unfold/2` でストリームを作っていく。各要素をリストにしてその後 `Stream.flat_map/2` することでフィルタリングを実現する。

その昔 `Enum.filter_map/3` という、その名の通り filter しつつ map する関数があったが 「`Enum.flat_map/2` を使え」ということで無くなった。

```elixir
Stream.unfold({2, []}, fn {candidate, primes} ->
  if Enum.any?(primes, fn prime -> rem(candidate, prime) == 0 end) do
    {[], {candidate + 1, primes}}
  else
    {[candidate], {candidate + 1, primes ++ [candidate]}}
  end
end) \
|> Stream.flat_map(&(&1))
```

</p>
</details>

<details><summary>2.</summary>
<p>
上記のストリームを使うため `v(-1)` とする(iex で直前の実行結果を参照する)

```elixir
v(-1) \
|> Stream.chunk_every(2, 1) \
|> Enum.find(fn [p1, p2] -> p2 - p1 === 30 end)
```

</p>
</details>

<details><summary>extra.</summary>
<p>
上記の安直なストリームでは遅すぎて話にならない。

`candidate` の平方根までの素数だけ調べれば良いのと、1ずつ足していくのではなく5から始めて2,4を交互に足していくことである程度枝刈りが出来る:

```elixir
Stream.unfold({5, [2, 3], 2}, fn {candidate, primes, added} ->
  sqrt = :math.sqrt(candidate)
  primes
  |> Stream.take_while(fn prime -> prime < sqrt end)
  |> Enum.any?(fn prime -> rem(candidate, prime) == 0 end)
  |> if do
    {[], {candidate + added, primes, 4 - added}}
  else
    {[candidate], {candidate + added, primes ++ [candidate], 4 - added}}
  end
end) \
|> Stream.flat_map(&(&1)) \
|> Stream.chunk_every(2, 1) \
|> Enum.find(fn [p1, p2] -> p2 - p1 === 100 end)
# => [396733, 396833]
```

これでも30秒くらいかかってしまう。

</p>
</details>

### 1-4. Tail recursion (easy)

<details><summary>解答例・解説</summary>
<p>

```elixir
defmodule Factory do
  def fact(n), do: fact(n, 1)

  defp fact(1, acc), do: acc
  defp fact(n, acc), do: fact(n - 1, acc * n)
end

Factory.fact(200)
# => 788657867364790503552363213932185062295135977687173263294742533244359449963403342920304284011984623904177212138919638830257642790242637105061926624952829931113462857270763317237396988943922445621451664240254033291864131227428294853277524242407573903240321257405579568660226031904170324062351700858796178922222789623703897374720000000000000000000000000000000000000000000000000
```

引数のデフォルト値を使っても良いが、このように再帰の中身を別の private function にすると見通しが良くなる(今回は無いが、`Enum.reverse` などの前処理/後処理を分離することも少なくない)。

Elixir(に限らず大抵のモダンな言語)はシームレスに多倍長整数が扱える。

</p>
</details>

### 1-5. Collatz (easy)

<details><summary>解答例・解説</summary>
<p>

```elixir
defmodule Collatz do
  def count(n), do: count(n, 0)

  defp count(1, acc),                     do: acc
  defp count(n, acc) when rem(n, 2) == 0, do: count(div(n, 2), acc + 1)
  defp count(n, acc),                     do: count(3 * n + 1, acc + 1)
end

Collatz.count(6_171)
# => 261
```

`n / 2` と書きたくなるが、それだと結果が `Float` になってしまいNG。したがって `div` を使う。

</p>
</details>

### 2-1. Programmer's manner (a bit hard)

<details><summary>解答例・解説</summary>
<p>
本来なら `GenServer` を使いたいところだが、出題した時点でまだ読んでないと思うので `spawn` で頑張る。

`%{key => {value, count}}` という状態を持たせれば良い。

```elixir
defmodule LazyKV do
  def start_link() do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        case Map.fetch(map, key) do
          {:ok, {value, count}} when count < 3 ->
            send(caller, nil)
            loop(Map.put(map, key, {value, count + 1}))
          {:ok, {value, 3}} ->
            send(caller, value)
            loop(map)
          :error ->
            send(caller, nil)
            loop(map)
        end
      {:put, key, new_value} ->
        case Map.fetch(map, key) do
          {:ok, {_old_value, count}} ->
            loop(Map.put(map, key, {new_value, count}))
          :error ->
            loop(Map.put(map, key, {new_value, 0}))
        end
    end
  end
end

{:ok, pid} = LazyKV.start_link()

send(pid, {:get, :foo, self()})
flush()
# nil

send(pid, {:put, :foo, "value"})
send(pid, {:get, :foo, self()})
send(pid, {:get, :foo, self()})
send(pid, {:get, :foo, self()})
send(pid, {:get, :foo, self()})
flush()
# nil
# nil
# nil
# "value"

send(pid, {:put, :foo, "new value"})
send(pid, {:get, :foo, self()})
flush()
# "new value"
```

「仕事を頼まれたら2回は断れ」という格言がある。相手が頼もうとしている仕事は本当は必要じゃないものだったり、もっといいやり方があることが多い。

</p></details>

<details><summary> `GenServer` を使う場合</summary>
<p>

```elixir
defmodule LazyKV do
  use GenServer

  @impl GenServer
  def init(_), do: {:ok, %{}}

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {_, count} = Map.get(state, key, {nil, 1})
    {:noreply, Map.put(state, key, {value, count})}
  end

  @impl GenServer
  def handle_call({:get, key, _}, _, state) do
    case Map.fetch(state, key) do
      {:ok, {value, 3}} ->
        {:reply, value, state}
      {:ok, {value, count}} ->
        {:reply, nil, Map.put(state, key, {value, count + 1})}
      :error ->
        {:reply, nil, state}
    end
  end
end

{:ok, pid} = GenServer.start_link(LazyKV, %{})
GenServer.call(pid, {:get, :foo, self()})
# => nil
GenServer.cast(pid, {:put, :foo, "value"})
# => :ok
GenServer.call(pid, {:get, :foo, self()})
# => nil
GenServer.call(pid, {:get, :foo, self()})
# => nil
GenServer.call(pid, {:get, :foo, self()})
# => "value"
GenServer.call(pid, {:get, :foo, self()})
# => "value"
GenServer.cast(pid, {:put, :foo, "new value"})
# => :ok
GenServer.call(pid, {:get, :foo, self()})
# => "new value"
```

今回は `GenServer` モジュールの関数を直接使っているが、普通はこれらを wrap する関数を `LazyKV` に定義する (`LazyKV.put/2` みたいなイメージ)。

</p>
</details>

### 2-2. Make it crash (normal)

<details><summary>解答例・解説</summary>
<p>

(並列に生成したほうが早いかと思って出題したが、普通に 1 process で繰り返したほうが早かった)

```elixir
Stream.iterate(0, &(&1 + 1)) \
|> Enum.each(fn n -> n |> to_string() |> String.to_atom() end)
```

`String.to_atom/1` はこのように危険な関数なので、実際の案件で使ってはいけないし、使おうとする人をみたら全力で止めなければならない。

</p>
</details>

### 2-3. Sleep sort (normal)

<details><summary>解答例・解説</summary>
<p>

```elixir
defmodule SleepSort do
  @interval 10

  def sort(list) do
    self_pid = self()
    Enum.each(list, fn n ->
      spawn fn -> remind(self_pid, n, n * @interval) end
    end)
    accumulate([])
  end

  defp remind(target, n, time) do
    Process.sleep(time)
    send(target, n)
  end

  defp accumulate(acc) do
    receive do
      n -> accumulate([n | acc])
    after
      @interval * 2 -> Enum.reverse(acc)
    end
  end
end

shuffled = Enum.shuffle(1..300)
SleepSort.sort(shuffled)
```

安直に `n` milliseconds だけ sleep としてしまうとタイミングによっては正しくソートできなくなる。適当な係数を掛けてやると良い。

最後の `receive` しつつリストを作るところが難しいが、再帰関数を使えばこのように実現可能。 `after` の待ち時間も考えどころだが、`@interval * 2` だけ待てば十分。

</p>
</details>
