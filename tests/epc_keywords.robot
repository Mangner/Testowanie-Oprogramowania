Settings 
Library    Collections
Library    ../libraries/EpcLibrary.py

 Keywords 
Reset EPC Network Simulator
    [Documentation]    Restores the simulator to its initial state.
    Api Reset Simulator

Device Should Have Default Transport Channel
    [Arguments]    ${ue_id}
    [Documentation]    Retrieves the list of bearers and verifies if the default bearer ID 9 is present.
    ${active_bearers}=    Api Get Ue Bearers    ${ue_id}
    List Should Contain Value    ${active_bearers}    9
    ...    msg=Error! Device ${ue_id} did not receive the default bearer with ID 9.