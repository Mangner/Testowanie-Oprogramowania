*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC06 Verify Adding Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-1
    Add Bearer-1 To UE-1
    Verify Bearer-1 Is Active On UE-1
    [Teardown]    Detach UE-1

TC07 Verify Adding Existing Bearer Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-2
    Device UE-2 Should Have Default Transport Channel
    Run Keyword And Expect Error    *400 Client Error*    Add Bearer-9 To UE-2
    [Teardown]    Detach UE-2

TC08 Verify Adding Bearer Out Of Range Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-3
    Run Keyword And Expect Error    *422 Client Error*    Add Bearer-10 To UE-3
    [Teardown]    Detach UE-3

TC09 Verify Removing Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-5
    Add Bearer-3 To UE-5
    Remove Bearer-3 From UE-5
    Verify Bearer-3 Is Not Active On UE-5
    [Teardown]    Detach UE-5

TC10 Verify Removing Default Bearer Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-6
    Run Keyword And Expect Error    *400 Client Error*    Remove Bearer-9 From UE-6
    [Teardown]    Detach UE-6

TC11 Verify Removing Inactive Bearer Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-7
    Run Keyword And Expect Error    *400 Client Error*    Remove Bearer-4 From UE-7
    [Teardown]    Detach UE-7

TC12 Verify Adding Bearer Below Range Throws Error
    [Tags]    bearer    negative
    [Setup]    Attach UE-37
    Run Keyword And Expect Error    *422 Client Error*    Add Bearer-0 To UE-37
    [Teardown]    Detach UE-37

TC13 Verify Never Created Bearer Traffic Endpoint Returns Error
    [Tags]    bearer    negative
    Reset EPC Network Simulator
    Attach UE-34
    Run Keyword And Expect Error    *400 Client Error*|*422 Client Error*  Get Traffic Stats For UE-34 Bearer-5
    [Teardown]    Detach UE-34
