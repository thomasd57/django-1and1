#!/bin/bash

# This script build python 3.6.3 with openssl and sqlite3
# Change build and install directories to your liking
mkdir install
install=$(realpath install)
mkdir build
cd build

openssl=openssl-1.1.0e
sqlite=sqlite-autoconf-3220000
python=Python-3.6.3

wget https://www.openssl.org/source/old/1.1.0/$openssl.tar.gz
wget https://sqlite.org/2018/$sqlite.tar.gz
wget https://www.python.org/ftp/python/3.6.3/$python.tgz

# openssl
(
tar -zxvf $openssl.tar.gz
cd openssl-1.1.0e
config --prefix=$install/$openssl
make
make install
) |& tee openssl.log

# sqlite3
(
tar -zxvf $sqlite.tar.gz
cd $sqlite
configure --prefix=$install/$sqlite
make
make install
) |& tee sqlite3.log

# python3.6.3
(
tar -zxvf $python.tgz
cd $python
patch setup.py ../setup.py.patch
ln -s $install/$openssl/include/openssl
configure --prefix=$install/python3.6.3
make
make install
) |& tee python.log

