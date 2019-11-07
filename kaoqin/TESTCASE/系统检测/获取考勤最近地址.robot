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
    log ${latitude}