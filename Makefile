SDKVER		= 4.3
DEVROOT		= /Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT		= $(DEVROOT)/SDKs/iPhoneOS$(SDKVER).sdk

CC			= $(DEVROOT)/usr/bin/arm-apple-darwin10-gcc-4.2.1
LD			= $(CC)
LDFLAGS		= -L$(SDKROOT)/usr/lib -L$(SDKROOT)/usr/lib/system -F$(SDKROOT)/System/Library/Frameworks -framework CoreFoundation -framework Foundation
CFLAGS		= -fconstant-cfstrings -std=c99 -Wall -O3 -I/var/include --sysroot='$(SDKROOT)' -isystem $(SDKROOT)/usr/include
VERSION		= 1.0

IP			= 10.0.1.3

TARGETS		= display-mirroring.o

all: display-mirroring

display-mirroring: $(TARGETS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
	rm -f display-mirroring 
	rm -f $(TARGETS)
	rm -f *.deb

package: all
	mkdir -p deb/usr/bin
	cp display-mirroring deb/usr/bin/
	dpkg-deb -b deb display-mirroring-$(VERSION).deb

transfer: package
	scp *.deb root@$(IP):

