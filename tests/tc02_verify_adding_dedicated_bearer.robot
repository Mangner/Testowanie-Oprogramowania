*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC02 Verify Adding Dedicated Bearer
    [Tags]    happy_path    bearer
    [Setup]    Attach UE    ue_id=1
    Add Bearer To UE    ue_id=1    bearer_id=1
    Verify Bearer Is Active    ue_id=1    bearer_id=1
    [Teardown]    Detach UE    ue_id=1
