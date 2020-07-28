# CISO Code Signing Service and Key Setup


### Registering a Team

The compliance-ci-toolchain leverages the CISO services to sign images.
A team needs to be registered on CISO.

Follow the instruction on this page:

<https://pgawdccosig01.sl.bluecloud.ibm.com>

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/landingpage.png)



### Downloading the Installer

Once registered visit the page again and log in.

At this point you can request a certificate or have an existing one
uploaded to the HSM (Hardware Security Module)

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/certrequest.png)

Click on the Local Sign button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/localsign.png)

Select the following options:

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/installer.png)

Click Review Parameters and generate your client bundle.

Extract the contents of the generated .tar file and look for the .pfx
file. This certificate acts as the key to the users partition. 


### Creating Key-Protect instance

Visit
<https://cloud.ibm.com/catalog/services/key-protect>

Create a new Key Protect instance or use an existing one.

Select the region and specify a service name for the instance.


### Uploading the certificate to the Vault.

The certificate content must be double encoded to a base64 string and the
output captured.

This can be done with the following command in a terminal

```javascript
echo $(cat Client_XXXXXXXXXXXXXXXXX.pfx | base64) | base64
```

Copy the base64 output from the terminal

Go to
<https://cloud.ibm.com/resources>

and click the Key Protect instance that was created.

Click the Add Key button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/create_key.png)

On the following dialog, select Import Key and Standard Key.

Set a name for the key and paste the base64 encoded certificate into the
key material field.

Click import key

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/set_key_data.png)

Make note of the Key-protect service instance name as well as the key
name as these will be required when configuring the Compliance Template
