#!/bin/sh

set -e

force login -i $RO_ENDPOINT -u $RO_USERNAME -p $RO_PASSWORD
force export metadata -x Report -x Dashboard
force fetch -d metadata -t Report -t Dashboard
s3-cli put --recursive --verbose metadata s3://salesforce-org-backups/metadata/$(date +%Y-%m-%d-%H%M%S)
