# CISO Code Signing Service and Key Setup

###  Prerequisites

The compliance-ci-toolchain leverages the CISO services to sign images.
You need to be a member of a team registered with CISO or have a team member who already has this access.
The steps required are:
* **[Register/Join a CISO registered team](#registration)**
* **[Obtain a signing certificate](#certificate)**
* **[Download the CISO certficate key to access your CISO services](#access)**
* **[Save the certificate/key into a secure vault for your pipeline to access it](#vault)**


### <a id="registration"></a>Register/join a CISO registered team
Go to the CISO home page using the link below.

<https://pgawdccosig01.sl.bluecloud.ibm.com>

Click the register for signing link and register a team

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/landingpage.png)

* ##### Team
Team members can be managed by going to Dashboard->Manage Team

### <a id="certificate"></a>Obtain a signing certificate
* ##### Certificate Management
At this point you can request a new certificate or have an existing one
uploaded to the HSM (Hardware Security Module). Go to Dashboard->Certificates
or from the home page

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/certrequest.png)

**Note**: _You do not require a production certificate for signing. The CISO team can provide a self-signed certificate for development._

### <a id="access"></a>Download the CISO certficate key to access your CISO services
#### Downloading the Installer

The Compliance-CI-Template uses the CISO signing client to facilitate signing images. The Tekton signing task in the Compliance-CI-Template uses a preconfigured image with the CISO client already installed. It only requires the CISO `.pfx` file to access the CISO signing service. There is a distinction between the these certificates. The certificate in the previous step is used for signing. The certificate in this step is used for accessing the CISO services.

The `.pfx` file can be obtained by downloading the CISO client.

Click on the Local Sign button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/localsign.png)

Select the following options:

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/installer.png)

Click Review Parameters and generate your client bundle.

Extract the contents of the generated `.tar` file and look for the `.pfx` file.

The contents will look like the following.

```
Client_XXXXXXXXXXXXXXXXX.pfx
client.conf
config.txt
ekm-client-2.0.2001.42407-el7+el8.x86_64.rpm
```

### <a id="vault"></a>Save the certificate/key into a secure vault for your pipeline to access it
We only need the file with the `.pfx` extension to proceed.

The steps differ slightly depeneding on whether Key-Protect or Hashicorp vaults are used and whether you are using a Windows or Linux based machine.

#### Mac

* ##### Double base64 encoding
```bash
echo $(cat Client_XXXXXXXXXXXXXXXXX.pfx | base64) | base64
```

* ##### Single base64 encoding
```bash
cat Client_XXXXXXXXXXXXXXXXX.pfx | base64
```

#### Windows

* ##### Double base64 encoding
```bash
echo $(cat Client_XXXXXXXXXXXXXXXXX.pfx | base64 -w0) | base64 -w0
```

* ##### Single base64 encoding
```bash
cat Client_XXXXXXXXXXXXXXXXX.pfx | base64 -w0
```

This is important due to the different handling of line breaks

### Hashicorp
You can use your own instance of Hashicorp. When uploading the `.pfx` content, it needs to be single base64 encoded. This is now the preferred method for the `compliance-ci-template`.

### Creating Key-Protect instance
**Note**: _Requires the value of the double base64 encoded `.pfx` file._

 - Visit <https://cloud.ibm.com/catalog/services/key-protect>
 - Create a new Key Protect instance or use an existing one.
 - Select the region and specify a service name for the instance.

#### Uploading the certificate to the Vault

Go to <https://cloud.ibm.com/resources> and click the Key Protect instance that was created.

Click the Add Key button

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/create_key.png)

On the following dialog, select Import Key and Standard Key.

Set a name for the key and paste the double base64 encoded `.pfx` file into the key material field. Please note, there are restrictions on the key name. The name must be between 2 and 50 characters long. Use standard English alpha-numeric characters. The only special character permitted is `"-"`.

Click import key

![](https://github.ibm.com/one-pipeline/docs/blob/master/assets/signing-setup/ciso/set_key_data.png)

Make note of the Key-Protect service instance name as well, as the key name will be required when configuring the Compliance Template.
