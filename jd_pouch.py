#!/usr/bin/env python
# -*- encoding: utf8 -*-

import re
import os
import sys
import urllib
import urllib2
import cookielib
import optparse

import time
import random

class JdPouch:

    def __init__(self, username, passwd):
        ''' init urllib and other parameters '''
        if username is None or passwd is None or \
                len(username) == 0 or len(passwd) == 0:
            raise Exception("null login info meet, please set username and passwd.")

        self.username = username
        self.passwd = passwd

        self.cookies = cookielib.CookieJar()
        self.cookieHandler= urllib2.HTTPCookieProcessor(self.cookies)
        self.opener = urllib2.build_opener(self.cookieHandler)
        self.opener.addheaders=[
            ('User-Agent', '''Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 ''' \
            '''(KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36 ''' \
            '''CoolNovo/2.0.9.20'''), 
            ('X-Requested-With', 'XMLHttpRequest')
            ]
        urllib2.install_opener(self.opener)

    @staticmethod
    def _add_request_headers(request, refer_url):
        request.add_header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9")
        request.add_header("Accept-Language", "en,zh-CN,zh;q=0.8,zh;q=0.6")
        request.add_header("Content-Type", "application/x-www-form-urlencoded;")
        request.add_header("Referer", refer_url)
        request.add_header("Origin", refer_url)
        request.add_header("Cache-Control", "no-cache")
        request.add_header("Pragma", "no-cache")

    GATEWAY_LOGIN = '''http://4.4.4.3:8887'''
    ERP_URL = '''http://erp.jd.com'''
    LOGIN_URL = ''' http://erp1.jd.com/newHrm/Verify.aspx?returnUrl=http%3a%2f%2ferp.jd.com%2findex.tpsml'''

    def check(self):
        init_request = urllib2.Request(JdPouch.GATEWAY_LOGIN)
        JdPouch._add_request_headers(init_request, JdPouch.GATEWAY_LOGIN)

        try:
            init_connect_res = urllib2.urlopen(init_request)
        except Exception, e:
            raise Exception("fail to do prelogin http action, %s" + str(e))

        init_connect_content = init_connect_res.read()
        ip_info = re.search(r'id="ipaddress" >([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})<', init_connect_content )

        if not ip_info is None and len(ip_info.groups()) != 0:
            sys.stdout.write("currnt ip(%s) has logged in.\n" % ip_info.group(1))
            return
        else:
            sys.stdout.write("current machine not logged with gateway, try to make it.\n")

        #need login gate way
        import base64
        request_post_data = {"username1" : self.username, "password1" : self.passwd, 
                            "username" : base64.encodestring(self.username).strip(), 
                            "password" : base64.encodestring(self.passwd).strip(), 
                            "language" : 1, "actionType" : "umlogin" , "userIpMac" : ""}

        request = urllib2.Request(
                        JdPouch.GATEWAY_LOGIN,
                        urllib.urlencode(request_post_data)
                        )
        JdPouch._add_request_headers(request, JdPouch.GATEWAY_LOGIN)

        try:
            login_res = urllib2.urlopen(request)
        except Exception, e:
            raise Exception("fail to do gateway login http action, " + str(e))
        login_res_content = login_res.read()

        ip_info = re.search(r'id="ipaddress" >([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})<', login_res_content)

        if ip_info is None or len(ip_info.groups()) == 0:
            raise Exception("gateway login failed.")
        else:
            sys.stdout.write("currnt ip(%s) has logged in.\n" % ip_info.group(1))

    def _pre_login(self):
        init_request = urllib2.Request(JdPouch.ERP_URL)
        JdPouch._add_request_headers(init_request, JdPouch.LOGIN_URL)
        try:
            init_connect_res = urllib2.urlopen(init_request)
        except Exception, e:
            raise Exception("fail to do prelogin http action, %s" + str(e))

        init_connect_content = init_connect_res.read()

        view_state = re.search(r'id="__VIEWSTATE" value="([/a-zA-Z0-9=].*?)"', init_connect_content)
        if view_state is None or len(view_state.groups()) == 0:
            raise Exception("prelogin, no view state found.")
        view_state_str = view_state.group(1)

        event_validation = re.search(r'id="__EVENTVALIDATION" value="([/a-zA-Z0-9=].*?)"', init_connect_content)
        if event_validation is None or len(event_validation.groups()) == 0:
            raise Exception("prelogin, no event validation found.")
        event_validation_str = event_validation.group(1)

        return (view_state_str, event_validation_str)

    def login(self):
        ''' do login action '''

        # try get get madantory parameters first.
        view_state_str, event_validation_str = self._pre_login()

        # then do actual login
        request_post_data = {"Name" : self.username, "Password" : self.passwd, "Logon" : "登  录",
                            "__VIEWSTATE" : view_state_str, "__EVENTVALIDATION" : event_validation_str}

        request = urllib2.Request(
                        JdPouch.LOGIN_URL,
                        urllib.urlencode(request_post_data)
                        )
        JdPouch._add_request_headers(request, JdPouch.LOGIN_URL)

        try:
            login_res = urllib2.urlopen(request)
        except Exception, e:
            raise Exception("fail to do login http action, %s" + str(e))

        login_res_headers = login_res.info().headers
        self.portal_str = ""
        for header_str in login_res_headers:
            portal_res = re.search(r'_portal_=([0-9a-zA-Z=].*?);', header_str)
            if portal_res is None or len(portal_res.groups()) == 0:
                continue
            self.portal_str = portal_res.group(1)
            break
        if len(self.portal_str) == 0:
            raise Exception("login failed, no portal cookie found.")

        sys.stdout.write("login successfully!\n")

    def _pre_pouch(self):
        KAOQIN_URL = "http://kaoqin.jd.com/"
        init_request = urllib2.Request(
                        KAOQIN_URL
                        )
        JdPouch._add_request_headers(init_request, KAOQIN_URL)
        try:
            init_pouch = urllib2.urlopen(init_request)
        except Exception, e:
            raise Exception("fail to do prepouch http action, %s" + str(e))

    def pouch(self):
        # set cookie ...
        self._pre_pouch()

        CHECK_IN_URL = """http://kaoqin.jd.com/kaoqin/checkIn"""

        current_time_stamp = int(time.time())

        request = urllib2.Request(
                        CHECK_IN_URL,
                        urllib.urlencode({"ts" : current_time_stamp})
                        )
        JdPouch._add_request_headers(request, CHECK_IN_URL)
        request.add_header("X-Requested-With", "XMLHttpRequest")
        request.add_header("Accept", "application/json, text/javascript, */*; q=0.01")

        try:
            pouch_res = urllib2.urlopen(request)
        except Exception, e:
            raise Exception("fail to do pouch http action, %s" + str(e))

        pouch_res_content = pouch_res.read()
        pouch_res_fields = re.search(
                r'(打卡成功) </br> ([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2})"}',
                pouch_res_content
                )
        if pouch_res_fields is None or len(pouch_res_fields.groups()) == 0:
            raise Exception("fail to pouch, res: " + pouch_res_content)
        pouch_timestamp_str = pouch_res_fields.group(2)

        sys.stdout.write("you have pouched successfully in %s.\n" % pouch_timestamp_str)

def usage():
    sys.stderr.write("usage: ./{script} -u ${username} -p ${passwd}\n")
    sys.exit(-1)

if __name__ == "__main__":

    optParser = optparse.OptionParser()
    optParser.add_option('-u', '--username', type='string', 
                            dest='username', help='the erp account')
    optParser.add_option('-p', '--passwd', type='string', 
                            dest='passwd', 
                            help='password that pair with the erp account')

    # sleep for a random period (within 25 minutes)
    sleep_time = random.randrange(1, 25 * 60)
    sys.stdout.write("we gonna sleep for %s seconds.\n" % sleep_time)
    time.sleep(sleep_time)

    # do pouch job
    try:
        (options, args) = optParser.parse_args()
        jd_pouch = JdPouch(options.username, options.passwd)
        jd_pouch.check()
        jd_pouch.login()
        jd_pouch.pouch()

    except Exception, e:
        sys.stderr.write("operation failed, details: " + str(e) + ".\n")
        usage()
