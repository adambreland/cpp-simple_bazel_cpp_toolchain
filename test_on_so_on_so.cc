#include <cstdlib>
#include <string>

#include "so_on_so.h"

int main(int argc, const char* argv[])
{
  return (so_on_so_func() == std::string {"so_on_so"}) ?
    EXIT_SUCCESS : EXIT_FAILURE;
}
