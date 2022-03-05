#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

DOSBOX_CPU_MASK=03
DOSBOX_EXE_NAME="dosbox"
DOSBOX_VMODE="-r 800 480 rgb32"
DOSBOX_HOME_DIR="/media/fat/DOSBox"
DOSBOX_OPTIONS="-conf /media/fat/DOSBox/Configs/dosbox-0.74-3.conf"
#DOSBOX_OPTIONS="-conf /media/fat/DOSBox/Configs/dosbox-0.74-3_tandy.conf"
DOSBOX_LIB_PATH="$DOSBOX_HOME_DIR/arm-linux-gnueabihf:$DOSBOX_HOME_DIR/arm-linux-gnueabihf/pulseaudio"
DOSBOX_CONF_TMP="/tmp/DOSBox.config"
DOSBOX_CONF="$DOSBOX_HOME_DIR/.config"

if [ -d "$DOSBOX_CONF_TMP" ];
then
	echo "Removing --> $DOSBOX_CONF_TMP"
	rm -rf "$DOSBOX_CONF"
fi
echo "Creating DIR --> $DOSBOX_CONF_TMP"
mkdir "$DOSBOX_CONF_TMP"

if [ -L "$DOSBOX_CONF" ]; 
then
	echo "$DOSBOX_CONF is a symlink - perfect :)"
else
	if [ -d "$DOSBOX_CONF" ];
	then
		echo "Removing --> $DOSBOX_CONF"
		rm -rf "$DOSBOX_CONF"
	fi
	echo "Linking $DOSBOX_CONF_TMP --> $DOSBOX_CONF"
	ln -s "$DOSBOX_CONF_TMP" "$DOSBOX_CONF"
fi

echo "Setting Video mode --> $DOSBOX_VMODE"
vmode $DOSBOX_VMODE

echo "Setting library path..."
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$DOSBOX_LIB_PATH"
echo $LD_LIBRARY_PATH
echo "Setting DosBox HOME path..."
export HOME="$DOSBOX_HOME_DIR"

cd $DOSBOX_HOME_DIR
echo "Starting DosBox..."
taskset $DOSBOX_CPU_MASK $DOSBOX_HOME_DIR/$DOSBOX_EXE_NAME $DOSBOX_OPTIONS 
echo "Removing --> $DOSBOX_CONF_TMP"
rm -rf "$DOSBOX_CONF_TMP"

