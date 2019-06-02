# dinput - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dinput.c stest.c util.c
OBJ = $(SRC:.c=.o)

all: options dinput stest

options:
	@echo dinput build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dinput: dinput.o drw.o util.o
	$(CC) -o $@ dinput.o drw.o util.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dinput stest $(OBJ) dinput-$(VERSION).tar.gz

dist: clean
	mkdir -p dinput-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dinput.1\
		drw.h util.h dinput_path dinput_run stest.1 $(SRC)\
		dinput-$(VERSION)
	tar -cf dinput-$(VERSION).tar dinput-$(VERSION)
	gzip dinput-$(VERSION).tar
	rm -rf dinput-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dinput dinput_path dinput_run stest $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dinput
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dinput_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dinput_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dinput.1 > $(DESTDIR)$(MANPREFIX)/man1/dinput.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dinput.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dinput\
		$(DESTDIR)$(PREFIX)/bin/dinput_path\
		$(DESTDIR)$(PREFIX)/bin/dinput_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/dinput.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
