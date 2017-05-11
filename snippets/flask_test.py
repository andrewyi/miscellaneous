# -*- python3 sources -*-
'''
andrew's test examples

'''

import sys
import logging


logger = logging.getLogger()

from app import create_app
app_for_test = create_app('development')
test_client = app_for_test.test_client()


def test_something():
    resp = test_client.get('/health')
    logger.error(resp.status)
    logger.error(resp.data)
    assert resp.data == b'OK'


def login_employee(employee_id):
    with test_client.session_transaction() as session:

        from flask.testing import make_test_environ_builder
        builder = make_test_environ_builder(app_for_test)
        ctx = app_for_test.request_context(builder.get_environ())
        ctx.push()
        ctx.session = session

        from app.models import Employee
        e = Employee.query.get(employee_id)
        assert e
        from flask_login import login_user
        login_user(e)
        logger.warning('login user e: %s/%s.', e.id, e.name)

        builder.close()
        ctx.auto_pop(None)


def main():
    test_client.__enter__()

    t = v = b = None
    try:
        logger.debug('test start.')
        login_employee(1)

        # TODO test code goes here
        test_something()

    except:
        logger.exception('test exception meet.')
        t, v, b = sys.exc_info()
    finally:
        logger.debug('test finished.')
        test_client.__exit__(t, v, b)


if __name__ == '__main__':
    sys.exit(main())
