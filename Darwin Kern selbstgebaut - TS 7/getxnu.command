#!/bin/sh
# Macoun 2010, Session 7, Terrassensaal
# Darwin Kern selbstgebaut (Alexander von Below)

curl -O http://www.opensource.apple.com/tarballs/xnu/xnu-1504.7.4.tar.gz
tar xzf xnu-1504.7.4.tar.gz


curl -O http://www.opensource.apple.com/tarballs/bootstrap_cmds/bootstrap_cmds-72.tar.gz
tar xzf bootstrap_cmds-72.tar.gz

curl -O http://www.opensource.apple.com/tarballs/cxxfilt/cxxfilt-9.tar.gz
tar xzf cxxfilt-9.tar.gz

curl -O http://www.opensource.apple.com/tarballs/dtrace/dtrace-78.tar.gz
tar xzf dtrace-78.tar.gz

curl -O http://www.opensource.apple.com/tarballs/kext_tools/kext_tools-180.2.tar.gz
tar xzf kext_tools-180.2.tar.gz


curl -O http://www.opensource.apple.com/tarballs/IOKitUser/IOKitUser-514.16.2.tar.gz
tar xzf IOKitUser-514.16.2.tar.gz
