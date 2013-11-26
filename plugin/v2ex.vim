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
import requests

TIMEOUT = 15
URL = 'http://www.v2ex.com/api/topics/latest.json'
HEADERS = {'User-Agent': 'vim'}

try:
    posts = requests.get(URL, stream=False, verify=False, timeout=TIMEOUT,
                         headers=HEADERS).json()
    del vim.current.buffer[:]

    for post in posts:
        node = post['node']['title'].encode('utf8')
        title = post['title'].encode('utf8')
        url = post['url'].encode('utf8')
        replies = post['replies']
        created_timstamp = post['created']
        created = time.strftime("%Y-%m-%d %H:%M:%S",
                                time.localtime(created_timstamp))
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
