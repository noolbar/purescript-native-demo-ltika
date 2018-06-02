module Main where
import Prelude
-- import Control.Monad.Eff.Console (log, logShow)

-- fib :: Int -> Int
-- fib 0 = 0
-- fib 1 = 1
-- fib n = fib (n - 2) + fib (n - 1)

-- main = do
--   log "Here's the result of fib 10:"
--   logShow (fib 10)


-- fib :: Int -> Int
-- fib 0 = 0
-- fib 1 = 1
-- fib n = fib (n - 2) + fib (n - 1)

-- main = do
--   fib 10

import Control.Monad.Eff ( Eff )
foreign import data MEMORY :: !
-- #define RCC_AHB1ENR_GPIODEN 0x00000008
-- #define PERIPH_BASE         0x40000000U
-- #define AHB1PERIPH_BASE     (PERIPH_BASE + 0x00020000U)
-- #define GPIOD_BASE          (AHB1PERIPH_BASE + 0x0C00U)
-- #define GPIOD               ((GPIO_TypeDef *) GPIOD_BASE)
-- #define GPIO_PIN_15         ((uint16_t)0x8000)
foreign import externSystemClock_Config :: forall eff. Eff ( memory :: MEMORY | eff ) Unit
foreign import externfeSetPeripheral :: forall eff. Int -> Eff( memory :: MEMORY | eff ) Unit
--foreign import unsafeHAL_GPIO_WritePin :: forall a b c. a -> b -> c -> Unit
foreign import externHAL_GPIO_WritePin :: forall eff. Int -> Int -> Int -> Eff( memory :: MEMORY | eff ) Unit
foreign import externHAL_Delay :: forall eff. Int -> Eff( memory :: MEMORY | eff ) Unit


main :: forall eff a.  Eff( memory :: MEMORY | eff ) a
main = do
  externSystemClock_Config
  externfeSetPeripheral 0x00000008
  infLoop
  where
    infLoop = do
      externHAL_GPIO_WritePin 0x40000000 0x8000 1
      externHAL_Delay 0x05037A00
      externHAL_GPIO_WritePin 0x40000000 0x8000 0
      externHAL_Delay 0x0A037A00
      infLoop