# java-s2i-gc
Example of adding a customized version of a Red Hat provided script.

This example will place a modified copy of [java-default-options](https://github.com/jboss-openshift/cct_module/blob/sprint-13/os-java-run/added/java-default-options) into a container derived from imagestream [redhat-openjdk18-openshift:1.2](https://github.com/jboss-openshift/application-templates/blob/ose-v1.4.10-1/openjdk/openjdk18-image-stream.json#L63) resolving the issue reported at [CLOUD-2286](https://issues.jboss.org/browse/CLOUD-2286) in a local container build.  The resulting container can then be used as a modified version of [registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.2](https://access.redhat.com/containers/#/registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift/images/1.2-7).  

By default this example names the modified container as [java-s2i-gc](https://github.com/travisrogers05/java-s2i-gc/blob/master/buildconfig.yml#L26).  You will likely want to set this to your preference and then change the [buildconfig](https://github.com/travisrogers05/java-s2i-gc/blob/master/buildconfig.yml), [imagestream](https://github.com/travisrogers05/java-s2i-gc/blob/master/imagestream.yml) and [template](https://github.com/travisrogers05/java-s2i-gc/blob/master/openjdk18-web-basic-s2i-modified.json) accordingly.


Files in this repository:
- Dockerfile - Used to copy the modified script into a container
- buildconfig.yml - Used to define a build for a modified container
- imagestream.yml - Used to create the example imagestream
- java-default-options - the modified script we are replacing
- openjdk18-web-basic-s2i-modified.json - template to test an application pod built using the modified container


Steps for incorporating this change into your own container based on [registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.2](https://access.redhat.com/containers/#/registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift/images/1.2-7):

1.  Save the [buildconfig](https://github.com/travisrogers05/java-s2i-gc/blob/master/buildconfig.yml) and [imagestream](https://github.com/travisrogers05/java-s2i-gc/blob/master/imagestream.yml) and make any changes to the files that you wish.
2.  Create the buildconfig and imagestream in your Openshift project.
~~~
oc create -f buildconfig.yml
oc create -f imagestream.yml
~~~  
3.  Run the build.  This will create a version of [registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.2](https://access.redhat.com/containers/#/registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift/images/1.2-7) that contains the modified [java-default-options](https://github.com/travisrogers05/java-s2i-gc/blob/master/java-default-options#L130) script.  This container will be named [java-s2i-gc](https://github.com/travisrogers05/java-s2i-gc/blob/master/buildconfig.yml#L26) by default.
~~~
oc start-build java-s2i-gc
~~~
4.  Now use the resulting output container, imagestream or imagestreamtag as the input for your Java application.  The example name is java-s2i-gc.  Modify this to your liking.
5.  Test the newly built container by creating an application pod and setting a different garbage collector.  The template sets `GC_COLLECTOR=UseG1GC`.
~~~
oc new-app -f openjdk18-web-basic-s2i-modified.json
~~~


Your application container will include the modified [java-default-options](https://github.com/travisrogers05/java-s2i-gc/blob/master/java-default-options#L130) file and will allow you to use the `GC_COLLECTOR` environment variable at deploy time to configure the garbage collector of your choice.

Valid values for `GC_COLLECTOR` are:
-  UseSerialGC
-  UseConcMarkSweepGC
-  UseG1GC

Where `UseParallelGC` will be selected as a default if `GC_COLLECTOR` is not set.


