*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC15 Verify Resetting Simulator
    [Tags]    system    positive
    [Setup]    Attach UE-13
    Reset EPC Network Simulator
    Verify UE-13 Is Not Attached
