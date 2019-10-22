*** Settings ***
Documentation     测试考勤接口
Test Template     模版
Resource          ../../关键字/通用/common.robot

*** Test Cases ***    latitude           longitude                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        return_code
001_获取考勤最近地址_返回码200
                      [Documentation]    *用例名称* 001_获取考勤最近地址_成功返回码200\n\n*用例编号* KQ_hqkqzjdz_001\n\n*用例版本* V2.4.0\n\n*用例级别* P1\n\n*用例类型* 自动化测试\n\n*用例作者* wanghao\n\n*前置条件*\n\n*操作步骤*\n\n请求数据：\nHead:"sessionId": "123123123",\nBody:\n{\n \ \ \ \ \ "latitude" : "31.587772", \ \ \ \ 必传经纬度\n \ "longitude" : "104.0537"\n}\n\n\n*预期结果*\n\n返回数据\\n{\n \ "code" : 200,\n \ "remark" : "成功",\n \ "nearKqAddress" : [ {\n \ \ \ "addressName" : "青岛海信智能商用系统股份有限公司", \ \ \ \ \ 地址名称\n \ \ \ "distance" : 100867 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 当前位置距最近考勤地址的距离\n \ } ]\n}
                      30.581486          104.04722                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ${KQ_code_200}

002_latitude为空_返回码424
                      [Documentation]    *用例名称* 002_latitude_返回码424\n\n*用例编号* KQ_hqkqzjdz_002\n\n*用例版本* V2.4.0\n\n*用例级别* P1\n\n*用例类型* 自动化测试\n\n*用例作者* wanghao\n\n*前置条件*\n\n*操作步骤*\n\n请求数据：\nHead:"sessionId": "123123123",\nBody:\n{\n \ \ \ \ \ "latitude" : "31.587772", \ \ \ \ 必传经纬度\n \ "longitude" : "104.0537"\n}\n\n\n*预期结果*\n\n返回数据\\n{\n \ "code" : 200,\n \ "remark" : "成功",\n \ "nearKqAddress" : [ {\n \ \ \ "addressName" : "青岛海信智能商用系统股份有限公司", \ \ \ \ \ 地址名称\n \ \ \ "distance" : 100867 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 当前位置距最近考勤地址的距离\n \ } ]\n}
                      \                  104.04722                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ${KQ_code_424}

003_longitude为空_返回码424
                      [Documentation]    *用例名称* 003_longitude_返回码424\n\n*用例编号* KQ_hqkqzjdz_003\n\n*用例版本* V2.4.0\n\n*用例级别* P1\n\n*用例类型* 自动化测试\n\n*用例作者* wanghao\n\n*前置条件*\n\n*操作步骤*\n\n请求数据：\nHead:"sessionId": "123123123",\nBody:\n{\n \ \ \ \ \ "latitude" : "31.587772", \ \ \ \ 必传经纬度\n \ "longitude" : "104.0537"\n}\n\n\n*预期结果*\n\n返回数据\\n{\n \ "code" : 200,\n \ "remark" : "成功",\n \ "nearKqAddress" : [ {\n \ \ \ "addressName" : "青岛海信智能商用系统股份有限公司", \ \ \ \ \ 地址名称\n \ \ \ "distance" : 100867 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 当前位置距最近考勤地址的距离\n \ } ]\n}
                      \                  30.581486                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ${KQ_code_424}

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
