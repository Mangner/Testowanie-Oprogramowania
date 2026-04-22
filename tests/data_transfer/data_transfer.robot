*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC10 Verify Starting Data Transfer
    [Tags]    transfer    positive
    [Setup]    Attach UE-8
    Start DL Transfer On UE-8 Bearer-9 Speed 50 Mbps
    Verify DL Transfer Is Active On UE-8 Bearer-9
    [Teardown]    Detach UE-8

TC13 Verify Checking Data Transfer
    [Tags]    transfer    positive
    [Setup]    Attach UE-11
    Add Bearer-2 To UE-11
    Start DL Transfer On UE-11 Bearer-9 Speed 10 Mbps
    Start DL Transfer On UE-11 Bearer-2 Speed 15 Mbps
    ${total_transfer}=    Get Total Transfer For UE-11 Unit Mbps
    [Teardown]    Detach UE-11

TC14 Verify Ending Specific Bearer Transfer
    [Tags]    transfer    positive
    [Setup]    Attach UE-12
    Start DL Transfer On UE-12 Bearer-9 Speed 40 Mbps
    End Transfer On UE-12 Bearer-9
    Verify No Transfer Is Active On UE-12 Bearer-9
    [Teardown]    Detach UE-12

TC32 Verify Starting UDP Transfer Succeeds
    [Tags]    transfer    positive
    [Setup]    Attach UE-84
    Start UDP Transfer On UE-84 Bearer-9 Speed 20 Mbps
    Verify DL Transfer Is Active On UE-84 Bearer-9
    [Teardown]    Detach UE-84

TC33 Verify Traffic Stats Are Accessible After Transfer Starts
    [Tags]    transfer    positive
    [Setup]    Attach UE-85
    Start DL Transfer On UE-85 Bearer-9 Speed 10 Mbps
    ${stats}=    Get Traffic Stats For UE-85 Bearer-9
    Should Not Be Equal    ${stats}    ${None}
    [Teardown]    Detach UE-85

TC34 Verify Traffic Stats Contain Positive Target BPS After Transfer
    [Tags]    transfer    positive
    [Setup]    Attach UE-86
    Start DL Transfer On UE-86 Bearer-9 Speed 5 Mbps
    ${stats}=    Get Traffic Stats For UE-86 Bearer-9
    ${target_bps}=    Get From Dictionary    ${stats}    target_bps
    Should Be True    ${target_bps} > 0
    [Teardown]    Detach UE-86

TC35 Verify Concurrent Transfers On Multiple Bearers
    [Tags]    transfer    positive
    [Setup]    Attach UE-87
    Add Bearer-1 To UE-87
    Start DL Transfer On UE-87 Bearer-9 Speed 10 Mbps
    Start DL Transfer On UE-87 Bearer-1 Speed 5 Mbps
    Verify DL Transfer Is Active On UE-87 Bearer-9
    Verify DL Transfer Is Active On UE-87 Bearer-1
    [Teardown]    Detach UE-87

TC48 Verify Start Traffic Response Status Is Traffic Started
    [Tags]    transfer    positive
    [Setup]    Attach UE-44
    ${body}=    Get Start Traffic Response Body For UE-44 Bearer-9 Speed 10 Mbps
    ${status}=    Get From Dictionary    ${body}    status
    Should Be Equal    ${status}    traffic_started
    [Teardown]    Detach UE-44

TC49 Verify Start Traffic Response Contains Correct Target BPS For Mbps
    [Tags]    transfer    positive
    [Setup]    Attach UE-45
    ${body}=    Get Start Traffic Response Body For UE-45 Bearer-9 Speed 10 Mbps
    ${target_bps}=    Get From Dictionary    ${body}    target_bps
    Should Be Equal As Integers    ${target_bps}    10000000
    [Teardown]    Detach UE-45

TC50 Verify Start Traffic With Kbps Sets Correct Target BPS
    [Tags]    transfer    positive
    [Setup]    Attach UE-46
    ${body}=    Api Start Data Transfer Kbps    46    9    500
    ${target_bps}=    Get From Dictionary    ${body}    target_bps
    Should Be Equal As Integers    ${target_bps}    500000
    [Teardown]    Detach UE-46

TC51 Verify Traffic Stats Protocol Field Matches Started Protocol
    [Tags]    transfer    positive
    [Setup]    Attach UE-47
    Start UDP Transfer On UE-47 Bearer-9 Speed 5 Mbps
    ${stats}=    Get Traffic Stats For UE-47 Bearer-9
    ${protocol}=    Get From Dictionary    ${stats}    protocol
    Should Be Equal    ${protocol}    udp
    [Teardown]    Detach UE-47

TC52 Verify Traffic Stats Duration Is Positive After Transfer
    [Tags]    transfer    positive
    [Setup]    Attach UE-48
    Start DL Transfer On UE-48 Bearer-9 Speed 5 Mbps
    Sleep    0.5s
    ${stats}=    Get Traffic Stats For UE-48 Bearer-9
    ${duration}=    Get From Dictionary    ${stats}    duration
    Should Be True    ${duration} > 0
    [Teardown]    Detach UE-48

TC58 Verify Traffic TX BPS Equals RX BPS In DL Transfer
    [Documentation]    DL transfer should have asymmetric tx/rx - this documents symmetric behavior as a potential bug.
    [Tags]    transfer    negative    known_bug
    [Setup]    Attach UE-93
    Start DL Transfer On UE-93 Bearer-9 Speed 10 Mbps
    Sleep    0.5s
    ${stats}=    Get Traffic Stats For UE-93 Bearer-9
    ${tx}=    Get From Dictionary    ${stats}    tx_bps
    ${rx}=    Get From Dictionary    ${stats}    rx_bps
    Should Not Be Equal    ${tx}    ${rx}
    [Teardown]    Detach UE-93
