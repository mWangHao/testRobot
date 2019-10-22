*** Variables ***
${KQ_URL}         https://kq.migu.cn:10443/miguattendTest    # 咪咕考勤北京测试服
${KQ_SQL_CONN}    {"host":"10.124.2.163","port":"3306","user":"attend","passwd":"kQdb@20!8","db":"migu_attendance_test"}    # 数据库链接地址{"host":"10.124.2.163","port":"3306","user":"attend","passwd":"kQdb@20!8","db":"attendance_test"}&{"host":"localhost","port":3306,"user":"root","passwd":"lgs0820","db":”migu_attendance_test"}
${KQ_KEY}         SHOWMETHEMONEY00    # AES密码
${KQ_SQL_CONN_DEL}    database='migu_attendance_test', user='attend', password='kQdb@20!8', host='10.124.2.163', port=3306, charset='utf8'
${KQ_attendmanage}    http://10.148.138.150:19090/attendmanage    # 考勤后台管理URL
