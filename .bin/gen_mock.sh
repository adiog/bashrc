#!/bin/bash
# Copyright 2016 Aleksander Gajewski <adiog@brainfuck.pl>
#   created:  Sat 13 Aug 2016 12:10:34 PM CEST
#   modified: Sat 13 Aug 2016 12:31:03 PM CEST


# use an absolute path as a single argument
HEADER_TO_MOCK=$1


# BASH_CLEANUP {{{
BASH_CLEANUP_FILE=`mktemp`
trap BASH_CLEANUP EXIT

function BASH_CLEANUP() {
  BASH_CLEANUP_FILE_REV=`mktemp`
  tac $BASH_CLEANUP_FILE > $BASH_CLEANUP_FILE_REV
  . $BASH_CLEANUP_FILE_REV
  rm $BASH_CLEANUP_FILE $BASH_CLEANUP_FILE_REV
}

function BASH_FINALLY() {
  echo "$*" >> $BASH_CLEANUP_FILE
}

function BASH_MKTEMP() {
  BASH_TMP=`mktemp`
  echo "rm $BASH_TMP" >> $BASH_CLEANUP_FILE
  echo $BASH_TMP
}

function BASH_MKTEMP_DIR() {
  BASH_TMP=`mktemp -d`
  echo "rm -fr $BASH_TMP" >> $BASH_CLEANUP_FILE
  echo $BASH_TMP
}
# }}}


if [[ -z "${GOOGLEMOCK_PATH}" ]];
then
  echo "Please set GOOGLEMOCK_PATH environment variable."
  exit 1
fi

GENERATOR=${GOOGLEMOCK_PATH}/scripts/generator/gmock_gen.py

if [[ -z "${COPYRIGHT_HEADER_TXT}" ]];
then
  echo "Please set COPYRIGHT_HEADER_TXT environment variable."
  exit 1
fi

if [[ ! -f ${COPYRIGHT_HEADER_TXT} ]];
then
  echo "COPYRIGHT_HEADER_TXT file does not exist."
  exit 1
fi

# change:
#   /path/to/repo/src/component/INCLUDE/header.hpp
# to:
#   /path/to/repo/src/component/TEST/INCLUDE/MOCKS/header.hpp
PATH_TO_MOCK=${HEADER_TO_MOCK/include/test\/include\/mocks}

# change:
#   /path/to/repo/src/component/test/include/mocks/header.HPP
# to:
#   /path/to/repo/src/component/test/include/mocks/headerMOCK.HPP
MOCK=${PATH_TO_MOCK/.hpp/Mock.hpp}

# change:
#   /path/to/repo/src/component/INCLUDE/header.hpp
# to:
#                                       header.hpp
INCLUDE_HEADER=${HEADER_TO_MOCK/*include\//}

# stop if mock already exists
if [[ -f $MOCK ]];
then
    echo "Mock file ${MOCK} already exists."
    exit 1
fi

# create a folder
MOCK_DIR=`dirname ${MOCK}`
mkdir -p ${MOCK_DIR}

# generate the proper mock with shipped scripts to TEMP
TEMP=`BASH_MKTEMP`
$GENERATOR ${HEADER_TO_MOCK} > ${TEMP}

# concatenate a copyright header
cat ${COPYRIGHT_HEADER_TXT} > ${MOCK}

# concatenate default includes
(
echo ""
echo "#pragma once"
echo ""
echo "#include <${INCLUDE_HEADER}>"
echo "#include <gmock/gmock.h>"
echo ""
echo ""
) >> ${MOCK}

# swap MockClass to ClassMock and append modifed TEMP to the output mock file
sed -e "s/class Mock\(\w*\)/class \1Mock/" ${TEMP} >> ${MOCK}

