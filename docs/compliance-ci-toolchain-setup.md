# Setup Guide for Tekton CI Pipeline with Compliance

## Prerequisites:
* **[K8S Cluster](https://cloud.ibm.com/docs/containers?topic=containers-getting-started)**
* **[Artifactory access](#artifactory)**
* **[IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started)**
* **[TaaS and CISO Registration](#taas-and-ciso-registration)**
* **[IBM Cloud Api Key](#ibm-cloud-api-key)**
* **[Service ID**](https://cloud.ibm.com/docs/account?topic=account-serviceids)**
* **[Service ID API Key**](https://cloud.ibm.com/docs/account?topic=account-serviceidapikeys#create_service_key)**
* **[HashiCorp Vault](https://pages.github.ibm.com/vault-as-a-service/vault/)**
* **[COS Bucket configured as a Compliance Evidence Locker](https://github.ibm.com/one-pipeline/docs/cos-evidence-locker-buckets.md#bucket-configuration)** (optional)


### TaaS and CISO Registration
There are a couple of steps that need to be taken prior to creating this toolchain for the first time.
1) Get access to a private worker that can establish a connection with the IBM internal network
2) A CISO account complete with a signing certificate

The CISO service is a signing service that can be leveraged for signing images. A worker with access to the internal IBM network is required to reach the CISO service. If you do not already has a private worker with IBM internal network access, you can avail of the services provided by TaaS. With TaaS, you can generate a `service_api_key`, that will allow you access to a pool of workers that have been preconfigured with IBM network access. Visit the following links for more details.

* **[CISO Code Signing Service and Key Setup](https://github.ibm.com/one-pipeline/docs/blob/master/ciso-setup.md)**

* **[Service API Key for TaaS Private Worker](https://github.ibm.com/one-pipeline/docs/blob/master/taas-setup.md)**

Optionally, you can also follow the next two guides. These will help you set up cluster image enforcement with `Portieris`.

- **Obtain the Public Key Certificate**

Create an instance of **[this toolchain](<https://github.ibm.com/one-pipeline/portieris-config-helper>)**. Once this pipeline has run, you can retrieve the public certificate from the logs

- **[Portieris Set Up](<portieris-setup.md>)**

The GitHub token that is issued to the IBM Cloud API key holder, needs access to read/set protected branch settings on repos.
This can be only done by admin level access to the repository.

- Possible solutions:
    - Use your personal IBM API key and personal repositories.
    - Use an IBM API key what is owned by a user with admin rights to the repository.

### Migrating an existing DCT signing toolchain to CISO signing
If you have an existing pipeline that uses DCT signing, the following link will show how to make the switch to CISO signing.
<https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/dct-ciso-migrate.md>

Otherwise continue with the setup doc to create a new toolchain.


## 1. Opening the toolchain setup page:

A toolchain can be created by
* **Create button** in the README

   [![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-ci-toolchain&env_id=ibm:yp:us-south)

* **Using the URL and the branch parameter**:
 <https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-ci-toolchain&env_id=ibm:yp:us-south&branch=master>

Alternatively a toolchain can also be created based on a set of prescribed secret names (otherwise known as `hints`) as described in the [Managing Secrets](https://pages.github.ibm.com/one-pipeline/docs/#/managing-secrets?id=shift-left-secrets) documentation by using the `master-with-hints` feature branch:

<https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-ci-toolchain&env_id=ibm:yp:us-south&branch=master-with-hints>

Modifications on feature branches can be tried out before merging into master.

## 2. Guided setup

Either of the two methods above will take you to the guided setup experience. This will guide you through the toolchain setup process in a logical order whilst presenting the recommended configuration options needed to create your toolchain.

A progress indicator is presented in the left margin showing the steps needed to complete the configuration and allowing navigation to a previous step with a mouse click. The configuration options for the current step are presented to the right of the progress indicator in the main area of the page.

| ![Guided setup](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/guided-wizard.png) |
| :--: |

To advance to the next step click the **Continue** button at the bottom of the current step. You can only advance to the next step when the configuration for the current step is complete and valid. You can navigate to the previous step by clicking the **Back** button.

Some steps may have an **Advanced Options** toggle at the top of the page. These steps by default present you with the minimum recommended configuration needed. However, advanced users that need finer grained control can click the **Advanced Options** toggle to reveal all options for the underlying integration.

| ![Advanced options](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/advanced-options.png) |
| :--: |

Once all the steps have been successfully completed the toolchain can be created by clicking the **Create** button on the final step.

## 3. Welcome step

| ![Toolchain default settings](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/welcome-step.png) |
| :--: |

Review the default information for the toolchain settings. The toolchain's name identifies it in IBM Cloud. Make sure that the toolchain's name is unique within your toolchains for the same region and resource group in IBM Cloud.

**Note**: _Toolchain region can differ from cluster and registry region._

## 4. Configuring other steps
### Repositories

The configuration of multiple repositories is required during the guided setup, each in their own step. The **Application** step is shown below. The recomended options are displayed by default but you can click the **Advanced Options** toggle to see all of the configuration options available for the underlying Git integration. 

| ![App repository](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/app-step.png) |
| :--: |

- **Application:** The application to be deployed.
- **Application related repositories**
    - **Inventory:** Change management is tracked in this repository. CD pipeline creates a new branch named as the created CR number, and merges it to master after deployment is concluded.
    - **Issues:** Issues about incidents that happen during the build and deployment process are stored here.
deployment is concluded.
    - **Evidence:** All raw compliance evidence that belongs to the application is collected here.

### Secrets

Several tools in this toolchain require secrets to access privileged resources. An IBM Cloud API key is an example of such a secret. All secrets should be stored securely in a secrets vault and then referenced as required by the toolchain. The **Secrets** step allows you to specify which secret vault integrations will be added to your toolchain. Use the provided toggles to add or remove the vault integrations that you require. These can be configured in subsequent steps however you should familiarize yourself with the concepts in the [Managing Secrets](https://pages.github.ibm.com/one-pipeline/docs/#/managing-secrets?id=shift-left-secrets) documentation as this provides important information about preconfiguring your vault providers and integrations appropriately.  This documentation gives you information on prerequisites and how to leverage a list of prescribed secret names otherwise known as `hints`.  By using `hints` in a template, a toolchain can be automatically populated with preconfigured secrets without any need to manually select these from various vault integrations attached to the toolchain.

| ![Choose secrets providers](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/secrets-providers.png) |
| :--: |

#### IBM Key Protect

Use [Key Protect](https://cloud.ibm.com/catalog/services/key-protect) to securely store and apply secrets like API keys and HashiCorp credentials that are part of your toolchain.

| ![Key Protect](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/key-protect.png) |
| :--: |

A Key Protect tool integration is included in this template to securely manage the HashiCorp `Role ID` and `Secret ID` in accordance with the [best practices for vault](https://pages.github.ibm.com/vault-as-a-service/vault/usage/best-practices.html) recommended  by SOS. Ideally these two HashiCorp secrets should be stored in Key Protect as a prerequisite for users creating toolchains. Doing so will protect access to HashiCorp Vault, which is the default secrets repository for most consumers.

#### HashiCorp Vault

Use HashiCorp Vault to securely store secrets that are needed by your toolchain. Examples of secrets are API keys, user passwords or any other tokens that enable access to sensitive information. Your toolchain stores references to the HashiCorp secrets, not the literal secret values, which enables advanced capabilities like secret rotation.

If your team does not have a HashiCorp Vault set up, you can follow [this documentation](https://pages.github.ibm.com/vault-as-a-service/vault/onboarding/project.html) to request a `Role ID`.

| ![HashiCorp Vault](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/hc-vault.png) |
| :--: |

 - **Name**: A name for this tool integration. This name will be displayed in the toolchain.
 - **Server URL**: The server URL for your HashiCorp Vault Instance. (`https://vserv-us.sos.ibm.com:8200`, `https://vserv-eu.sos.ibm.com:8200`, `https://vserv-test.sos.ibm.com:8200`, `https://vserv.sos.ibm.com:8200`)
 - **Integration URL**: The URL that you want to navigate to when you click the HashiCorp Vault Integration tile.
 - **Secrets Path**: The mount path where your secrets are stored in your HashiCorp Vault Instance.
 - **Authentication Method**: The Authentication method for your HashiCorp Vault Instance.
 - **Role ID:** Your team's [AppRole Role ID](https://pages.github.ibm.com/vault-as-a-service/vault/usage/approle-role-ids.html).
 - **Secret ID:** Your team's [Secret ID](https://pages.github.ibm.com/vault-as-a-service/vault/usage/manage-secret-ids.html).

### COS bucket (optional)

The addition of a COS bucket to your toolchain is recommended but optional. To remove it use the toggle in the **Evidence** step.

| ![COS bucket toggle](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/cos-toggle.png) |
| :--: |

Cloud Object Storage is used to store the evidences and artifacts generated by the Compliance Pipelines.
If you wish to use this feature, you must have a Cloud Object Storage instance and a Bucket. [Read the recommendation for configuring a Bucket that can act as a Compliance Evidence Locker](https://github.ibm.com/one-pipeline/docs/cos-evidence-locker-buckets.md#bucket-configuration).

**Note:**: _This is currently optional, you can set any kind of COS bucket as a locker, event without a retention policy. The pipeline won't check or enforce settings at the moment._

For help, please visit the [Cloud Object Storage documentation](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage).

You need to provide the following information for the Pipelines to reach the aforementioned bucket:
- Cloud Object Storage endpoint
- Bucket name
- Service API key

You can set up the COS locker later, by providing the necessary `cos-bucket-name` and `cos-endpoint`.

To get the **Cloud Object Storage Endpoint**, please visit your COS Instance's page and select the _'Endpoints'_ section in the menu. You will need to copy the Public Endpoint matching the Bucket's _region_ and _resiliency_.

| ![COS Endpoint](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/cos-endpoint-menu.png) |
| :--: |

If you decide not to use Cloud Object Storage as an evidence locker, you can also set the required values after the creation of the toolchain by setting the `cos-bucket-name`, `cos-endpoint` environment variables in the CI Pipeline.

### Tekton Pipeline
 
Tekton resources are defined in YAML files managed in source repositories. Tekton definitions can be changed also after the toolchain is created. These repositories can be contributed to or can be forked although it is recommended to use the default repository provided by this step.

### Deployment Target

The Tekton CI Toolchain with Compliance comes with an integrated Tekton pipeline to automate continuous build, test and deploy of the Docker application. In this step you must configure the target where the application will be deployed.

| ![Delivery pipeline](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/delivery-pipeline.png) |
| :--: |

- **App name:**\
The name of the application.
    - Default: `hello-compliance-app`

- **IBM Cloud API Key:**<a id="ibm-cloud-api-key"></a>\
The API key is used to interact with the `ibmcloud` CLI tool in several tasks.

    - An existing key can be copy&pasted
    - An existing key can be imported from an existing Key Protect Instance by clicking the key icon

| ![IBM Cloud API Key](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/ibmcloud-api-key-to-key-icon.png) |
| :--: |

   - A new key can be created from here by clicking the `New +` button.
   - Generate a new api-key if you don’t have one or copy an existing key to the field (**IMPORTANT**: _if you want an IBM Cloud API key, you must have a Kubernetes cluster_)


| ![New API Key](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/new-api-key.png) |
| :--: |

   **Note**: _The newly generated API key can be immediately saved to an existing Key Protect instance._

| ![Save new API Key](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/save-new-api-key.png) |
| :--: |

   **Note**: _A new Key Protect Instance can be created here: <https://cloud.ibm.com/catalog/services/key-protect>_

   **Note**: _An IBM Cloud API key can also be created here: <https://cloud.ibm.com/iam/apikeys>_

   Once the API Key field is filled out, the registry and cluster related fields will be filled out automatically.

| ![Kubernetes cluster](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/kubernetes-cluster.png) |
| :--: |

### Image Signing

Any images built by this toolchain and recorded in the inventory must be signed before they can be deployed to production. To enable image signing you need to have a TaaS private worker and an IBM CISO signing certificate.

Insert your `Service ID API Key` to the corresponding field. This should be the Service API key obtained from TaaS. It is required to connect to the IBM internal network.
Also use the picker to select the vault integration and key entry containing the CISO signing certificate.

| ![Delivery Pipeline Private Worker](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/private-worker-integration-setup.png) |
| :--: |

For more information see:
 - [Working with Delivery Pipeline Private Workers](https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-private-workers)
 - [Service ID's](https://cloud.ibm.com/iam/serviceids)

### Artifactory

The template comes with an artifactory integration to enable using cocoa compliance custom base image in the tekton tasks.

Further material and guides about the artifactory are available [here](https://www.ibm.com/garage/method/practices/deliver/tool_artifactory).

**Note**: _You can access the Artifactory [here](https://na.artifactory.swg-devops.com/artifactory/webapp/#/home)._

| ![Artifactory](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/artifactory.png) |
| :--: |

- **User ID:** The artifactory user id - usually your IBM email address
- **API Key:** The artifactory API key
    An artifactory token can be created [here](https://na.artifactory.swg-devops.com/artifactory/webapp/#/profile) and stored in Key Protect
    When an artifactory API key already exists in Key Protect, it can be imported here.
- **Repository name:**  The name of the artifactory repository
    Default: `wcp-compliance-automation-team-docker-local`
    This is where the cocoa base image is stored.

**Note**: _The User ID and the API Key token is required for pipeline working._

### Slack Integration (optional)

If you want to receive notifications about your PR/CI Pipeline events, you can configure the Slack Tool during the setup from the toolchain template, or you can add the Slack Tool later.

In order for a Slack channel to receive notifications from your tools, you need a Slack webhook URL. To get a webhook URL, see the Incoming Webhooks section of the [Slack API website](https://api.slack.com/messaging/webhooks).

| ![Slack Tool](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/slack.png) |
| :--: |

### Common DevOps Insights Toolchain (optional)

CI toolchain needs a toolchain ID with an existing DevOps Insights instance, so that it is able to publish the deployment records to insights. If toolchain ID is not present, the local DevOps Insights integration is used if present.

| ![DOI Toolchain ID](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/doi-toolchain-optional.png) |
| :--: |

You can copy the Toolchain ID from the URL of your toolchain.
A toolchain's URL follows this pattern: `https://cloud.ibm.com/devops/toolchains/<toolchain-ID-comes-here>?env_id=ibm:yp:us-south`

For example, if the URL is: `https://cloud.ibm.com/devops/toolchains/aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee?env_id=ibm:yp:us-south` then the toolchain's ID is: `aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee`.

**Note**: _Make sure to only include the ID here, not the full URL._

You can also set a target environment for the DOI interactions, this parameter is optional. If you provide this parameter, it will be used instead of the target environment from the inventory.

### DevOps Insights (optional)

DevOps Insights can optionally be included in the created toolchain and after each compliance check evidence is published into it. You do not need to configure insights, the CI pipeline will automatically use the insights instance included in the toolchain.

### Orion WebIDE (optional)

Develop for the web and the cloud in this browser-based integrated development environment (IDE).

### SonarQube (optional)

If you add your own SonarQube instance, the static scan will run on this instance with your rules and quality gate. 

If you don't add this tool, the CI pipeline will create a new SonarQube instance with default settings to run a static scan.

| ![SonarQube tool](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/sonarqube.png) |
| :--: |

## 5. Creating the toolchain

 **Create toolchain:**

  - Click the create button at the bottom of the **Summary** step, and wait for the toolchain to be created.

  **Note**: _The individual toolchain integrations can be configured also after the pipeline has been created._


## 6. Run PR/CI Pipeline

Configure your application repository by following these [instructions](https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/github-repository-configuration.md)

**Run PR Pipeline**

- To start the PR pipeline, you should create a pull request in your application repository.

| ![PR status checks](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/pr-checks.png) |
| :--: |

- Several status checks will run on your branch, which can be set in your branch protection rules

Currently


      tekton/code-branch-protection
      tekton/code-unit-tests
      tekton/code-cis-check
      tekton/code-vulnerability-scan
      tekton/code-detect-secrets


- Keep in mind, that at least one run is needed for github to list the status checks in Settings, to be able to mark them as required. Because of this, for the first time, pr pipeline will inevitably fail. Mark the status checks required and rerun the pr pipeline from the UI.

**Note**: _There is a solution to bypass the initial failing pr pipeline, which is available in the end of [this instruction](https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/github-repository-configuration.md)._

**Run CI Pipeline**

There are two ways to start a CI pipeline:
1. After a successful PR pipeline, approving and merging the PR to the master branch.
2. Trigger the CI pipeline manually.

If you want to trigger the CI pipeline manually select the Delivery Pipeline card.

| ![Run CI Pipeline](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/run-ci-pipeline.png) |
| :--: |

**Configure Pipeline**

You can add a `commit-id` text property (click `Add property` button and select `"Text property"`), if you trigger the pipeline manually. If no `commit-id` is supplied, the Pipeline will take the latest commit ID from the master branch of your app.

<!-- TBD: Readme needed after implementing the automated versioning -->

For example:

| ![commit-id](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/commit-id.png) |
| :--: |

Add the trigger parameters (click `Run Pipeline` button), select `"Manual Trigger"` and click `Run`.

| ![CI Trigger](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/ci-trigger.png) |
| :--: |
