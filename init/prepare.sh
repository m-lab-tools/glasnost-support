#!/bin/bash

set -x 
set -e

if [ -z "$SOURCE_DIR" ] ; then
    echo "Expected SOURCE_DIR in environment"
    exit 1
fi
if [ -z "$BUILD_DIR" ] ; then
    echo "Expected BIULD_DIR in environment"
    exit 1
fi

if test -d $BUILD_DIR ; then
    rm -rf $BUILD_DIR/*
fi

yum groupinstall -y Development\ Tools
# NOTE: assume EPEL repository is available 
# NOTE: this assumes an centos6+ environment
yum install -y libpcap libpcap-devel libcurl libcurl-devel libmicrohttpd \
               libmicrohttpd-devel eclipse-ecj libgcj libgcj-devel \
               java-1.5.0-gcj java-1.5.0-gcj-devel

pushd glasnost/src
    make 
    make applet
    make applet-mac
    # NOTE: there is no 'make install'
popd

cat <<EOF
Hi. PAY ATTENTION PLEASE!

The archive GlasnostReplayerMac.jar requires a proper signature to
work correctly on Mac OS X.

Depending on the name of your keystore this will look like:

    jarsigner -keystore <mlab-java-signing-keystore> GlasnostReplayerMac.jar <keyname>

After performing the above step, copy the .jar back to $BUILD_DIR/ and re-run
prepare.sh to pull in the newly signed .jar

TODO: make this work.
EOF

cp $SOURCE_DIR/glasnost/src/GlasnostReplayer*.jar  $BUILD_DIR/
cp $SOURCE_DIR/glasnost/src/gserver  $BUILD_DIR/
mkdir -p $BUILD_DIR/scripts
mkdir -p $BUILD_DIR/logs
cp $SOURCE_DIR/glasnost/src/protocols.spec 	 $BUILD_DIR/scripts
# NOTE: these scripts are not committed yet.
#cp $SOURCE_DIR/glasnost/ops/datapull_rename.py $BUILD_DIR/
#cp $SOURCE_DIR/glasnost/ops/cleanup.py         $BUILD_DIR/
cp $SOURCE_DIR/init/datapull_rename.py $BUILD_DIR/
cp $SOURCE_DIR/init/cleanup.py         $BUILD_DIR/
cp -r $SOURCE_DIR/init $BUILD_DIR/
