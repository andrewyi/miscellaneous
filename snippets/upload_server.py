#!/usr/bin/env python
# -*- encoding: utf8 -*-

import os
import cgi
import BaseHTTPServer

class handler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()
        self.wfile.write('''
        <form method="post" enctype="multipart/form-data">
            <input type="file" name="uploaded">
            <button>Submit</button>
        </form>
        ''')

    def do_POST(self):
        form = cgi.FieldStorage(
                fp = self.rfile,
                headers = self.headers,
                environ = {
                    'REQUEST_METHOD': 'POST',
                    'CONTENT_TYPE': self.headers['Content-Type']
                    },
                )
        uploaded = form['uploaded']
        with open(uploaded.filename, 'w') as f:
            f.write(uploaded.file.read())

        self.do_GET()
        os._exit(0)

BaseHTTPServer.HTTPServer(('', 7777), handler).serve_forever()
