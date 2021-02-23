#include "ar_on_ar.h"

#include <string>

#include "ar1.h"

std::string ar_on_ar_func()
{
  std::string result {"ar_on_"};
  result.append(ar1_func());
  return result;
}
