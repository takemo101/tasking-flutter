# ビルドに必要なファイルを展開します。
.PHONY: setup
setup:
	cp ./.example.env ./.env
	cp ./bundle.stab ./bundle.sh

#### for android ####

# Androidアプリに必要なキーストアファイルを生成します。
# ツールの指示に従って情報を入力してください。
.PHONY: create-android-key
create-android-key:
	keytool -genkey -v -keystore ./key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key -storetype JKS
	mv ./key.jks ./android/


# Androidアプリのリリースに必要なaabファイルを生成します。
.PHONY: create-app-bundle
create-app-bundle:
	rm ./app.aab
	flutter build appbundle
	cp ./build/app/outputs/bundle/release/app-release.aab ./app.aab


# リリースのためのaabファイルをスマホにインストールします。
# bundletoolを利用するので事前にインストールする必要があります。
# bundle.shを実行するのですが、
# 設定が必要になるのでREADMEを参照しながら設定してください。
.PHONY: install-app-bundle
install-app-bundle:
	chmod +x bundle.sh
	flutter build appbundle
	./bundle.sh

#### for test ####

# ./lib/module以下のテストを全て実行します。
.PHONY: test-module
test-module:
	flutter test ./lib/module
