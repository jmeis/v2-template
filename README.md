> **Note**: 
  The compliance-ci-toolchain currently fetches all the images required to carry out pipeline tasks from TaaS Artifactory Repository. We are currently in the process of seeking approval to push these images to ICR (IBM Container Registry). Please ensure that your CI Toolchain has TaaS Artifactory Repository configured correctly to enable the pipeline to pull the images. 
  There are links or references in this document with `WIP` suffix that corresponds to in-progress documentation. The links will be sanitized once the documentation activity is finished.

# ![Icon](./.bluemix/secure-lock-kubernetes.png) Develop a Secure and Compliant Kubernetes Application

This project provides a toolchain (template) that enables "shift-left" Continuous Integration (CI) with Security and Compliance Automation in accordance with the latest DevSecOps best practices described in the [reference architecture](https://pages.github.ibm.com/CloudEngineering/system_architecture/devops/)-WIP.

## Topics

- [Toolchain Overview](#toolchain-overview)
  - [Graphical Summary](#graphical-summary)
  - [Security & Compliance Best Practice Automation](#security--compliance-best-practice-automation)
- [Configure Toolchain](#running-and-configuring-the-toolchain)
  - [Getting Started](#getting-started)
  - [Step-by-Step Guide](#step-by-step-guide)
- [Run Pipelines](#run-pipelines) 
  - [Run CI Pipeline in "development mode"](#run-ci-pipeline-in-"development"-mode)
  - [Run PR Pipeline in "App-Preview" Mode](#run-pr-pipeline-in-"app-preview"-mode)
- [Known Issues](#known-issues)
- [Learn More](#learn-more)

---

## Toolchain Overview

This reference implementation is based on the [Tekton open source technology](https://tekton.dev/) and is a key part of the IBM `one-pipeline` initiative which seeks to enable standardized compliance across DevOps pipelines for [IBM Public Cloud](https://www.ibm.com/cloud/public) service teams. The specification recommends seperation of  the CI (Continuous Integration) tasks from the CD (Continous Deployment) tasks. Please refer to the [Deploy a Secure and Compliant Kubernetes Application](https://github.ibm.com/open-toolchain/compliance-cd-toolchain) guide to setup a Continous Deployment Pipeline to deploy your application to production environments.

The toolchain is pre-configured with a simple sample application to enable out-of-the box evaluation. It features various categories of tasks like *source control integration*, *issue tracking*, *status checking*, *static code scanning*, *unit tests*, *vulnerability advisories*, *image signing* and more. It also is configured with an *evidence locker* and *inventory repository*, and is designed to test, build and deploy the sample application to an *IBM Cloud Kubernetes Cluster* whenever the application code or configurations are modified. The image below provides a pictorial overview of the toolchain components and flow.

### Graphical Summary

The following image provides an overview of how the CI compliance toolchain interacts with various application and IBM Cloud resources and when triggered by changes in the application code.

![Icon](./.bluemix/toolchain.png)

### Security & Compliance Best Practice Automation

The CI compliance toolchain automates security and compliance best practices including the following:

- Runs a static code scanner on the application repositories to detect secrets in the application source code and vulnerable packages used as application dependencies
- Build container image on every Git commit, setting a tag based on build number, timestamp and commit id for traceability
- Sanity check the Dockerfile prior to creating the image
- Apply Docker signature after Docker unit tests, sanity checks and successful build
- Use a private image registry to store the built image, automatically configure access permissions for target cluster deployment using API tokens than can be revoked
- Check container image for security vulnerabilities and add an additional Docker signature upon successful completion
- Insert the built image tag into the deployment manifest automatically
- Use an explicit namespace in cluster to insulate each deployment (and make it easy to clear, by "kubectl delete namespace")
- Checks for the presence of the two signatures before proceeding with the deployment

---

## Configure Toolchain

### Getting Started


To get started, click this button:

[![Create toolchain](https://cloud.ibm.com/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.ibm.com/open-toolchain/compliance-ci-toolchain.git&env_id=ibm:yp:us-south&branch=develop)

> **Note**: This link attempts to create the toolchain in the `us-south` (Dallas) region by default; however, you can select another region on the resultant page.

### Step-by-Step Guide

- **[Setup Guide](./docs/compliance-ci-toolchain-setup.md)**:
If this is your first time running the CI template then you should read the [Setup Guide](./docs/compliance-ci-toolchain-setup.md) before running the toolchain.

- **[Troubleshooting guide](https://github.ibm.com/open-toolchain/docs/blob/master/troubleshooting.md)**:
If you experience a problem during setup or running your pipelines, refer [Troubleshooting Guide](https://github.ibm.com/open-toolchain/docs/blob/master/troubleshooting.md)-WIP before raising an issue.

---

## Run Pipelines

### Run CI Pipeline in "development" mode

Running in "development mode" enables you to quickly test the implementation of your [shift-left compliance one-pipeline.yaml](https://pages.github.ibm.com/one-pipeline/docs/#/custom-scripts)-WIP file, without executing any shift-left compliance related task, so as to optimize pipeline execution time.

  > **Warning**: This mode should be used for **development** purpose **only**, and can not be considered as a replacement of the official shift-left compliance pipelines which remain the reference implementations.

- **Audience**:
  - Developers in charge of adopting the shift-left compliance CI pipeline for a given component, implementing [corresponding one-pipeline.yaml](https://pages.github.ibm.com/one-pipeline/docs/#/custom-scripts)-WIP file.

- **Purpose**:

  - Develop, implement and quickly test a new [shift-left compliance one-pipeline.yaml](https://pages.github.ibm.com/one-pipeline/docs/#/custom-scripts)-WIP file using a simplified pipeline.
  - Only execute the various stages of the one-pipeline.yaml file.
  - Skip most of the shift-left compliance related task, hence optimizing the time to execute your code.

- **Prerequisites**:
  - *You should have already created a compliance CI toolchain by clicking the `Create toolchain` button above.*

- **Setup**
  - Go to the `Triggers` page of your CI pipeline
  - Create a new development mode trigger:

    - *Add the Trigger*: add a new Manual Trigger by clicking the `Add Trigger` button.
    - *Name the Trigger*: pick a name of your choice (ex: `Manual-Dev-Mode`)

    - *EventListener*: `dev-mode-listener`

    - Save your changes

  ![Icon](./.bluemix/dev-mode-trigger.png)

- **Run the Development-mode pipeline**
  - Go back to the `PipelineRuns` page, click on the `Run Pipeline button`.
  - Select the `Manual-Dev-Mode` trigger you just created.
  - Click on the `Run` button.

  ![Icon](./.bluemix/run-dev-mode.png)

- **Observe**:
  - The Development-mode pipeline execution pipeline is executed without unnecessary shift-left compliance tasks.
  - Iterate until you're satisfied with your `one-pipeline.yaml` file implementation.

- **Enable normal-mode**
  - To switch back to normal shift-left compliance CI pipeline, either disable or delete the `Manual-Dev-Mode` Trigger.

---

### Run PR Pipeline in "App-Preview" Mode

The "App Preview" Pull-Request (PR) Pipeline extends the normal Pull Request Pipeline by including additional stages in the pipeline's process that enable you to deploy, scan and preview the application as well as run additional acceptance tests.

- **Audience**:
  - Developers adopting the shift-left compliance PR-pipeline (by adopting the [corresponding one-pipeline.yaml](https://pages.github.ibm.com/one-pipeline/docs/#/custom-scripts)-WIP file) and requiring additional stages to support an application preview in a near-production deployment environment.  These additional stages include:
    - *build-containerize*,
    - *build-scan-artifact*,
    - *deploy-app-preview* and
    - *deploy-acceptance-tests*.

- **Purpose**:
  - Benefit of additional stages in the PR Pipeline to perform containerization, scan artifact(s), deploy application as a "preview" and perform acceptance tests.

- **Prerequisites**:
  - *You should have already created a compliance CI toolchain by clicking the `Create toolchain` button above.*

- **Setup**
  - Go to the `Triggers` page of your CI pipeline
  - Update the Git PR Trigger:
    - EventListener: `app-preview-pr-listener`
    - Save your changes

---
### Known Issues:

1. [Insufficient Privileges to the Service ID API Key for the COS bucket created using `New +` Icon](https://github.ibm.com/cocoa/board/issues/1880)
    > **Workaround**: When user tries to create a **new** Service ID API Key for the COS Integration in the `Evidence Storage` step, the resultant key has no access to the underlying bucket. Once a key is created, user need to explicitly set appropriate permissions for the key to access the bucket using IAM console. 
2. [CI and CD Toolchain unable to push data to DevOps-Insights Integration](https://github.ibm.com/cocoa/board/issues/1784)
    > **Workaround**: Both CI and CD toolchains fail to push data to DevOps Insights. Please go the `Environment Properties` section of the respective toolchains and locate the properties with name `doi-environment` and `doi-toolchain-id`. If the `doi-environment` property has value `${DOI_ENVIRONMENT}`, clear the value. Similarily, if the `doi-toolchain-id` property has value `${DOI_TOOLCHAIN_ID}`, clear the value.
3. [VA Scan detects Security Notice RHSA-2021:2170 in ubi8 base-image used for Sample Application](https://github.ibm.com/org-ids/roadmap/issues/17632)
    > **Workaround**: The sample application image uses ubi8 image as the base image. Recent RHSA-2021:2170 security notice for the image is caused due to outdated glibc library in the image. VA Image Scanning detects vulnerability in the image and hence the Image Scanning Step fails in the CI Pipeline. Till the image is updated with the fixed version of glibc library, we need to exempt the security notice from vulnerability scan. Run below command from your ibmcloud cli to create an exemption
    ```
    ibmcloud cr exemption-add --scope us.icr.io/<icr-repository-name> --issue-type sn  --issue-id RHSA-2021:2170
    ```
---
### Learn More

* [Tutorial](https://www.ibm.com/cloud/architecture/tutorials/tekton-pipeline-with-compliance-automation-kubernetes)-WIP
* [Getting started with clusters](https://cloud.ibm.com/docs/containers?topic=containers-getting-started)
* [Getting started with toolchains](https://cloud.ibm.com/devops/getting-started)
* [Documentation](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-getting-started&pos=2)
* [Private workers](https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-install-private-workers)
* [Working with Tekton pipelines](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-tekton-pipelines)
* [Getting started IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started)
