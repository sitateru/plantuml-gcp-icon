#!/usr/bin/env bash

set -ex

google_blue="#4285F4"

TEMPLATE=$(cat <<EOF

!definelong GCP___SPRITE__(alias,name,container='rectangle',stereo='__SPRITE__')
skinparam container<<stereo>> {
  BackgroundColor White
  BorderColor GCP_BORDER_COLOR
  Shadowing false
}
container "<b>name</b>\n<color:GCP_COLOR><\$__SPRITE__{scale=0.25}></color>" <<stereo>> as alias
!enddefinelong
EOF
)

IFS=$'\n'; set -f
for file in $(find "./GCP Icons" -name '*.png'); do
    base=$(basename $file)
    name=$(echo "${base%.*}" | sed 's/[ -]//g')
    outfile="${file%.png}.puml"
    java -jar plantuml.jar -encodesprite 16z "$file" | sed "s/\\\$[a-zA-Z]\+/\\\$$name/" > $outfile
    echo "$TEMPLATE" | sed "s/__SPRITE__/$name/g" >> $outfile
done
unset IFS; set +f
