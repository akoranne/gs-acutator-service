#	fly -t concourse pipelines
#	fly -t concourse destroy-pipeline -p gs-acutator-service-rel
#	fly -t concourse pipelines
fly -t concourse set-pipeline -p gs-acutator-service-rel -c pipeline-create-release.yml -l secrets
fly -t concourse unpause-pipeline --pipeline gs-acutator-service-rel
fly -t concourse pipelines
