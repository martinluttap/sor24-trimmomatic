SOFTWARE := "trimmomatic"
init: _init-hooks

_init-hooks:
	pre-commit install

emit-software:
  @echo {{SOFTWARE}}

# Builds individual software version
build VERSION:
   just {{VERSION}}/build-docker

push VERSION:
   just {{VERSION}}/push-docker

# Builds all docker images for each directory with a justfile
build-all:
    #!/bin/bash
    for dir in `ls .`; do
        if [ -d "${dir}" ]; then
            if [ -f "${dir}"/justfile ]; then
                just build "${dir}";
                just push "${dir}";
            fi
        fi
    done
