
# NERVA Ledger app

This is the binary distribution of the NERVA Ledger app.

This readme will provide instructions on how to verify the integrity of the ledger app and install it on your device.  
You should read and understand this document and ensure you are confident in the process before continuing.  
No responsibility will be taken for loss of funds or any unexpected behaviour of your device.
 
## Verify the signing key

It is important for security that the app be verified as coming from the official source. To meet this requirement, the app is signed using GPG.  
The app files are located in the `bin` directory

`./bin/app.hex`  
`./bin/app/hex.sig`

Before proceeding with the installation, we should ensure the app.hex file is official.

### Linux

`gpg --verify ./bin/app.hex.sig`

This will output the following something similar to the text below

```text
gpg: assuming signed data in './bin/app.hex'
gpg: Signature made Sat 09 Mar 2019 00:48:22 AEDT
gpg:                using RSA key 37CBC31FEAE5A569DD0C59D8E78478ACBBF8DA1A
gpg: Good signature from "Nerva Project <nerva@getnerva.org>" [ultimate]
```
We can see that the signature is good. Next, we must verify that the key that signed this is itself legitimate.  
Use the `--recv-key` option with the RSA key hash printed by the last command to verify with a key server that the 
author is indeed "Nerva Project"

`gpg --recv-key 37CBC31FEAE5A569DD0C59D8E78478ACBBF8DA1A`

This will output the following something similar to the text below

```text
gpg: key E78478ACBBF8DA1A: "Nerva Project <nerva@getnerva.org>" not changed
gpg: Total number processed: 1
gpg:              unchanged: 1
```

If this information matches and no errors are reported, we can proceed.

### Windows

TODO: Need windows instructions

## Installation

Before proceeding, please ensure you have python installed and your ledger is visible within the ledger live app

There is an installation script for Linux/Mac and Windows which contain the following functions

- Setup: `ledger.sh setup`  
This option will set up the ledger loader so you can install the app

- Install: `ledger.sh install`
This option will install the nerva app on your ledger

- Uninstall: `ledger.sh uninstall`
This option will uninstall the ledger app.

- Seed: `ledger.sh seed`
This option will send the seed for your ledger wallet to the device so that it can be viewed under the *Show Seed* option within the app

## Using the ledger with the Nerva CLI

Generate a hardware wallet  
`./nerva-wallet-cli --generate-from-device <wallet-path>`

Once done, you can load the wallet in future with  
`./nerva-wallet-cli --wallet-file <wallet-path> --hw-device "Ledger"`
