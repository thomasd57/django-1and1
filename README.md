# django-1and1
This illustrates how to run django post 1.8 on 1and1 hosting platforms. The major difficulties are 
1. hosting package does not provide root access 
2. installed Apache modules include only fcgi and not wsgi. Support for fcgi was removed from Django 1.8 onward. 
3. default python does not include virtual environment nor pip, making it hard to install packages.

## Python
The build-python.sh script builds python 3.6.3 from sources, adding packages for sqlite3 and openssl and providing venv.

## Django
The old pre-1.8 django fcgi code is however available as standalong package django_fcgi, which in turn depends on flup. Flup is not compatible with python3, but there is a small package flup6 which works fine with django_fcgi and is python 3. 

## Apache
A rewrite rule in .htacess is required to forward all the http requests to django, but it should enhanced to serve statics directly.

## Installation

> build-python.sh
# Modify application.fcgi shebang to point to your python
# create virtual environment
> install/python3.6.3/bin/python3 -m venv venv
> source venv/bin/activate
# Download python packages
> pip -r requirements.txt
# Develop your django application
