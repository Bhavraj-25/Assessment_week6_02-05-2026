*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../Auth/Bearer_Token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get Shopper Address
    [Documentation]    Getting all the address
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}

    ${response}=  GET On Session    shopper_session    /shoppers/${SHOPPER_ID}/address    headers=${header}
    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}

Post Shopper Address
    [Documentation]    Adding new address for the shopper
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    
    ${payload}=  Create Dictionary
    ...  addressId=101
    ...  buildingInfo=5floor
    ...  city=jaipur
    ...  country=india
    ...  landmark=string
    ...  name=firstname
    ...  phone=string
    ...  pincode=string
    ...  state=rajasthan
    ...  streetInfo=string
    ...  type=string
    
    ${response}=  POST On Session    shopper_session    /shoppers/${SHOPPER_ID}/address    headers=${header}    json=${payload}

    Log To Console    ${response.text}
    Should Be Equal As Integers    ${response.status_code}  201

    ${body}=    Set Variable    ${response.json()}
    ${ADDRESS_ID}=  Get From Dictionary    ${body}[data]    addressId

    Log To Console    ${ADDRESS_ID}
    Set Suite Variable    ${ADDRESS_ID}

Get Address by addressId
    [Documentation]    Get a particular address by addressId
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    
    ${response}=    GET On Session    shopper_session    /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}    headers=${header}
    
    Should Be Equal As Integers    ${response.status_code}    200

Update Address
    [Documentation]    Update an added address
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}
    
    ${payload}=  Create Dictionary
    ...  addressId=101
    ...  buildingInfo=6floor
    ...  city=jaipur
    ...  country=india
    ...  landmark=neem park
    ...  name=firstname
    ...  phone=string
    ...  pincode=100090
    ...  state=rajasthan
    ...  streetInfo=jln road
    ...  type=string
    
    ${response}=    PUT On Session    shopper_session    /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}    headers=${header}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    
    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}
    
Delete Address
    [Documentation]    Delete an added address
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}
    
    ${response}=    DELETE On Session    shopper_session    /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}    headers=${header}
    Should Be Equal As Integers    ${response.status_code}    204