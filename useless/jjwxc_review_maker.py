#!/usr/bin/env python
# -*- encoding: utf8 -*-

import os
import sys
import urllib2

class NovelReview:

    JJWXC_URL='http://www.jjwxc.net'

    def __init__(self, username=None, passwd=None, showname=None):
        ''' init urllib and other parameters '''

        if not username is None and len(username) != 0:
            self.username = username
            self.passwd = passwd

        if not showname is None:
            self.showname = showname
        else:
            self.showname = u'python review robot'

        self.comment_url='http://www.jjwxc.net/lib/insertcomment_ajax.php'

        import cookielib
        self.cookies = cookielib.CookieJar()
        self.cookieHandler= urllib2.HTTPCookieProcessor(self.cookies)
        self.operner = urllib2.build_opener(self.cookieHandler)
        self.operner.addheaders=[('User-Agent', '''Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 ''' + \
                                                '''(KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36 ''' + \
                                                '''CoolNovo/2.0.9.20'''), ('X-Requested-With', 'XMLHttpRequest')]
        urllib2.install_opener(self.operner)

        self.is_login = False

    def login(self):
        ''' do login action '''
        import time
        login_url=('''http://my.jjwxc.net/login.php?action=login&login_mode=ajax&USEUUID=undefined&loginname=%s''' + \
                  '''&loginpassword=%s&Ekey=&Challenge=&auth_num=&cookietime=0&client_time=%s''' + \
                  '''&jsonp=jQuery1800784496606560424_1411400120166&_=1411400216421''' ) \
                  % (self.username, self.passwd, int(time.time()))
        request = urllib2.Request(login_url)
        request.add_header("Accept-Language", "zh-CN,zh;q=0.8")
        request.add_header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8, \"zh-CN,zh;q=0.8\"")
        request.add_header("Referer", NovelReview.JJWXC_URL)

        res = urllib2.urlopen(request)
        login_res = res.read()
        import re
        s_flag = re.search(r'"readerId":"[0-9]+"', login_res)

        if s_flag is None:
            sys.stderr.write("sorry, failed to login, please check your username and passwd.\n")
            sys.stderr.write("login res: %s.\n" % login_res)
            raise Exception("login failed!")
        else:
            self.is_login = True

    goodReviewList = [u'', u'']
    @staticmethod
    def generateGoodReview():
        ''' generate review contents '''
        goodReview = u''
        import random
        r = random.Random()
        for i in range(0, 1):
            goodReview = goodReview + NovelReview.goodReviewList[r.randint(0, len(NovelReview.goodReviewList) - 1)]
        return goodReview

    def _buildData(self, novel_id, chapter_id):
        ''' build review post data '''
        post_map = {}
        post_map['novelid'] = novel_id
        post_map['chapterid'] = chapter_id
        post_map['commentauthor'] = self.showname
        post_map['commentmark'] = 5
        post_map['commentbody'] = NovelReview.generateGoodReview().encode('utf-8')
        import urllib
        return urllib.urlencode(post_map)

    def _doPost(self, post_data):
        ''' do actual post action '''
        request = urllib2.Request(self.comment_url, post_data)
        request.add_header("Accept-Language", "zh-CN,zh;q=0.8")
        request.add_header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8, \"zh-CN,zh;q=0.8\"")
        request.add_header("Referer", NovelReview.JJWXC_URL)

        res = urllib2.urlopen(request)
        return res.read()


    def makeReview(self, novel_id, chapter_id):
        ''' main make function '''
        post_data = self._buildData(novel_id, chapter_id)
        res = self._doPost(post_data)

        import re
        review_flag = re.search(r'"status":1', res)
        if review_flag is None:
            sys.stderr.write("sorry, make review failed. novel id: %s, chapter id: %s.\n" % (novel_id, chapter_id))
            sys.stderr.write("make review res: %s.\n" % res)
            return False
        else:
            return True

def usage():
    sys.stderr.write("invalid parameters.\n")
    sys.stderr.write("please refer to ./{script} -h\n")
    sys.exit(-1)

if __name__ == "__main__":

    import optparse
    optParser = optparse.OptionParser()

    optParser.add_option('-n', '--novelid', type='int', dest='novel_id', \
                               help='the novel id')
    optParser.add_option('-b', '--beginchapterid', type='int', dest='begin_id', \
                               help='sequence of which chapter you wanna mmake a review start with')
    optParser.add_option('-e', '--endchapterid', type='int', dest='end_id', \
                               help='sequence which chapter you wanna mmake a review end with')
    optParser.add_option('-u', '--username', type='string', dest='username', \
                               help='only if you wanna login')
    optParser.add_option('-p', '--passwd', type='string', dest='passwd', \
                               help='only if you specify a username') 
    optParser.add_option('-s', '--showname', type='string', dest='showname', \
                               help='this will be displayd in your review') 

    try:
        (options, args) = optParser.parse_args()
        novel_id = options.novel_id
        begin_id = options.begin_id
        end_id = options.end_id
        username = options.username
        passwd = options.passwd
        showname = options.showname

        if begin_id is None or begin_id == 0 or \
           end_id is None or end_id == 0 or \
           begin_id > end_id or \
           ( not username is None and passwd is None):
            raise Exception("invalid input parameters!")

        novelReview = NovelReview(username, passwd, showname)

        if not username is None and len(username) != 0 and len(passwd) != 0:
            novelReview.login()

        for chapter_id in range(begin_id, end_id + 1):
            if novelReview.makeReview(novel_id, chapter_id):
                sys.stdout.write("make review success for novel(%s) chapter(%s)\n" % (novel_id, chapter_id))
            else:
                sys.stderr.write("make review failed for novel(%s) chapter(%s)\n" % (novel_id, chapter_id))

    except Exception, e:
        usage()

