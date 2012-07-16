#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <getopt.h>
#include <libconfig.h++>

using namespace std;
using namespace libconfig;

void print_help() {
  cout <<"Available arguments are :" << endl 				\
       << "\t-g : get current backlight percentage" << endl		\
       << "\t-s perc : set backlight percentage to perc" << endl	\
       << "\t-c perc : change current backlight percentage by perc" << endl \
       << "\t-h : print help" << endl					\
       << endl << "Only the first argument is taken into account." << endl;
}

string backlight_path;

 // read config file using libconfig
void parseconfig(const char * filename) {
	Config config;
	config.readFile(filename);

	config.lookupValue("backlight_path", backlight_path);
}


int main(int argc, char * argv[]) {
  
  parseconfig("backlight_control.cfg");
  
  bool gflag = false;
  bool sflag = false;
  bool cflag = false;
  int value = 0;
  int index;
  
  int option_char;
  bool arg_error;
  
  arg_error = false;
  
  if ((option_char = getopt(argc , argv, "ghc:s:")) != EOF )
    {
      switch (option_char)
	{
	case 'g':
	  gflag = true;
	  break;
	case 's':
	  sflag = true;
	  break;
	case 'c':
	  cflag = true;
	  break;
	case 'h':
	  print_help();
	  return 0;
	  break;
	case '?':
	  arg_error = true;
	  break;
	}
    }
  else { arg_error = true; }
  
  if (arg_error == true) {
    cerr << "Wrong or no argument given." << endl;
    print_help();
    return 1;
  }
  
  if (sflag || cflag) { value = atoi(optarg); }
  
  
  FILE * file_max_brightness;
  FILE * file_brightness;
  char path_tmp[80];
  
  strcpy(path_tmp, backlight_path.c_str());
  strcat(path_tmp, "max_brightness");
  
  file_max_brightness = fopen(path_tmp, "r");
  
  strcpy(path_tmp, backlight_path.c_str());
  strcat(path_tmp, "brightness");
  
  file_brightness = fopen(path_tmp, "r+");

  char str_max_brightness[10];
  char str_brightness[10];
  char str_new_brightness[10];
  
  
  fread(str_max_brightness, 8, 9, file_max_brightness);
  fread(str_brightness, 8, 9, file_brightness);
  
  
  int max_brightness = atoi(str_max_brightness);
  int brightness = atoi(str_brightness);

  if (gflag) {
    cout << "Current brightness : " << brightness * 100 / max_brightness <<"%" << endl;
    return 0;
  }

  int new_brightness;

  if (sflag) {
    new_brightness = max_brightness * value / 100;
  }
  
  if (cflag) {
    new_brightness = max_brightness * value / 100 + brightness;
  }

  sprintf(str_new_brightness, "%d", new_brightness);
  
  fseek(file_brightness, 0, SEEK_SET);
  fwrite(str_new_brightness, 8, 10, file_brightness);

  return 0;
}
