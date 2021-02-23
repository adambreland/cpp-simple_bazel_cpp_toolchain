#include "shared_library_on_pic_on_pic.h"

#include <string>

#include "pic_on_pic.h"

std::string so_on_pic_on_pic_func()
{
  std::string result {"so_on_"};
  return result.append(pic_on_pic_func());
}
