## License
These codes are licensed under CC0.
http://creativecommons.org/publicdomain/zero/1.0/deed.ja

## How to use
1. Check that pcc moves after describing something with [purescript-native](https://github.com/andyarvanitis/purescript-native).

1. Save STMicroelectronics `STM32CubeF4`.Then copy following files from `LL template` and save it in `bootfile`.

    `STM32Cube_FW_F4_V1.21.0\Drivers\CMSIS\Include`
    `STM32Cube_FW_F4_V1.21.0\Drivers\CMSIS\Device\ST\STM32F4xx\Include`
    `STM32Cube_FW_F4_V1.21.0\Drivers\STM32F4xx_HAL_Driver\Inc`

    `STM32Cube_FW_F4_V1.21.0\Projects\STM32F4-Discovery\Templates_LL\SW4STM32\STM32F4-Discovery\STM32F407VGTx_FLASH.ld`

    `STM32Cube_FW_F4_V1.21.0\Projects\STM32F4-Discovery\Templates_LL\Src\`
    `STM32Cube_FW_F4_V1.21.0\Projects\STM32F4-Discovery\Templates_LL\Inc\`
    `STM32Cube_FW_F4_V1.21.0\Projects\STM32F4-Discovery\Templates_LL\SW4STM32\startup_stm32f407xx.S`

1. Check the configuration of `bootfile`

    ```code
    workDir/
    |-bootfile/
    |---startup_stm32f407xx.s
    |---main.h
    |---stm32_assert.h
    |---stm32f4xx_it.h
    |---stm32f4xx_it.c
    |---system_stm32f4xx.c
    |---STM32F407VGTx_FLASH.ld
    |---STM32Cube_FW_F4_V1.21.0/

1. run `make`

    ```bash
    > make release SHELL='sh -x' GC=NO CXX=arm-none-eabi-gcc CXXFLAGS=-DSTM32F407xx CFLAGS=-DSTM32F407xx
    ``` 
1. Make sure that the executable file is produced.

    ```bash
    > qemu-system-gnuarmeclipse.exe --verbose --board STM32F4-Discovery --gdb tcp::3333 --semihosting-config enable=on,target=native --image ./output/bin/main
    ```

![Ltika](https://raw.githubusercontent.com/noolbar/purescript-native-demo-ltika/master/res/Ltika.gif)

## reference
[PureScriptでLチカをしよう(2)](https://qiita.com/noolbar/items/1243d53200c5106df0a0) (Japanese)

