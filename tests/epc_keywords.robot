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

Verify UE-${ue_id} Is Attached
    [Documentation]    Verifies that a UE is currently attached to the network.
    Api Fetch All Details For User Equipment    ${ue_id}

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
    ...    msg=Error! Device ${ue_id} did not receive the default bearer with ID 9.

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
    [Documentation]    Verifies if the transfer is active by checking transfer info is accessible.
    ${transfer_info}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}

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

Get All Active UEs
    [Documentation]    Returns the list of currently attached UE IDs.
    ${ues}=    Api Get All Ues
    RETURN    ${ues}

Verify UE-${ue_id} Is In Active UE List
    [Documentation]    Verifies that a given UE ID appears in the active UE list.
    ${ues}=    Api Get All Ues
    ${ue_id_int}=    Convert To Integer    ${ue_id}
    List Should Contain Value    ${ues}    ${ue_id_int}

Verify UE-${ue_id} Is Not In Active UE List
    [Documentation]    Verifies that a given UE ID does not appear in the active UE list.
    ${ues}=    Api Get All Ues
    ${ue_id_int}=    Convert To Integer    ${ue_id}
    List Should Not Contain Value    ${ues}    ${ue_id_int}

Get UE Details For UE-${ue_id}
    [Documentation]    Returns UE details as a dictionary.
    ${details}=    Api Get Ue Details As Dict    ${ue_id}
    RETURN    ${details}

Start UDP Transfer On UE-${ue_id} Bearer-${bearer_id} Speed ${speed} Mbps
    [Documentation]    Starts UDP data transfer for a specific bearer.
    Api Start Data Transfer With Protocol    ${ue_id}    ${bearer_id}    ${speed}    udp

Get Traffic Stats For UE-${ue_id} Bearer-${bearer_id}
    [Documentation]    Returns traffic statistics for a specific bearer.
    ${stats}=    Api Get Transfer Info    ${ue_id}    bearer_id=${bearer_id}
    RETURN    ${stats}

Verify Root Endpoint Responds
    [Documentation]    Verifies that the root endpoint returns a successful response.
    Api Get Root Status

Verify UE Stats Endpoint Responds
    [Documentation]    Verifies that the UE stats endpoint returns a successful response.
    Api Get Ues Stats

Verify Attaching UE-${ue_id} Returns HTTP Status ${expected_code}
    [Documentation]    Verifies the HTTP status code returned when attaching a UE.
    ${status}=    Api Get Http Status For Attach    ${ue_id}
    Should Be Equal As Integers    ${status}    ${expected_code}

Verify Adding Bearer-${bearer_id} To UE-${ue_id} Returns HTTP Status ${expected_code}
    [Documentation]    Verifies the HTTP status code returned when adding a bearer.
    ${status}=    Api Get Http Status For Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status}    ${expected_code}

Verify Starting Traffic On UE-${ue_id} Bearer-${bearer_id} Protocol ${protocol} Speed ${speed} Mbps Returns HTTP Status ${expected_code}
    [Documentation]    Verifies the HTTP status code returned when starting traffic.
    ${status}=    Api Get Http Status For Start Traffic    ${ue_id}    ${bearer_id}    ${speed}    ${protocol}
    Should Be Equal As Integers    ${status}    ${expected_code}

Get Attach Response Body For UE-${ue_id}
    [Documentation]    Attaches a UE and returns the response body as a dictionary.
    ${body}=    Api Attach Ue Get Response Body    ${ue_id}
    RETURN    ${body}

Get Detach Response Body For UE-${ue_id}
    [Documentation]    Detaches a UE and returns the response body as a dictionary.
    ${body}=    Api Detach Ue Get Response Body    ${ue_id}
    RETURN    ${body}

Get Add Bearer Response Body For UE-${ue_id} Bearer-${bearer_id}
    [Documentation]    Adds a bearer and returns the response body as a dictionary.
    ${body}=    Api Add Bearer Get Response Body    ${ue_id}    ${bearer_id}
    RETURN    ${body}

Get Start Traffic Response Body For UE-${ue_id} Bearer-${bearer_id} Speed ${speed} Mbps
    [Documentation]    Starts TCP traffic and returns the response body.
    ${body}=    Api Start Traffic Get Response Body    ${ue_id}    ${bearer_id}    ${speed}
    RETURN    ${body}
