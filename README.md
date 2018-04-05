# java-s2i-gc
Example of adding a customized version of a Red Hat provided script.

This example will place a modified copy of [java-default-options](https://github.com/jboss-openshift/cct_module/blob/sprint-13/os-java-run/added/java-default-options) into a container derived from imagestream [redhat-openjdk18-openshift:1.2](https://github.com/jboss-openshift/application-templates/blob/ose-v1.4.10-1/openjdk/openjdk18-image-stream.json#L63) resolving the issue reported at [CLOUD-2286](https://issues.jboss.org/browse/CLOUD-2286) in a local container build.


Steps for incorporating this change into your own container based on [registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.2](https://access.redhat.com/containers/#/registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift/images/1.2-7):

1.  Save the [buildconfig](https://github.com/travisrogers05/java-s2i-gc/blob/master/buildconfig.yml) and make any changes to it that you wish.
2.  Create the buildconfig in your Openshift project.
~~~
oc create -f buildconfig
~~~  
3.  Run the build.
~~~
oc start-build java-s2i-gc
~~~
4.  Now use the resulting output container as the input for your Java application.

Your application container will include the modified [java-default-options](https://github.com/travisrogers05/java-s2i-gc/blob/master/java-default-options#L130) file and will allow you to use the `GC_COLLECTOR` environment variable at deploy time to configure the garbage collector of your choice.

Valid values are:
-  UseSerialGC
-  UseConcMarkSweepGC
-  UseG1GC

Where `UseParallelGC` will be selected as a default if `GC_COLLECTOR` is not set.


