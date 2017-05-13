# 有志による Rescale 取扱説明書

## マニュアルページ

下記よりアクセスできます。

- https://daikumatan.github.io/_build/html/


## document 作成に参加するには?

### Sphinx 環境の構築

ソースをcloneします。

```
git clone https://github.com/daikumatan/daikumatan.github.io
```

ディレクトリーを移動します。

```
cd daikumatan.github.io
```

Sphinx環境を `docker build` コマンド で構築します。

```
docker build -t my-Rescale-doc .
```

<!--
`docker run` にて　Sphinx のオートビルドが有効になります。Sphinxのソース変更に伴い、自動的にwebpageもmakeされます。

```
docker run -t -v $(pwd):/sphinx rescale-cli-sphinx
```
-->

### Sphinxによるドキュメントのbuild

コンテナーを起動し、ログインします。

```
docker run -it -v $(pwd):/sphinx my-Rescale-doc /bin/bash
```

ここからは docker container 内でのコマンド実行です。
HOSTのディレクトリーをマウントしている sphinx ディレクトリーに移動します。

```
cd /sphinx
```

sphinx で追加/修正した Document を auto-build するために下記スクリプトを実行します。

```
./autobuild_on_docker.sh
```
