# Quectel_EC2x_QuecOpen_Examples

This is QuecOpen examples for Quectel EC2X modules

## Requirements

In order to play with samples, there are some consumptions:

- EC2X QuecOpen SDK from your local Quectel contact
- Ubuntu machine running LTS Ubuntu 14.04 or 16.04 or 18.04
- EC2X module is flashed with firmware which is same prefix name with the SDK number. In this guide, I will use `EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001_SDK.tar.bz2` for SDK and base FW `EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001.zip`
- Able to use ADB to communicate with the module

## Clone the repo

Clone the repo with --recursive param, so it could also clone the submodule:

```bash
git clone --recursive https://github.com/ngohaibac/Quectel_EC2x_QuecOpen_Examples.git
cd Quectel_EC2x_QuecOpen_Examples
```

## Preparation

### Step 1: Upgrade base firmware

In order to work with QuecOpen, the module needs to be flashed with QuecOpen base firmware EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001.zip.

Note: the SDK and the base firmware must be matched

- Base firmware: EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001.zip
- SDK: EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001_SDK.tar.bz2

### Step 2: Install driver and extract SDK

1. Install driver and test ADB

Suggested dev environment is: Ubuntu LTS 18.04 or 16.04.

In order to support all futher Quectel modules, it is suggested to install drivers and configure the system to recognize ADB port. Follow the instruction in folder `Quectel_Module_ADB_Issue'. This is the most important step.

Now, you should see the device with command: `adb devices`, and also see 4 serial ports:

- /dev/ttyUSB0 - DM port for upgrade firmware and get the device log
- /dev/ttyUSB1 - get NMEA message output
- /dev/ttyUSB2 - for AT command communication
- /dev/ttyUSB3 - for PPP connections or AT communication

You also able to login to the device using:

```bash
adb shell
```

1. SDK Copy the SDK and extract:

```bash
cp /path/EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001_SDK.tar.bz2 .
tar xjvf EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001_SDK.tar.bz2
```

Folder structure:

```bash
tree -L 2
.
├── EC21EFAR06A01M4G_OCPU_BETA1112_01.001.01.001_SDK.tar.bz2
├── HelloWorld
│   ├── CMakeLists.txt
│   ├── build
│   ├── build.sh
│   └── main.c
├── LICENSE
├── Quectel_Modules_ADB_Issue
│   ├── 51-android.rules
│   ├── LICENSE
│   ├── Quectel_Modules_ADB_Issue
│   ├── README.md
│   ├── adb_usb.ini
│   └── setup.sh
├── README.md
└── ql-ol-sdk
    ├── Makefile
    ├── ql-ol-crosstool
    ├── ql-ol-extsdk
    ├── ql-ol-kernel
    ├── ql-ol-rootfs
    ├── ql-ol-rootfs.tar.gz
    └── ql-ol-usrdata
```

In order to prepare cross platform environment, please execute this before each build session.

```bash
source ql-ol-sdk/ql-ol-crosstool/ql-ol-crosstool-env-init
```

## Step 3: Compile the example

### Compile the source

Inside each folder, run bash script or cmake to create Makefile:

```bash
cd HelloWorld
sh build.sh
```

OR

```bash
cd HelloWorld
mkdir build
cd build
cmake ..
make
```

Result is in build/ folder.

### Run and debug inside QuecOpen

Inside the build directory, copy the program into /usrdata

```bash
adb push HelloWorld /usrdata
adb shell
```

Inside the shell:

```bash
cd /usrdata
./HelloWorld
```

## EC2x available resources and notes

Inside EC2x, chipset is Qualcomm 9x07 and application is running on the ARM-Cortex A7. There are 2 available libraries in QuecOpen:

- Qualcomm dependent libs: located inside ql-ol-extsdk, which are provided by Quectel
- Standard Linux dependent libs: follow the Linux standard with compiled binary files and header files are located in ql-ol-crosstool/sysroots/. If the application needs extra function which is not yet compiled, user could compile and put into the rootfs

Available resource:

- RAM: 100MB
- Flash: Root partition 100MB
- User partiton: 100MB, is mouted under `/usrdata`

Current DTS has following peripheral info:

- SPI6 - `/dev/spi`
- I2C-2 - `/dev/i2c-2`
- I2C-4 - `/dev/i2c-4`
- UART-5 - `/dev/ttyHSL1` (disabled by default)
- UART-2 - `/dev/ttyHSL0` (enabled by default; for debug port)
- UART-6 - `/dev/ttyHSL2` (disabled by default; with SPI)
- UART-3 - `/dev/ttyHS0` (enabled by default)

To communicate with the baseband core, use: `/dev/smd8`