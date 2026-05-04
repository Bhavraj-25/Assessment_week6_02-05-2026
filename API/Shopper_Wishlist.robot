*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../Auth/Bearer_Token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get Shopper Wishlist
    [Documentation]    Get all the products from wishlist
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}
        
    ${response}=    GET On Session    shopper_session    /shoppers/${SHOPPER_ID}/wishlist    headers=${header}
    
    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}

    Should Be Equal As Integers    ${response.status_code}    200

Add Product to Wishlist
    [Documentation]    Add a product to wishlist
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}

    ${payload}=    Create Dictionary
    ...  productId=79
    ...  quantity=1

    ${response}=    POST On Session    shopper_session    /shoppers/${SHOPPER_ID}/wishlist    headers=${header}    json=${payload}
    Log To Console    ${response.text}

    ${body}=    Set Variable    ${response.json()}
    ${PRODUCT_ID}=  Get From Dictionary    ${body}[data]    productId
    Should Be Equal As Integers    ${response.status_code}    201

    Log To Console    ${PRODUCT_ID}
    Set Suite Variable    ${PRODUCT_ID}

Delete Product
    [Documentation]    Delete a product from wishlist
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}
    
    ${response}=    DELETE On Session    shopper_session    /shoppers/${SHOPPER_ID}/wishlist/${PRODUCT_ID}    headers=${header}
    Should Be Equal As Integers    ${response.status_code}    204