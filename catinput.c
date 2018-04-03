#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <string.h>

int main(int argc, char **argv) {
	if (argc == 1) {
		fprintf(stderr, "%s: Expected a path as first argument\n", argv[0]);
		return 1;
	}

	int not_interactive = argc == 3 &&
		(!strcmp(argv[2], "--not-interactive"));

	char *path = argv[1];
	FILE *device;
	if (!(device = fopen(path, "r"))) {
		fprintf(stderr, "Error while opening device: %m\n");
		return 1;
	}
	
	while (1) {
		struct input_event ev;
		if (!(fread(&ev, sizeof(ev), 1, device))) {
			fputs("Unknown error while reading from device\n", stderr);
			return 1;
		}
		if (not_interactive)
			printf("%hd\t%hd\t%d\n", ev.type, ev.code, ev.value);
		else
			printf("type: %hd code: %hd value: %d\n", ev.type, ev.code, ev.value);
		fflush(stdout);
	}
}
