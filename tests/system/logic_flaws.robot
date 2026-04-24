*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC19 Verify Throughput Does Not Exceed Configured Target
    [Tags]    logic    transfer    negative
    Reset EPC Network Simulator
    Attach UE-31
    Add Bearer-1 To UE-31
    Start DL Transfer On UE-31 Bearer-1 Speed 1 Mbps
    Verify Reported Throughput Is Within Configured Limit On UE-31 Bearer-1 Max Ratio 1.20
    [Teardown]    Detach UE-31

TC20 Verify Stopped Traffic Is Removed From Aggregated Stats
    [Tags]    logic    transfer    negative
    Reset EPC Network Simulator
    Attach UE-32
    Add Bearer-1 To UE-32
    Start DL Transfer On UE-32 Bearer-1 Speed 2 Mbps
    End Transfer On UE-32 Bearer-1
    Verify No Transfer Is Active On UE-32 Bearer-1
    Verify Aggregated Stats For UE-32 Show No Active Traffic
    [Teardown]    Detach UE-32

TC21 Verify Removed Bearer Traffic Endpoint Returns Error
    [Tags]    logic    bearer    negative
    Reset EPC Network Simulator
    Attach UE-33
    Add Bearer-2 To UE-33
    Remove Bearer-2 From UE-33
    Run Keyword And Expect Error    *    Api Get Transfer Info    33    bearer_id=2
    [Teardown]    Detach UE-33

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
