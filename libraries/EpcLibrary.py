import requests
from robot.api import logger

class EpcLibrary:
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    def api_send_request_to_attach_user_equipment(self, ue_id):
        """Podłącza UE do sieci."""
        url = f"{self.base_url}/ues"
        payload = {"ue_id": int(ue_id)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Attach UE request for {ue_id} successful.")
        return response

    def api_add_dedicated_bearer_channel_to_ue(self, ue_id, bearer_id):
        """Dodaje dedykowany bearer do UE."""
        url = f"{self.base_url}/ues/{ue_id}/bearers"
        payload = {"bearer_id": int(bearer_id)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Add bearer {bearer_id} to UE {ue_id} successful.")
        return response

    def api_fetch_all_details_for_user_equipment(self, ue_id):
        """Pobiera pełne szczegóły UE, w tym podłączone bearery i statystyki."""
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.get(url)
        response.raise_for_status()
        
        if response.status_code == 200:
            logger.info(f"Pobrano dane dla UE {ue_id}.")
        return response

    def api_extract_active_bearers_list_for_ue(self, ue_id):
        """Pobiera i formatuje listę aktywnych bearerów dla danego UE z obiektu JSON."""
        response = self.api_fetch_all_details_for_user_equipment(ue_id)
        if response.status_code == 200:
            data = response.json()
            bearers_dict = data.get("bearers", {})
            return [int(k) for k in bearers_dict.keys()]
        return []

    def api_disconnect_user_equipment_from_network(self, ue_id):
        """Odłącza UE od sieci. Procedura wymaga podania UE ID."""
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.delete(url)
        response.raise_for_status()
        logger.info(f"Detach UE request for {ue_id} successful.")
        return response
    
    def api_reset_epc_network_simulator_to_defaults(self):
        """Przywraca symulator do stanu początkowego czyszcząc wszystkie dane."""
        requests.post(f"{self.base_url}/reset")
        logger.warn("Symulator został zresetowany do ustawień fabrycznych!")