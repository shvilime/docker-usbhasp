FROM ubuntu:bionic
LABEL maintainer="sergo@shvili.me"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ARG DEBIAN_FRONTEND=noninteractive

COPY files/usb-vhci-hcd.patch files/usb-vhci-iocifc.patch /tmp/
COPY files/usbhaspd /etc/init.d/
COPY keys /home/keys

RUN dpkg --add-architecture i386; \
    apt-get update; \
    # ---- Install packages ------------------------------------------------------------
    apt-get install -y --no-install-recommends linux-headers-$(uname -r) build-essential automake autoconf libtool libusb-0.1-4:i386 libjansson-dev git; \
    cd /tmp; \
    # ---- Clone vhci_hcd, libusb_vhci, UsbHasp from repositories ----------------------
    git clone git://git.code.sf.net/p/usb-vhci/vhci_hcd; \
    git clone git://git.code.sf.net/p/usb-vhci/libusb_vhci; \
    git -c http.sslVerify=false clone https://github.com/sam88651/UsbHasp.git; \
    cp /tmp/vhci_hcd/usb-vhci.h /usr/include/linux; \
    # ---- Compile and install vhci_hcd ------------------------------------------------
    cd /tmp/vhci_hcd; \
    patch usb-vhci-hcd.c /tmp/usb-vhci-hcd.patch; \
    patch usb-vhci-iocifc.c /tmp/usb-vhci-iocifc.patch; \
    make > /dev/null 2>&1; \
    cp usb-vhci-hcd.ko /lib/modules/$(uname -r); \
    cp usb-vhci-iocifc.ko /lib/modules/$(uname -r); \
    touch /etc/modules; \
    echo 'usb_vhci_hcd' >> /etc/modules; \
    echo 'usb_vhci_iocifc' >> /etc/modules; \
    # ---- Compile and install libusb_vhci ---------------------------------------------
    cd /tmp/libusb_vhci; \
    autoreconf --install --force > /dev/null 2>&1; \
    ./configure > /dev/null 2>&1; \
    make install > /dev/null 2>&1; \
    # ---- Compile and install UsbHasp -------------------------------------------------
    cd /tmp/UsbHasp; \
    make; \
    cp /tmp/UsbHasp/dist/Release/GNU-Linux/usbhasp /usr/local/bin/; \
    ldconfig; \
    # ---- Clear docker image ----------------------------------------------------------
    apt-get remove --purge -y linux-headers-$(uname -r) build-essential automake autoconf libtool git; \
    apt-get clean autoclean; \
    apt-get autoremove -y; \ 
    rm -rf /tmp/*; \
    rm -rf /var/lib/apt/lists/*

CMD /etc/init.d/usbhaspd start; tail -f /dev/null