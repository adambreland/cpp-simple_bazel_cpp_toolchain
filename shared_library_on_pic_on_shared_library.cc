#include "shared_library_on_pic_on_shared_library.h"

#include <string>

#include "pic_on_shared_library.h"

std::string so_on_pic_on_so_func()
{
  std::string result {"so_on_"};
  result.append(pic_on_so_func());
  return result;
}
