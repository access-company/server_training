## 環境構築

- **ハンズオンの際、すでに済ませてあることを期待します**
- 社内的には、[asdf](https://github.com/asdf-vm/asdf)を使うことを推奨しています
- Erlang 20.2.2とElixir 1.5.3をインストールしておきましょう(2018/05)

### 念のため: 大雑把な手順

- (Bash系を想定)

```
$ git clone https://github.com/asdf-vm/asdf.git ~/.asdf
$ source ~/.asdf/asdf.sh
$ asdf plugin-add erlang
$ asdf plugin-add elixir
$ asdf install erlang x.y.z && asdf global erlang x.y.z
(ここ、それなりに時間がかかるはず)
$ asdf install elixir i.j.k && asdf global elixir i.j.k
```

## ターミナル、エディタ

- ターミナルはmacOS標準のTerminal.appで最初は十分です
- なんでもいいので、テキストエディタを用意しておきましょう
    - はじめはElixirのシンタックスハイライトがあったほうがいいかもしれません
