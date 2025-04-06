Provisioner 
"remote-exec" Provisioner
- invokes script on a remote resource after it is created 
 inline - list of command
 script - path

 "local-exec" Provisioner
 - invokes a local executable after a resource is created 
 - locally, NOT on the created resource 

 Provisioner are not recommended 
 - use user_data if availabile 
 - breaks idempotency concept
 - TF doesn't know what you execute 
 - breaks current-desired state comparison

 Alternative to remote-exec
 - use configuration management tools ansible,puppet tools
 - once server provisioned, hand over to those tools
 - execute scripts seprate from terraform
 - from CI/CD tools

 Provisioner failed 
 


