#ifndef MPUFFI_HH
#define MPUFFI_HH


#include "PureScript/PureScript.hh"

namespace MPUFFI {
  using namespace PureScript;

  void externSystemClock_Config(void);
  auto externfeSetPeripheral (const any &flag) -> any;
  auto externHAL_GPIO_WritePin (const any &GPIOx, const any &GPIO_Pin, const any &PinState) -> any;
  auto externHAL_Delay(const any &delay) -> any;

}
#endif