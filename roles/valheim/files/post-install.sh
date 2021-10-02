#!/usr/bin/env bash

set -exo pipefail

epic_loot_version=0.8.6
epic_loot_path=/home/steam/valheim/BepInEx/plugins/EpicLoot

if ! grep -q "$epic_loot_version" "$epic_loot_path/version"; then
	echo "Epic loot version is outdated, removing"
	rm -rf "$epic_loot_path"
fi

if [ ! -d $epic_loot_path ]; then
	echo "Installing epic loot"
	curl -f -o /tmp/epicloot.zip "https://gcdn.thunderstore.io/live/repository/packages/RandyKnapp-EpicLoot-$epic_loot_version.zip"
	mkdir -p /tmp/epicloot
	unzip /tmp/epicloot.zip -d /tmp/epicloot
	cp -r /tmp/epicloot/files "$epic_loot_path"
	echo "$epic_loot_version" > "$epic_loot_version"
	chown -R 1000:1000 "$epic_loot_path"
fi

rm -rf /home/steam/valheim/BepInEx/config
cp -r /home/steam/bep-config /home/steam/valheim/BepInEx/config
chown -R 1000:1000 /home/steam/valheim/BepInEx/config
