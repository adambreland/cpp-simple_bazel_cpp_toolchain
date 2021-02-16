#include <cstdlib>
#include <iostream>
#include <string>

#include "ar1.h"

int main(int argc, char* argv[])
{
  std::cout << "exe_on_" << ar1_func() << '\n';
  return EXIT_SUCCESS;
}
