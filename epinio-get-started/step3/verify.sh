#!/bin/bash

epinio app env list sample 2>/dev/null | grep -q "MY_VAR"
