#!/bin/bash

epinio app show sample 2>/dev/null | grep -q "Status.*1/1"
