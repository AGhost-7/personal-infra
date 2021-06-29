#!/usr/bin/env bash

set -exo pipefail

epic_loot_path=/home/steam/valheim/BepInEx/plugins/EpicLoot
if [ ! -d $epic_loot_path ]; then
	curl -f -o /tmp/epicloot.zip https://cdn.thunderstore.io/live/repository/packages/RandyKnapp-EpicLoot-0.8.2.zip
	mkdir -p /tmp/epicloot
	unzip /tmp/epicloot.zip -d /tmp/epicloot
	cp -r /tmp/epicloot/files "$epic_loot_path"
	chown -R 1000:1000 "$epic_loot_path"
fi

rm -rf /home/steam/valheim/BepInEx/config
cp -r /home/steam/bep-config /home/steam/valheim/BepInEx/config
chown -R 1000:1000 /home/steam/valheim/BepInEx/config
