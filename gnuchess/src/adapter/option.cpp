/* option.cpp

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


// option.cpp

// includes

#include <cstdlib>
#include <cstring>

#include "option.h"
#include "util.h"

namespace adapter {
  
// constants

static const bool UseDebug = false;

// types

struct option_t {
   const char * var;
   const char * val;
};

// variables

static option_t Option[] = {

   { "OptionFile",    NULL, }, // string

   // options

   { "EngineName",    NULL, }, // string
   { "EngineDir",     NULL, }, // string
   { "EngineCommand", NULL, }, // string

   { "Log",           NULL, }, // true/false
   { "LogFile",       NULL, }, // string

   { "Chess960",      NULL, }, // true/false

   { "Resign",        NULL, }, // true/false
   { "ResignMoves",   NULL, }, // move number
   { "ResignScore",   NULL, }, // centipawns

   { "MateScore",     NULL, }, // centipawns

   { "Book",          NULL, }, // true/false
   { "BookFile",      NULL, }, // string

   { "BookRandom",    NULL, }, // true/false
   { "BookWorst",     NULL, }, // true/false
   { "BookLearn",     NULL, }, // true/false

   { "KibitzMove",    NULL, }, // true/false
   { "KibitzPV",      NULL, }, // true/false

   { "KibitzCommand", NULL, }, // string
   { "KibitzDelay",   NULL, }, // seconds

   { "ShowPonder",    NULL, }, // true/false

   // work-arounds

   { "UCIVersion",    NULL, }, // 1-
   { "CanPonder",     NULL, }, // true/false
   { "SyncStop",      NULL, }, // true/false
   { "PromoteWorkAround", NULL, }, // true/false

   // { "",              NULL, },

   { NULL,            NULL, },
};

// prototypes

static option_t * option_find (const char var[]);

// functions

// option_init()

void option_init() {

   // option file

   const char optionName[]="gnuchess.ini";
   char optionFile[MaxFileNameSize+1];
   FILE *of;
   if ( ( of = fopen(optionName, "r") ) != NULL ) {
      fclose(of);
      strcpy(optionFile,"");
   } else {
      strcpy(optionFile,compute_pkgdatadir());
      strcat(optionFile,"/");
   }
   strcat(optionFile,optionName);

   // options

   option_set("OptionFile",optionFile);

   option_set("EngineName","GNU Chess");
   option_set("EngineDir",".");
   option_set("EngineCommand","<empty>");

   option_set("Log","false");
   option_set("LogFile","adapter.log");

   option_set("Chess960","false");

   option_set("Resign","false");
   option_set("ResignMoves","3");
   option_set("ResignScore","600");

   option_set("MateScore","10000");

   option_set("Book","false");
   option_set("BookFile","book.bin");

   option_set("BookRandom","true");
   option_set("BookWorst","false");
   option_set("BookLearn","false");

   option_set("KibitzMove","false");
   option_set("KibitzPV","false");

   option_set("KibitzCommand","tellall");
   option_set("KibitzDelay","5");

   option_set("ShowPonder","true");

   // work-arounds

   option_set("UCIVersion","2");
   option_set("CanPonder","false");
   option_set("SyncStop","false");
   option_set("PromoteWorkAround","false");

   // option_set("","");
}

// option_set()

bool option_set(const char var[], const char val[]) {

   option_t * opt;

   ASSERT(var!=NULL);
   ASSERT(val!=NULL);

   opt = option_find(var);
   if (opt == NULL) return false;

   my_string_set(&opt->val,val);

   if (UseDebug) my_log("POLYGLOT OPTION SET \"%s\" -> \"%s\"\n",opt->var,opt->val);

   return true;
}

// option_get()

const char * option_get(const char var[]) {

   option_t * opt;

   ASSERT(var!=NULL);

   opt = option_find(var);
   if (opt == NULL) my_fatal("option_get(): unknown option \"%s\"\n",var);

   if (UseDebug) my_log("POLYGLOT OPTION GET \"%s\" -> \"%s\"\n",opt->var,opt->val);

   return opt->val;
}

// option_get_bool()

bool option_get_bool(const char var[]) {

   const char * val;

   val = option_get(var);

   if (false) {
   } else if (my_string_case_equal(val,"true") || my_string_case_equal(val,"yes") || my_string_equal(val,"1")) {
      return true;
   } else if (my_string_case_equal(val,"false") || my_string_case_equal(val,"no") || my_string_equal(val,"0")) {
      return false;
   }

   ASSERT(false);

   return false;
}

// option_get_double()

double option_get_double(const char var[]) {

   const char * val;

   val = option_get(var);

   return atof(val);
}

// option_get_int()

int option_get_int(const char var[]) {

   const char * val;

   val = option_get(var);

   return atoi(val);
}

// option_get_string()

const char * option_get_string(const char var[]) {

   const char * val;

   val = option_get(var);

   return val;
}

// option_find()

static option_t * option_find(const char var[]) {

   option_t * opt;

   ASSERT(var!=NULL);

   for (opt = &Option[0]; opt->var != NULL; opt++) {
      if (my_string_case_equal(opt->var,var)) return opt;
   }

   return NULL;
}

}  // namespace adapter

// end of option.cpp

