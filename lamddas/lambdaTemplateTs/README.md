# Lambda template

This is a lambda template. Here we describe how a lambda should be implemented to match the coding style of the project

## Directories

* Use a ```services``` directory for aws services like dynamo, s3, etc. The files created here should match the name of
  the service its being use, do not mix the services.
* Use the ```dto``` folder to create Types
* Use the ```enums``` folder to create enums
* Use the ```utils``` folder to create utility methods.

## Advices

* Use types in your project
* Make index.ts as simple as possible
* Use enums
* Inputs for the lambda should be minimum.
* When creating a lambda for handling current user information use the identity username grabbed from cognito, do not
  pass as an input

```ts
export type Event = {
        input: string;
}
 ```



