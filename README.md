# node12buildContainer

This is my generic NodeJS build container for web and microservice projects. It is used for private and client 
projects. It contains

- Node 12
- Yarn 
- Webpack
- JSPM
- uglify-es 
- concat-cli
- typescript
- tslint 5.18.0

Includes support folders for ssh keys if those are needed by the build.

Copy keys to this secured path

    /usr/keys

Copy source code to this path to build

    /usr/build

## Build this container

To build, run the following at the command line in project root

    docker build -t shukriadams/node12build .

Test

    docker run --name mytest -dit shukriadams/node12build:latest  
    docker exec mytest node -v   # > v12.20.1  
    docker exec mytest yarn -v   # > 1.17.3

docker tag shukriadams/node12build:latest shukriadams/node12build:x.y.z

Tag

    docker tag shukriadams/node12build:latest shukriadams/node12build:x.y.z
    
On ARM
    
    docker tag shukriadams/node12build:latest shukriadams/node12build:x.y.z-arm
    
Push (for me only)

    docker push shukriadams/node12build:x.y.z
    docker push shukriadams/node12build:latest
    docker push shukriadams/node12build:x.y.z-arm

## Uses

### Jenkins 

This script can be used directly in a Jenkins build job. If needed, copy SSH keys in. As the build 
container itself is not deployed, keys will not be copied further ahead by docker. Example build :

    # remove existing container, start a new instance
    container=myBuildContainer
    docker stop $container || true && docker rm $container || true
    docker run --name $container -dit shukriadams/node12build:latest 

    # copy required ssh keys to /usr/keys folder
    docker cp /host/key/path/id_rsa $container:/usr/keys

    # copy source code to build folder
    docker cp /src/code/. $container:/usr/build

    # build
    docker exec $container /bin/bash -c "npm install -g grunt && npm install && grunt assemble"

    # copy build artefacts out
    docker cp $container:/usr/build/. /host/build/artefacts/path

