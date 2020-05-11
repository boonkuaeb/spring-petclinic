#!/usr/bin/env bash

CONTAINER_NAME="jmx-spring-petclinic"
CONTAINER_IMAGE="john3kuae/jmx-spring-petclinic"

CATALINA_OPTS="CATALINA_OPTS=$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7091 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"

JAVA_TOOL_OPTIONS="JAVA_TOOL_OPTIONS=-Xms256M -Xmx512M -XX:+PrintGCDetails -Xloggc:/tmp/${CONTAINER_NAME}-gc.log -XX:+UseG1GC -XX:+UseStringDeduplication  -Djava.rmi.server.hostname=192.168.0.105 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=3333 -Dspring.profiles.active=mysql"

#-XX:+UseStringDeduplication
docker stop ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME}

#./mvnw clean package
#
docker build -t ${CONTAINER_IMAGE} .

docker run --init -d --name ${CONTAINER_NAME} --cpus=".5" --memory="512m" -p 8081:8080 -p 7091:7091 -p 3333:3333 -e "${JAVA_TOOL_OPTIONS}" -e "${CATALINA_OPTS}" -e "${CATALINA_OPTS}" ${CONTAINER_IMAGE}

docker logs -f ${CONTAINER_NAME}



# jmap -dump:format=b,file=/tmp/heapdump1.bin 7
# jcmd 7 Thread.print > /tmp/thread
# docker cp jmx-spring-petclinic:tmp/heapdump1.bin ./heapdump1.bin
# docker cp jmx-spring-petclinic:/tmp/thread ./thread1
# docker cp jmx-spring-petclinic:/tmp/jmx-spring-petclinic-gc.log ./jmx-spring-petclinic-gc1.log


# https://fastthread.io/
# https://gceasy.io/
# https://heaphero.io/
