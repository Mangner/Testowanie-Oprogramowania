*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC03 Verify Adding Existing Bearer Throws Error
    [Tags]    bearer
    [Setup]    Attach UE    ue_id=2
    Add Bearer To UE    ue_id=2    bearer_id=2
    Run Keyword And Expect Error    *    Add Bearer To UE    ue_id=2    bearer_id=2
    [Teardown]    Detach UE    ue_id=2
