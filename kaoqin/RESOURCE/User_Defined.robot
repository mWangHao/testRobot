*** Variables ***
${tel_tsg}        10000004580    # tsg登录号码
${password}       123456    # 密码
${deviceid}       861353038702297    # 设备号
${ostype}         0    # 操作系统 \ android 1 /ios \ 0
${channelid}      0    # 百度推送id
${root}           0    # 1：手机root/越狱；0：手机未root/越狱；-1：无法获取root/越狱状态
${simuLocation}    0    # 1：手机开启模拟位置；0：手机未开启模拟位置；
${simulator}      0    # 1：app运行在模拟器中；0：未运行在模拟器中；-1：无法获取是否在模拟器中。
${pageNum}        1    # 列表第一页
${pageSize}       10    # 一页10条记录
${reason_variable}    今天要加班    #原因
${longitude}      104.047041    # 考勤地点经度
${latitude}       30.581486    # 考勤地点纬度
${status_variable}    0    # 0 待审，1通过，2未通过
${longitude_new}    30.98765    # 非考勤地点经度
${latitude_new}    104.9999    # 非考勤地点维度
${status_agree}    1    #获取的审批类型为同意的加班列表
${status_refuse}    2    # 获取的审批类型为拒绝的加班列表
${tel_comic}      10000004582    #comic登录号码
${telcomic_leader}    10000004584    #comic审批人
${tel_video}      10000004581    # video登录号码
${telvideo_leader}    10000004583    #video审批人
${teltsg_leader}    10000004585    #tsg审批人
${pageNo}         1    # 列表第一页
${reason_variable_Wq}    我要撤回/发起外勤    # 原因
${startTime}      20181006    # 开始时间
${endTime}        20181006    # 结束时间
${addressDetail}    成都咪咕    # 发起外勤地址详情B01
${auditorId}      39771    # 发起外勤审核人IdB01
${mobileType}     MOBILE_TYPE_HUIYI    # 发起外勤类型B01
${days}           1    # 发起外勤days参数B01
${addressName}    成都    # 发起外勤地址名字B01
${longitude_wq}    104.066409    # 外勤地址B01
${latitude_wq}    31.61245    # 外勤地址B01
${examine_yishenhe}    yishenhe    # 已审核
${examine_daishenhe}    daishenhe    # 待审核
${leaderID_tsg}    12    # tsg默认审核人ID
${mobileTargetAddressid}    3909    # A01外勤地址/中软国际
${localLatitude_A01}    30.553516    # 中软国际
${localLongitude_A01}    104.067573    # 中软国际
${tel_Jie_video}    10000002681    # jie_vedio测试视讯加班
${registrationId}    12345678901    # 注册ID
${reason_untie}    先不管我要解绑    # 解绑理由
${status}         0    # 查询我处理的全部
${professionType}    TSG_MYDEAL_LEAVE    # 请假
${professionType_repair}    TSG_MYCREATE_REPAIR    # 补考勤
${professionId}    1    # 补考勤
${exceptionType}    3    # 旷工
${auditorId_tsg}    12    # 补考勤审核人tsg
${professionType_overtimevideo}    VIDEO_MYDEAL_OVERTIME    # 领导加班我处理的_video
${professionType_leave_ldtsg}    TSG_MYDEAL_LEAVE    # 请假领导-tsg
${professionType_leave_tsg}    TSG_MYCREATE_LEAVE    # 请假申请人-我的创建
${professionType_leave_video}    VIDEO_MYCREATE_LEAVE    # 请假申请人-我的创建-video
${status_shenpi}    2
