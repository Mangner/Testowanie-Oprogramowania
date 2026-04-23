*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC15 Verify Resetting Simulator
    [Tags]    system    positive
    [Setup]    Attach UE-13
    Reset EPC Network Simulator
    Verify UE-13 Is Not Attached

TC24 Verify UE List Is Updated After Detach
    [Tags]    system    regression
    [Setup]    Reset EPC Network Simulator
    Attach UE-34
    Attach UE-35
    Detach UE-34
    ${ue_list}=    Get Attached UE List
    ${ue_34}=    Convert To Integer    34
    ${ue_35}=    Convert To Integer    35
    List Should Not Contain Value    ${ue_list}    ${ue_34}
    List Should Contain Value    ${ue_list}    ${ue_35}
    [Teardown]    Reset EPC Network Simulator

TC25 Verify Stats Scope For Single UE Query
    [Tags]    system    regression
    [Setup]    Reset EPC Network Simulator
    Attach UE-36
    ${stats}=    Get UE Stats    ue_id=36    include_details=${True}
    Should Be Equal As Strings    ${stats}[scope]    ue:36
    Should Be Equal As Integers    ${stats}[ue_count]    1
    [Teardown]    Reset EPC Network Simulator
