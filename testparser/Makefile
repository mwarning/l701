

SOURCES = main.c build_lex.c build_parse.c build_tree.c

CC = gcc
CFLAGS = -g -W -Wall # -Werror
LDFLAGS = -g

OBJECTS = $(SOURCES:.c=.o)


main: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

clean::
	$(RM) main *.d *.o build_lex.* build_parse.*

.c.o:
	$(CC) -MD -MP $(CFLAGS) -o $@ -c $<

build_lex.h: syntax.l
	flex syntax.l

build_parse.h: build.y
	bison build.y

build_lex.c: build_lex.h
	@

build_parse.c: build_parse.h
	@

DEPENDS = $(SOURCES:.c=.d)

-include $(DEPENDS)

%.d:
	@echo > $@ "$*.o: build_lex.h build_parse.h"

#main: main.c
#	bison build.y
#	flex syntax.l
#	gcc build_lex.c build_parse.c main.c -o main
