*** Settings ***
Library           requests
Library           json
Library           base64
Library           migu_library
Library           Collections
Resource          ../../RESOURCE/global.robot
Resource          ../../RESOURCE/interface_url.robot
Library           RequestsLibrary
Library           pymysql
Resource          ../../RESOURCE/return.robot
Library           DateTime
Resource          ../../RESOURCE/User_Defined.robot
Library           DatabaseLibrary
Library           String
Library           re

*** Keywords ***
发送请求_post
    [Arguments]    ${url}    ${data}
    log    ${url}
    ${url_2}    Split String    ${url}    ?sessionId=
    ${len}    Get Length    ${url_2}
    ${url}    Set Variable    ${url_2[0]}
    ${sessionId}    Run Keyword IF    ${len}==2    Set Variable    ${url_2[1]}
    Run Keyword IF    ${len}==2    Run Keyword    data中设置sessionid参数    ${data}    ${sessionId}    ${url}
    ${res_data}    Run Keyword IF    ${len}==1    Set Variable    ${data}
    ...    ELSE IF    ${len}==2    Set Variable    ${res_data2}
    log    ${res_data}
    ${res}    CommonLibrary_httpInterface_post_form    ${url}    ${res_data}
    log    ${res}
    [Return]    ${res}

AES加密
    [Arguments]    ${message}
    ${message}    Convert To String    ${message}
    ${message}    CommonLibrary Replace String    ${message}    u'    "
    ${message}    CommonLibrary Replace String    ${message}    '    "
    ${encoded}    Encryt    ${message}    ${KQ_KEY}
    [Return]    ${encoded}

检查数据库
    [Arguments]    ${in_data}    ${KQ_SQL_CONN}    ${KQ_SQL_param}
    check in mysql    ${in_data}    ${KQ_SQL_CONN}    ${KQ_SQL_param}

AES解密
    [Arguments]    ${res_data}
    ${return_AES}    Convert To Bytes    ${res_data}
    ${decoded}    Decrypt    ${return_AES}    ${KQ_KEY}
    ${decoded}    CommonLibrary JsonStr To Dic    ${decoded}
    [Return]    ${decoded}

获取tokenID
    [Arguments]    ${sessionId}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_Token}?sessionId=${sessionId}    ${sessionId}
    ${returnInfo}    AES解密    ${return_AES}
    ${TokenId}    Get From Dictionary    ${returnInfo}    token
    log    ${TokenId}
    [Return]    ${TokenId}

获取当前时间YYYYMMDDHHmmSS
    ${date}=    Get Current Date
    ${Nowtime}=    Convert Date    ${date}    result_format=%Y%m%d%H%M%S
    [Return]    ${Nowtime}

登陆获取sessionID
    ${login}    Create Dictionary    tel=${tel_tsg}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${sessionId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["sessionId"]}
    ${sessionId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_tsg}
    ${sessionId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_tsg}
    ${sessionId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${sessionId_200}
    [Return]    ${sessionId}

获取外勤地点
    [Arguments]    ${sessionId}
    ${Search_data}    Create Dictionary    keyWord=${keyWord}    parentid=${parentid}    pageNum=${pageNum} \    pageSize= ${pageSize}
    log    ${Search_data}
    #josn字符转化成Dictionary
    ${Search_data_json}    evaluate    json.dumps(${Search_data})    json
    log    ${Search_data_json}
    ${Search_data_AES}    AES加密    ${Search_data_json}
    ${AES_Search_data}    发送请求_post    ${KQ_URL}${KQ_search_sites_2}?sessionId=${sessionId}    ${Search_data_AES}
    ${returnInfo}    AES解密    ${AES_Search_data}
    ${mobileaddress}    Get From Dictionary    ${returnInfo}    mobileaddress
    log    ${mobileaddress}
    ${mobileTargetAddressid}    Get From Dictionary    ${mobileaddress}    addressid
    log    ${mobileTargetAddressid}

获取领导人列表
    [Arguments]    ${sessionId}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_inquire_leader}?sessionId=${sessionId}    ${sessionId}
    ${returnInfo}    AES解密    ${return_AES}
    ${leaderID}    Get From Dictionary    ${returnInfo}    leaderid
    log    ${leaderID}
    [Return]    ${leaderID}

用户考勤打卡
    [Arguments]    ${longitude}    ${latitude}    ${isAutoSignIn}
    ${sessionId}    登陆获取sessionID
    ${TokenId}    获取tokenID    ${sessionId}
    ${Nowtime}    获取当前时间YYYYMMDDHHmmSS
    ${Kaoqin_data}    Create Dictionary    latitude=${latitude}    longitude=${longitude}    isAutoSignIn=${isAutoSignIn}    tokenId=${TokenId}    now=${Nowtime}
    log    ${Kaoqin_data}
    #josn字符转化成Dictionary
    ${Kaoqin_data_json}    evaluate    json.dumps(${Kaoqin_data})    json
    log    ${Kaoqin_data_json}
    ${Search_data_AES}    AES加密    ${Kaoqin_data_json}
    ${Kaoqin_res_data}    发送请求_post    ${KQ_URL}${KQ_kaoqin}?sessionId=${sessionId}    ${Search_data_AES}
    ${returnInfo}    AES解密    ${Kaoqin_res_data}
    log    ${returnInfo}

