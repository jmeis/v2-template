# Setup Guide for Tekton CI Pipeline with Compliance

### 1. Create toolchain:

A toolchain can be created by
* **Create button** in the README

   [![Deploy To Bluemix](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/one-pipeline/compliance-ci-toolchain&env_id=ibm:yp:us-south)

* **the url**  
 <https://cloud.ibm.com/devops/setup/deploy?repository=&lt;template-repository-url&gt;&amp;env_id=ibm:yp:&lt;enviroment&gt;&amp;branch=&lt;branch&gt;>

Using the url, modifications on feature branches can be tried out before merging into master.

### 2. Name toolchain and select a toolchain region

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/toolchain-default-settings.png) |
| :--: | 

Review the default information for the toolchain settings. The toolchain's name identifies it in IBM Cloud. Make sure that the toolchain's name is unique within IBM Cloud. 

Note: toolchain region can differ from cluster and registry region.

### 3. Tool integrations

#### Repositories

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/app-repo.png) |
| :--: | 

- **Application repository:** The application to be deployed. 

     All fields are required. 

    - **Repository type:**
      - `New`: Creates a new empty repository.
      - `Fork`: Fork the repository you add in the `Source repository URL` field.
      - `Clone`: Clone the repository you add in the `Source repository URL` field. You have to choose the owner of the repository, which by default is your selected ibm cloud login account. Check the `Repository Name` field for possible mismatch.
      - `Existing:` It uses a repository what you source in the repository url.
    - **Source repository URL:**
        The application repository URL. 
      - Default: <https://github.ibm.com/one-pipeline/hello-compliance-app>
    - **Owner:** The application repository owner.  If you want to switch to a different account, click the Profile avatar icon in the banner and select the account.
      - Default: Your log in account. 
    - **Repository Name:** The repository name will be generated from the name you gave for toolchain.
  
 
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/tekton-definitions.png) |
| :--: | 

- **Tekton definitions**

    Tekton definitions can be changed also after the toolchain is created. These repositories can be contributed to or can be forked.  
    All fields are required.

    - **Tekton Definition repository:**
        The tekton pipeline defintions (pipeline(s), triggers, listeners, etc.) are kept in this repo.  
        Default: <https://github.ibm.com/one-pipeline/compliance-ci-toolchain>

    - **Tekton Catalog repository:**
        The common tekton tasks are contained in this repo.  
        Default: <https://github.ibm.com/one-pipeline/common-tekton-tasks> 


- **Application related repositories**

    All fields are required.

    | ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/issues-repo.png) |
    |:--: | 

    - **Incident issues repository:** Issues about incidents that happen during the build and deployment process are stored here.    
        - Default repository type: `New`

    | ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/evidence-repo.png) |
    | :--: | 
    
    - **Evidence locker repository:** All raw compliance evidence that belongs to the application is collected here.  
        - Default repository type: `New` 

    | ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/inventory-repo.png) |
    | :--: |     

    - **Inventory repository:** Change management is tracked in this repository. CD pipeline creates a new branch named as the created CR number, and merges it to master after deplyment is concluded.
        - Default repository type: `New` 

#### Delivery Pipeline
The Tekton CI Toolchain with Compliance comes with an integrated Tekton pipeline to automate continuous build, test and deploy of the Docker application.

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/delivery-pipeline.png) |
| :--: |

- **App name:**  
The name of the application.
    - Default: same as the selected `Repository Name`.
    
- **IBM Cloud API Key:**  
The API key is used to interact with the ibmcloud CLI tool in several tasks.

    - An existing key can be copy&pasted
    - An existing key be imported from an existing Key Protect Instance by clicking the key icon 
    
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/ibmcloud-api-key-to-key-icon.png) |
| :--: | 
    
   - A new key can be created from here by clicking the `New +` button.
   - Generate a new api-key if don’t have, if you have copy it to the field. (IMPORTANT: if you want and ibm cloud api key, you must have a Kubernetes cluster)
    
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/new-api-key.png) |
| :--: | 
    
   Note: The newly generated API key can be immediately saved to an existing Key Protect instance.
    
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/save-new-api-key.png) |
| :--: | 
    
   Note: A new Key Protect Instance can be created here: <https://cloud.ibm.com/catalog/services/key-protect>  
   Note: An IBM Cloud API key can also be created here: <https://cloud.ibm.com/iam/apikeys>  
   
   Once the API Key field is filled out, the registry and cluster related fields will be filled out automatically.
    
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/kubernetes-cluster.png) |
| :--: | 
    
