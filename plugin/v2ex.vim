" File: v2ex.vim
" Desption: v2ex for vim
" Author: solos
" Last Change: 2014/02/28

if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif
function! V2EX()

python << EOF
import vim
import json
import time
import datetime

has_requests = True
try:
    import requests
except:
    import urllib2
    has_requests = False

TIMEOUT = 15
URL = 'http://www.v2ex.com/api/topics/latest.json'
HEADERS = {'User-Agent': 'vim'}

try:
    if has_requests:
        posts = requests.get(URL, stream=False, verify=False, timeout=TIMEOUT,
                             headers=HEADERS).json()
    else:
        req = urllib2.Request(URL, headers=HEADERS)
        response = urllib2.urlopen(req).read()
        posts = json.loads(response)

    del vim.current.buffer[:]

    for post in posts:
        node = post['node']['title'].encode('utf8')
        title = post['title'].encode('utf8').replace('\n', '')
        url = post['url'].encode('utf8').replace('\n', '')
        replies = post['replies']
        created_timestamp = post['created']
        created = time.strftime("%Y-%m-%d %H:%M:%S",
                                time.localtime(created_timestamp))
        last_modified = post['last_modified']
        last_touched_timestamp = post['last_touched']
        last_touched = time.strftime("%Y-%m-%d %H:%M:%S",
                                     time.localtime(last_touched_timestamp))
        content = post['content'].encode('utf8')
        username = post['member']['username'].encode('utf8')
        vim.current.buffer.append("[%s] %s\t%s\t [%s]" % (node, title, url,
                                                          replies))
        vim.current.buffer.append("  %s\t创建时间：%s\t最后访问时间：%s" %
                                  (username, created, last_touched))
        for line in content.split('\n'):
            vim.current.buffer.append('    %s' % line.strip())
        vim.current.buffer.append('')
    vim.command("set foldmethod=indent")
    vim.command("set foldcolumn=1")
except Exception, e:
    print e

EOF
endfunction
command! V2EX call V2EX()
command! V2Ex call V2EX()
command! V2eX call V2EX()
command! V2ex call V2EX()
