#include <cstdlib>
#include <iostream>

#include "shared_library.h"

int main(int argc, char* argv[])
{
  std::cout << "exe_on_" << so_func() << '\n';
  return EXIT_SUCCESS;
}
