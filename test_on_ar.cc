#include <cstdlib>
#include <string>

#include "ar1.h"

int main(int argc, char* argv[])
{
  std::string result {"test_on_"};
  result.append(ar1_func());
  return (result == "test_on_ar1") ?
    EXIT_SUCCESS : EXIT_FAILURE;
}
