import requests
from robot.api import logger

class EpcLibrary:
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    def api_attach_ue(self, ue_id):
        """Podłącza UE do sieci."""
        url = f"{self.base_url}/ues"
        payload = {"ue_id": int(ue_id)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Attach UE request for {ue_id} successful.")
        return response

    def api_add_bearer_to_ue(self, ue_id, bearer_id):
        """Dodaje bearer do UE."""
        url = f"{self.base_url}/ues/{ue_id}/bearers"
        payload = {"bearer_id": int(bearer_id)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Add bearer {bearer_id} to UE {ue_id} successful.")
        return response

    def api_get_ue_details(self, ue_id):
        """Pobiera szczegóły UE, w tym podłączone bearery[cite: 47, 48]."""
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.get(url)
        response.raise_for_status()
        
        if response.status_code == 200:
            logger.info(f"Pobrano dane dla UE {ue_id}.")
        return response

    def api_get_ue_bearers(self, ue_id):
        """Pobiera listę aktywnych bearerów dla danego UE."""
        response = self.api_get_ue_details(ue_id)
        if response.status_code == 200:
            return response.json().get("bearers", [])
        return []

    def api_detach_ue(self, ue_id):
        """Odłącza UE od sieci. Procedura wymaga podania UE ID[cite: 18, 20]."""
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.delete(url)
        response.raise_for_status()
        logger.info(f"Detach UE request for {ue_id} successful.")
        return response
    
    def api_reset_simulator(self):
        """Przywraca symulator do stanu początkowego[cite: 57, 58]."""
        requests.post(f"{self.base_url}/reset")
        logger.warn("Symulator został zresetowany!")