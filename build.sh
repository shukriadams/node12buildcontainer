set -e

DOCKERPUSH=0
ARCHITECTURE=""
while [ -n "$1" ]; do 
    case "$1" in
    --dockerpush) 
        DOCKERPUSH=1 ;; 
    --arc)
        ARCHITECTURE="$2" shift;;      
    esac 
    shift
done

docker build -t shukriadams/node12build .
echo "container built"

LOOKUP=$(docker run shukriadams/node12build:latest bash -c "node -v") 
if [ "$LOOKUP" != "v12.22.1" ] ; then
    echo "ERROR : container returned unexpected string ${LOOKUP}"
    exit 1
else
    echo "container smoketest passed"
fi

if [ $DOCKERPUSH -eq 1 ]; then
    echo "starting docker push"
    TAG=$(git describe --tags --abbrev=0) 
    echo "Tag ${TAG} detected"

    docker tag shukriadams/node12build:latest shukriadams/node12build:"${TAG}${ARCHITECTURE}"
    docker login -u $DOCKER_USER -p $DOCKER_PASS 
    docker push shukriadams/node12build:$TAG$ARCHITECTURE
fi

echo "build complete"
