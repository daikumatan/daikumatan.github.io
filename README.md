# Rescale CLI 虎の巻 (工事中)

# マニュアルページ

下記よりアクセスできます。

- https://daikumatan.github.io/_build/html/


# 環境の構築

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
docker build -t rescale-cli-sphinx .
```

`docker run` にて　Sphinx のオートビルドが有効になります。Sphinxのソース変更に伴い、自動的にwebpageもmakeされます。

```
docker run -t -v $(pwd):/sphinx rescale-cli-sphinx
```

コンテナー内に入りたいときは下記を実行します。

```
docker run -it -v $(pwd):/sphinx rescale-cli-sphinx /bin/bash
```
