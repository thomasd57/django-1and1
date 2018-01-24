#!/bin/bash

# This script build python 3.6.3 with openssl and sqlite3

function print_usage {
    echo 'Usage: build-python.sh [-b <build_dir>] [-i <install_dir>] [-S] [-Q] [-h]
    -i <install_dir>    : installation directory, default ./install
    -b <build_dir>      : build directory, default ./build
    -S                  : skip building SSL (already done)
    -Q                  : skip building SQLITE3 (already done)
'
    exit
}

here=$PWD
build=build
install=install

while getopts :b:i:SQh opt; do
    case $opt in
        b)  build=$OPTARG ;;
        i)  install=$OPTARG ;;
        S)  skip_ssl=1 ;;
        Q)  skip_sqlite=1 ;;
        h)  print_usage ;;
        \?) echo "Invalid option: -$OPTARG" >&2 ;;
    esac
done

install=$(realpath $install)
mkdir -p $install
build=$(realpath $build)
mkdir -p $build
cd $build

openssl=openssl-1.1.0e
sqlite=sqlite-autoconf-3220000
python=Python-3.6.3

# openssl
[ $skip_ssl = 1 ] || (
    wget https://www.openssl.org/source/old/1.1.0/$openssl.tar.gz
    rm -rf $openssl
    tar -zxf $openssl.tar.gz
    cd openssl-1.1.0e
    config --prefix=$install/$openssl
    make
    make install
) |& tee openssl.log

# sqlite3
[ $skip_sqlite = 1 ] || (
    wget https://sqlite.org/2018/$sqlite.tar.gz
    rm -rf $sqlite
    tar -zxf $sqlite.tar.gz
    cd $sqlite
    configure --prefix=$install/$sqlite
    make
    make install
) |& tee sqlite3.log

# python3.6.3
(
    wget https://www.python.org/ftp/python/3.6.3/$python.tgz
    rm -rf $python
    tar -zxf $python.tgz
    cd $python
    export SSL_DIR=$install/$openssl
    export SQLITE_DIR=$install/$sqlite
    patch setup.py $here/setup.py.patch
    ln -s $install/$openssl/include/openssl
    configure --prefix=$install/python3.6.3
    make
    make install
) |& tee python.log
