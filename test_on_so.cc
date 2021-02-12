#include <cstdlib>

#include "so.h"

int main(int argc, char* argv[])
{
  return (so_func(1) == 1) ? EXIT_SUCCESS : EXIT_FAILURE;
}
