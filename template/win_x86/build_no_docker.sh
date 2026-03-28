#!/bin/bash
set -e

# 準備: ビルド用の作業ディレクトリを作成
mkdir -p build_work
cd build_work

# --- 1. Mupen64Plus Core のビルド ---
echo "Building Mupen64Plus Core..."
git clone https://github.com/mupen64plus/mupen64plus-core.git
cd mupen64plus-core
# PATCHESディレクトリは元のリポジトリ構成に合わせて参照
git apply ../../PATCHES/core_256mb.patch
cd projects/unix
# MinGW 32bitを指定してビルド
make all -j$(nproc) OS=MINGW CPU=i686 CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++
cd ../../..

# --- 2. Libretro Core (NX) のビルド ---
echo "Building Libretro Core..."
git clone https://github.com/libretro/mupen64plus-libretro-nx
cd mupen64plus-libretro-nx
git apply ../../PATCHES/ra_256mb.patch
git apply ../../PATCHES/ra_vulnpatch.patch
# LibretroのMakefileは環境変数CC等を見てくれるのでmakeのみで実行
make -j$(nproc) platform=win_x86 CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++
cd ..

echo "Build Complete."
