# ledger-app-nerva

This repo contains the Nerva Ledger App for Ledger Nano S.

## Prerequisites

- Ledger firmware version 1.6+  
- Nerva CLI software 0.1.7.0 or above  
- The following packages installed: 

### Debian/Ubuntu
`apt install docker.io python3 python3-pip python3-virtualenv pcsc-tools pcscd libpcsclite1 libusb-1.0-0-dev python3-dev libudev-dev`  

*NOTE: It is best to also download the latest ledger live app and make sure your device is visible and accessible in the ledger live app.*

## Building the app

`cd ./scripts`  
`./ledger build`  
`./ledger load` 

For a full list of available commands run the `ledger` script without arguments

## Using the ledger with the Nerva CLI

Generate a hardware wallet  
`./nerva-wallet-cli --generate-from-device <wallet-path>`

Once done, you can load the wallet in future with  
`./nerva-wallet-cli --wallet-file <wallet-path> --hw-device "Ledger"`

## Can't connect to the ledger using the CLI or Load script

It most likely means you don't have the required udev rules to access the device. You can run programs and scripts accessing the ledger with sudo, or you can add the appropriate rules for the ledger.

Prior to Ubuntu 19.04, you need the following entries in `/etc/libccid_Info.plist`

```xml
<plist version="1.0">
<dict>
    <key>ifdVendorID</key>
    <array>
        <string>0x2C97</string> 
        ...
    </array>

    <key>ifdProductID</key>
    <array>
        <string>0x0001</string> 
        ...
    </array>

    <key>ifdFriendlyName</key>
    <array>
        <string>Ledger Nano S</string> 
        ...
    </array>
</dict>
</plist>
```

Create the following udev rules `/etc/udev/rules.d/99-ledger.rules`  
`SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", TAG+="uaccess", TAG+="udev-acl" GROUP="plugdev"`  
`SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl" GROUP="plugdev"`  
