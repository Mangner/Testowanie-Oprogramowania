*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC03 Verify Adding Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-1
    Add Bearer-1 To UE-1
    Verify Bearer-1 Is Active On UE-1
    [Teardown]    Detach UE-1

TC04 Verify Adding Existing Bearer Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-2
    Device UE-2 Should Have Default Transport Channel
    Run Keyword And Expect Error    *    Add Bearer-9 To UE-2
    [Teardown]    Detach UE-2

TC05 Verify Adding Bearer Out Of Range Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-3
    Run Keyword And Expect Error    *    Add Bearer-10 To UE-3
    [Teardown]    Detach UE-3

TC06 Verify Checking Active Bearers
    [Tags]    bearer    positive
    [Setup]    Attach UE-4
    Add Bearer-2 To UE-4
    ${active_bearers}=    Get Active Bearers For UE-4
    List Should Contain Value    ${active_bearers}    ${9}
    List Should Contain Value    ${active_bearers}    ${2}
    [Teardown]    Detach UE-4

TC07 Verify Removing Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-5
    Add Bearer-3 To UE-5
    Remove Bearer-3 From UE-5
    Verify Bearer-3 Is Not Active On UE-5
    [Teardown]    Detach UE-5

TC08 Verify Removing Default Bearer Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-6
    Run Keyword And Expect Error    *    Remove Bearer-9 From UE-6
    [Teardown]    Detach UE-6

TC09 Verify Removing Inactive Bearer Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-7
    Run Keyword And Expect Error    *    Remove Bearer-4 From UE-7
    [Teardown]    Detach UE-7
