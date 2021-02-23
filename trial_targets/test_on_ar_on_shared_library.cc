#include <cstdlib>
#include <iostream>
#include <string>

#include "ar_on_shared_library.h"

int main(int argc, char* argv[])
{
  return (ar_on_so_func() == "ar_on_so") ?
    EXIT_SUCCESS : EXIT_FAILURE;
}
