*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC24 Verify Get UE List Returns Valid Response
    [Tags]    ue_list    positive
    [Setup]    Reset EPC Network Simulator
    ${ues}=    Get All Active UEs
    Should Not Be Equal    ${ues}    ${None}

TC25 Verify Attached UE Appears In Active UE List
    [Tags]    ue_list    positive
    [Setup]    Attach UE-60
    Verify UE-60 Is In Active UE List
    [Teardown]    Detach UE-60

TC26 Verify UE Details Response Contains Correct UE ID
    [Tags]    ue_list    positive
    [Setup]    Attach UE-70
    ${details}=    Get UE Details For UE-70
    ${ue_id}=    Get From Dictionary    ${details}    ue_id
    Should Be Equal As Integers    ${ue_id}    70
    [Teardown]    Detach UE-70

TC27 Verify UE List Count Increases After Attaching New UE
    [Tags]    ue_list    positive
    [Setup]    Reset EPC Network Simulator
    ${initial_ues}=    Get All Active UEs
    ${initial_count}=    Get Length    ${initial_ues}
    Attach UE-72
    ${updated_ues}=    Get All Active UEs
    ${updated_count}=    Get Length    ${updated_ues}
    ${expected_count}=    Evaluate    ${initial_count} + 1
    Should Be Equal As Integers    ${updated_count}    ${expected_count}
    [Teardown]    Detach UE-72
