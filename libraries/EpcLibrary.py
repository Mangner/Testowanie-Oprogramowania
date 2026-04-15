import requests
from robot.api import logger

class EpcLibrary:
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    def get_ue_details(self, ue_id):
        """Pobiera szczegóły UE, w tym podłączone bearery[cite: 47, 48]."""
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.get(url)
        
        if response.status_code == 200:
            logger.info(f"Pobrano dane dla UE {ue_id}.")
        return response

    def detach_ue(self, ue_id):
        """Odłącza UE od sieci. Procedura wymaga podania UE ID[cite: 18, 20]."""
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.delete(url)
        
        if response.status_code == 200:
            logger.info(f"Sukces: UE {ue_id} został odłączony.")
        else:
            logger.error(f"Błąd przy odłączaniu UE {ue_id}: {response.status_code}")
            
        return response
    
    def reset_simulator(self):
        """Przywraca symulator do stanu początkowego[cite: 57, 58]."""
        requests.post(f"{self.base_url}/reset")
        logger.warn("Symulator został zresetowany!")