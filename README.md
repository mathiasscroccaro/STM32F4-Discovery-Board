# STM32F4 DISCOVERY BOARD

In the project's directorys you will find some examples codes for STM32F4 Discovery Board. This budget I bought from Aliexpress. At the present moment, I am at the master's degree and I did had to pay the recently new tax from brazilian post offices (R$15,00) for imported products.

Next lines, I will describe how to program and flash the device. Looks simple, but it was a hard work to compile all theses informations.

## Installing the IDE and configuring the flasher

You have to install:

1) IDE and compiller: install the System Workbench plataform;
2) Flasher: install st-flash project from Texane (Thanks a lot!).
https://github.com/texane/stlink
3) STM32 CubeMx from ST Electronics. With this shit you gonna build a rocket with 5 code lines. No kidding

## Compilling and flashing

1) Create a new project at CubeMX
2) Export for the system workbench. Remember to change to SW4... your development tool;
3) Code;
4) Go to root directory of your ".hex" file and type at the terminal:
	arm-none-eabi-objcopy -S -O binary <your.project.name.hex> <your.project.name.bin>
	st-flash write <your.project.name.bin> 0x08000000
