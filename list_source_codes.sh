#!/bin/bash

echo go源码行数：
find . -name "*.go" -exec wc -l {} \; | awk 'BEGIN{total=0} {total=total+$1} END{print total}'



RESULT_FILE="source_codes.txt"
echo "开始输出所有代码到 ${RESULT_FILE}"

rm -f ${RESULT_FILE}
rm -f ${RESULT_FILE}.begin
rm -f ${RESULT_FILE}.end

for file in $(find . -name "*.go" -type f ! -path "./*.git*" ! -path "./${0}" ! -path "./${RESULT_FILE}")
do
    echo -e "文件名：${file:2}\n" >> ${RESULT_FILE}
    cat ${file} | sed '/^\/\//d' | sed '/\/\*/,/\*\//d' >> ${RESULT_FILE}
    echo -e "\n\n" >> ${RESULT_FILE}
done 

head -n 2000 ${RESULT_FILE} > ${RESULT_FILE}.begin
tail -n 2000 ${RESULT_FILE} > ${RESULT_FILE}.end

echo "done"
