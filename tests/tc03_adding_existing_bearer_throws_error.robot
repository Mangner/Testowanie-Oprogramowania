*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC03 Verify Adding Existing Bearer Throws Error
    [Tags]    bearer
    [Setup]    Attach UE-2
    Device UE-2 Should Have Default Transport Channel
    Run Keyword And Expect Error    *    Add Bearer-9 To UE-2
    [Teardown]    Detach UE-2
