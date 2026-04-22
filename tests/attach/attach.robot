*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC16 Verify Successful UE Attach
    [Tags]    attach    positive
    Attach UE-15
    Verify UE-15 Is Attached
    Device UE-15 Should Have Default Transport Channel
    [Teardown]    Detach UE-15

TC19 Verify Attaching UE With Minimum Valid ID Succeeds
    [Tags]    attach    positive    boundary
    Attach UE-1
    Verify UE-1 Is Attached
    [Teardown]    Detach UE-1

TC20 Verify Attaching UE With Maximum Valid ID Succeeds
    [Tags]    attach    positive    boundary
    Attach UE-100
    Verify UE-100 Is Attached
    [Teardown]    Detach UE-100

TC46 Verify Attach Response Body Contains Status Attached
    [Tags]    attach    positive
    ${body}=    Get Attach Response Body For UE-40
    ${status}=    Get From Dictionary    ${body}    status
    ${ue_id}=    Get From Dictionary    ${body}    ue_id
    Should Be Equal    ${status}    attached
    Should Be Equal As Integers    ${ue_id}    40
    [Teardown]    Detach UE-40
