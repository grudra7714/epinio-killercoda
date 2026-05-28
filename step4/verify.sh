#!/bin/bash

epinio namespace list 2>/dev/null | grep -qv "production"
