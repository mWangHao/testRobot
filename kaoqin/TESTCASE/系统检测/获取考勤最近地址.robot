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
    log	${latitude}    
