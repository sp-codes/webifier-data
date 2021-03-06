#!/usr/bin/env bash

cd ..

if [ -e persistent/application-data.extension ]
then
    cat persistent/application-data.extension >> webifier-data/src/main/resources/application.properties
fi

cd webifier-data
./gradlew :build
cd ..

cd run

rm -f webifier-data-*.jar
rm -f start-data.sh

cp ../webifier-data/build/libs/webifier-data-*.jar .

JAR=$(ls| grep 'webifier\-data\-.*\.jar')

cat > start-data.sh << EOF
killall webifier-data

LD_PRELOAD=../persistent/libprocname.so PROCNAME=webifier-data java -jar ${JAR} > output-data.log 2>&1 &
EOF

chmod +x start-data.sh