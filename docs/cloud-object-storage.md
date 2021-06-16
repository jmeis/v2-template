# Configure Cloud Object Storage(COS) for storing evidence 

## Creating a Cloud Object Storage Instance
Create a [Cloud Object Storage Instance](https://cloud.ibm.com/catalog/services/cloud-object-storage).

## Creating a bucket
In Cloud Object Storage, files are grouped in buckets. (You could think of buckets like directories, except there are no subdirectories in buckets.) 

1. In the Cloud Object Storage GUI, click *Buckets*.
2. Click *Create bucket*.
3. Give the bucket a name that is unique and helpful for remembering what the bucket is being used for (over time, you might create many buckets!)
4. Set Resiliency to "Regional". In general, regional resiliency will have the best performance with the lowest cost. However if the ability to survive a regional outage is essential to you, set the resiliency to "Cross Region".
5. For best performance, set Location to the same location as your Toolchain location.
6. Usually, the default for Storage class is suitable for use and usually, you won't need to use *ADVANCED CONFIGURATION*.


## Creating a service credential

1. In the Cloud Object Storage GUI, click *Service Credential*.
2. Click *New Credential*.
3. Provide the details
   *  *Name:* Name of the credential
   *  *role:* Role for the credential. (*writer* role is suggested for uploading the file)

## Provide Bucket access to the service credential

1. In the Cloud Object Storage GUI, click *Buckets*.
2. Select the bucket which was created in earlier step.
3. Click on the *Access policies* and select the *Service IDs* option
4. Now select the service credential which was created in earlier step and select the *writer* role.
5. Now click in the *Create Access Policy* Button.

## Copy the API Key of the service credential

1. In the Cloud Object Storage GUI, click *Service Credential*.
2. Now click on the *expand* the service credential. This will show you the *apikey*. 
3. Note down the *apikey*

## Endpoints 

1. In the Cloud Object Storage GUI, click *Buckets*.
2. Select the bucket which was created in earlier step.
3. Now select *Configuration* tab and select the *Endpoints*.
4. Note down the *public endpoint* 
