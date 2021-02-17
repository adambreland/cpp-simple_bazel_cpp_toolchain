#include "shared_library_on_pic.h"

#include <string>

#include "pic1.h"

std::string so_on_pic_func()
{
  std::string result {"so_on_"};
  result.append(pic1_func());
  return result;
}
