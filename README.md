# urbit-turnkey debian package

Contains scripts and services to enable basic turnkey urbit functionality.

Place a keyfile on a usb storage device, named in the way bridge produces urbit keyfiles (e.g. `sampel-palnet-1.key`)

If using a distro with NetworkManager (Armbian), a `wifi.txt` file placed on a usb storage device, containing the SSID on the first line and the password (if any) on the second line, will setup wifi.

## To build

dpkg-buildpackage -uc -us