- **Key Protect Vault Instance name:**
   - The key protect vault holds the dct init keys for image signing and image validation. This field is required.
- **DevOps Docker Image Validation signer:**
    - Default: `"devops-validation"`
  

#### Artifactory

The template comes with an artifactory integration to enable using cocoa compliance custom base image in the tekton tasks.  
Note: You can access the Artifactory [here](https://eu.artifactory.swg-devops.com/artifactory/webapp/#/home)  
      Further material and guides about the artifactory are available [here](https://taas.w3ibm.mybluemix.net/guides#artifactory)  

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/artifactory.png) |
| :--: | 

- **Integration name:**  Tool integration name in the toolchain  
    Default: `artifactory-{timestamp}`
- **Integration URL:**  The url of the artifactory repository  
    Default: `https://wcp-compliance-automation-team-docker-local.artifactory.swg-devops.com`  
    This is where the cocoa base image is stored.
- **Repository type:**  The artifactory repository type  
    Default: `Docker registry`  
    Note: This should not be changed, otherwise the pipeline will break.
- **User ID:** The artifactory user
- **Authentication token:** The artifactory API key  
    An artifactory token can be created [here](https://eu.artifactory.swg-devops.com/artifactory/webapp/#/profile) and stored in Key Protect  
    When an artifactory API key already exists in Key Protect, it can be imported here.
- **Release URL:**  The url of the artifactory repository  
    Default: `wcp-compliance-automation-team-docker-local.artifactory.swg-devops.com`

    
### 4. Create Toolchain and add Delivery Pipeline Private Worker

 **Create toolchain:**

  - Click the create button at the bottom of the page, and wait for the toolchain to be created.
 
  Note: The individual toolchain integrations can be configured also after the pipeline has been created.

**Add Delivery Pipeline Private Worker**

You should add a private worker tool to the CI toolchain for a successful PR/CI run. Currently there are tasks in the tekton definitions what can have access for essential files for running by that way.

- Click the `Add a Tool+` button and select `Delivery Pipeline Private Worker`.

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/private-worker.png) |
| :--: | 

- Add the integration name.
- Click `Create +` button to create Service ID API Key.
- Click the `Create Integration` button.

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/delivery-pw.png) |
| :--: | 

- Now, your toolchain has got a Delivery Pipeline Private Worker. Click there and follow the instructions.
- Note: You must use IBM Cloud CLI for setup and configure. 
  
**dct init Pipeline**

The dct init pipeline is used during the image signing. It signs the current image in the CI/CD pipeline, what we want to install to the cluster. You need to run this pipeline only once:

- You only have to run the pipeline, because It is already configured.

### 5. Run PR/CI Pipeline

Configure your application repository via this [link](https://github.ibm.com/one-pipeline/compliance-ci-toolchain/blob/master/docs/github-repository-configuration.md)
 
**Run PR Pipeline**

- To start the PR pipeline, you should create pull request in your application repository.
  
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/pr-checks.png) |
| :--: | 

- Several status checks will run on your branch, what you set in you branch protection rules e.g.(`whitewater-detect-secrets`, `tekton/pr-unit-tests`, `tekton/pr-compliance`)
  
**Run CI Pipeline**

There are two ways to start a CI pipeline:
1. After a successful PR pipeline, the pull request was approved and merged to the master.
2. Trigger the CI pipeline manually.

If you want to trigger the CI pipeline manually select the Delivery Pipeline card.

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/run-ci-pipeline.png) |
| :--: | 

Add it to the pipeline environmental variables (click `Configure Pipeline` button). 

 | ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/env-properties-ci.png) |
| :--: | 

You must add a `commit-id` text property (click `Add property` button and select `"Text property"`), if you trigger the pipeline manually.

For example: 
| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/commit-id.png) |
| :--: | 

Add it to the trigger parameters (click `Run Pipeline` button), select `"Manual Trigger"` and click `Run`.

| ![Image](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/ci-trigger.png) |
| :--: | 

