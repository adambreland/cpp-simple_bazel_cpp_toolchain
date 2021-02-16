#include "ar_on_shared_library.h"

#include <string>

#include "shared_library.h"

std::string ar_on_so_func()
{
  std::string result {"ar_on_"};
  return result.append(so_func());
}
