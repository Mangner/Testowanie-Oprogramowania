*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC01 Verify Successful UE Detach
    [Tags]    detach    positive
    [Setup]    Attach UE-20
    Detach UE-20
    Verify UE-20 Is Not Attached

TC02 Verify Detaching Unattached UE Throws Error
    [Tags]    detach    negative
    Run Keyword And Expect Error    *    Detach UE-30
