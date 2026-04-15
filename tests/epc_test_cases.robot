*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC01 Verify Successful UE Detach
    [Tags]    happy_path    detach
    [Setup]    Attach UE    ue_id=20
    Detach UE    ue_id=20
    Verify UE Is Not Attached    ue_id=20

TC02 Verify Adding Dedicated Bearer
    [Tags]    happy_path    bearer
    [Setup]    Attach UE    ue_id=1
    Add Bearer To UE    ue_id=1    bearer_id=1
    Verify Bearer Is Active    ue_id=1    bearer_id=1
    [Teardown]    Detach UE    ue_id=1

TC03 Verify Adding Existing Bearer Throws Error
    [Tags]    sad_path    bearer
    [Setup]    Attach UE    ue_id=2
    Add Bearer To UE    ue_id=2    bearer_id=2
    Run Keyword And Expect Error    *    Add Bearer To UE    ue_id=2    bearer_id=2
    [Teardown]    Detach UE    ue_id=2
