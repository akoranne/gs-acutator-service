# CI pipeline for Simple Rules Engine

Update the credentials as needed or make a copy of it.

To setup the pipeline, follow the following steps

Login to Concourse
```
	$> fly -t concourse login -c <concourse-endpoint>
	$> fly -t concourse login -c http://192.168.100.4:8080
```

Add the pipeline and unpause it.
```
  $> fly -t concourse set-pipeline -p gs-acutator-service-rel -c pipeline-create-release.yml -l secrets

	$> fly -t concourse unpause-pipeline --pipeline gs-acutator-service-rel

	$> fly -t concourse pipelines
```


## References
* https://github.com/olhtbr/metadata-resource
* https://github.com/SWCE/metadata-resource
