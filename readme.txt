how is varible works in modules
 value are defined in .tfvars file
 set as values in variable.tf in root
 values are passed to child modules as arguments
 via variable.tf in child modules

 how do we access the resource of a child modules?

 output values
 - like return values of modules
 - to expose/export resourec attribute to paarent modules

 terraform init - whenever modules added/chnaged we have to run this command 