void print_char(char c) {
  volatile char *video = (volatile char*)0xB8000;
  video[0] = c;
  video[1] = 0x07;
}

void kernel_main() {
  const char* str = "Hello from kernel!";
  char* vidptr = (char*)0xb8000;
  unsigned int i = 0;
  unsigned int j = 0;

  while (j < 80 * 25 * 2) {
    vidptr[j] = ' ';
    vidptr[j + 1] = 0x07;
    j = j + 2;
  }

  j = 0;

  while (str[i] != '\0') {
    vidptr[j] = str[i];
    vidptr[j + 1] = 0x07;
    ++i;
    j = j + 2;
  }
  print_char('A');
  return;
}
