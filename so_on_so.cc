#include "so_on_so.h"

#include <string>

#include "so.h"

std::string so_on_so_func()
{
  std::string result {so_func()};
  result.append("_on_so");
  return result;
}
