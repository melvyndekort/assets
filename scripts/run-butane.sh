#!/bin/sh

for FILE in butane-cfgs/*.bu; do
  IGN="$(basename $FILE | sed 's/.bu$/.ign/')"
  docker run --interactive --rm --volume ${PWD}:/pwd --workdir /pwd quay.io/coreos/butane:release --pretty --strict $FILE > src/ignition/$IGN
done

