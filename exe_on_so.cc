#include <cstdlib>
#include <iostream>

#include "ar1.h"
#include "shared_library.h"

int main(int argc, char* argv[])
{
  std::cout << "exe_on_" << so_func() << '\n';
  std::cout << "exe_on_" << ar1_func() << '\n';
  return EXIT_SUCCESS;
}
