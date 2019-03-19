#!/bin/bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export SDK_VER=1552
export DEVICE_ID=0x31100004
export APP_NAME=Nerva
export APP_VER=1.5.8
export APP_SIZE=0x00000280
export ICON_HEX=0100000000ffffff00a815a815fc3f07e004304718e408a72db4e5102718e20c2007e0fc3fa815a815

if [ -f "${dir}/loader/bin/activate" ]; then
    echo "Setting python environment"
    source ${dir}/loader/bin/activate
fi

function setup()
{
    echo "Please provide your user password to install dependencies or press Ctrl+C to skip"
    sudo apt install pcsc-tools pcscd libpcsclite1 libudev-dev libusb-1.0-0-dev python-dev virtualenv libusb-dev libudev-dev

    if ! [ -d "${dir}/loader" ]; then
        virtualenv -p python3 loader
        source ${dir}/loader/bin/activate
        pip3 install pycryptodomex ECPy ledgerblue

        pkgdir=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")

        if [ ! -d "${pkgdir}" ]; then
            echo "Could not determine site-packages folder. seedconv utility will be unavailable"
        else
            cp -r ${dir}/tools/seedconv ${pkgdir}/tools
        fi

    else
        echo "Ledger virtualenv already created"
    fi

    exit 0
}

function install()
{
    python3 -m ledgerblue.loadApp --targetId ${DEVICE_ID} --fileName ${dir}/bin/app.hex \
    --appName ${APP_NAME} --appVersion ${APP_VER} --dataSize ${APP_SIZE} --icon ${ICON_HEX} \
    --appFlags 0x40 --path "44'/14336'" --curve secp256k1 --tlv

    exit 0
}

function uninstall()
{ 
    python3 -m ledgerblue.deleteApp --targetId ${DEVICE_ID} --appName ${APP_NAME}
    exit 0
}

function seed()
{
    python3 -m tools.seedconv online
    exit 0
}

$1