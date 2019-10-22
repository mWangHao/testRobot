*** Settings ***
Library           requests
Library           json
Library           base64
Library           migu_library
Resource          ../../RESOURCE/global.robot
Resource          ../../RESOURCE/interface_url.robot
Library           Collections
Library           RequestsLibrary
Library           pymysql
Resource          ../../RESOURCE/return.robot
Library           DateTime
Resource          ../../RESOURCE/User_Defined.robot
Library           DatabaseLibrary
Resource          ../../RESOURCE/manager_Defined.robot

*** Keywords ***
登录获取sessionId-后台
    ${KQ_login_account}    Set Variable    /login/account.html
    ${login}    Create Dictionary    tel=${tel_attendmanage}    password=${password}
    log    ${login}
    #Dictionary转json
    ${login_json}    evaluate    json.dumps(${login})    json
    log    ${login_json}
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_login_account}    ${login_json}
    #json转Dictionary
    ${res_data_dict}    json.Loads    ${return_data}
    ${data}    Get From Dictionary    ${res_data_dict}    data
    ${sessionId}    Get From Dictionary    ${data}    sessionId
    log    ${sessionId}
    [Return]    ${sessionId}

新增代码表_后台
    ${sessionId}    登录获取sessionId-后台
    ${KQ_doSaveKqCode}    Set Variable    /code/doSaveKqCode.html
    ${querylist}    Create Dictionary    fieldName=${fieldName}    orderId=${orderId}    codeName=${codeName}    belongTable=${belongTable}    remark=${remark}
    ...    codeValue=${codeValue}    isDisable=${isDisable}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_doSaveKqCode}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

代码表查询get_codeId
    [Arguments]    ${fieldName}    ${belongTable}    # 更新代码表等都需用到
    ${sessionId}    登录获取sessionId-后台
    ${KQ_getKqCodeByTable}    Set Variable    /code/getKqCodeByTable.html
    ${querylist}    Create Dictionary    fieldName=${fieldName}    belongTable=${belongTable}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_getKqCodeByTable}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${data}    Get From Dictionary    ${returnInfo}    data
    log    ${data}
    ${codeId}    Get From Dictionary    ${data[0]}    codeId
    [Return]    ${codeId}

发送请求_post
    [Arguments]    ${url}    ${data}
    log    ${url}
    ${res}    CommonLibrary_httpInterface_post_form    ${url}    ${data}
    log    ${res}
    [Return]    ${res}

删除代码表_后台
    [Arguments]    ${fieldName}    ${belongTable}
    ${codeId}    代码表查询get_codeId    ${fieldName}    ${belongTable}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_doDelKqCode}    Set Variable    /code/doDelKqCode.html
    ${codeIdList}    Create List    ${codeId}
    ${querylist}    Create Dictionary    codeIdList=${codeIdList}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_doDelKqCode}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

新增菜单
    ${sessionId}    登录获取sessionId-后台
    ${KQ_doSaveMenu}    Set Variable    /menu/doSaveMenu.html
    ${querylist}    Create Dictionary    menuName=${menuName}    menuUrl=${menuUrl}    orderId=${orderId_menu}    selectMenuId=${selectMenuId}    increaseTo=${increaseTo}
    ...    remark=${remark}    isDisable=${isDisable}    selectMenuName=${selectMenuName}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_doSaveMenu}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    ${data}    Get From Dictionary    ${returnInfo}    data
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}
    [Return]    ${data}

删除菜单
    [Arguments]    ${menuId}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_menu_doDelMenu}    Set Variable    /menu/doDelMenu.html
    ${querylist}    Create Dictionary    menuId=${menuId}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_menu_doDelMenu}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

删除考勤地址
    [Arguments]    ${addressId}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_doDelAddress}    Set Variable    /address/doDelAddress.html
    ${addressIdList}    Create List    ${addressId}
    ${querylist}    Create Dictionary    addressIdList=${addressIdList}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_doDelAddress}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

新增考勤地址
    ${sessionId}    登录获取sessionId-后台
    ${KQ_doSaveAddress}    Set Variable    /address/doSaveAddress.html
    ${querylist}    Create Dictionary    city=${city}    expTime=${expTime}    latitude=${latitude}    selectMenuId=${selectMenuId}    county=${county}
    ...    remark=${remark}    type=${type}    isDisable=${isDisable}    companyId=${companyId}    addressDetail=${addressDetail}    province=${province}
    ...    scope=${scope}    addressName=${addressName}    effTime=${effTime}    longitude=${longitude}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_doSaveAddress}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    ${data}    Get From Dictionary    ${returnInfo}    data
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}
    [Return]    ${data}

删除FAQ
    [Arguments]    ${faqId}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_faq_doDelFaq}    Set Variable    /faq/doDelFaq.html
    ${faqIdList}    Create List    ${faqId}
    ${querylist}    Create Dictionary    faqIdList=${faqIdList}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_faq_doDelFaq}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

