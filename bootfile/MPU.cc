#define MPUFFI_C

#include "stm32f4xx_it.h"
// #include <stm32f4xx_hal_gpio.h>
// #include <stm32f4xx_hal.h>
#include "PureScript/PureScript.hh"
#include "Main/Main_ffi.hh"
#include "Data.Unit/Unit.hh"

namespace MPUFFI {
  using namespace PureScript;

  auto externfeSetPeripheral (const any &flag) -> any {
    return [=]() -> any {
      RCC -> AHB1ENR |= static_cast<const unsigned int>(flag);
      return Data_Unit::unit;
    };
  };

  // void HAL_GPIO_WritePin(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin, GPIO_PinState PinState);
  auto externHAL_GPIO_WritePin (const any &GPIOx, const any &GPIO_Pin, const any &PinState) -> any {
    return [=]() -> any {
      GPIOD->MODER = static_cast<const unsigned int>(GPIOx);
      if(PinState != 0){
          GPIOD->ODR = static_cast<const unsigned int>(GPIO_Pin);
      }
      else {
          GPIOD->ODR = 0;
      }
      return Data_Unit::unit;
    };
  };

  // void HAL_Delay(uint32_t Delay);
  auto externHAL_Delay(const any &delay) -> any {
    return [=]() -> any {
      uint32_t max = static_cast<const unsigned int>(delay);
      volatile uint32_t count = 0;
      while(count < max ) {
          count++;
      }
      return Data_Unit::unit;
    };
  };


  /**
    * @brief  System Clock Configuration
    *         The system Clock is configured as follow :
    *            System Clock source            = PLL (HSE)
    *            SYSCLK(Hz)                     = 168000000
    *            HCLK(Hz)                       = 168000000
    *            AHB Prescaler                  = 1
    *            APB1 Prescaler                 = 4
    *            APB2 Prescaler                 = 2
    *            HSE Frequency(Hz)              = 8000000
    *            PLL_M                          = 8
    *            PLL_N                          = 336
    *            PLL_P                          = 2
    *            VDD(V)                         = 3.3
    *            Main regulator output voltage  = Scale1 mode
    *            Flash Latency(WS)              = 5
    * @param  None
    * @retval None
    */
  void SystemClock_Config(void)
  {
    /* Enable HSE oscillator */
    LL_RCC_HSE_Enable();
    while(LL_RCC_HSE_IsReady() != 1)
    {
    };

    /* Set FLASH latency */
    LL_FLASH_SetLatency(LL_FLASH_LATENCY_5);

    /* Main PLL configuration and activation */
    LL_RCC_PLL_ConfigDomain_SYS(LL_RCC_PLLSOURCE_HSE, LL_RCC_PLLM_DIV_8, 336, LL_RCC_PLLP_DIV_2);
    LL_RCC_PLL_Enable();
    while(LL_RCC_PLL_IsReady() != 1)
    {
    };

    /* Sysclk activation on the main PLL */
    LL_RCC_SetAHBPrescaler(LL_RCC_SYSCLK_DIV_1);
    LL_RCC_SetSysClkSource(LL_RCC_SYS_CLKSOURCE_PLL);
    while(LL_RCC_GetSysClkSource() != LL_RCC_SYS_CLKSOURCE_STATUS_PLL)
    {
    };

    /* Set APB1 & APB2 prescaler */
    LL_RCC_SetAPB1Prescaler(LL_RCC_APB1_DIV_4);
    LL_RCC_SetAPB2Prescaler(LL_RCC_APB2_DIV_2);

    /* Set systick to 1ms */
    SysTick_Config(168000000 / 1000);

    /* Update CMSIS variable (which can be updated also through SystemCoreClockUpdate function) */
    SystemCoreClock = 168000000;
  }

  /* ==============   BOARD SPECIFIC CONFIGURATION CODE END      ============== */

  #ifdef  USE_FULL_ASSERT

  /**
    * @brief  Reports the name of the source file and the source line number
    *         where the assert_param error has occurred.
    * @param  file: pointer to the source file name
    * @param  line: assert_param error line source number
    * @retval None
    */
  void assert_failed(uint8_t *file, uint32_t line)
  {
    /* User can add his own implementation to report the file name and line number,
      ex: printf("Wrong parameters value: file %s on line %d", file, line) */

    /* Infinite loop */
    while (1)
    {
    }
  }
  #endif

  /**
    * @}
    */

  /**
    * @}
    */

  /************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

  void externSystemClock_Config(void){
    SystemClock_Config();
  }
}
