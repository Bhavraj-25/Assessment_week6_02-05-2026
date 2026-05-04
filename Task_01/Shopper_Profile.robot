*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../Auth/Bearer_Token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Shopper_login
    Create Session    shopper_session    ${BASE_URL}    verify=False
    
    ${payload}=  Create Dictionary
    ...  email=${USER_EMAIL}
    ...  password=${USER_PASSWORD}
    ...  role=${USER_ROLE}
    
    ${response}=  POST On Session    shopper_session    /users/login    json=${payload}
    
    Log To Console    ${payload}
    Log To Console    ${response.text}
    
    Should Be Equal As Integers    ${response.status_code}  200
    
    ${body}=  Set Variable  ${response.json()}
    
    ${fetched_email}=  Get From Dictionary  ${body}[data]  email
    Should Be Equal  ${fetched_email}  ${USER_EMAIL}

Find Shopper data by shopperID
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}

    ${response}=  GET On Session  shopper_session  /shoppers/${SHOPPER_ID}  headers=${header}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

Update the shopper Details
    [Documentation]  Test case to verify updating shopper details.
    Create Session    shopper_session    ${BASE_URL}    verify=False

    ${header}=  Create Dictionary    Authorization=Bearer ${token}

    ${payload}=  Create Dictionary
    ...  city=jaipur
    ...  country=india
    ...  email=${USER_EMAIL}
    ...  firstName=firstname
    ...  gender=MALE
    ...  lastName=lastname
    ...  password=********
    ...  phone=9876543210
    ...  state=rajasthan
    ...  zoneId=ALPHA

    ${response}=  PATCH On Session  shopper_session  /shoppers/${SHOPPER_ID}  headers=${header}  json=${payload}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}