*** Settings ***
Resource    epc_keywords.robot

*** Test Cases ***
TC01 Verify Successful UE Detach
    [Tags]     detach
    [Setup]    Attach UE-20
    Detach UE-20
    Verify UE-20 Is Not Attached




# pogrupować funkcjonalnie
# 