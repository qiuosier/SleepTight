#
#	Makefile for sleepwatcher
#
#	21.11.2004 bb	created
#	05.05.2005 bb	removed Carbon framework, target clean added
#	23.04.2006 bb	produce a Universal binary of sleepwatcher
#	02.04.2010 bb	-macosx-version-min=10.3 => 10.4
#	26.12.2018 bb	modified for 64-bit build, PowerPC now optional
#			use "make sleepwatcher" to build the Intel only binary,
#			use "make sleepwatcher.ppc" in a Xcode 3.2.6
#			environment to create the PowerPC binary, then
#			use "make fat" to create a fat binary (PowerPC and
#			Intel 32-bit and 64-bit)
#

CFLAGS_PPC= -O3 -prebind -mmacosx-version-min=10.4 -mtune=G4 -arch ppc
CFLAGS_I386= -O3 -prebind -mmacosx-version-min=10.4 -arch i386
CFLAGS_X86_64= -O3 -prebind -mmacosx-version-min=10.4 -arch x86_64 
LIBS= -framework IOKit -framework CoreFoundation

BINDIR=/usr/local/sbin
MANDIR=/usr/local/man

sleepwatcher: sleepwatcher.c
	$(CC) $(CFLAGS_I386) -o sleepwatcher.i386 sleepwatcher.c $(LIBS)
	$(CC) $(CFLAGS_X86_64) -o sleepwatcher.x86_64 sleepwatcher.c $(LIBS)
	lipo -create sleepwatcher.i386 sleepwatcher.x86_64 -output sleepwatcher
	rm sleepwatcher.i386 sleepwatcher.x86_64

fat: sleepwatcher sleepwatcher.ppc
	lipo -create sleepwatcher sleepwatcher.ppc -output sleepwatcher.fat
	mv sleepwatcher.fat sleepwatcher
	rm sleepwatcher.ppc

sleepwatcher.ppc: sleepwatcher.c
	$(CC) $(CFLAGS_PPC) -o sleepwatcher.ppc sleepwatcher.c $(LIBS)

install: sleepwatcher sleepwatcher.8
	mkdir -p $(BINDIR)
	install -o root -g wheel -m 755 sleepwatcher $(BINDIR)
	mkdir -p $(MANDIR)/man8
	install -o root -g wheel -m 644 sleepwatcher.8 $(MANDIR)/man8

clean:
	rm -f sleepwatcher
