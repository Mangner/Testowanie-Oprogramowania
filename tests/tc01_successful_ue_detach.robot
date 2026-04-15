*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC01 Verify Successful UE Detach
    [Tags]     detach
    [Setup]    Attach UE    ue_id=20
    Detach UE    ue_id=20
    Verify UE Is Not Attached    ue_id=20
