*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC15 Verify Resetting Simulator
    [Tags]    system    positive
    [Setup]    Attach UE-13
    Reset EPC Network Simulator
    Verify UE-13 Is Not Attached

TC36 Verify Root Endpoint Returns Response
    [Tags]    system    positive
    Verify Root Endpoint Responds

TC37 Verify UE Stats Endpoint Returns Response
    [Tags]    system    positive
    Verify UE Stats Endpoint Responds

TC38 Verify Reset Clears All Attached UEs
    [Tags]    system    positive
    [Setup]    Run Keywords    Attach UE-88    AND    Attach UE-89
    Reset EPC Network Simulator
    ${ues}=    Get All Active UEs
    ${count}=    Get Length    ${ues}
    Should Be Equal As Integers    ${count}    0

TC56 Verify Stats UE Count Matches Number Of Attached UEs
    [Tags]    system    positive
    [Setup]    Reset EPC Network Simulator
    Attach UE-61
    Attach UE-62
    ${stats}=    Api Get Ues Stats
    ${ue_count}=    Get From Dictionary    ${stats}    ue_count
    Should Be Equal As Integers    ${ue_count}    2
    [Teardown]    Run Keywords    Detach UE-61    AND    Detach UE-62

TC57 Verify Stats Total TX BPS Is Zero Before Traffic Starts
    [Tags]    system    positive
    [Setup]    Attach UE-63
    ${stats}=    Api Get Ues Stats
    ${total_tx}=    Get From Dictionary    ${stats}    total_tx_bps
    Should Be Equal As Integers    ${total_tx}    0
    [Teardown]    Detach UE-63

TC59 Verify Stats Total TX BPS Is Positive During Active Traffic
    [Tags]    system    positive
    [Setup]    Attach UE-64
    Start DL Transfer On UE-64 Bearer-9 Speed 10 Mbps
    Sleep    0.3s
    ${stats}=    Api Get Ues Stats
    ${total_tx}=    Get From Dictionary    ${stats}    total_tx_bps
    Should Be True    ${total_tx} > 0
    [Teardown]    Detach UE-64
