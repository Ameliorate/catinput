TARGET=catinput
LIBS=
CC?=gcc
CFLAGS?=-g -Wall
INSTALL_PATH?=/usr/local/bin
MANUAL_PATH?=/usr/share/man/man1

.PHONY: default all clean run format install uninstall

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o
	-rm -f $(TARGET)

run: $(TARGET)
	./$(TARGET)

format:
	indent -linux -i8 -nut -l80 *.c

install: $(TARGET)
	install $(TARGET) $(INSTALL_PATH)
	cp nmfd.1 $(MANUAL_PATH)
	
uninstall:
	rm -f $(INSTALL_PATH)/$(TARGET)
	rm -f $(MANUAL_PATH)/nmfd.1
	
check:
	test -f $(TARGET)

