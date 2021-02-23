#include "pic_on_pic.h"

#include <string>

#include "pic1.h"

std::string pic_on_pic_func()
{
  std::string result {"pic_on_"};
  result.append(pic1_func());
  return result;
}
