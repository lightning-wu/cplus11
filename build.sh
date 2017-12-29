#!/bin/bash

set -e -u -E # this script will exit if any sub-command fails

WORK_DIR=$(cd $(dirname $0); pwd)
source ./build.conf

########################################
# download & build depend software
########################################

DEPS_SOURCE=$WORK_DIR/thirdsrc
DEPS_PREFIX=$WORK_DIR/thirdparty
DEPS_CONFIG="--prefix=${DEPS_PREFIX} --disable-shared --with-pic CPPFLAGS=-I${DEPS_PREFIX}/include LDFLAGS=-L${DEPS_PREFIX}/lib"
FLAG_DIR=$WORK_DIR/.build

export PATH=${DEPS_PREFIX}/bin:$PATH
mkdir -p ${DEPS_SOURCE} ${DEPS_PREFIX} ${FLAG_DIR} ${DEPS_PREFIX}/include ${DEPS_PREFIX}/lib

if [ ! -f "$WORK_DIR/depends.mk" ]; then
    cp $WORK_DIR/depends.mk.template $WORK_DIR/depends.mk
fi

cd ${DEPS_SOURCE}


#spdlog
if [ ! -f "${FLAG_DIR}/spdlog" ] \
    || [ ! -f "${DEPS_PREFIX}/include/spdlog/spdlog.h" ]; then
    git clone ${SPDLOG_URL}
    cd spdlog
    cp -rf include/spdlog ${DEPS_PREFIX}/include/
    cd -
    touch "${FLAG_DIR}/spdlog"
fi


cd ${WORK_DIR}

########################################
# config depengs.mk
########################################

sed -i "" "s:^SPDLOG=.*:SPDLOG=$DEPS_PREFIX:" depends.mk


cd ${WORK_DIR}
make clean
make
