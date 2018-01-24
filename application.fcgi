#!/kunden/homepages/32/d377917679/htdocs/.virtualenv/django/bin/python

import os
import sys
import traceback

home = '/kunden/homepages/32/d377917679/htdocs'
try:
    os.environ['VIRTUAL_ENV'] = os.path.join(home, '.virtualenv/django/bin')
    os.environ['PATH'] = os.environ['VIRTUAL_ENV'] + ':' + os.environ['PATH']

    project = os.path.join(home, 'site/test')
    # Add a custom Python path.
    sys.path.insert(0, project)

    # Switch to the directory of your project.
    os.chdir(project)

    # Set the DJANGO_SETTINGS_MODULE environment variable.
    os.environ['DJANGO_SETTINGS_MODULE'] = "polls.settings"

    from django_fastcgi.servers.fastcgi import runfastcgi
    from django.core.servers.basehttp import get_internal_wsgi_application

    wsgi_application = get_internal_wsgi_application()
    runfastcgi(wsgi_application, method="prefork", daemonize="false", minspare=1, maxspare=1, maxchildren=1)
except:
    with open(os.path.join(home, 'tmp/error.log'), 'w') as fp:
        traceback.print_exc(file = fp)
