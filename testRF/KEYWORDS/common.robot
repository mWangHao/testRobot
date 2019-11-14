*** Settings ***
Library           requests
Resource          ../RESOURCES/global.robot
Resource          ../RESOURCES/interface_url.robot
Library           json

*** Keywords ***
get_请求
    [Arguments]    ${url}    ${param}
    ${url_final}    Set Variable    ${url}?${param}
    ${redata}    requests.Get    url=${url_final}    headers=&{headers}
    [Return]    ${redata}
