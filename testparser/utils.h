
#pragma once

char *read_file(size_t *size, const char path[]);
void print_loc(const char *file_path, const char *file_data, size_t file_length, size_t pos);
