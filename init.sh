#! /bin/bash

############################
# set environment variables
############################



if [[ $_ == $0 ]]; then
  echo "Error: please use command \"source ./init.sh\""
  exit 1
fi

docker -v  > /dev/null
if [[ $? -ne 0 ]]; then
  echo "docker is missing.  Follow instructions at https://docs.docker.com/compose/install/ to install"
  return 1
fi
docker-compose -v  > /dev/null
if [[ $? -ne 0 ]]; then
  echo "docker-compose is missing or not configured.  Follow instructions at https://docs.docker.com/compose/install/ to install"
  return 1
fi

if [[ "$(docker-compose -v)" == "docker-compose version 1.8.0"* ]] ; then
  echo "Version of docker-compose is out of date, follow instructions at https://docs.docker.com/compose/install/"
  echo "Note: the default ubuntu repositories will not help you here."
  return 1
fi



export REPO_DIR=`pwd`

if [ $(basename `pwd`) != "Skyport2" ] ; then
  echo "Please run \"source ./init.sh\" inside the Skyport2 repository directory"
  return
fi


export NGINX_PORT=8001

# Top level data dir
export DATADIR=${REPO_DIR}/live-data
mkdir -p $DATADIR

# Path to config dir with service specific subdirs. Contains config for demo case
export CONFIGDIR=${REPO_DIR}/Config/
export DOCSDIR=${REPO_DIR}/Documents/
export CWL_DIR=${REPO_DIR}/CWL


export SKYPORT_TMPDIR=$DATADIR/tmp
mkdir -p ${SKYPORT_TMPDIR}


# Path to shock data and log dir
export SHOCKDIR=${DATADIR}/shock/
mkdir -p ${SHOCKDIR}/data
mkdir -p ${SHOCKDIR}/log

# Path to AWE
export AWEDIR=${DATADIR}/awe
mkdir -p ${DATADIR}/awe
mkdir -p ${DATADIR}/awe/db
mkdir -p ${DATADIR}/awe-worker/work






# Path to primary log dir
export LOGDIR=${DATADIR}/log/

# Create log dirs for Shock , nginx
mkdir -p ${LOGDIR}
mkdir -p ${LOGDIR}/shock
mkdir -p ${LOGDIR}/nginx
mkdir -p ${LOGDIR}/awe
mkdir -p ${LOGDIR}/awe-worker



# Docker image tag , used by Dockerfiles and Compose file
export TAG=demo


source ./get_docker_binary.sh

source ./get_ip_address.sh

export SKYPORT_URL=http://${SKYPORT_HOST}:${NGINX_PORT}
export AWE_SERVER_URL=${SKYPORT_URL}/awe/api/
export SHOCK_SERVER_URL=${SKYPORT_URL}/shock/api/
export AUTH_API_URL=${SKYPORT_URL}/auth/api/


# create awe-monitor config
sed -e "s;\${AWE_SERVER_URL};${AWE_SERVER_URL};g" -e "s;\${AUTH_API_URL};${AUTH_API_URL};g" ${CONFIGDIR}/awe-monitor/config.js_template > ${CONFIGDIR}/awe-monitor/config.js



echo Set config to:
echo "TAG=${TAG}"
echo "CONFIGDIR=${CONFIGDIR}"
echo "SHOCKDIR=${SHOCKDIR}"
echo "DATADIR=${DATADIR}"
echo "LOGDIR=${LOGDIR}"
echo ""
echo "SKYPORT_HOST=${SKYPORT_HOST}" 
echo "SKYPORT_URL=${SKYPORT_URL}"
echo "AWE_SERVER_URL=${AWE_SERVER_URL}"
echo "SHOCK_SERVER_URL=${SHOCK_SERVER_URL}"
echo "AUTH_API_URL=${AUTH_API_URL}"
echo ""
echo "DOCKER_VERSION=${DOCKER_VERSION}"
echo "DOCKER_BINARY=${DOCKER_BINARY}"


echo ""
echo "Next step: docker-compose up"
echo ""
echo "...then open http://localhost:${NGINX_PORT} in your browser."
echo ""

