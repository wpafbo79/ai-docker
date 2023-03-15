#!/bin/bash

set -e
set -u
set -o pipefail

source config.sh
source ../create-compose-file.common.sh

create-compose-file
