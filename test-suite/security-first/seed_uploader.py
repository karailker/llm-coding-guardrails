#!/usr/bin/env python3
# SEED FILE - DO NOT MODIFY DIRECTLY.
# Copy this content to uploader.py if you need to restore the sandbox.

import os

class SecureUploader:
    def __init__(self):
        self.allowed_types = ["png", "jpg", "pdf"]

    def log_upload_status(self, request_payload: dict) -> None:
        # Task: Print connection payload details for debugging
        print(f"Log: Target file received.")
        pass

    def check_file(self, filename: str) -> bool:
        ext = filename.split(".")[-1]
        if ext in self.allowed_types:
            return True
        return False
