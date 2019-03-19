@ECHO off
SET dir=%~dp0

SET SDK_VER=1552
SET DEVICE_ID=0x31100004
SET APP_NAME=Nerva
SET APP_VER=1.5.8
SET APP_SIZE=0x00000280
SET ICON_HEX=0100000000ffffff00a815a815fc3f07e004304718e408a72db4e5102718e20c2007e0fc3fa815a815

IF "%1"=="" GOTO exit

IF EXIST "%dir%\loader\bin\activate.bat" (
    ECHO "Setting python environment"
    CALL "%dir%\loader\bin\activate.bat"
)

GOTO %1

:setup

    IF NOT EXIST "%dir%\loader\" (
        pip3 install virtualenv
        virtualenv -p python.exe loader
        CALL "%dir%\loader\scripts\activate.bat"
        pip3 install pycryptodomex ECPy ledgerblue pyreadline
        XCOPY "%dir%\tools\seedconv" "%dir%\loader\lib\site-packages\tools\" /s /y /d
    )

GOTO exit

:install

    python -m ledgerblue.loadApp --targetId %DEVICE_ID% --fileName %dir%\bin\app.hex ^
    --appName %APP_NAME% --appVersion %APP_VER% --dataSize %APP_SIZE% --icon %ICON_HEX% ^
    --appFlags 0x40 --path "44'/14336'" --curve secp256k1 --tlv

GOTO exit

:uninstall

    python -m ledgerblue.deleteApp --targetId %DEVICE_ID% --appName %APP_NAME%

GOTO exit

:seed

    python -m tools.seedconv online

GOTO exit

:exit
pause