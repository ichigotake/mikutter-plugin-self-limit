# mikutter 自己規制プラグイン

TwitterAPIの制限とは関係無しに独自の規制ルールを設定するmikutterプラグイン

## DESCRIPTION

TwitterのAPI規制の様に、自分の発言を規制するプラグインです

1ツイートをする度にカウントが1ずつ増えていきます
カウントが「規制ツイート数」に達すると発言ができなくなります
ただし、規制されるのは「Ctrl + Enter」等の、ショートカットキーによるポストのみです

ツイートボタンによるツイートは規制に関与しません
(どうしても対応したい時などに利用出来る抜け穴です)

Twitterに夢中になりすぎないようにするための「目安」としてご利用ください！


## INSTALL

プラグインディレクトリにダウンロード

    $ git clone git://github.com/ichigotake/mikutter-plugin-self-limit.git ~/.mikutter/plugin/self_limit


## CONFIGURATION

起動した後に設定画面を開いて「自己規制」から各種設定ができます


## ISSUES

https://github.com/ichigotake/mikutter-plugin-self-limit/issues

## SEE ALSO

[mikutter](http://mikutter.hachune.net/)


## AUTHOER

[@ichigotake](https://twitter.com/ichigotake)


