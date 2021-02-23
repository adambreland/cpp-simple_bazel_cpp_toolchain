#include <cstdlib>
#include <iostream>
#include <string>

#include "shared_library_on_shared_library.h"

int main(int argc, const char* argv[])
{
  std::string test_string {so_on_so_func()};
  std::cout << test_string << '\n';
  return (test_string == std::string {"so_on_so"}) ?
    EXIT_SUCCESS : EXIT_FAILURE;
}
