# Setup Guide for Tekton CI Pipeline with Compliance

## Prerequisites

* [Create a K8s cluster](https://cloud.ibm.com/docs/containers?topic=containers-getting-started) on IBM Cloud Kubernetes Service to deploy your application.
* [Install IBM Cloud CLI](https://cloud.ibm.com/docs/containers?topic=containers-getting-started) on your operating system to interact with IBM Cloud Resources.
* [Create Image Signing Key](./gpg-keypair.md) with proper encoding to sign your application docker images.
* [Create Toolchain Secrets](./toolchain-secrets.md) to access different integrations and secure them.
* [Validate recommended IAM Permissions](./iam-permissions.md) are assigned to corressponding integrations.

## Optional:
* [COS Bucket](./cloud-object-storage.md) as the compliance evidence locker to durably store pipeline run evidence.


## Table of Contents

1. [Start Toolchain Setup](#1-start-toolchain-setup)
2. [Guided Setup](#2-Guided-setup)
3. [Setup Toolchain Name and Region](#3-setup-toolchain-name-and-region)
4. [Setup Tool Integrations](#4-setup-tool-integrations)
    - Repositories
        - [Application Repository](#application)
        - [Inventory Repository](#inventory)
        - [Issues](#issues)
    - Secrets
        - [Key Protect](#ibm-key-protect)
        - [Secrets Manager](#ibm-secrets-manager)
        - [Hashicorp Vault](#hashicorp-vault)
    - [Evidence Storage](#evidence-storage)
        - [COS bucket](#cos-bucket)     
    - [Tekton Pipeline](#tekton-pipeline)
    - [Deploy](#deploy)
    - [Image Signing](#image-signing)
    - [Optional Tools](#optional-tools)
        - [Slack](#slack)
        - [Common DevOps Insights Toolchain](#common-devops-insights-toolchain)
        - [DevOps Insights](#devops-insights)
        - [Orion WebIDE](#orion-webide)
        - [SonarQube](#sonarqube)
        - [Artifactory](#artifactory)     
5. [Create Toolchain](#5-create-toolchain)
6. [Run Pipeline](#6-run-pr/ci-pipeline)

---
## 1. Start Toolchain Setup:

A toolchain can be created by
* **Create button** in the README

   [![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/open-toolchain/compliance-ci-toolchain.git&env_id=ibm:yp:us-south)


*   Navigate to [IBM Cloud Continuous Delivery Toolchain Catalog](https://cloud.ibm.com/devops/create?env_id=ibm:yp:us-south&ENABLE_COMPLIANCE_TEMPLATES=true) and select  
    **CI - Develop a secure app with DevSecOps practices**

## 2. Guided setup

Either of the two methods above will take you to the guided setup experience. This will guide you through the toolchain setup process in a logical order whilst presenting the recommended configuration options needed to create your toolchain.

A progress indicator is presented in the left margin showing the steps needed to complete the configuration and allowing navigation to a previous step with a mouse click. The configuration options for the current step are presented to the right of the progress indicator in the main area of the page.

| ![Guided setup](./images/devsecops_set-up_toolchain_name_region.png) |
| :--: |

To advance to the next step click the **Continue** button at the bottom of the current step. You can only advance to the next step when the configuration for the current step is complete and valid. You can navigate to the previous step by clicking the **Back** button.

Some steps may have an **Advanced Options** toggle at the top of the page. These steps by default present you with the minimum recommended configuration needed. However, advanced users that need finer grained control can click the **Advanced Options** toggle to reveal all options for the underlying integration.

| ![Advanced options](./images/devsecops_set-up_advancd_option_orig.png) |
| :--: |

Once all the steps have been successfully completed the toolchain can be created by clicking the **Create** button on the final step.

**Note:** You can always go back to previous steps in the guided installer, the toolchain installer retains all the configuration you have done in the successive stages.

## 3. Setup Toolchain Name and Region

| ![Toolchain default settings](./images/devsecops_set-up_toolchain_name_region.png) |
| :--: |

Review the default information for the toolchain settings. The toolchain's name identifies it in IBM Cloud. Make sure that the toolchain's name is unique within your toolchains for the same region and resource group in IBM Cloud.

**Note**: _Toolchain region can differ from cluster and registry region._

## 4. Setup Tool Integrations
### Application

The configuration of multiple repositories is required during the guided setup, each in their own step. 

**Note:** For each repository you may either choose to clone the repository provided as sample or may provide url to an existing IBM hosted Git Repos and Issue Tracking (GRIT) repository that you own. Currently, the toolchain supports linking only to existing GRIT repositories. Future releases will provide support to link to GitHub, GitHub Enterprise (GHE) and other SCM Providers.

The **Application** step that refers to the application source code repository is shown below. 
  
| ![App repository](./images/devsecops_application_repo.png) |
| :--: |

The recommended options are displayed by default but you can click the **Advanced Options** toggle to see all of the configuration options available for the underlying Git integration. The default behavior of the toolchain is to `Use default sample` that clones the sample application as IBM hosted GRIT Repository.

- **New repository name**: Name of the IBM hosted GRIT Repository created by the toolchain as your application repsitory. The region of the repository will remain the same as that of the toolchain.

In case you wish to link an existing Application Repository for the toolchain, you may choose `Bring your own app` option and provide it as input to `Repository URL` field. As noted earlier, the toolchain currently supports linking only to existing GRIT repositories.
### Inventory

Change management is tracked in this repository. CD pipeline creates a new branch named as the created CR number, and merges it to master after deployment is concluded. 

| ![Inventory repository](./images/devsecops_inventory_repo.png) |
| :--: |

The default behavior of the toolchain is to `Create new inventory` that creates a new Inventory Repository as IBM hosted GRIT Repository. In case you wish to link an existing Inventory Repository for the toolchain, you may choose `Use existing inventory` option and provide it as input to `Repository URL` field. As noted earlier, the toolchain currently supports linking only to existing GRIT repositories.

- **New repository name**: Name of the IBM hosted GRIT Repository created by the toolchain as your inventory repository. The region of the repository will remain the same as that of the toolchain.

### Issues    

Issues about incidents that are captured during the build and deployment process are tracked in the repository. T

| ![Issues repository](./images/devsecops_issues_repo.png) |
| :--: | 

The default behavior of the toolchain is to `Create new issues repository` that creates a new repository as IBM hosted GRIT Repository. In case you wish to link an existing Issues Repository for the toolchain, you may choose `Use existing issues repository` option and provide it as input to `Repository URL` field. As noted earlier, the toolchain currently supports linking only to existing GRIT repositories.

- **New repository name**: Name of the IBM hosted GRIT Repository created by the toolchain as your inventory repository. The region of the repository will remain the same as that of the toolchain.

### Secrets

Several tools in this toolchain require secrets to access privileged resources. An IBM Cloud API key is an example of such a secret. All secrets should be stored securely in a secrets vault and then referenced as required by the toolchain. The **Secrets** step allows you to specify which secret vault integrations will be added to your toolchain. Use the provided toggles to add or remove the vault integrations that you require. These can be configured in subsequent steps however you should familiarize yourself with the concepts in the [Managing Secrets](https://pages.github.ibm.com/one-pipeline/docs/#/managing-secrets?id=shift-left-secrets)-WIP documentation as this provides important information about preconfiguring your vault providers and integrations appropriately.

| ![Choose secrets providers](./images/devsecops_setup_secrets.png) |
| :--: |

#### IBM Key Protect

Use [Key Protect](https://cloud.ibm.com/catalog/services/key-protect) to securely store and apply secrets like API keys, Image Signature, or HashiCorp credentials that are part of your toolchain. It's recommended that you create a Key Protect Service Instance before proceeding further. Incase you have already created a Key Protect Service Instance as prerequisite, you can link the same in this step.

| ![Key Protect](./images/devsecops_set-up_key_protect_mgr.png) |
| :--: |

- **Name**: Name of Key Protect instance created by the toolchain. This key protect instance can be accessed by this name during various stages of the toolchan setup.
- **Region**: Region in which the Key Protect service resides.
- **Resource Group**: Resource Group that the Key Protect service belongs.
- **Service name**: Key Protect service name.

A Key Protect tool integration is included in this template to securely manage the HashiCorp `Role ID` and `Secret ID` in accordance with the [best practices for vault](https://pages.github.ibm.com/vault-as-a-service/vault/usage/best-practices.html)-WIP recommended  by SOS. Ideally these two HashiCorp secrets should be stored in Key Protect as a prerequisite for users creating toolchains. Doing so will protect access to HashiCorp Vault, which is the default secrets repository for most consumers.

#### IBM Secrets Manager

Use [Secrets Manager](https://cloud.ibm.com/catalog/services/secrets-manager) to securely store and apply secrets like API keys, Image Signature or Hashicorp credentials that are part of your toolchain. It's recommended that you create a Secrets Manager Service Instance before proceeding further. Incase you have already created a Secrets Manager Service Instance as prerequisite, you can link the same in this step.

| ![Secrets Manager](./images/devsecops_set-up_secrets_mgr.png) |
| :--: |

- **Name**: Name of Secrets Manager instance created by the toolchain. This Secrets Manager instance can be accessed by this name during various stages of the toolchan setup.
- **Region**: Region in which the Secrets Manager service resides.
- **Resource Group**: Resource Group that the Secrets Manager service belongs.
- **Service name**: Secrets Manager service name.

#### Hashicorp Vault

Use HashiCorp Vault to securely store secrets that are needed by your toolchain. Examples of secrets are API keys, user passwords or any other tokens that enable access to sensitive information. Your toolchain stores references to the HashiCorp secrets, not the literal secret values, which enables advanced capabilities like secret rotation.

If your team does not have a HashiCorp Vault set up, you can follow [Vault Onboarding](https://pages.github.ibm.com/vault-as-a-service/vault/onboarding/project.html)-WIP to request a `Role ID`.

| ![HashiCorp Vault](./images/devsecops_set-up_hashicorp.png) |
| :--: |

 - **Name**: A name for this tool integration. This name will be displayed in the toolchain.
 - **Server URL**: The server URL for your HashiCorp Vault Instance. (`https://vserv-us.sos.ibm.com:8200`, `https://vserv-eu.sos.ibm.com:8200`, `https://vserv-test.sos.ibm.com:8200`, `https://vserv.sos.ibm.com:8200`)
 - **Integration URL**: The URL that you want to navigate to when you click the HashiCorp Vault Integration tile.
 - **Secrets Path**: The mount path where your secrets are stored in your HashiCorp Vault Instance.
 - **Authentication Method**: The Authentication method for your HashiCorp Vault Instance.
 - **Role ID:** Your team's [AppRole Role ID](https://pages.github.ibm.com/vault-as-a-service/vault/usage/approle-role-ids.html).
 - **Secret ID:** Your team's [Secret ID](https://pages.github.ibm.com/vault-as-a-service/vault/usage/manage-secret-ids.html).

Note: _We advise you to use AppRole authentication method as this method can be used to read secret values._
### Evidence Storage

All raw compliance evidence that belongs to the application is collected in this repository. This repository option should only be used for evaluation purpose. 

The default behavior of the toolchain is to `Create new evidence locker repository` that creates a new repository as IBM hosted GRIT Repository. In case you wish to link an existing Evidence Locker for the toolchain, you may choose `Use existing evidence locker` option and provide it as input to `Repository URL` field. As noted earlier, the toolchain currently supports linking only to existing GRIT repositories.

| ![Evidence repository](./images/devsecops_set-up_evidence_storage.png) |
| :--: | 

**Note:** However, it is strongly recommended to collect and store all the evidences in a COS bucket which can be configured as described below. 
#### COS bucket

| ![COS bucket toggle](./images/devsecops_set-up_cos-toggle.png) |
| :--: |

Cloud Object Storage is used to store the evidences and artifacts generated by the Compliance Pipelines.
If you wish to use this feature, you must have a Cloud Object Storage instance and a Bucket. Please visit the [Cloud Object Storage documentation](https://github.ibm.com/open-toolchain/compliance-ci-toolchain/blob/develop/docs/cloud-object-storage.md) for detailed creation steps. Refer to recommendation [here](https://pages.github.ibm.com/one-pipeline/docs/#/cos-evidence-locker-buckets?id=bucket-configuration)-WIP for configuring a bucket as Compliance Evidence Locker.

**Note:**: _This is currently optional, you can set any kind of COS bucket as a locker, even without a retention policy. The pipeline won't check or enforce settings at the moment._


You need to provide the following information for the Pipelines to reach the mentioned bucket:
- Cloud Object Storage endpoint
- Bucket name
- Service API key

You can set up the COS locker later, by providing the necessary `cos-bucket-name` and `cos-endpoint`.

| ![COS Endpoint](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/cos-endpoint-menu.png) |
| :--: |

If you decide not to use Cloud Object Storage as an evidence locker, you can also set the required values after the creation of the toolchain by setting the `cos-bucket-name`, `cos-endpoint` environment variables in the CI Pipeline.

### Tekton Pipeline
 
The toolchain comes with an integrated Tekton pipeline to automate continuous build, test and deploy of the application to development cluster. This repository contains Tekton resources defined in YAML files that carry out the pipeline tasks. Tekton definitions can be changed also once the toolchain is created. These repositories can be contributed to or can be forked although it is recommended to use the default repository provided by this step.

| ![Tekton Pipeline](./images/devsecops_set-up_tekton_pipeline.png) |
| :--: |

The default behavior of the toolchain is to `Clone existing pipeline` that creates a new repository as IBM hosted GRIT Repository. In case you wish to link an existing Pipeline Repository for the toolchain, you may choose `Use existing repository` option and provide it as input to `Repository URL` field. As noted earlier, the toolchain currently supports linking only to existing GRIT repositories.
### Deploy

The default behavior of the toolchain is to `Clone existing pipeline` that creates a new repository as IBM hosted GRIT Repository. In case you wish to link an existing Pipeline Repository for the toolchain, you may choose `Use existing repository` option and provide it as input to `Repository URL` field. As noted earlier, the toolchain currently supports linking only to existing GRIT repositories.

- **App name:**\
The name of the application.
    - Default: `hello-compliance-app`

- **IBM Cloud API Key:**<a id="ibm-cloud-api-key"></a>\
The API key is used to interact with the `ibmcloud` CLI tool in several tasks. Incase you have already created a cluster, an API to access the cluster and stored the key in a secure vault (any of Key Protect, Secrets Manager or HashiCorp Vault), as prerequisite you can use the same in this step.

    - Option-1: An existing key can be imported from an existing Secret Provider intance created as prerequisites (Key Protect Instance, Secret Manager Instance or HashiCorp Vault) by clicking the key icon (Recommended)
    - Option-2: An existing key can be copy & pasted (Not Recommended)
    - Option-3: A new key can be created from here by clicking the `New +` button. Generate a new api-key if you don’t have one or copy an existing key to the field.The newly generated API key can be immediately saved to an existing Key Protect instance

Click on the `Key` Icon to use an existing key from your Secret Provider.

- **Provider**: The Secret Provider which stores your API Key to access the cluster, as linked to your toolchain earlier. It can be a Key Protect Instace, Secret Manager Instance or Hashicorp Vault Instance.
- **Resource Group**: Resource Group that the Secrets Manager Provider belongs.
- **Secret name**: Name/Alias of the secret i.e. API Key.

Once the API Key field is filled, the registry and cluster related fields will be filled automatically.


| ![Kubernetes cluster](./images/devsecops_set-up_deployment_target.png) |
| :--: |
### Image Signing

Any images built by this toolchain and recorded in the inventory must be signed before they can be deployed to production. The pipeline uses Skopeo as default tool to provide Image signing capability. You can use an existing GPG Key or [create a new GPG Key](./gpg-keypair.md).

**Note**: _Please ensure that key follows the appropriate encoding as required by the chosen tool to store secrets._

| ![Image Signing](./images/devsecops_set-up_image_signing.png) |
| :--: |

Click on the `Key` Icon to use an existing key from your Secret Provider.

- **Provider**: The Secret Provider which stores your GPG Key. It can be a Key Protect Instace, Secret Manager Instance or Hashicorp Vault Instance.
- **Resource Group**: Resource Group that the Secrets Manager Provider belongs.
- **Secret name**: Name/Alias of the secret i.e. GPG Key.

### Optional Tools

#### Slack

If you want to receive notifications about your PR/CI Pipeline events, you can configure the Slack Tool during the setup from the toolchain template, or you can add the Slack Tool later.

In order for a Slack channel to receive notifications from your tools, you need a Slack webhook URL. To get a webhook URL, see the Incoming Webhooks section of the [Slack API website](https://api.slack.com/messaging/webhooks).

| ![Slack Tool](./images/devsecops_set-up_slack.png) |
| :--: |

#### Common DevOps Insights Toolchain

DevOps Insights can optionally be included in the created toolchain and after each compliance check evidence is published into it. The toolchain can use an existing DevOps Insights instance, to publish the deployment records to insights. You can link DevOps Insights integration from another toolchain by providing the Integration ID.

| ![DOI Toolchain ID](./images/devsecops_set-up_devops_insight_orig.png) |
| :--: |

You can copy the Toolchain ID from the URL of your toolchain.
A toolchain's URL follows this pattern: `https://cloud.ibm.com/devops/toolchains/<toolchain-ID-comes-here>?env_id=ibm:yp:us-south`

For example, if the URL is: `https://cloud.ibm.com/devops/toolchains/aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee?env_id=ibm:yp:us-south` then the toolchain's ID is: `aaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee`.

**Note**: _Make sure to only include the ID here, not the full URL._

You can also set a target environment for the DOI interactions, this parameter is optional. If you provide this parameter, it will be used instead of the target environment from the inventory.

#### DevOps Insights

Use this option if you wish to create a new instance of DevOps Insights to be used for the toolchain. There is no configuration required and toolchain will create a new instance of Devops Insight if this option is selected. The CI pipeline will automatically use the insights instance included in the toolchain.
#### Orion WebIDE

Develop for the web and the cloud in this browser-based integrated development environment (IDE).

#### SonarQube (Beta Release)

If you add your own SonarQube instance, the static scan will run on this instance with your rules and quality gate. 

| ![SonarQube tool](./images/devsecops_set-up_sonarqube.png) |
| :--: |

#### Artifactory 

The template comes with an artifactory integration to enable using custom images to carry out pipeline tasks in the tekton pipelines.

Further material and guides about the artifactory are available [here](https://www.ibm.com/garage/method/practices/deliver/tool_artifactory).

| ![Artifactory](./images/devsecops_set-up_artifactory.png) |
| :--: |

- **User ID:** The artifactory user id
- **API Key:** The artifactory API key
    An artifactory token can be created and stored in Key Protect
    When an artifactory API key already exists in Key Protect, it can be imported here.
- **Repository name:**  The name of the artifactory repository
    This is where the images for pipeline tasks is stored.

**Note**: _The User ID and the API Key token is required for pipeline working._
## 5. Create Toolchain

 **Create toolchain:**

  - Click the create button at the bottom of the **Summary** step, and wait for the toolchain to be created.

  **Note**: _The individual toolchain integrations can be configured also after the pipeline has been created._

| ![Summary](./images/devsecops_set-up_summary_page.png) |
| :--: |

| ![Summary](./images/devsecops_toolchain_created.png) |
| :--: |
## 6. Run PR/CI Pipeline


**Run PR Pipeline**

- To start the PR pipeline, create a pull request in your application repository.

- The corressponding Merge Request in your application repository will be in "Pending" state till all the stages of PR Pipeline finishes successfully.  

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
