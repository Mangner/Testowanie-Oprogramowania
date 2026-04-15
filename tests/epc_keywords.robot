*** Settings ***
Library    Collections
Library    ../libraries/EpcLibrary.py

*** Keywords ***
Reset EPC Network Simulator
    [Documentation]    Restores the simulator to its initial state.
    Api Reset Epc Network Simulator To Defaults

Attach UE
    [Arguments]    ${ue_id}
    [Documentation]    Attaches the UE and checks for errors.
    Api Send Request To Attach User Equipment    ${ue_id}

Detach UE
    [Arguments]    ${ue_id}
    [Documentation]    Detaches the UE from the network.
    Api Disconnect User Equipment From Network    ${ue_id}

Verify UE Is Not Attached
    [Arguments]    ${ue_id}
    [Documentation]    Verifies that a UE is not attached to the network.
    ${status}    ${error_message}=    Run Keyword And Ignore Error    Api Fetch All Details For User Equipment    ${ue_id}
    Should Be Equal As Strings    ${status}    FAIL
    Should Contain    ${error_message}    400   

Add Bearer To UE
    [Arguments]    ${ue_id}    ${bearer_id}
    [Documentation]    Adds a dedicated bearer to a UE.
    Api Add Dedicated Bearer Channel To Ue    ${ue_id}    ${bearer_id}

Verify Bearer Is Active
    [Arguments]    ${ue_id}    ${bearer_id}
    [Documentation]    Verifies that a specific bearer is active for a UE.
    ${active_bearers}=    Api Extract Active Bearers List For Ue    ${ue_id}
    List Should Contain Value    ${active_bearers}    ${bearer_id}

Device Should Have Default Transport Channel
    [Arguments]    ${ue_id}
    [Documentation]    Retrieves the list of bearers and verifies if the default bearer ID 9 is present.
    ${active_bearers}=    Api Extract Active Bearers List For Ue    ${ue_id}
    List Should Contain Value    ${active_bearers}    9
    ...    msg=Error! Device ${ue_id} did not receive the default bearer with ID 9.