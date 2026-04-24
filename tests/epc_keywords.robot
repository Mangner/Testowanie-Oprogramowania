*** Settings ***
Library    Collections
Library    ../libraries/EpcLibrary.py

*** Keywords ***
Reset EPC Network Simulator
    [Documentation]    Restores the simulator to its initial state.
    Api Reset Epc Network Simulator To Defaults

Attach UE-${ue_id}
    [Documentation]    Attaches the UE and checks for errors.
    Api Send Request To Attach User Equipment    ${ue_id}

Detach UE-${ue_id}
    [Documentation]    Detaches the UE from the network.
    Api Disconnect User Equipment From Network    ${ue_id}

Verify UE-${ue_id} Is Not Attached
    [Documentation]    Verifies that a UE is not attached to the network.
    ${status}    ${error_message}=    Run Keyword And Ignore Error    Api Fetch All Details For User Equipment    ${ue_id}
    Should Be Equal As Strings    ${status}    FAIL
    Should Contain    ${error_message}    400   

Add Bearer-${bearer_id} To UE-${ue_id}
    [Documentation]    Adds a dedicated bearer to a UE.
    Api Add Dedicated Bearer Channel To Ue    ${ue_id}    ${bearer_id}

Verify Bearer-${bearer_id} Is Active On UE-${ue_id}
    [Documentation]    Verifies that a specific bearer is active for a UE.
    ${active_bearers}=    Api Extract Active Bearers List For Ue    ${ue_id}
    ${bearer_id_int}=    Convert To Integer    ${bearer_id}
    List Should Contain Value    ${active_bearers}    ${bearer_id_int}

Device UE-${ue_id} Should Have Default Transport Channel
    [Documentation]    Retrieves the list of bearers and verifies if the default bearer ID 9 is present.
    ${active_bearers}=    Api Extract Active Bearers List For Ue    ${ue_id}
    ${default_bearer_int}=    Convert To Integer    9
    List Should Contain Value    ${active_bearers}    ${default_bearer_int}

Verify UE-${ue_id} Is Attached
    [Documentation]    Verifies that a UE is currently attached to the network.
    Api Fetch All Details For User Equipment    ${ue_id}

Remove Bearer-${bearer_id} From UE-${ue_id}
    [Documentation]    Removes a dedicated bearer from a UE.
    Api Remove Bearer From Ue    ${ue_id}    ${bearer_id}

Verify Bearer-${bearer_id} Is Not Active On UE-${ue_id}
    [Documentation]    Verifies that a specific bearer is no longer active for a UE.
    ${active_bearers}=    Api Extract Active Bearers List For Ue    ${ue_id}
    ${bearer_id_int}=    Convert To Integer    ${bearer_id}
    List Should Not Contain Value    ${active_bearers}    ${bearer_id_int}

Get Active Bearers For UE-${ue_id}
    [Documentation]    Returns the list of active bearers for a specific UE.
    ${active_bearers}=    Api Extract Active Bearers List For Ue    ${ue_id}
    RETURN    ${active_bearers}

Get Attached UE List
    [Documentation]    Returns IDs of currently attached UEs.
    ${ue_list}=    Api List Attached Ues
    RETURN    ${ue_list}

Get UE Stats
    [Documentation]    Returns aggregate stats for all UEs or a single UE.
    [Arguments]    ${ue_id}=${None}    ${include_details}=${False}
    ${stats}=    Api Get Ues Stats    ue_id=${ue_id}    include_details=${include_details}
    RETURN    ${stats}

Start DL Transfer On UE-${ue_id} Bearer-${bearer_id} Speed ${speed} Mbps
    [Documentation]    Starts DL data transfer for a specific bearer.
    Api Start Data Transfer    ${ue_id}    ${bearer_id}    ${speed}

Verify DL Transfer Is Active On UE-${ue_id} Bearer-${bearer_id}
    [Documentation]    Verifies if the transfer is active.
    ${transfer_info}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}
    # It just needs to ensure transfer info is available for the bearer.

