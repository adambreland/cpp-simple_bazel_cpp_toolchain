#include "pic_on_shared_library.h"

#include <string>

#include "shared_library.h"

std::string pic_on_so_func()
{
  std::string result {"pic_on_"};
  result.append(so_func());
  return result;
}
