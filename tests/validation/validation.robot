*** Settings ***
Resource    ../epc_keywords.robot

*** Test Cases ***
TC40 Verify Attaching UE With ID Zero Returns HTTP 422
    [Tags]    validation    negative    boundary
    Verify Attaching UE-0 Returns HTTP Status 422

TC41 Verify Attaching UE With ID 101 Returns HTTP 422
    [Tags]    validation    negative    boundary
    Verify Attaching UE-101 Returns HTTP Status 422

TC42 Verify Adding Bearer With ID Zero Returns HTTP 422
    [Tags]    validation    negative    boundary
    [Setup]    Attach UE-90
    Verify Adding Bearer-0 To UE-90 Returns HTTP Status 422
    [Teardown]    Detach UE-90

TC43 Verify Adding Bearer With ID 10 Returns HTTP 422
    [Tags]    validation    negative    boundary
    [Setup]    Attach UE-92
    Verify Adding Bearer-10 To UE-92 Returns HTTP Status 422
    [Teardown]    Detach UE-92

TC44 Verify Starting Traffic With Invalid Protocol Returns HTTP 422
    [Tags]    validation    negative
    [Setup]    Attach UE-94
    Verify Starting Traffic On UE-94 Bearer-9 Protocol ftp Speed 10 Mbps Returns HTTP Status 422
    [Teardown]    Detach UE-94

TC45 Verify Starting Traffic Above Max Speed Limit Returns HTTP 422
    [Documentation]    Known bug: app should reject Mbps > 100 with 422 but returns 200 instead.
    [Tags]    validation    negative    known_bug
    [Setup]    Attach UE-95
    Verify Starting Traffic On UE-95 Bearer-9 Protocol tcp Speed 150 Mbps Returns HTTP Status 422
    [Teardown]    Detach UE-95
