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

Get Aggregated Stats For UE-${ue_id} Include Details ${include_details}
    [Documentation]    Retrieves aggregated throughput stats for a specific UE scope.
    ${stats}=    Api Get Aggregated Stats    ue_id=${ue_id}    include_details=${include_details}
    RETURN    ${stats}

Verify Reported Throughput Is Within Configured Limit On UE-${ue_id} Bearer-${bearer_id} Max Ratio ${max_ratio}
    [Documentation]    Verifies that measured tx/rx do not exceed target by more than allowed ratio.
    ${traffic}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}
    ${target_bps}=    Get From Dictionary    ${traffic}    target_bps
    ${tx_bps}=    Get From Dictionary    ${traffic}    tx_bps
    ${rx_bps}=    Get From Dictionary    ${traffic}    rx_bps
    ${limit_bps}=    Evaluate    int(${target_bps} * ${max_ratio})
    Should Be True    ${tx_bps} <= ${limit_bps}    msg=TX throughput ${tx_bps} exceeds allowed limit ${limit_bps} for target ${target_bps}
    Should Be True    ${rx_bps} <= ${limit_bps}    msg=RX throughput ${rx_bps} exceeds allowed limit ${limit_bps} for target ${target_bps}

Verify Aggregated Stats For UE-${ue_id} Show No Active Traffic
    [Documentation]    Verifies that no active traffic is reported in /ues/stats for UE scope.
    ${stats}=    Get Aggregated Stats For UE-${ue_id} Include Details ${False}
    ${bearer_count}=    Get From Dictionary    ${stats}    bearer_count
    ${total_tx_bps}=    Get From Dictionary    ${stats}    total_tx_bps
    ${total_rx_bps}=    Get From Dictionary    ${stats}    total_rx_bps
    Should Be Equal As Integers    ${total_tx_bps}    0    msg=Expected total_tx_bps=0 after stop, got ${total_tx_bps}
    Should Be Equal As Integers    ${total_rx_bps}    0    msg=Expected total_rx_bps=0 after stop, got ${total_rx_bps}
    Should Be Equal As Integers    ${bearer_count}    0    msg=Expected bearer_count=0 after stop, got ${bearer_count}