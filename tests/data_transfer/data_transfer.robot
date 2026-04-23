*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC10 Verify Starting Data Transfer
    [Tags]    transfer    positive
    [Setup]    Attach UE-8
    Start DL Transfer On UE-8 Bearer-9 Speed 50 Mbps
    Verify DL Transfer Is Active On UE-8 Bearer-9
    [Teardown]    Detach UE-8

TC11 Verify Starting Transfer Exceeding Max Speed Throws Error
    [Tags]    transfer    negative
    [Setup]    Attach UE-9
    Run Keyword And Expect Error    *    Start DL Transfer On UE-9 Bearer-9 Speed 150 Mbps
    [Teardown]    Detach UE-9
#prawdziwy błąd ??????
TC12 Verify Starting Transfer On Inactive Bearer Throws Error
    [Tags]    transfer    negative
    [Setup]    Attach UE-10
    Run Keyword And Expect Error    *    Start DL Transfer On UE-10 Bearer-5 Speed 20 Mbps
    [Teardown]    Detach UE-10

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

TC22 Verify Starting Transfer With Zero Speed Throws Error
    [Tags]    transfer    negative
    [Setup]    Attach UE-32
    Run Keyword And Expect Error    *    Start DL Transfer On UE-32 Bearer-9 Speed 0 Mbps
    [Teardown]    Detach UE-32

TC23 Verify Reported Throughput Is Within Configured Limit
    [Tags]    transfer    defect
    [Setup]    Attach UE-33
    Start DL Transfer On UE-33 Bearer-9 Speed 5 Mbps
    Verify Reported Throughput Is Within 20 Percent Of Target On UE-33 Bearer-9
    [Teardown]    Detach UE-33
