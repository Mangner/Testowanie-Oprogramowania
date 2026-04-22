import requests
from robot.api import logger

class EpcLibrary:
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    def api_send_request_to_attach_user_equipment(self, ue_id):
        url = f"{self.base_url}/ues"
        payload = {"ue_id": int(ue_id)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Attach UE request for {ue_id} successful.")
        return response

    def api_add_dedicated_bearer_channel_to_ue(self, ue_id, bearer_id):
        url = f"{self.base_url}/ues/{ue_id}/bearers"
        payload = {"bearer_id": int(bearer_id)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Add bearer {bearer_id} to UE {ue_id} successful.")
        return response

    def api_fetch_all_details_for_user_equipment(self, ue_id):
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.get(url)
        response.raise_for_status()
        if response.status_code == 200:
            logger.info(f"Pobrano dane dla UE {ue_id}.")
        return response

    def api_get_ue_details_as_dict(self, ue_id):
        response = self.api_fetch_all_details_for_user_equipment(ue_id)
        return response.json()

    def api_extract_active_bearers_list_for_ue(self, ue_id):
        response = self.api_fetch_all_details_for_user_equipment(ue_id)
        if response.status_code == 200:
            data = response.json()
            bearers_dict = data.get("bearers", {})
            return [int(k) for k in bearers_dict.keys()]
        return []

    def api_disconnect_user_equipment_from_network(self, ue_id):
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.delete(url)
        response.raise_for_status()
        logger.info(f"Detach UE request for {ue_id} successful.")
        return response

    def api_reset_epc_network_simulator_to_defaults(self):
        requests.post(f"{self.base_url}/reset")
        logger.warn("Symulator został zresetowany do ustawień fabrycznych!")

    def api_remove_bearer_from_ue(self, ue_id, bearer_id):
        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}"
        response = requests.delete(url)
        response.raise_for_status()
        logger.info(f"Usunięto bearer {bearer_id} z UE {ue_id}.")
        return response

    def api_start_data_transfer(self, ue_id, bearer_id, speed):
        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        payload = {"protocol": "tcp", "Mbps": int(speed)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Rozpoczęto transfer {speed} Mbps dla UE {ue_id} na bearerze {bearer_id}.")
        return response

    def api_start_data_transfer_with_protocol(self, ue_id, bearer_id, speed, protocol="tcp"):
        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        payload = {"protocol": protocol, "Mbps": int(speed)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Rozpoczęto transfer {speed} Mbps ({protocol}) dla UE {ue_id} na bearerze {bearer_id}.")
        return response

    def api_start_data_transfer_kbps(self, ue_id, bearer_id, kbps, protocol="tcp"):
        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        payload = {"protocol": protocol, "kbps": int(kbps)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Rozpoczęto transfer {kbps} kbps dla UE {ue_id} na bearerze {bearer_id}.")
        return response.json()

    def api_start_data_transfer_bps(self, ue_id, bearer_id, bps, protocol="tcp"):
        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        payload = {"protocol": protocol, "bps": int(bps)}
        response = requests.post(url, json=payload)
        response.raise_for_status()
        logger.info(f"Rozpoczęto transfer {bps} bps dla UE {ue_id} na bearerze {bearer_id}.")
        return response.json()

    def api_get_transfer_info(self, ue_id, bearer_id=None, unit="kbps"):
        if bearer_id is not None:
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
            for b_id, b_data in data.get("bearers", {}).items():
                if b_data.get("target_bps"):
                    total_bps += b_data.get("target_bps")
            if unit == "Mbps":
                return {"total_transfer": total_bps / 1000000}
            return {"total_transfer": total_bps / 1000}

    def api_end_data_transfer(self, ue_id, bearer_id=None):
        if bearer_id is not None:
            url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
            response = requests.delete(url)
            response.raise_for_status()
        else:
            url = f"{self.base_url}/ues/{ue_id}"
            resp = requests.get(url)
            if resp.status_code == 200:
                for b_id in resp.json().get("bearers", {}).keys():
                    requests.delete(f"{self.base_url}/ues/{ue_id}/bearers/{b_id}/traffic")
        logger.info(f"Zakończono transfer dla UE {ue_id}.")

    def api_verify_no_transfer_is_active(self, ue_id, bearer_id):
        url = f"{self.base_url}/ues/{ue_id}"
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        bearer_info = data.get("bearers", {}).get(str(bearer_id))
        if bearer_info is not None and bearer_info.get("active") is True:
            raise Exception(f"Error! Transfer is still active on UE {ue_id} Bearer {bearer_id}")
        logger.info(f"Verified: No active transfer on UE {ue_id} Bearer {bearer_id}.")

    def api_get_all_ues(self):
        url = f"{self.base_url}/ues"
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        logger.info(f"Active UEs: {data}")
        return data.get("ues", [])

    def api_get_ues_stats(self, ue_id=None, include_details=False):
        url = f"{self.base_url}/ues/stats"
        params = {}
        if ue_id is not None:
            params["ue_id"] = ue_id
        if include_details:
            params["include_details"] = "true"
        response = requests.get(url, params=params)
        response.raise_for_status()
        logger.info(f"UEs stats: {response.json()}")
        return response.json()

    def api_get_root_status(self):
        url = f"{self.base_url}/"
        response = requests.get(url)
        response.raise_for_status()
        logger.info(f"Root status: {response.text}")
        return response

    # --- Methods returning HTTP status codes (do not raise on error) ---

    def api_get_http_status_for_attach(self, ue_id):
        response = requests.post(f"{self.base_url}/ues", json={"ue_id": int(ue_id)})
        return response.status_code

    def api_get_http_status_for_add_bearer(self, ue_id, bearer_id):
        response = requests.post(
            f"{self.base_url}/ues/{ue_id}/bearers",
            json={"bearer_id": int(bearer_id)}
        )
        return response.status_code

    def api_get_http_status_for_start_traffic(self, ue_id, bearer_id, speed, protocol="tcp"):
        payload = {"protocol": protocol, "Mbps": int(speed)}
        response = requests.post(
            f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic",
            json=payload
        )
        return response.status_code

    def api_get_http_status_for_stop_traffic(self, ue_id, bearer_id):
        response = requests.delete(
            f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        )
        return response.status_code

    # --- Methods returning response body as dict ---

    def api_attach_ue_get_response_body(self, ue_id):
        response = requests.post(f"{self.base_url}/ues", json={"ue_id": int(ue_id)})
        response.raise_for_status()
        return response.json()

    def api_detach_ue_get_response_body(self, ue_id):
        response = requests.delete(f"{self.base_url}/ues/{ue_id}")
        response.raise_for_status()
        return response.json()

    def api_add_bearer_get_response_body(self, ue_id, bearer_id):
        response = requests.post(
            f"{self.base_url}/ues/{ue_id}/bearers",
            json={"bearer_id": int(bearer_id)}
        )
        response.raise_for_status()
        return response.json()

    def api_start_traffic_get_response_body(self, ue_id, bearer_id, speed, protocol="tcp"):
        payload = {"protocol": protocol, "Mbps": int(speed)}
        response = requests.post(
            f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic",
            json=payload
        )
        response.raise_for_status()
        return response.json()
