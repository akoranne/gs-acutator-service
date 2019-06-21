# CI pipeline for Simple Rules Engine

Update the credentials as needed or make a copy of it.

To setup the pipeline, follow the following steps

Login to Concourse
```
	$> fly -t concourse login -c <concourse-endpoint>
	$> fly -t concourse login -c http://192.168.100.4:8080
```

Deploy the develop pipeline and unpause it.
```
	$> fly -t concourse sp -p gs-acutator-service-develop -c pipeline-develop.yml -l secrets --var=git-branch=develop
	$> fly -t concourse unpause-pipeline --pipeline gs-acutator-service-develop
	$> fly -t concourse pipelines
```

This project has the release pipeline, for pushing to stage and manual deploy to prod.
Deploy the release pipeline and unpause it.
```
	$> fly -t concourse sp -p gs-acutator-service-release -c pipeline-develop.yml -l secrets --var=git-branch=master
	$> fly -t concourse unpause-pipeline --pipeline gs-acutator-service-release
	$> fly -t concourse pipelines
```


## References

Resources:

* https://hub.docker.com/r/swce/keyval-resource
* https://hub.docker.com/r/swce/metadata-resource/
* https://hub.docker.com/r/askxtreme/java8-node/

* https://github.com/SWCE/keyval-resource
* https://github.com/SWCE/metadata-resource
* https://github.com/akoranne/docker-recipes/tree/master/java8-node
