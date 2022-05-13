# lcls-rhel7-conda-docker

# lcls-rhel6-conda-docker

The Docker image described in this repository aims replicate an LCLS production RHEL7 machines for environment build and test. While resolved conda environments are largely transferable, there are some instances of virtual packages that may break a packed environment. [Virtual packages](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-virtual.html) include `__cuda`, `__osx`, `__glibc`, `__linux`, `__unix`, `__win`. Of particular importance to our conda environment builds is the `glibc` version. 

The image requires mounting of an environment file to `/tmp/environment.yml`, mounting of the repository to `/tmp/project`, mounting of a testing script to `/tmp/run-test.sh`, and setting of the environment variable `ENVIRONMENT_NAME`. 

Environment files may be tested using this image locally with a docker installation:
```
$ docker run -v $(pwd)/environment.yml:/tmp/environment.yml \
        -v $(pwd):/tmp/project \
        -v /complete/path/to/test/file.sh:/tmp/run-test.sh \
        -e ENVIRONMENT_NAME=my_environment \
        -t jgarrahan/lcls-rhel7-conda-docker:v1.0 /tmp/environment.yml
```

These are all handled by the GitHub action [`slaclab/lcls-rhel7-conda-pack`](https://github.com/slaclab/lcls-rhel7-conda-pack).

Releases to this repository trigger a workflow that builds the docker image using the repository Dockerfile. The resulting image is published to [dockerhub](https://hub.docker.com/repository/docker/jgarrahan/lcls-rhel7-conda-docker) using the release version as a tag. 

## Tests
The Docker image expects tests defined and run using a bash script mounted to `/tmp/run-test.sh`. An effort should be made by code developers to implement a comprehensive set of tests for their packages with the understanding that the efficacy of this pack-and-test process is a function of their effort in doing so.  The Python environment described by their yaml will be active during testing.