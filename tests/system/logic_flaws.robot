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
