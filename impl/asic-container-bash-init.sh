#!/bin/bash
dir="$(dirname "${BASH_SOURCE[0]}")"
singularity exec /cad/products/cds/asic_container /bin/bash --init-file "$dir/asic-container-bash-init"
