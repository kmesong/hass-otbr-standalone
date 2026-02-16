#!/bin/bash

# In standalone mode, we cannot push discovery to Supervisor.
# Users must add the integration manually.

echo "[$(date)] INFO: Discovery skipped (Standalone mode)."
exit 0
