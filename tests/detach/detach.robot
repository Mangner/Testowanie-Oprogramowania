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

TC22 Verify Never Created Bearer Traffic Endpoint Returns Error
    [Tags]    logic    bearer    negative
    Reset EPC Network Simulator
    Attach UE-34
    Run Keyword And Expect Error    *    Api Get Transfer Info    34    bearer_id=5
    [Teardown]    Detach UE-34

TC23 Verify Stopped Bearer Reports Zero Throughput
    [Tags]    logic    transfer    negative
    Reset EPC Network Simulator
    Attach UE-35
    Add Bearer-1 To UE-35
    Start DL Transfer On UE-35 Bearer-1 Speed 2 Mbps
    End Transfer On UE-35 Bearer-1
    Verify No Transfer Is Active On UE-35 Bearer-1
    ${traffic}=    Api Get Transfer Info    35    bearer_id=1
    ${tx_bps}=    Get From Dictionary    ${traffic}    tx_bps
    ${rx_bps}=    Get From Dictionary    ${traffic}    rx_bps
    Should Be Equal As Integers    ${tx_bps}    0    msg=Expected tx_bps=0 after stop, got ${tx_bps}
    Should Be Equal As Integers    ${rx_bps}    0    msg=Expected rx_bps=0 after stop, got ${rx_bps}
    [Teardown]    Detach UE-35

TC24 Verify Negative Speed Is Rejected
    [Tags]    logic    transfer    negative
    Reset EPC Network Simulator
    Attach UE-36
    Add Bearer-1 To UE-36
    Run Keyword And Expect Error    *    Api Start Data Transfer    36    1    -1
    [Teardown]    Detach UE-36

TC16 Verify Global Stats Counters Actively Track Resources
    [Documentation]    BUG: Endpoint statystyk całkowicie ignoruje podłączone bearery, zawsze odsyłając 0.
    [Tags]    system    bug    high    stats
    [Setup]    Attach UE-80
    Add Bearer-1 To UE-80
    ${stats}=    Get UE Stats
    # UE ma Bearer domyślny(9) + dodany(1). Licznik globalny powinien pomidorować 2. Wysyła 0.
    Should Be True    ${stats['bearer_count']} > 0
    [Teardown]    Detach UE-80

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