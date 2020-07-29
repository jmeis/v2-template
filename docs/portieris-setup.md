# Installing and configuring Portieris


### Pre-requisites

Kubernetes 1.16 or above

Helm 3 is required to install Portieris. This needs to be installed on
your workstation.

Installing Helm 3

See <https://helm.sh/docs/intro/install/>

Removing Tiller

Tiller needs to be removed from the cluster. Ensure beforehand that
uninstalling Tiller will not affect any other services

```javascript
kubectl delete deployment tiller-deploy -n kube-system

kubectl delete service tiller-deploy -n kube-system
```

(if there are secrets)

```javascript
kubectl delete secret tiller-secret -n kube-system
```

Obtain the public key certificate associated with the GPG certificate
signing chain.

Connect to Cluster

Log into your account and ensure that you can run Kube commands. Please
see <https://cloud.ibm.com/kubernetes/clusters> for help

### Migrating from DCT signing to CISO
This is a second pre-requisite step and only applies to users with an existing toolchain with the Docker siging and image policy in place. This needs to be removed before installing Portieris.
***Note the following will remove all image policies***. 
Run
```javascript
kubectl delete deployment cise-ibmcloud-image-enforcement -n ibm-system
kubectl delete --ignore-not-found=true MutatingWebhookConfiguration image-admission-config
kubectl delete --ignore-not-found=true ValidatingWebhookConfiguration image-admission-config
kubectl delete crd clusterimagepolicies.securityenforcement.admission.cloud.ibm.com
kubectl delete crd imagepolicies.securityenforcement.admission.cloud.ibm.com
```
And if you have not done so already. Remove Tiller
```javascript
kubectl delete deployment tiller-deploy -n kube-system
kubectl delete service tiller-deploy -n kube-system
```


### Portieris Installation

Portieris is the gatekeeper that the Compliance-CI-Toolchain leverages
to ensure that only signed images are deployed.

It can be configured to secure cluster-wide deployments or namespace
specific deployments. For this setup we will be using a namespace
specific set up

To get started clone the Protieris repository

<https://github.com/IBM/portieris.git>

Use the same namespace that will be used in the Compliance-CI-Template

Change directory into the Portieris Git repository.

Run
```javascript
./helm/portieris/gencerts <namespace>
```

The gencerts script generates new SSL certificates and keys for
Portieris. Portieris presents this certificates to the Kubernetes API
server when the API server makes admission requests. If you do not
generate new certificates, it could be possible for an attacker to spoof
Portieris in your cluster.

Run
```javascript
kubectl create namespace <namespace>
```

Run
```javascript
helm install portieris --set namespace=<namespace\> helm/portieris
```


### Provisioning the Secrets Key

With the public key on hand we need to use it to generate a Kubernetes
secret. For this illustration, we will call the public certificate key
from GPG key.asc

First change directory to the one containing the key

Run
```javascript
kubectl create secret generic fskey -n <namespace> --from-file=key=key.asc
```

***fskey***: the name of the generated secret

***namespace***: the namespace that was or will be used by the Compliance
Template deployment.

***key.asc***: the public key certificate.


To view the secret that has been created:

Run
```javascript
kubectl get secret -n <namespace>
```

To check that the key has provided content in the secret. There data field should not be empty:

Run
```javascript
kubectl edit secret fskey -n <namespace>
```


### Portieris Configuration

Portieris uses two type of resources to manage securing image
deployments to the cluster.

-   ***ClusterImagePolicy***

-   ***ImagePolices***

The ClusterImagePolicy is a cluster level enforcement. It will take
effect when no imagepolicy is available. For example, an image policy is
set up in a namespace called "prod" but an image gets deployed to
"default" in this case the ClusterImagePolicy will be applied.

To view the different policies

```javascript
kubectl edit clusterimagepolicy
```

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/portierirs/clusterimage_policy.png)

The important part of the above is

```yaml
spec:

repositories:

-   Name: "*"
```

This is the default setting when installed. Basically a wildcard on all
repositories allowing all deployments. This file can be modified for more advanced configurations.

```javascript
kubectl edit imagepolicies default -n prod
```

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/portierirs/image_policy.png)

The "spec" part here needs to be modified to enforce a signature constraint
on images from our designated registry namespace.

Edit the image policy to add the following

```yaml
repositories:
- name: us.icr.io/registry-namespace/*
  policy:
    simple:
      requirements:
      - type: signedBy
        keySecret: fskey


```

***name***: refers to the path to the image registry that we wish to check

***policy***: is the conditions that we which to enforce

***type***: signedBy requires a signature on the image

***keySecret***: is a reference to the secret that we set up previously from
the GPG public key certificate

The above steps are all the requirements for setting up Portieris in
relation to the Compliant template usage.

Portieris can handle multiple signatures from different sources for
example

```yaml
repositories:
- name: us.icr.io/team1-namespace/\*
  policy:
    simple:
      requirements:
      - type: signedBy
        keySecret: team1-key
```

```yaml
repositories:
- name: us.icr.io/team2-namespace/\*
  policy:
    simple:
      requirements:
      - type: signedBy
        keySecret: team2-key
```

For more complex setups, please see

See <https://github.com/IBM/portieris> for more details
