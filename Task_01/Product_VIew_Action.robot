*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../Auth/Bearer_Token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get Product Alpha
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}

    ${response}=  GET On Session    shopper_session    /products/alpha    headers=${header}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}