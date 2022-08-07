#include <neorv32.h>

int main() {


  while (1) {
        neorv32_gpio_pin_toggle(0);
  }

  return 0;
}
