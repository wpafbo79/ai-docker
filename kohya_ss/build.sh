#!/bin/bash

set -e
set -u
set -o pipefail

source ./config.sh
source ../build.common.sh

build
