*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC21 Verify Resetting Simulator
    [Tags]    system    positive
    [Setup]    Attach UE-13
    Reset EPC Network Simulator
    Verify UE-13 Is Not Attached

TC22 Verify UE List Is Updated After Detach
    [Tags]      system    regression
    [Setup]     Reset EPC Network Simulator
    Attach UE-34
    Attach UE-35
    Detach UE-34
    Attached UE List Should Not Contain UE-34
    Attached UE List Should Contain UE-35
    [Teardown]  Reset EPC Network Simulator

TC23 Verify Global Stats Counters Actively Track Resources
    [Tags]    system  regression
    [Setup]   Attach UE-80
    Add Bearer-1 To UE-80
    Global Bearer Count Should Be Greater Than Zero
    [Teardown]    Detach UE-80
