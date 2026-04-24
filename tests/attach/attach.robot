*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC01 Verify Successful UE Attach
    [Tags]    attach    positive
    Attach UE-15
    Verify UE-15 Is Attached
    Device UE-15 Should Have Default Transport Channel
    [Teardown]    Detach UE-15

TC02 Verify Attaching Out Of Range UE Throws Error
    [Tags]    attach    negative
    Run Keyword And Expect Error    *422 Client Error*    Attach UE-101

TC03 Verify Attaching Already Attached UE Throws Error
    [Tags]    attach    negative
    [Setup]    Attach UE-16
    Run Keyword And Expect Error    *400 Client Error*    Attach UE-16
    [Teardown]    Detach UE-16

TC04 Verify Attaching Below Range UE Throws Error
    [Tags]    attach    negative
    Run Keyword And Expect Error    *422 Client Error*    Attach UE-0

TC05 Verify Successful UE Detach
    [Tags]    detach    positive
    [Setup]    Attach UE-20
    Detach UE-20
    Verify UE-20 Is Not Attached