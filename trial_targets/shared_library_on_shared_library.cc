#include "shared_library_on_shared_library.h"

#include <string>

#include "shared_library.h"

std::string so_on_so_func()
{
  std::string result {so_func()};
  result.append("_on_so");
  return result;
}
