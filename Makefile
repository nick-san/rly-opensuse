# mkosi のラッパー Makefile

# mkosi コマンドの実行に sudo を使用する
SUDO = sudo

# mkosi 実行ファイル名
MKOSI = mkosi

# mkosi に常に渡す共通オプション
# 前回の問題を解決するため --tools-tree=default を設定
MKOSI_OPTS = --tools-tree=default

# .PHONY でファイル名とターゲット名が衝突するのを防ぐ
.PHONY: all build vm shell boot clean distclean

# デフォルトターゲット (make とだけ打った時に実行)
all: build

# 'make build' - イメージをビルドする
build:
	$(SUDO) $(MKOSI) $(MKOSI_OPTS) build

# 'make vm' - イメージを QEMU (VM) で起動する
vm:
	$(SUDO) $(MKOSI) $(MKOSI_OPTS) vm

# 'make shell' - イメージ内でシェルを起動する (systemd-nspawn)
shell:
	$(SUDO) $(MKOSI) $(MKOSI_OPTS) shell

# 'make boot' - イメージを systemd-nspawn で起動する
boot:
	$(SUDO) $(MKOSI) $(MKOSI_OPTS) boot

# 'make clean' - ビルド成果物（イメージファイルなど）を削除する
clean:
	$(SUDO) $(MKOSI) $(MKOSI_OPTS) clean

# 'make distclean' - 成果物、インクリメンタルキャッシュ、パッケージキャッシュをすべて削除する
distclean:
	$(SUDO) $(MKOSI) $(MKOSI_OPTS) clean -ff
