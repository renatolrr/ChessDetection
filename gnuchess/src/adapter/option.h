/* option.h

   GNU Chess protocol adapter

   Copyright (C) 2001-2011 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


// option.h

#ifndef OPTION_H
#define OPTION_H

// includes

#include "util.h"

namespace adapter {
  
// functions

extern void         option_init       ();

extern bool         option_set        (const char var[], const char val[]);
extern const char * option_get        (const char var[]);

extern bool         option_get_bool   (const char var[]);
extern double       option_get_double (const char var[]);
extern int          option_get_int    (const char var[]);
extern const char * option_get_string (const char var[]);

}  // namespace adapter

#endif // !defined OPTION_H

// end of option.h

