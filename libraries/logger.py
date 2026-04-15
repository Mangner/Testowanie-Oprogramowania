from robot.api import logger

def loguj_status_symulatora(status_code):
    if status_code == 200:
        logger.info(f"Test passed: {status_code}")
    else:
        logger.warn(f"Test failed: {status_code}")