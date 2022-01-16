#!/bin/bash
#
# Copyright 2022 mbo.dev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "${DIR}/.." || exit 1

FOLDER=docs/assets/img
FILE=$1

cd "${FOLDER}" || exit 2
if [[ "" == "${FILE}" ]]; then
  echo "usage: $0 <filename>"
  exit 3
fi
if [[ ! -e "${FILE}" ]]; then
  echo "${FILE} doesn't exist in ${FOLDER}"
  exit 4
fi

filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
target="${filename}_opt.${extension}"
rm -f "${target}"
echo "# filename: ${filename}, extension: ${extension}, target: ${target}"

convert "${filename}.${extension}" -depth 24 -define png:compression-filter=2 -define png:compression-level=9 -define png:compression-strategy=1 "$target"
