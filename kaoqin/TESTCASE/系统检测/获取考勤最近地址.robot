*** Settings ***
Documentation     获取考勤最近地址接口
Test Template     模版
Resource          ../../关键字/通用/common.robot

*** Test Cases ***    latitude     longitude    return_code
001_获取考勤最近地址_返回码200
                      30.581486    104.04722    ${KQ_code_200}

002_latitude为空_返回码424
                      \            104.04722    ${KQ_code_424}

003_longitude为空_返回码424
                      \            30.581486    ${KQ_code_424}

*** Keywords ***
模版
    [Arguments]    ${latitude}    ${longitude}    ${return_code}
    ${req_date_str}    数据格式
    ${sessionId}    登陆获取sessionID
    ${req_data_final}    数据预处理    ${req_date_str}    ${latitude}    ${longitude}
    ${res_data}    发送请求_post    ${KQ_URL}${KQ_nearKqAddress}?sessionId=${sessionId}    ${req_data_final}
    数据后处理    ${res_data}    ${return_code}

数据预处理
    [Arguments]    ${req_data_str}    ${latitude}    ${longitude}
    ${req_data_dict}    json.loads    ${req_data_str}
    #step2: 改变字典value的值
    Set To Dictionary    ${req_data_dict}    latitude=${latitude}
    Set To Dictionary    ${req_data_dict}    longitude=${longitude}
    log    ${req_data_dict}
    #step3：对传入信息加密
    ${req_data_aes}    AES加密    ${req_data_dict}
    [Return]    ${req_data_aes}

数据格式
    ${data}    Set Variable    {"latitude":"30.581486","longitude":"104.04722"}
    [Return]    ${data}

数据后处理
    [Arguments]    ${res_data}    ${return_code}
    #step1: 解密
    ${res_data}    AES解密    ${res_data}
    #step2: 验证返回码
    Should Be Equal As Numbers    ${res_data["code"]}    ${return_code}
    #step3: 查询mysql验证返回数据