获取当前时间YYYYMMDD
    ${date}=    Get Current Date
    ${Nowday}=    Convert Date    ${date}    result_format=%Y%m%d
    log    ${Nowday}
    [Return]    ${Nowday}

时间戳转换为时间
    [Arguments]    ${Timestamp}
    ${Timestamp}    Evaluate    ${Timestamp}/1000
    log    ${Timestamp}
    ${Time}    Convert Date    ${Timestamp}    result_format=%Y%m%d%H%M%S
    log    ${Time}
    [Return]    ${Time}

时间转换为时间戳
    [Arguments]    ${Nowtime}
    ${Time}    Convert Date    ${Nowtime}    epoch
    log    ${Time}
    ${Timestamp}    Evaluate    int(${Time})*1000
    log    ${Timestamp}
    [Return]    ${Timestamp}

登陆获取userID
    ${login}    Create Dictionary    tel=${tel_tsg}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${userId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["userId"]}
    ${userId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取userId解绑后    tel=${tel_tsg}
    ${userId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取userId解绑后    tel=${tel_tsg}
    ${userId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${userId_200}
    [Return]    ${userId}

获取待审核临时加班申请单
    ${sessionId}    登陆获取sessionID
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_overtime_queryMyApplylist}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${leaveList}    Get From Dictionary    ${returnInfo}    leaveList
    log    ${leaveList[0]}
    ${otleaveId}    Get From Dictionary    ${leaveList[0]}    otleaveId
    log    ${otleaveId}
    [Return]    ${otleaveId}

发起临时加班
    ${sessionId}    登陆获取sessionID
    ${Overtime}    Create Dictionary    reason=${reason_variable}    longitude=${longitude_new}    latitude=${latitude_new}
    log    ${Overtime}
    #josn字符转化成Dictionary
    ${Overtime_json}    evaluate    json.dumps(${Overtime})    json
    log    ${Overtime_json}
    ${Overtime_AES}    AES加密    ${Overtime_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_Overtimeapply}?sessionId=${sessionId}    ${Overtime_AES}
    ${returnInfo}    AES解密    ${return_AES}
    comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200
    [Return]    ${sessionId}

撤回临时加班申请
    ${otleaveId}    获取待审核临时加班申请单
    ${sessionId}    登陆获取sessionID
    #撤回加班申请
    ${undo}    Create Dictionary    otleaveId=${otleaveId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_otleaveRevoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

登陆获取领导账号sessionID
    ${login}    Create Dictionary    tel=${teltsg_leader}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${sessionId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["sessionId"]}
    ${sessionId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取SessionId解绑后    tel=${teltsg_leader}
    ${sessionId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取SessionId解绑后    tel=${teltsg_leader}
    ${sessionId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${sessionId_200}
    [Return]    ${sessionId}

审批人获取临时加班申请待审列表
    ${sessionId_leader}    登陆获取领导账号sessionID
    ${querylist}    Create Dictionary    pageNum=${pageNum}    pageSize=${pageSize}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_queryApprovallist}?sessionId=${sessionId_leader}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${leaveList}    Get From Dictionary    ${returnInfo}    leaveList
    log    ${leaveList[0]}
    ${orderId}    Get From Dictionary    ${leaveList[0]}    orderId
    ${taskId}    Get From Dictionary    ${leaveList[0]}    taskId
    [Return]    ${orderId}    ${taskId}    # 加班流程Id

获取临时加班申请单-被审批同意
    ${sessionId}    登陆获取sessionID
    ${querylist}    Create Dictionary    status=${status_agree}    pageNum=${pageNum}    pageSize=${pageSize}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_overtime_queryMyApplylist}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${leaveList}    Get From Dictionary    ${returnInfo}    leaveList
    log    ${leaveList[0]}
    ${otleaveId}    Get From Dictionary    ${leaveList[0]}    otleaveId
    log    ${otleaveId}
    [Return]    ${otleaveId}

撤回临时加班申请单-被审批同意
    ${otleaveId}    获取临时加班申请单-被审批同意
    ${sessionId}    登陆获取sessionID
    #撤回加班申请
    ${undo}    Create Dictionary    otleaveId=${otleaveId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_otleaveRevoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

获取临时加班申请单-被审批拒绝
    ${sessionId}    登陆获取sessionID
    ${querylist}    Create Dictionary    status=${status_refuse}    pageNum=${pageNum}    pageSize=${pageSize}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_overtime_queryMyApplylist}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${leaveList}    Get From Dictionary    ${returnInfo}    leaveList
    log    ${leaveList[0]}
    ${otleaveId}    Get From Dictionary    ${leaveList[0]}    otleaveId
    log    ${otleaveId}
    [Return]    ${otleaveId}

撤回临时加班申请单-被审批拒绝
    ${otleaveId}    获取临时加班申请单-被审批拒绝
    ${sessionId}    登陆获取sessionID
    #撤回加班申请
    ${undo}    Create Dictionary    otleaveId=${otleaveId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_otleaveRevoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

更改密码账户登录获取sessionId
    ${login}    Create Dictionary    tel=10000000999    password=123456    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    channelid=${channelid}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${sessionId_updatepassword}    Get From Dictionary    ${returnInfo}    sessionId
    [Return]    ${sessionId_updatepassword}

发送请求_get
    [Arguments]    ${url}    ${data}
    log    ${url}
    ${res}    CommonLibrary_httpInterface_get    ${url}    ${data}
    log    ${res}
    [Return]    ${res}

登陆获取sessionIDcomic
    ${login}    Create Dictionary    tel=${tel_comic}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${sessionId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["sessionId"]}
    ${sessionId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_comic}
    ${sessionId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_comic}
    ${sessionId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${sessionId_200}
    [Return]    ${sessionId}

登陆获取sessionIDvideo
    ${login}    Create Dictionary    tel=${tel_video}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${sessionId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["sessionId"]}
    ${sessionId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_video}
    ${sessionId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_video}
    ${sessionId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${sessionId_200}
    [Return]    ${sessionId}

登陆获取领导账号userID
    ${login}    Create Dictionary    tel=${teltsg_leader}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${userId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["userId"]}
    ${userId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取userId解绑后    tel=${teltsg_leader}
    ${userId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取userId解绑后    tel=${teltsg_leader}
    ${userId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${userId_200}
    [Return]    ${userId}

撤回外勤B01申请
    ${mobileId}    获取待审核外勤B01列表
    ${sessionId_video}    登陆获取sessionIDvideo
    #撤回外勤B01申请
    ${undo}    Create Dictionary    mobileId=${mobileId}    reason=${reason_variable_Wq}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_Wqb_MobileRevoke}?sessionId=${sessionId_video}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

获取待审核外勤B01列表
    ${sessionId_video}    登陆获取sessionIDvideo
    ${querylist}    Create Dictionary    pageNo=${pageNo}    pageSize=${pageSize}    status=${status_variable}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_getMyApplyList_Wq}?sessionId=${sessionId_video}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    log    ${returnInfo}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${mobileId}    Get From Dictionary    ${list[0]}    mobileId
    log    ${mobileId}
    [Return]    ${mobileId}

发起外勤B01申请
    ${sessionId_Video}    登陆获取sessionIDvideo
    ${time}    Create Dictionary    startTime=${startTime}    endTime=${endTime}
    ${timeList}    Create List    ${time}
    #发起外勤B01申请
    ${mobileWorkDate}    Create Dictionary    timeList=${timeList}    reason=${reason_variable_Wq}    addressDetail=${addressDetail}    auditorId=${auditorId}    latitude=${latitude_wq}
    ...    mobileType=${mobileType}    days=${days}    addressName=${addressName}    longitude=${longitude_wq}
    #字典转换为json字符串
    ${mobileWorkDate_Json}    evaluate    json.dumps(${mobileWorkDate})    json
    log    ${mobileWorkDate_Json}
    ${mobileWorkDate_AES}    AES加密    ${mobileWorkDate_Json}
    #发送Post请求
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_Wqb_Apply}?sessionId=${sessionId_video}    ${mobileWorkDate_AES}
    ${returnInfo}    AES解密    ${return_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200

登陆获取领导账号sessionID_Video
    ${login}    Create Dictionary    tel=${telvideo_leader}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${sessionId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["sessionId"]}
    ${sessionId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取SessionId解绑后    tel=${telvideo_leader}
    ${sessionId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取SessionId解绑后    tel=${telvideo_leader}
    ${sessionId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${sessionId_200}
    [Return]    ${sessionId}

审核人获取待审核外勤B01申请列表
    ${sessionId}    登陆获取领导账号sessionID_Video
    ${querylist}    Create Dictionary    examine=${examine_daishenhe}    pageNo=${pageNo}    pageSize=${pageSize}
    log    ${querylist}
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_wqb_queryHandlelist}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    log    ${orderId}
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    log    ${taskId}
    [Return]    ${orderId}    ${taskId}    #外勤B01流程Id

获取外勤B01申请单-被审批同意
    ${sessionId}    登陆获取sessionIDvideo
    ${querylist}    Create Dictionary    status=${status_agree}    pageNo=${pageNo}    pageSize=${pageSize}
    log    ${querylist}
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_getMyApplyList_Wq}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    log    ${returnInfo}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${mobileId}    Get From Dictionary    ${list[0]}    mobileId
    log    ${mobileId}
    [Return]    ${mobileId}

获取外勤B01申请单-被审批拒绝
    ${sessionId}    登陆获取sessionIDvideo
    ${querylist}    Create Dictionary    status=${status_refuse}    pageNo=${pageNo}    pageSize=${pageSize}
    log    ${querylist}
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_getMyApplyList_Wq}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    log    ${returnInfo}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${mobileId}    Get From Dictionary    ${list[0]}    mobileId
    log    ${mobileId}
    [Return]    ${mobileId}

撤回外勤A01申请
    ${mobileworkID}    查询当前外勤A01
    log    ${mobileworkID}
    ${sessionId}    登陆获取sessionID
    #撤回外勤B01申请
    ${undo}    Create Dictionary    mobileworkID=${mobileworkID}    reason=${reason_variable_Wq}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_WqA01_revokeMobilework}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

发起外勤A01申请
    ${sessionId}    登陆获取sessionID
    ${leaderID}    Create List    ${leaderID_tsg}
    #发起外勤B01申请
    ${mobileWorkDate}    Create Dictionary    mobileTargetAddressid=${mobileTargetAddressid}    localLatitude=${localLatitude_A01}    localLongitude=${localLongitude_A01}    leaderID=${leaderID}    reason=${reason_variable_Wq}
    ...    localAddressName=${addressDetail}    localAddressDetail=${addressDetail}
    #字典转换为json字符串
    ${mobileWorkDate_Json}    evaluate    json.dumps(${mobileWorkDate})    json
    log    ${mobileWorkDate_Json}
    ${mobileWorkDate_AES}    AES加密    ${mobileWorkDate_Json}
    #发送Post请求
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_WqA01_requestmobilework}?sessionId=${sessionId}    ${mobileWorkDate_AES}
    ${returnInfo}    AES解密    ${return_AES}
    comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

查询当前外勤A01
    #发送Post请求
    ${sessionId}    登陆获取sessionID
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_WqA01_queryCurrentmobilework}?sessionId=${sessionId}    ${sessionId}
    ${returnInfo}    AES解密    ${return_AES}
    ${mobileworkID}    Get From Dictionary    ${returnInfo}    mobileworkID
    log    ${mobileworkID}
    [Return]    ${mobileworkID}

撤回请假申请(tsg|comic)

重置登录设备
    [Arguments]    ${tel}
    Connect To Database Using Custom Params    pymysql    ${KQ_SQL_CONN_DEL}    #链接数据库
    Execute Sql String    DELETE FROM user_untie WHERE userId=(SELECT userId FROM \ users WHERE tel='${tel}'And enable='1' );
    Execute Sql String    UPDATE users SET \ deviceid=null \ WHERE \ tel='${tel}';
    log    重置登录设备成功

解绑手机未登录
    [Arguments]    ${tel}
    ${untie_data}    Create Dictionary    tel=${tel}    reason=${reason_untie}
    log    ${untie_data}
    #josn字符转化成Dictionary
    ${untie_json}    evaluate    json.dumps(${untie_data})    json
    log    ${untie_json}
    ${untie_AES}    AES加密    ${untie_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_user_doUserUntie}    ${untie_AES}
    ${returnInfo}    AES解密    ${return_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    ${KQ_code_200}
    log    解绑成功

解绑后账号密码登录
    [Arguments]    ${tel}
    ${login}    Create Dictionary    tel=${tel}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${sessionId}    Get From Dictionary    ${returnInfo}    sessionId
    ${userId}    Get From Dictionary    ${returnInfo}    userId
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    [Return]    ${sessionId}    ${userId}    ${return_code}

登录获取SessionId解绑后
    [Arguments]    ${tel}
    重置登录设备    ${tel}
    #解绑手机未登录    ${tel}
    ${sessionId}    ${userId}    ${return_code}    解绑后账号密码登录    ${tel}
    [Return]    ${sessionId}

登录获取userId解绑后
    [Arguments]    ${tel}
    重置登录设备    ${tel}
    #解绑手机未登录    ${tel}
    ${sessionId}    ${userId}    ${return_code}    解绑后账号密码登录    ${tel}
    [Return]    ${userId}

获取我处理的数据列表orderId
    ${data}    Create Dictionary    professionType=${professionType_leave_ldtsg}    pageNo=${pageNo}    pageSize=${pageSize}    status=${status_shenpi}
    log    ${data}
    ${req_data}    evaluate    json.dumps(${data})    json
    log    ${req_data}
    ${req_AES}    AES加密    ${req_data}
    ${sessionId}    登陆获取领导账号sessionID
    ${respond_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId}    ${req_AES}
    ${returnInfo}    AES解密    ${respond_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    log    ${orderId}
    [Return]    ${orderId}

获取待审核临时加班申请单-视讯
    ${sessionId}    登陆获取sessionIDvideo
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_overtime_queryMyApplylist}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${leaveList}    Get From Dictionary    ${returnInfo}    leaveList
    log    ${leaveList[0]}
    ${otleaveId}    Get From Dictionary    ${leaveList[0]}    otleaveId
    log    ${otleaveId}
    [Return]    ${otleaveId}

撤回加班申请-视讯
    ${otleaveId}    获取待审核临时加班申请单-视讯
    ${sessionId}    登陆获取sessionIDvideo
    #撤回加班申请
    ${undo}    Create Dictionary    otleaveId=${otleaveId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_otleaveRevoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

登录获取sessionId_jievideo
    ${login}    Create Dictionary    tel=${tel_Jie_video}    password=${password}    deviceid=${deviceid}    ostype=${ostype}    root=${root}
    ...    simulator=${simulator}    simuLocation= ${simuLocation}    registrationId=${registrationId}
    log    ${login}
    #josn字符转化成Dictionary
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${login_AES}    AES加密    ${login_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_login}    ${login_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    ${sessionId_200}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${returnInfo["sessionId"]}
    ${sessionId_408}    Run Keyword If    ${return_code}==408    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_Jie_video}
    ${sessionId_408}    Run Keyword If    ${return_code}==490    Run Keyword And Return    登录获取SessionId解绑后    tel=${tel_Jie_video}
    ${sessionId}    Run Keyword If    ${return_code}==${KQ_code_200}    Set Variable    ${sessionId_200}
    [Return]    ${sessionId}

发起加班-视讯
    ${sessionId}    登陆获取sessionIDvideo
    ${startTime}    获取当前时间YYYYMMDDHHmmSS
    ${endTime}    获取当前时间且后延时间
    ${time}    Create Dictionary    startTime=${startTime}    endTime=${endTime}
    ${timeList}    Create List    ${time}
    ${hours}    Set Variable    2
    ${Overtime}    Create Dictionary    timeList=${timeList}    reason=${reason_variable}    hours=${hours}    addressDetail=${addressDetail}    auditorId=${auditorId}
    ...    latitude=${latitude}    addressName=${addressName}    longitude=${longitude}
    log    ${Overtime}
    #josn字符转化成Dictionary
    ${Overtime_json}    evaluate    json.dumps(${Overtime})    json
    log    ${Overtime_json}
    ${Overtime_AES}    AES加密    ${Overtime_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_overtime_video_doApply}?sessionId=${sessionId}    ${Overtime_AES}
    ${returnInfo}    AES解密    ${return_AES}
    comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

获取当前时间且后延时间
    ${now}    获取当前时间YYYYMMDDHHmmSS
    log    ${now}
    ${date}=    Add Time To Date    ${now}    +02:00:00
    ${finalTime}=    Convert Date    ${date}    result_format=%Y%m%d%H%M%S
    log    ${finalTime}
    [Return]    ${finalTime}

获取补考勤待审核列表
    ${sessionId}    登陆获取sessionID
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_repair}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_mycreateGetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${repairId}    Get From Dictionary    ${list[0]}    professionId
    [Return]    ${repairId}

撤回补考勤
    ${repairId}    获取补考勤待审核列表
    ${sessionId}    登陆获取sessionID
    #撤回加班申请
    ${undo}    Create Dictionary    repairId=${repairId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_repair_repairRevoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

获取昨日时间YYYYMMDD
    ${now}    获取当前时间YYYYMMDD
    log    ${now}
    ${date}=    Add Time To Date    ${now}    -1 days
    ${finalTime}=    Convert Date    ${date}    result_format=%Y%m%d
    log    ${finalTime}
    [Return]    ${finalTime}

发起补考勤
    ${sessionId}    登陆获取sessionID
    ${beforeTime}    获取昨日时间YYYYMMDD
    ${mornTime}    Set Variable    090000
    ${afterTime}    Set Variable    220000
    ${startTime}    Set Variable    ${beforeTime}${mornTime}
    ${endTime}    Set Variable    ${beforeTime}${afterTime}
    ${time}    Create Dictionary    startTime=${startTime}    endTime=${endTime}
    ${timeList}    Create List    ${time}
    ${repairtime}    Create Dictionary    timeList=${timeList}    reason=${reason_variable}    exceptionType=${exceptionType}    auditorId=${auditorId_tsg}    exceptionTime=${beforeTime}
    log    ${repairtime}
    #josn字符转化成Dictionary
    ${repairtime_json}    evaluate    json.dumps(${repairtime})    json
    log    ${repairtime_json}
    ${repairtime_AES}    AES加密    ${repairtime_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_repair_doApply}?sessionId=${sessionId}    ${repairtime_AES}
    ${returnInfo}    AES解密    ${return_AES}
    comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

审批人获取补考勤申请待审列表
    ${sessionId_leader}    登陆获取领导账号sessionID
    ${querylist}    Create Dictionary    pageNo=${pageNum}    pageSize=${pageSize}    professionType=${professionType_repair}    status=${status_variable}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId_leader}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${orderId}    ${taskId}    # 补考勤流程Id

审批人获取加班申请待审列表_视讯
    ${sessionId_leader}    登陆获取领导账号sessionID_Video
    ${querylist}    Create Dictionary    pageNo=${pageNum}    pageSize=${pageSize}    professionType=${professionType_overtimevideo}    status=${status_variable}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId_leader}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${orderId}    ${taskId}    # 加班流程Id

获取请假待审核列表-tsg
    ${sessionId}    登陆获取sessionID
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_leave_tsg}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_mycreateGetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${leaveId}    Get From Dictionary    ${list[0]}    professionId
    [Return]    ${leaveId}

发起请假-tsg
    ${sessionId}    登陆获取sessionID
    ${startTime}    获取当前时间YYYYMMDDHHmmSS
    ${endTime}    Add Time To date    ${startTime}    +2Days    result_format=%Y%m%d%H%M%S
    ${leaveTime}    Create Dictionary    startTime=${startTime}    endTime=${endTime}    days=2
    ${timeList}    Create List    ${leaveTime}
    ${typeId}    Set Variable    2
    ${leavetimeDic}    Create Dictionary    timeList=${timeList}    reason=${reason_variable}    typeId=${typeId}
    log    ${leavetimeDic}
    #josn字符转化成Dictionary
    ${leavetime_json}    evaluate    json.dumps(${leavetimeDic})    json
    log    ${leavetime_json}
    ${leavetime_AES}    AES加密    ${leavetime_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_leave_v1_apply}?sessionId=${sessionId}    ${leavetime_AES}
    ${returnInfo}    AES解密    ${return_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200
    [Return]    ${startTime}    ${endTime}

撤回请假-tsg
    ${leaveId}    获取请假待审核列表-tsg
    ${sessionId}    登陆获取sessionID
    #撤回加班申请
    ${undo}    Create Dictionary    leaveId=${leaveId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_leaveRevoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

创建补考勤条件
    ${recordtime}    获取昨日时间YYYYMMDD
    ${time}    Set Variable    091200
    ${morntime}    Set Variable    ${recordtime}${time}
    Connect To Database Using Custom Params    pymysql    ${KQ_SQL_CONN_DEL}    #链接数据库
    ${userid}    Query    SELECT userid FROM users WHERE tel=${tel_tsg}
    Execute Sql String    DELETE FROM user_record WHERE userid = (SELECT userid FROM users WHERE tel=${tel_tsg}) AND recordtime=${recordtime};
    Execute Sql String    INSERT INTO user_record (userid,recordtime,morntime,mornlongitude,mornlatitude,afterlongitude,afterlatitude,workaddressid)VALUES(${userid[0][0]},${recordtime},${morntime},${longitude},${latitude},0,0,2);
    Execute Sql String    DELETE FROM time WHERE userid = (SELECT userid FROM users WHERE tel=${tel_tsg}) AND today=${recordtime};
    Execute Sql String    INSERT into time (userid,today,work,name,workday,isCasual,casualDuration,isoff,offDuration,late,leaveEarly,notFinish,noshow,mobileWork)VALUES(${userid[0][0]},${recordtime},0,${tel_tsg},0,0,0,0,0,0,1,0,0,0);

审批人获取请假申请待审列表-tsg
    ${sessionId_leader}    登陆获取领导账号sessionID
    ${querylist}    Create Dictionary    pageNo=${pageNum}    pageSize=${pageSize}    professionType=${professionType_leave_ldtsg}    status=${status_variable}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId_leader}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${orderId}    ${taskId}    # 请假流程Id

撤回请假-视讯
    ${leaveId}    获取请假待审核列表-视讯
    ${sessionId}    登陆获取sessionIDvideo
    #撤回加班申请
    ${undo}    Create Dictionary    leaveId=${leaveId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_video_leaveRevoke.html}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

获取请假待审核列表-视讯
    ${sessionId}    登陆获取sessionIDvideo
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_leave_video}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_mycreateGetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${leaveId}    Get From Dictionary    ${list[0]}    professionId
    [Return]    ${leaveId}

撤回请假-视讯 2.5.4
    ${leaveId}    获取请假待审核列表-视讯
    ${sessionId}    登陆获取sessionIDvideo
    #撤回加班申请
    ${undo}    Create Dictionary    leaveId=${leaveId}    leaveTypeId=2    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_cancel_apply.html}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200

发起请假-video
    ${sessionId}    登陆获取sessionIDvideo
    ${startTime}    获取当前时间YYYYMMDDHHmmSS
    ${endTime}    Add Time To date    ${startTime}    +2Days    result_format=%Y%m%d%H%M%S
    ${leaveTime}    Create Dictionary    startTime=${startTime}    endTime=${endTime}    days=2
    ${timeList}    Create List    ${leaveTime}
    ${typeId}    Set Variable    2
    ${leavetimeDic}    Create Dictionary    timeList=${timeList}    reason=${reason_variable}    typeId=${typeId}
    log    ${leavetimeDic}
    #josn字符转化成Dictionary
    ${leavetime_json}    evaluate    json.dumps(${leavetimeDic})    json
    log    ${leavetime_json}
    ${leavetime_AES}    AES加密    ${leavetime_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_video_apply.html}?sessionId=${sessionId}    ${leavetime_AES}
    ${returnInfo}    AES解密    ${return_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200
    [Return]    ${startTime}    ${endTime}

新增/更新活动v2.5.4
    ${sessionId}    登陆获取sessionID
    ${activityName}    CommonLibrary Random Number    1    100    2
    ${startTime_activity}    获取当前时间且后延时间
    ${endTime_activity}    Add Time To date    ${startTime_activity}    +02:00:00    result_format=%Y%m%d%H%M%S
    ${activityAddress}    Set Variable    成功咪咕音乐
    ${activityDescription}    Set Variable    活动在咪咕音乐
    ${activityAddressDetail}    Set Variable    中海国际J座大堂
    ${activityScore}    Set Variable    10
    ${isAll}    Set Variable    0
    ${userIdList}    Create List    7    12
    ${applylist}    Create Dictionary    auditorId=${auditorId_tsg}    latitude=${latitude}    activityName=${activityName}    startTime=${startTime_activity}    endTime=${endTime_activity}
    ...    activityAddress=${activityAddress}    activityDescription=${activityDescription}    activityAddressDetail=${activityAddressDetail}    longitude=${longitude}    activityScore=${activityScore}    isAll=${isAll}
    ...    userIdList=${userIdList}
    log    ${applylist}
    #josn字符转化成Dictionary
    ${applylist_json}    evaluate    json.dumps(${applylist})    json
    ${applylist_AES}    AES加密    ${applylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_activity_saveActivity.html}?sessionId=${sessionId}    ${applylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${returncode}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${returncode}    200

审核活动\v2.5.4
    ${activityId}    ${orderId}    ${taskId}    TSG审批人获取活动待审列表
    ${sessionId}    登陆获取领导账号sessionID
    ${decisionId}    Set Variable    2
    ${querylist}    Create Dictionary    reason=${reason_variable}    orderId=${orderId}    taskId=${taskId}    decisionId=${decisionId}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_activity_approval.html}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200
    [Return]    ${activityId}

TSG审批人获取活动待审列表
    ${sessionId}    登陆获取领导账号sessionID
    ${professionType_activity}    Set Variable    TSG_MYDEAL_ACTIVITY
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_activity}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${activityId}    Get From Dictionary    ${list[0]}    professionId
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${activityId}    ${orderId}    ${taskId}

TSG 撤销活动
    ${activityId}    TSG申请人获取待审核列表
    ${sessionId}    登陆获取sessionID
    #撤回活动申请
    ${undo}    Create Dictionary    activityId=${activityId}    reason=${reason_variable}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_activity_activityRevoke.html}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Comment    Should Be Equal As Numbers    ${returnInfo["code"]}    200

TSG申请人获取待审核列表
    ${sessionId}    登陆获取sessionID
    ${professionType_activity}    Set Variable    TSG_MYCREATE_ACTIVITY
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_activity}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_mycreateGetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${activityId}    Get From Dictionary    ${list[0]}    professionId
    [Return]    ${activityId}

TSG发布活动
    ${sessionId}    登陆获取sessionID
    ${activityId}    审核活动\v2.5.4
    ${applylist}    Create Dictionary    activityId=${activityId}
    log    ${applylist}
    #josn字符转化成Dictionary
    ${applylist_json}    evaluate    json.dumps(${applylist})    json
    ${applylist_AES}    AES加密    ${applylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_doPublish.html}?sessionId=${sessionId}    ${applylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${returncode}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${returncode}    200
    [Return]    ${activityId}

视讯请假申请v2.5.4
    ${sessionId}    登陆获取sessionIDvideo
    ${startTime}    获取当前时间YYYYMMDDHHmmSS
    ${endTime}    Add Time To date    ${startTime}    +2Days    result_format=%Y%m%d%H%M%S
    ${leaveTime}    Create Dictionary    startTime=${startTime}    endTime=${endTime}    days=2
    ${timeList}    Create List    ${leaveTime}
    ${typeId}    Set Variable    2
    ${leavetimeDic}    Create Dictionary    timeList=${timeList}    reason=${reason_variable}    typeId=${typeId}
    log    ${leavetimeDic}
    #josn字符转化成Dictionary
    ${leavetime_json}    evaluate    json.dumps(${leavetimeDic})    json
    log    ${leavetime_json}
    ${leavetime_AES}    AES加密    ${leavetime_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_leave_video_all_apply.html}?sessionId=${sessionId}    ${leavetime_AES}
    ${returnInfo}    AES解密    ${return_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200
    [Return]    ${startTime}    ${endTime}

审核人获取请假待审核列表-视讯2.5.4
    ${sessionId}    登陆获取领导账号sessionID_Video
    ${professionType_Leave}    Set Variable    VIDEO_MYDEAL_LEAVE
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_Leave}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${leaveId}    Get From Dictionary    ${list[0]}    professionId
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${orderId}    ${taskId}

新增/更新活动-领取活动v2.5.4
    ${sessionId}    登陆获取sessionID
    ${activityName}    CommonLibrary Random Number    1    100    2
    ${NowTIme}    获取当前时间YYYYMMDDHHmmSS
    ${startTime_activity}    Add Time To date    ${NowTIme}    +00:00:06    result_format=%Y%m%d%H%M%S
    ${endTime_activity}    Add Time To date    ${startTime_activity}    +02:00:00    result_format=%Y%m%d%H%M%S
    ${activityAddress}    Set Variable    成功咪咕音乐
    ${activityDescription}    Set Variable    活动在咪咕音乐
    ${activityAddressDetail}    Set Variable    中海国际J座大堂
    ${activityScore}    Set Variable    10
    ${isAll}    Set Variable    0
    ${userIdList}    Create List    7    12
    ${applylist}    Create Dictionary    auditorId=${auditorId_tsg}    latitude=${latitude}    activityName=${activityName}    startTime=${startTime_activity}    endTime=${endTime_activity}
    ...    activityAddress=${activityAddress}    activityDescription=${activityDescription}    activityAddressDetail=${activityAddressDetail}    longitude=${longitude}    activityScore=${activityScore}    isAll=${isAll}
    ...    userIdList=${userIdList}
    log    ${applylist}
    #josn字符转化成Dictionary
    ${applylist_json}    evaluate    json.dumps(${applylist})    json
    ${applylist_AES}    AES加密    ${applylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_activity_saveActivity.html}?sessionId=${sessionId}    ${applylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${returncode}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${returncode}    200

视讯审批人审批请假为同意
    ${orderId}    ${taskId}    审核人获取请假待审核列表-视讯2.5.4
    ${sessionId}    登陆获取领导账号sessionID_Video
    ${querylist}    Create Dictionary    reason=同意    decisionId=2    orderId=${orderId}    taskId=${taskId}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_Leave_video_all_approval.html}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${returnInfo_code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${returnInfo_code}    200

审核人获取请假同意列表-视讯2.5.4
    ${sessionId}    登陆获取领导账号sessionID_Video
    ${professionType_Leave}    Set Variable    VIDEO_MYDEAL_LEAVE
    ${querylist}    Create Dictionary    status=1    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_Leave}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${leaveId}    Get From Dictionary    ${list[0]}    professionId
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${leaveId}

视讯加载销假列表
    ${sessionId}    登陆获取sessionIDvideo
    ${querylist}    Create Dictionary    pageNum=${pageNum}    pageSize=${pageSize}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_video_cancel_queryList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${leaveId}    Get From Dictionary    ${data[0]}    leaveId
    ${leaveTypeId}    Get From Dictionary    ${data[0]}    leaveTypeId
    ${startTime}    Get From Dictionary    ${data[0]}    startTime
    ${endTime}    Get From Dictionary    ${data[0]}    endTime
    ${days}    Get From Dictionary    ${data[0]}    days
    ${reason}    Get From Dictionary    ${data[0]}    reason
    ${cancelStartTime}    Get From Dictionary    ${data[0]}    cancelStartTime
    ${cancelEndTime}    Get From Dictionary    ${data[0]}    cancelEndTime
    ${cancelDays}    Get From Dictionary    ${data[0]}    cancelDays
    ${isMend}    Get From Dictionary    ${data[0]}    isMend
    [Return]    ${leaveId}    ${leaveTypeId}    ${startTime}    ${endTime}    ${days}    ${reason}
    ...    ${cancelStartTime}    ${cancelEndTime}    ${cancelDays}    ${isMend}

撤回销假-视讯
    ${revokeReason}    Set Variable    RF撤销销假
    ${cancelId}    Video申请人获取销假待审核列表
    ${sessionId}    登陆获取sessionIDvideo
    ${undo}    Create Dictionary    cancelId=${cancelId}    revokeReason=${revokeReason}
    log    ${undo}
    #josn字符转化成Dictionary
    ${undo_json}    evaluate    json.dumps(${undo})    json
    log    ${undo_json}
    ${undo_AES}    AES加密    ${undo_json}
    ${undo_AES}    发送请求_post    ${KQ_URL}${KQ_leave_video_cancel_revoke}?sessionId=${sessionId}    ${undo_AES}
    ${returnInfo}    AES解密    ${undo_AES}
    Should Be Equal As Numbers    ${returnInfo["code"]}    200

Video申请人获取销假待审核列表
    ${sessionId}    登陆获取sessionIDvideo
    ${professionType_LCANCEL}    Set Variable    VIDEO_MYCREATE_LCANCEL
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_LCANCEL}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_mycreateGetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${cancelId}    Get From Dictionary    ${list[0]}    professionId
    [Return]    ${cancelId}

Video申请人发起销假申请
    ${leaveId}    ${leaveTypeId}    ${startTime}    ${endTime}    ${days}    ${reason}    ${cancelStartTime}
    ...    ${cancelEndTime}    ${cancelDays}    ${isMend}    视讯加载销假列表
    ${sessionId}    登陆获取sessionIDvideo
    ${cancelReason}    Set Variable    销假哒
    ${applylist}    Create Dictionary    leaveId=${leaveId}    leaveTypeId=${leaveTypeId}    startTime=${startTime}    cancelEndTime=${cancelEndTime}    days=${days}
    ...    reason=${reason}    cancelStartTime=${cancelStartTime}    cancelEndTime=${cancelEndTime}    cancelDays=${cancelDays}    isMend=${isMend}    cancelReason=${cancelReason}
    ...    endTime=${endTime}
    log    ${applylist}
    #josn字符转化成Dictionary
    ${applylist_json}    evaluate    json.dumps(${applylist})    json
    ${applylist_AES}    AES加密    ${applylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_leave_video_cancel_apply}?sessionId=${sessionId}    ${applylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${return_code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${return_code}    200
    [Return]    ${leaveId}

视讯审核人获取销假待审核列表
    ${sessionId}    登陆获取领导账号sessionID_Video
    ${professionType_cancel}    Set Variable    VIDEO_MYDEAL_LCANCEL
    ${querylist}    Create Dictionary    status=${status_variable}    pageNum=${pageNum}    pageSize=${pageSize}    professionType=${professionType_cancel}
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_shenpi_myhandle_GetList}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${list}    Get From Dictionary    ${data}    list
    log    ${list}
    ${cancelId}    Get From Dictionary    ${list[0]}    professionId
    ${orderId}    Get From Dictionary    ${list[0]}    orderId
    ${taskId}    Get From Dictionary    ${list[0]}    taskId
    [Return]    ${orderId}    ${taskId}    ${cancelId}

查询未读考勤外勤条数
    ${sessionId}    登陆获取sessionID
    ${querylist}    Create Dictionary
    log    ${querylist}
    #josn字符转化成Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${querylist_AES}    AES加密    ${querylist_json}
    ${return_AES}    发送请求_post    ${KQ_URL}${KQ_queryUnreadNum}?sessionId=${sessionId}    ${querylist_AES}
    ${returnInfo}    AES解密    ${return_AES}
    ${officework}    Get From Dictionary    ${returnInfo}    officework
    log    ${officework}
    ${mobilework}    Get From Dictionary    ${returnInfo}    mobilework
    log    ${mobilework}
    [Return]    ${officework}    ${mobilework}

视讯请假增加调休时间
    Connect To Database Using Custom Params    pymysql    ${KQ_SQL_CONN_DEL}    #链接数据库
    Execute Sql String    UPDATE users set surplus=2000,score=4000 where tel='${tel_video}'
    log    重置调休时间成功

data中设置sessionid参数
    [Arguments]    ${data}    ${sessionId}    ${url}
    ${res_data}    AES解密    ${data}
    Set To Dictionary    ${res_data}    sessionId=${sessionId}
    ${res_data1}    AES加密    ${res_data}
    Set Test Variable    ${res_data2}    ${res_data1}
