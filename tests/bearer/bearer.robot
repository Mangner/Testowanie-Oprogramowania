*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC03 Verify Adding Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-1
    Add Bearer-1 To UE-1
    Verify Bearer-1 Is Active On UE-1
    [Teardown]    Detach UE-1

TC06 Verify Checking Active Bearers
    [Tags]    bearer    positive
    [Setup]    Attach UE-4
    Add Bearer-2 To UE-4
    ${active_bearers}=    Get Active Bearers For UE-4
    List Should Contain Value    ${active_bearers}    ${9}
    List Should Contain Value    ${active_bearers}    ${2}
    [Teardown]    Detach UE-4

TC07 Verify Removing Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-5
    Add Bearer-3 To UE-5
    Remove Bearer-3 From UE-5
    Verify Bearer-3 Is Not Active On UE-5
    [Teardown]    Detach UE-5

TC29 Verify Adding Bearer With Maximum Dedicated ID Succeeds
    [Tags]    bearer    positive    boundary
    [Setup]    Attach UE-81
    Add Bearer-8 To UE-81
    Verify Bearer-8 Is Active On UE-81
    [Teardown]    Detach UE-81

TC30 Verify Adding Multiple Dedicated Bearers To Single UE
    [Tags]    bearer    positive
    [Setup]    Attach UE-82
    Add Bearer-1 To UE-82
    Add Bearer-2 To UE-82
    Verify Bearer-1 Is Active On UE-82
    Verify Bearer-2 Is Active On UE-82
    [Teardown]    Detach UE-82

TC31 Verify Bearer Count Decreases After Removing Dedicated Bearer
    [Tags]    bearer    positive
    [Setup]    Attach UE-83
    Add Bearer-3 To UE-83
    ${bearers_before}=    Get Active Bearers For UE-83
    ${count_before}=    Get Length    ${bearers_before}
    Remove Bearer-3 From UE-83
    ${bearers_after}=    Get Active Bearers For UE-83
    ${count_after}=    Get Length    ${bearers_after}
    ${expected}=    Evaluate    ${count_before} - 1
    Should Be Equal As Integers    ${count_after}    ${expected}
    [Teardown]    Detach UE-83

TC53 Verify Add Bearer Response Body Contains Correct Fields
    [Tags]    bearer    positive
    [Setup]    Attach UE-42
    ${body}=    Get Add Bearer Response Body For UE-42 Bearer-5
    ${status}=    Get From Dictionary    ${body}    status
    ${ue_id}=    Get From Dictionary    ${body}    ue_id
    ${bearer_id}=    Get From Dictionary    ${body}    bearer_id
    Should Be Equal    ${status}    bearer_added
    Should Be Equal As Integers    ${ue_id}    42
    Should Be Equal As Integers    ${bearer_id}    5
    [Teardown]    Detach UE-42

TC54 Verify Added Bearer Appears As Key In UE Details
    [Tags]    bearer    positive
    [Setup]    Attach UE-43
    Add Bearer-6 To UE-43
    ${details}=    Get UE Details For UE-43
    ${bearers}=    Get From Dictionary    ${details}    bearers
    Dictionary Should Contain Key    ${bearers}    6
    [Teardown]    Detach UE-43
