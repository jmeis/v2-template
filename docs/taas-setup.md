**Service API Key for TaaS Private Worker**


*Registering With Taas*

The CISO signing requires access to the internal IBM .9 network. This is
not normally possible via pipelines running in IBM Public Cloud. As a
solution to this, the TaaS team have set up a pool of private workers
for Tekton, that can be leveraged to run pipelines and grant access to
the internal network.

To use one of these private workers from the TaaS pool we must use one
of their Service API keys to configure a private worker integration in
the toolchain.

Go to
[[https://self-service.taas.cloud.ibm.com/teams]{.ul}](https://self-service.taas.cloud.ibm.com/teams)
and register a team, if you do not already have one.

When a team has been created, click the manage team button that will now
be visible.

Look for the resource section on the next page and click the create
resource button followed by the Tekton button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/taas/subscription.png)

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/taas/resource.png)

Note: At this point you might not be able
to see or be able to access to the Tekton button to create a Tekton
resource. If this is the case leave a request in the TaaS slack channel

\#taas-tekton-help

<https://ibm-cloudplatform.slack.com/archives/C012LPENMCH>


*Generating a Service API Key*

From the team page click the Manage Resource button for the Tekton
resource

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/taas/manage.png)

Look for the API key section and create a new key

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/taas/createkey.png)

Make note of the provided key as it will only be displayed once. The key
will be required for the Compliance-CI-Toolchain set up
