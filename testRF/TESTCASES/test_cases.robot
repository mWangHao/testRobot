*** Settings ***
Resource          ../KEYWORDS/common.robot

*** Test Cases ***
001_乘法
    ${a}    Set Variable    2
    ${b}    Set Variable    3
    Should Be Equal As Numbers    ${${a}*${b}}    6

002_搜索
    ${url}    Set Variable    https://www.baidu.com
    ${param}    Set Variable    wd=a
    ${redata_dic}    get_请求    ${url}    ${param}
    Should Contain    ${redata_dic.text}    a
