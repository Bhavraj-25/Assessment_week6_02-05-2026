*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${BASE_URL}  https://www.shoppersstack.com/shopping
${USER_EMAIL}    majej@gmail.com
${USER_PASSWORD}    ********
${USER_ROLE}    SHOPPER

*** Keywords ***
Get Bearer Token
    Create Session  auth_session    ${BASE_URL}    verify=False

    ${payload}=  Create Dictionary
    ...  email=${USER_EMAIL}
    ...  password=${USER_PASSWORD}
    ...  role=${USER_ROLE}
    
    ${response}=  POST On Session    auth_session    /users/login    json=${payload}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=  Set Variable    ${response.json()}
    ${token}=  Get From Dictionary    ${body}[data]    jwtToken
    ${user_id}=  Get From Dictionary    ${body}[data]    userId

    Set Suite Variable    ${token}
    Set Suite Variable    ${SHOPPER_ID}    ${user_id}

