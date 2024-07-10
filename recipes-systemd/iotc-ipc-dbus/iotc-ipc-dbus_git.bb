DESCRIPTION = "IOTC IPC for python with dbus wrapper class"

LICENSE = "CLOSED"

SRC_URI += "git://git@github.com/vputys/ipc_iotc_dbus.git;branch=master;protocol=ssh"

SRCREV = "6378658c9011a98ea7ed545948d91bf513a5107b"

inherit setuptools3

S = "${WORKDIR}/git"

RDEPENDS:${PN} += "python3 python3-pydbus"