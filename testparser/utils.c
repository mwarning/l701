#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>


void print_loc(const char *file_path, const char *file_data, size_t file_length, size_t pos) {
    //assert(file_path.length);
    //assert(pos < file_length);

    //const char beg = file_data;
	const char* beg = file_data;
	const char* ptr = beg + pos;
	const char* end = beg + file_length;

    if (pos > 0 && pos == file_length) {
        pos -= 1;
    }

	if (pos > file_length) {
		fprintf(stderr, "<Location out of bounds>\n");
		return;
	}

    if (file_length == 0) {
        fprintf(stderr, "<File is empty>\n");
        return;
    }

	//assert(beg <= end, "beg <= end");
	//assert(beg <= ptr, "beg <= ptr");
	//assert(end >= ptr, "end >= ptr");
	
	//size_t pos = ptr - beg;
	int col = 0;
	int row = 0;
	
	const char *p = beg;
	const char* row_beg = beg;
	while (p < ptr) {
		if (*p == '\n') {
			row += 1;
			row_beg = p+1;
		}
		++p;
	}
	col = ptr - row_beg;
	
	const char *row_end = row_beg;
	while (row_end < end) {
		if (*row_end == '\n') {
            break;
		}

		row_end += 1;
	}

	//auto indent = new char[](col);
	//indent[] = ' ';

	//auto line = row_beg[0..row_end-row_beg];
	
    /*
	//replace all tabs from the line
	//to get the marker to the right position
	for(auto i = 0; i < line.length; ++i)
	{
		if(line[i] == '\t')
			line[i] = ' ';
	}*/
    
    fprintf(stderr, "%s:%d:%d\n", file_path, row + 1, col + 1);

    int row_len = row_end - row_beg;
    for (int i = 0; i < row_len; i += 1) {
		fprintf(stderr, "%c\n", row_beg[i]);
	}
	fprintf(stderr, "\n");

	for (int i = 0; i < col; i += 1) {
		fprintf(stderr, " ");
	}
	fprintf(stderr, "^");

    return;
}
