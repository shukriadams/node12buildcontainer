set -e

DOCKERPUSH=0

while [ -n "$1" ]; do 
    case "$1" in
    --dockerpush) DOCKERPUSH=1 ;;
    esac 
    shift
done

docker build -t shukriadams/node12build .

#test 
LOOKUP=$(docker run shukriadams/node12build:latest bash -c "node -v") 
if [ "$LOOKUP" != "v12.22.1" ] ; then
    echo "ERROR : container returned unexpected string ${LOOKUP}"
    exit 1
fi

if [ $DOCKERPUSH -eq 1 ]; then
    TAG=$(git describe --tags --abbrev=0) 
    # ARCHITECTURE=""    # set to -ARM if necessary

    docker tag shukriadams/node12build:latest shukriadams/node12build:$TAG$ARCHITECTURE
    docker login -u $DOCKER_USER -p $DOCKER_PASS 
    docker push shukriadams/node12build:$TAG$ARCHITECTURE
fi

echo "build complete"
