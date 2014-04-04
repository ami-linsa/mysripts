#!/usr/bin/env python
#coding=utf-8

import MySQLdb
import time
h,p,u,ps,d = ('*.*.*.*',3333,'qatest','qatest','ddb_test')
conn = MySQLdb.connect(host=h, port=p, user=u, passwd=ps, db=d,connect_timeout=20)
cursor = conn.cursor()
k = 0
for i in range(10) :
    a = time.time()
    cursor.execute("select id from xone_app_tools where name='%s'" % ('数据库',))
    rs = cursor.fetchall() 
    b = time.time()
    print '%s : ' % str(i+1)+str(round(b-a,4))+'s'+' ; id=%s' % (str(rs[0][0]),)
    k += (b-a)
print 'avg : '+str(round(k/1000,4))+'s'

cursor.close()
conn.close()
