# Service API Key for TaaS Private Worker


### Registering With Taas

The CISO signing service requires access to the internal IBM .9 network. This can be achieved by obtaining a TaaS Service API Key which grants access to a worker from the TaaS Tekton private worker pool.

Go to
<https://self-service.taas.cloud.ibm.com/teams>
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

***#taas-tekton-help***

<https://ibm-cloudplatform.slack.com/archives/C012LPENMCH>


### Generating a Service API Key

From the team page click the Manage Resource button for the Tekton
resource

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/taas/manage.png)

Look for the API key section and create a new key

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/taas/createkey.png)

***Important!*** Make note of the provided key as it will only be displayed once. The key
will be required for the Compliance-CI-Toolchain set up. It is recommended that this key be saved in a vault such as Hashicorp or Key-Protect, Hashicorp being the vault favoured by compliance-ci-template.

For Key-Protect only this key needs to be single base64 encoded before saving in in Key-Protect
See the [Vault Section](https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/taas-setup.md#vault) in the CISO-setup steps for creating a key in Key-Protect if required

### Note on Service API Key
The Service-Api should only be shared with team members. Not everyone needs to be added to the TaaS team if only the key is required. It can be shared directly with team members to store in their own vault or the TaaS team administrator can create a vault entry if the vault is available for sharing.

