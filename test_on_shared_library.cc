#include <cstdlib>

#include "shared_library.h"

int main(int argc, char* argv[])
{
  return (so_func() == "so") ? EXIT_SUCCESS : EXIT_FAILURE;
}
