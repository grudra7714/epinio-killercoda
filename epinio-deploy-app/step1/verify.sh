#!/bin/bash

test -f /var/run/epinio-ready \
  && epinio app show sample 2>/dev/null | grep -q "Status.*1/1"
