# Updating to CISO signing from DCT

### Pre-requisites

Ensure the following steps have been performed:
- <https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/ciso-setup.md>
- <https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/portieris-setup.md>
- <https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/taas-setup.md>

Go to the CI pipeline and click the `Environment properties` tab on the left.

Add a new secure property called `vault-secret` and use the picker to select the CISO `.pfx` certificate value that was created in the CISO setup step.

On the `Definitions` tab add an additional definition. Click the `Add` button.
- **repository**: common-tekton-tasks
- **branch**: master
- **path**: preview/ciso

Click `Save`.

Back on the toolchain integrations page. Find the private worker and click `Configure`. Update it to use the Service API key obtained from TaaS.

Click `Save`.

The pipeline should be ready to run now.


### Post Setup
The DCT init pipeline can be deleted.
