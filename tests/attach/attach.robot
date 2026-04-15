*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC16 Verify Successful UE Attach
    [Tags]    attach    positive
    Attach UE-15
    Verify UE-15 Is Attached
    Device UE-15 Should Have Default Transport Channel
    [Teardown]    Detach UE-15

TC17 Verify Attaching Out Of Range UE Throws Error
    [Tags]    attach    negative
    Run Keyword And Expect Error    *    Attach UE-101

TC18 Verify Attaching Already Attached UE Throws Error
    [Tags]    attach    negative
    [Setup]    Attach UE-16
    Run Keyword And Expect Error    *    Attach UE-16
    [Teardown]    Detach UE-16
