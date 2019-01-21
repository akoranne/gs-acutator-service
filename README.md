# gs-acutator-service

This project is a sample spring boot project used for concourse testing. 

The wiki can be found [here](https://github.com/akoranne/gs-acutator-service.wiki.git)


## References
https://spring.io/guides/gs/actuator-service/


## Cloud

#### Create Service Instance

1. login to pcf

	```
	$> cf login --skip-ssl-validation -a https://api.local2.pcfdev.io -o pcfdev-org -s pcfdev-space
	API endpoint: https://api.local.pcfdev.io
	
	Email> user
	
	Password>
	Authenticating...
	OK
	```

2. create service instance of the config-server

	```
	$> cf cs app-autoscaler standard autoscaler
	$> cf service autoscaler
	```

#### Deploy to PCF 

1. Push to PCF

	```
	$> cf push
	```

2. Test locally

	```
	Go to
		http://gs-acutator-service.<pcf-domain>
	 
	You should see the jason document.
	```
	
3. To verify the client side service lookup, goto
   
	```
   	http://gs-acutator-service.<pcf-domain>/
   	
   	http://gs-acutator-service.<pcf-domain>/greeting
	```


4. Apply autoscaling rules
    ```
    $> cf autoscaling-apps      
    $> cf autoscaling-rules         gs-acutator-service
    $> cf autoscaling-events        gs-acutator-service

    $> cf configure-autoscaling gs-acutator-service autoscaler-manifest.yml

    $> cf autoscaling-apps      
    $> cf autoscaling-rules         gs-acutator-service
    $> cf autoscaling-events        gs-acutator-service


    ```
