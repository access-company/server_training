## 環境構築

- 環境構築できていることを確認します。所要時間: 5 分未満
- もし準備が行き届いていなければ時間を取ります。〜20 分程度

---

- **以下ハンズオンの際、準備を済ませてあることを期待します**
- 社内的には、[asdf](https://github.com/asdf-vm/asdf)を使うことを推奨しています
  - asdf について詳細は[公式ガイド](https://asdf-vm.com/#/core-manage-asdf-vm)参照
- Erlang 20.3.8.25 と Elixir 1.9.4 をインストールしておきましょう(2020/04)

### 念のため: 大雑把な手順

- (Bash 系を想定)

```
$ git clone https://github.com/asdf-vm/asdf.git ~/.asdf
$ source ~/.asdf/asdf.sh
$ brew coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc wxmac unzip curl
$ asdf plugin-add erlang
$ asdf plugin-add elixir
$ asdf install erlang x.y.z && asdf global erlang x.y.z
(ここ、それなりに時間がかかるはず)
$ asdf install elixir i.j.k && asdf global elixir i.j.k
```

- openssl 等は必須となります。忘れがちなので注意！

  - openssl なしで Erlang をインストールしてしまい、あとから`ssl`関連のエラーが発生した場合は Erlang を再インストールして下さい

    ```
    $ brew coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc wxmac unzip curl
    $ asdf uninstall erlang x.y.z
    $ asdf install erlang x.y.z
    ```

## ターミナル、エディタ

- ターミナルは macOS 標準の Terminal.app で最初は十分です
  - 個人的なおすすめは分割表示などが柔軟にできる[iTerm2](https://www.iterm2.com/)です
- なんでもいいので、テキストエディタを用意しておきましょう
  - はじめは Elixir のシンタックスハイライトがあったほうがいいかもしれません
