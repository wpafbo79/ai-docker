#!/bin/bash

set -e
set -u
set -o pipefail

source config.sh
source ../create-container.common.sh

create-container $@
