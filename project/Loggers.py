import logging as log
import os

LOG_DIR = str(os.getcwd())+"\\logs\\"

def log_setup(logger_name, log_file, mode='a'):
        """
        Logging setup and initialization
        """
        #   Initialize handlers
        new_log = log.getLogger(logger_name)
        formatter = log.Formatter("%(asctime)s | %(message)s")
        file_handler = log.FileHandler(log_file, mode=mode)
        file_handler.setFormatter(formatter)
        stream_handler = log.StreamHandler()

        #   create logging object with handlers
        new_log.setLevel(log.DEBUG)
        new_log.addHandler(file_handler)
        new_log.addHandler(stream_handler)
        return new_log
    
class DefaultLogger():
    def __init__(self, log):
        self.log_obj = log_setup(f"ExpenseCalculatorLog-{log}", LOG_DIR+f"{log}.log")
    
    def log(self, logStr):
        self.log_obj.info(logStr)

class DatabaseLogger(DefaultLogger):
    def __init__(self):
        super().__init__("dbHelper")
        
class ExpenseCalcLogger(DefaultLogger):
    def __init__(self):
        super().__init__("expenseCalc")
        
class TestLogger(DefaultLogger):
    def __init__(self):
        super().__init__("dbTesting")