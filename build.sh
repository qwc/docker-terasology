#!/bin/bash

rm versionInfo.properties*


if [ " ${TERASOLOGY_PROPERTIES_URL}" == " " ]; then
    if [ " ${TERASOLOGY_BUILD}" == " " ]; then
        source .env
        TERASOLOGY_PROPERTIES_URL=http://jenkins.terasology.org/job/TerasologyStable/lastSuccessfulBuild/artifact/build/resources/main/org/terasology/version/versionInfo.properties
    else
        if [ " ${TERASOLOGY_BUILD}" == " unstable" ]; then
            TERASOLOGY_PROPERTIES_URL=http://jenkins.terasology.org/job/Terasology/lastSuccessfulBuild/artifact/build/resources/main/org/terasology/version/versionInfo.properties
        fi
    fi
fi

wget ${TERASOLOGY_PROPERTIES_URL}

source versionInfo.properties

# docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

TAGNAME=$engineVersion-$displayVersion

docker build --no-cache -t qwick/terasology:$TAGNAME .

docker push qwick/terasology:$TAGNAME
if [ " ${TERASOLOGY_TAG}" == " latest" ]; then
    NEW_TAGNAME=latest
    docker tag qwick/terasology:$TAGNAME qwick/terasology:$NEW_TAGNAME

    docker push qwick/terasology:$NEW_TAGNAME
fi