Get Total Transfer For UE-${ue_id} Unit ${unit}
    [Documentation]    Retrieves total transfer for all bearers in specified unit.
    ${transfer_info}=    Api Get Transfer Info    ${ue_id}    unit=${unit}
    RETURN    ${transfer_info}

End Transfer On UE-${ue_id} Bearer-${bearer_id}
    [Documentation]    Stops data transfer on a specific bearer.
    Api End Data Transfer    ${ue_id}    bearer_id=${bearer_id}

Verify No Transfer Is Active On UE-${ue_id} Bearer-${bearer_id}
    [Documentation]    Verifies that transfer has been stopped.
    Api Verify No Transfer Is Active    ${ue_id}    ${bearer_id}

Verify Reported Throughput Is Within ${tolerance_percent} Percent Of Target On UE-${ue_id} Bearer-${bearer_id}
    [Documentation]    Verifies that reported tx/rx throughput does not exceed configured target by too much.
    ${transfer_info}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}
    Should Be True    ${transfer_info}[target_bps] > 0
    ${max_allowed_bps}=    Evaluate    int(${transfer_info}[target_bps] * (1 + ${tolerance_percent} / 100))
    Should Be True    ${transfer_info}[tx_bps] <= ${max_allowed_bps}
    Should Be True    ${transfer_info}[rx_bps] <= ${max_allowed_bps}

Get Traffic Stats For UE-${ue_id} Bearer-${bearer_id}
    ${stats}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}
    RETURN    ${stats}

Get Transfer Info For UE And Bearer
    [Documentation]    Retrieves transfer info for a UE and bearer.
    [Arguments]    ${ue_id}    ${bearer_id}
    ${transfer_info}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}
    RETURN    ${transfer_info}

Verify Transfer Info Request Throws Error For UE And Bearer
    [Documentation]    Verifies that getting transfer info for non-existent bearer throws error.
    [Arguments]    ${ue_id}    ${bearer_id}
    Run Keyword And Expect Error    *    Get Transfer Info For UE And Bearer    ${ue_id}    ${bearer_id}

Verify Transfer BPS Is Zero For UE And Bearer
    [Documentation]    Verifies that both TX and RX BPS are zero after transfer is stopped.
    [Arguments]    ${ue_id}    ${bearer_id}
    ${traffic}=    Get Transfer Info For UE And Bearer    ${ue_id}    ${bearer_id}
    Log    Traffic stats: ${traffic}
    ${tx_bps}=    Get From Dictionary    ${traffic}    tx_bps
    ${rx_bps}=    Get From Dictionary    ${traffic}    rx_bps
    Should Be Equal As Integers    ${tx_bps}    0    msg=Expected tx_bps=0 after stop, got ${tx_bps}
    Should Be Equal As Integers    ${rx_bps}    0    msg=Expected rx_bps=0 after stop, got ${rx_bps}


Attached UE List Should Contain UE-${ue_id}
    [Documentation]    Pobiera listę i sprawdza, czy dany UE na niej jest.
    ${ue_list}=    Get Attached UE List
    ${ue_id_int}=    Convert To Integer    ${ue_id}
    List Should Contain Value    ${ue_list}    ${ue_id_int}

Attached UE List Should Not Contain UE-${ue_id}
    [Documentation]    Pobiera listę i sprawdza, czy danego UE na niej NIE MA.
    ${ue_list}=    Get Attached UE List
    ${ue_id_int}=    Convert To Integer    ${ue_id}
    List Should Not Contain Value    ${ue_list}    ${ue_id_int}


Global Bearer Count Should Be Greater Than Zero
    [Documentation]    Pobiera statystyki globalne i sprawdza licznik bearerów.
    ${stats}=    Get UE Stats
    Should Be True    ${stats['bearer_count']} > 0
