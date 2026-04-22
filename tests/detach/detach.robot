*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC01 Verify Successful UE Detach
    [Tags]    detach    positive
    [Setup]    Attach UE-20
    Detach UE-20
    Verify UE-20 Is Not Attached

TC23 Verify Detached UE Is Not In Active UE List
    [Tags]    detach    positive
    [Setup]    Attach UE-50
    Detach UE-50
    Verify UE-50 Is Not In Active UE List

TC47 Verify Detach Response Body Contains Status Detached
    [Tags]    detach    positive
    [Setup]    Attach UE-41
    ${body}=    Get Detach Response Body For UE-41
    ${status}=    Get From Dictionary    ${body}    status
    ${ue_id}=    Get From Dictionary    ${body}    ue_id
    Should Be Equal    ${status}    detached
    Should Be Equal As Integers    ${ue_id}    41
