*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../Auth/Bearer_Token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get All Product from Cart
    [Documentation]    Get all the products from cart
    Create Session    shopper_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}

    ${response}=  GET On Session  shopper_session  /shoppers/${SHOPPER_ID}/carts  headers=${header}

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

    Should Be Equal As Integers  ${response.status_code}  200

Add Product to Cart
    [Documentation]    Add a product to cart
    Create Session  shopper_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${payload}=  Create Dictionary
    ...  productId=83
    ...  quantity=1
    
    ${response}=  POST On Session  shopper_session  /shoppers/${SHOPPER_ID}/carts  headers=${header}  json=${payload}
    
    ${body}=  Set Variable  ${response.json()}
    ${PRODUCT_ID}=   Get From Dictionary    ${body}[data]    productId
    ${data}=      Get From Dictionary    ${body}    data
    ${ITEM_ID}=   Get From Dictionary    ${data}    itemId
    Set Suite Variable    ${ITEM_ID}
    
    Should Be Equal As Integers    ${response.status_code}  201
    Log To Console    ${response.text}
    Log To Console    ${body}

Update Product in Cart
    [Documentation]    Update the quantity of a product in cart
    Create Session  shopper_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${payload}=  Create Dictionary
    ...  quantity=2

    ${response}=  PUT On Session  shopper_session  /shoppers/${SHOPPER_ID}/carts/${ITEM_ID}  headers=${header}  json=${payload}
    Should Be Equal As Integers    ${response.status_code}  200
    Log To Console    ${response.text}
    
Delete Product from Cart
    [Documentation]    Delete a product from cart
    Create Session  shopper_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    
    ${response}=  DELETE On Session  shopper_session  /shoppers/${SHOPPER_ID}/carts/${PRODUCT_ID}  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  200