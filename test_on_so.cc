#include <cstdlib>

#include "so.h"

int main(int argc, char* argv[])
{
  return (so_func() == "so") ? EXIT_SUCCESS : EXIT_FAILURE;
}