新增FAQ
    ${sessionId}    登录获取sessionId-后台
    ${KQ_faq_doSaveFaq}    Set Variable    /faq/doSaveFaq.html
    ${querylist}    Create Dictionary    isDisable=${isDisable}    question=${question}    answer=${answer}    companyId=${companyId}    id=${id}
    ...    type=${type}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_faq_doSaveFaq}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    ${data}    Get From Dictionary    ${returnInfo}    data
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}
    [Return]    ${data}

删除组织
    [Arguments]    ${companyId}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_company_doDelKqCompany}    Set Variable    /company/doDelKqCompany.html
    ${querylist}    Create Dictionary    companyId=${companyId}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_company_doDelKqCompany}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

新增组织
    ${sessionId}    登录获取sessionId-后台
    ${KQ_company_doSaveKqCompany}    Set Variable    /company/doSaveKqCompany.html
    ${querylist}    Create Dictionary    isDisable=1    increaseTo=1    expTime=20191208105300    companyName=测试接口TSET    assistantUserId=40198
    ...    effTime=20190104105300    remark=测试接口需要    type=3    principalUserId=40198    selectCompanyId=1
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_company_doSaveKqCompany}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    ${data}    Get From Dictionary    ${returnInfo}    data
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}
    [Return]    ${data}

删除用户
    [Arguments]    ${searchName}
    ${userId}    查询用户userId    ${searchName}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_user_doDelUser}    Set Variable    /user/doDelUser.html
    ${userIds}    Create List    ${userId}
    ${querylist}    Create Dictionary    userIds=${userIds}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_user_doDelUser}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

查询用户userId
    [Arguments]    ${searchName}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_user_searchUser}    Set Variable    /user/searchUser.html
    ${querylist}    Create Dictionary    searchName=${searchName}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_user_searchUser}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${data}    Get From Dictionary    ${returnInfo}    data
    ${userId}    Get From Dictionary    ${data[0]}    userid
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}
    [Return]    ${userId}

新增用户
    ${sessionId}    登录获取sessionId-后台
    ${KQ_user_doSaveUser}    Set Variable    /user/doSaveUser.html
    ${relates_dic}    Create Dictionary    companyId=15    isDefault=1
    ${relates}    Create List    ${relates_dic}
    ${roleIds}    Create List    2
    ${firstApproval}    Create List    2
    ${twoApproval}    Create List    2
    ${threeApproval}    Create List    2
    ${fourthApproval}    Create List    2
    ${querylist}    Create Dictionary    username=RFtest_jiekou    tel=12369854701    email=11@163.com    positionid=1    regionid=1
    ...    createtime=20190107    enable=1    empNum=89755    alias=89755    sex=1    entryTime=20190107
    ...    seniority=20    isLocalization=0    fromType=1    isOfficial=1    relates=${relates}    roleIds=${roleIds}
    ...    firstApproval=${firstApproval}    twoApproval=${twoApproval}    threeApproval=${threeApproval}    fourthApproval=${fourthApproval}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_user_doSaveUser}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

删除角色
    [Arguments]    ${roleId}
    ${sessionId}    登录获取sessionId-后台
    ${KQ_role_doDelRole}    Set Variable    /role/doDelRole.html
    ${querylist}    Create Dictionary    roleId=${roleId}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_role_doDelRole}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}

新增角色
    ${sessionId}    登录获取sessionId-后台
    ${KQ_role_doSaveRole}    Set Variable    /role/doSaveRole.html
    ${companyIds}    Set Variable    64
    ${companyIds}    Create List    ${companyIds}
    ${userInfos}    Create Dictionary    userid=40198    username=王皓-测试WEB    belongCompanyId=15
    ${userInfos}    Create List    ${userInfos}
    ${menuIds}    Set Variable    2
    ${menuIds}    Create List    ${menuIds}
    ${querylist}    Create Dictionary    roleName=测试接口TEST1    roleCode=tst    remark=tst    selectCompanyId=15    increaseTo=1
    ...    companyIds=${companyIds}    userInfos=${userInfos}    menuIds=${menuIds}
    log    ${querylist}
    #josn <-- Dictionary
    ${querylist_json}    evaluate    json.dumps(${querylist})    json
    ${return_data}    发送请求_post    ${KQ_attendmanage}${KQ_role_doSaveRole}?sessionId=${sessionId}    ${querylist_json}
    #josn --> Dictionary
    ${returnInfo}    json.Loads    ${return_data}
    ${data}    Get From Dictionary    ${returnInfo}    data
    ${code}    Get From Dictionary    ${returnInfo}    code
    Should Be Equal As Numbers    ${code}    ${KQ_code_200}
    [Return]    ${data}
