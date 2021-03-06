#
# Sleep Tight, Part of Project Gemini.
# 2019 Qiu Qin.
# 
# This file is modified from the make file for sleepwatcher by Bernhard Baehr.
# Modifications:
# 19.5.2019 qq	Install and load plist file.
# 18.5.2019 qq	Added 64-bit only build. Use "make sleepwatcher64" to build 64-bit only binary.
#				Changed manual directory to /usr/local/share/man.
#				Remove "-o" and "-g" options in "make install".
# 				"make install" now works for single user without root permission.
# 				For newer macOS, use the following commands to create a symlink for libgcc_s
#				$ cd /usr/local/lib
#				$ sudo ln -s ../../lib/libSystem.B.dylib libgcc_s.10.4.dylib
# 
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

# Binary directory
BINDIR=/usr/local/sbin
# Manual directory
MANDIR=/usr/local/share/man
# LaunchAgent directory
AGENTDIR=~/Library/LaunchAgents
# The .plist file for launchd
PLIST=de.bernhard-baehr.sleepwatcher.plist
# Gets the basename (filename) of the .plist file.
# This may not be the same as $(PLIST) if use supply PLIST=path/to/file in make install
AGENTNAME=$(shell basename $(PLIST))

sleepwatcher: sleepwatcher.c
	$(CC) $(CFLAGS_I386) -o sleepwatcher.i386 sleepwatcher.c $(LIBS)
	$(CC) $(CFLAGS_X86_64) -o sleepwatcher.x86_64 sleepwatcher.c $(LIBS)
	lipo -create sleepwatcher.i386 sleepwatcher.x86_64 -output sleepwatcher
	rm sleepwatcher.i386 sleepwatcher.x86_64

sleepwatcher64: sleepwatcher.c
	$(CC) $(CFLAGS_X86_64) -o sleepwatcher.x86_64 sleepwatcher.c $(LIBS)
	lipo -create sleepwatcher.x86_64 -output sleepwatcher
	rm sleepwatcher.x86_64

fat: sleepwatcher sleepwatcher.ppc
	lipo -create sleepwatcher sleepwatcher.ppc -output sleepwatcher.fat
	mv sleepwatcher.fat sleepwatcher
	rm sleepwatcher.ppc

sleepwatcher.ppc: sleepwatcher.c
	$(CC) $(CFLAGS_PPC) -o sleepwatcher.ppc sleepwatcher.c $(LIBS)

install: sleepwatcher sleepwatcher.8
	mkdir -p $(BINDIR)
	install -m 755 sleepwatcher $(BINDIR)
	mkdir -p $(MANDIR)/man8
	install -m 644 sleepwatcher.8 $(MANDIR)/man8
	install -m 644 $(PLIST) $(AGENTDIR)
	launchctl unload ~/Library/LaunchAgents/$(AGENTNAME)
	launchctl load ~/Library/LaunchAgents/$(AGENTNAME)

clean:
	rm -f sleepwatcher
