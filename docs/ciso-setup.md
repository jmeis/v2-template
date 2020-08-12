# CISO Code Signing Service and Key Setup

###  Prerequisites
#### Registering a Team

The compliance-ci-toolchain leverages the CISO services to sign images.
A team first needs to be registered with CISO.

Go to the CISO home page using the link below.

<https://pgawdccosig01.sl.bluecloud.ibm.com>

Click the register for signing link and register a team

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/landingpage.png)

* ##### Team
Team members can be managed by going to Dashboard->Manage Team

* ##### Certificate Management
At this point you can request a new certificate or have an existing one
uploaded to the HSM (Hardware Security Module). Go to Dashboard->Certificates
or from the home page

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/certrequest.png)

### Downloading the Installer

The Compliance-CI-Template uses the CISO signing client. The Tekton signing task uses a preconfigured image with the CISO client already installed. It only requires the CISO .pfx file to access the CISO signing service.

The .pfx file can be obtained by downloading the CISO client.

Click on the Local Sign button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/localsign.png)

Select the following options:

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/installer.png)

Click Review Parameters and generate your client bundle.

Extract the contents of the generated .tar file and look for the .pfx
file.

The contents will look like the following.

```javascript
Client_XXXXXXXXXXXXXXXXX.pfx
client.conf
config.txt
ekm-client-2.0.2001.42407-el7+el8.x86_64.rpm
```


The contents for this file needs to be extracted and double base64 encoded.

This can be done with the following command in a terminal

```javascript
echo $(cat Client_XXXXXXXXXXXXXXXXX.pfx | base64) | base64
```

Copy the content of this output and save it in Key-Protect

### Creating Key-Protect instance

Visit
<https://cloud.ibm.com/catalog/services/key-protect>

Create a new Key Protect instance or use an existing one.

Select the region and specify a service name for the instance.


### Uploading the certificate to the Vault.

Go to
<https://cloud.ibm.com/resources>

and click the Key Protect instance that was created.

Click the Add Key button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/create_key.png)

On the following dialog, select Import Key and Standard Key.

Set a name for the key and paste the base64 encoded .pfx file into the
key material field.

Click import key

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/set_key_data.png)

Make note of the Key-protect service instance name as well as the key
name as these will be required when configuring the Compliance Template
