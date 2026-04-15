*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC02 Verify Adding Dedicated Bearer
    [Tags]    bearer
    [Setup]    Attach UE-1
    Add Bearer-1 To UE-1
    Verify Bearer-1 Is Active On UE-1
    [Teardown]    Detach UE-1
