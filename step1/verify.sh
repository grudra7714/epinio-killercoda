#!/bin/bash

kubectl get namespace epinio > /dev/null 2>&1 && epinio settings show > /dev/null 2>&1
