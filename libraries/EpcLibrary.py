import requests
from robot.api import logger


class EpcLibrary:
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    # ========================
    # 🔧 PARSERY
    # ========================

    def _parse_ue_id(self, ue_id):
        if isinstance(ue_id, str) and ue_id.startswith("UE-"):
            return int(ue_id.split("-")[1])
        return int(ue_id)

    def _parse_bearer_id(self, bearer_id):
        if isinstance(bearer_id, str) and bearer_id.startswith("Bearer-"):
            return int(bearer_id.split("-")[1])
        return int(bearer_id)

    # ========================
    # 📡 UE OPERATIONS
    # ========================

    def api_list_attached_ues(self):
        url = f"{self.base_url}/ues"
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        logger.info("Fetched attached UE list.")
        return data.get("ues", [])

    def api_get_ues_stats(self, ue_id=None, include_details=False):
        url = f"{self.base_url}/ues/stats"
        params = {"include_details": str(bool(include_details)).lower()}

        if ue_id is not None:
            params["ue_id"] = self._parse_ue_id(ue_id)

        response = requests.get(url, params=params)
        response.raise_for_status()
        logger.info(f"Fetched UE stats for {'all' if ue_id is None else f'UE {ue_id}'}.")
        return response.json()

    def api_send_request_to_attach_user_equipment(self, ue_id):
        url = f"{self.base_url}/ues"
        payload = {"ue_id": self._parse_ue_id(ue_id)}

        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Attach UE {ue_id} successful.")
        return response

    def api_disconnect_user_equipment_from_network(self, ue_id):
        ue_id = self._parse_ue_id(ue_id)
        url = f"{self.base_url}/ues/{ue_id}"

        response = requests.delete(url)
        response.raise_for_status()
        logger.info(f"Detach UE {ue_id} successful.")
        return response

    def api_reset_epc_network_simulator_to_defaults(self):
        requests.post(f"{self.base_url}/reset")
        logger.warn("Symulator został zresetowany do ustawień fabrycznych!")

    # ========================
    # 📦 BEARERS
    # ========================

    def api_add_dedicated_bearer_channel_to_ue(self, ue_id, bearer_id):
        ue_id = self._parse_ue_id(ue_id)
        bearer_id = self._parse_bearer_id(bearer_id)

        url = f"{self.base_url}/ues/{ue_id}/bearers"
        payload = {"bearer_id": bearer_id}

        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Added bearer {bearer_id} to UE {ue_id}.")
        return response

    def api_remove_bearer_from_ue(self, ue_id, bearer_id):
        ue_id = self._parse_ue_id(ue_id)
        bearer_id = self._parse_bearer_id(bearer_id)

        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}"
        response = requests.delete(url)
        response.raise_for_status()
        logger.info(f"Removed bearer {bearer_id} from UE {ue_id}.")
        return response

    def api_extract_active_bearers_list_for_ue(self, ue_id):
        response = self.api_fetch_all_details_for_user_equipment(ue_id)

        if response.status_code == 200:
            data = response.json()
            bearers_dict = data.get("bearers", {})
            return [int(k) for k in bearers_dict.keys()]

        return []

    def api_fetch_all_details_for_user_equipment(self, ue_id):
        ue_id = self._parse_ue_id(ue_id)
        url = f"{self.base_url}/ues/{ue_id}"

        response = requests.get(url)
        response.raise_for_status()

        logger.info(f"Pobrano dane dla UE {ue_id}.")
        return response

    # ========================
    # 🚀 TRAFFIC
    # ========================

    def api_start_data_transfer(self, ue_id, bearer_id, speed):
        ue_id = self._parse_ue_id(ue_id)
        bearer_id = self._parse_bearer_id(bearer_id)

        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        payload = {"protocol": "tcp", "Mbps": int(speed)}

        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Started {speed} Mbps transfer on UE {ue_id}, bearer {bearer_id}.")
        return response

    def api_get_transfer_info(self, ue_id, bearer_id=None, unit="kbps"):
        ue_id = self._parse_ue_id(ue_id)

        if bearer_id is not None:
            bearer_id = self._parse_bearer_id(bearer_id)
            url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"

            response = requests.get(url)
            response.raise_for_status()

            data = response.json()
            data["speed"] = data.get("target_bps", 0)
            return data

        else:
            url = f"{self.base_url}/ues/{ue_id}"
            response = requests.get(url)
            response.raise_for_status()

            data = response.json()
            total_bps = 0

            for b_data in data.get("bearers", {}).values():
                if b_data.get("target_bps"):
                    total_bps += b_data.get("target_bps")

            if unit == "Mbps":
                return {"total_transfer": total_bps / 1_000_000}

            return {"total_transfer": total_bps / 1000}

    def api_end_data_transfer(self, ue_id, bearer_id=None):
        ue_id = self._parse_ue_id(ue_id)

        if bearer_id is not None:
            bearer_id = self._parse_bearer_id(bearer_id)
            url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"

            response = requests.delete(url)
            response.raise_for_status()

        else:
            url = f"{self.base_url}/ues/{ue_id}"
            resp = requests.get(url)

            if resp.status_code == 200:
                for b_id in resp.json().get("bearers", {}).keys():
                    requests.delete(f"{self.base_url}/ues/{ue_id}/bearers/{b_id}/traffic")

        logger.info(f"Stopped transfer for UE {ue_id}.")

    def api_verify_no_transfer_is_active(self, ue_id, bearer_id):
        ue_id = self._parse_ue_id(ue_id)
        bearer_id = self._parse_bearer_id(bearer_id)

        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.get(url)
        response.raise_for_status()

        data = response.json()
        bearer_info = data.get("bearers", {}).get(str(bearer_id))

        if bearer_info is not None and bearer_info.get("active") is True:
            raise Exception(f"Transfer still active on UE {ue_id}, bearer {bearer_id}")

        logger.info(f"No active transfer on UE {ue_id}, bearer {bearer_id}.")