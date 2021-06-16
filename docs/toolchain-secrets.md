# Managing Secrets in your Toolchains

Many of the tool integrations in your toolchains require secrets to be provided, e.g. passwords, API keys, certificates or other tokens. For instance, an IBM Cloud API key to carry out the most basic of pipeline tasks - like logging into IBM Cloud. Similarly, an IBM COS (Cloud Object Store) Writer API Key for the pipeline to interact with your COS Instance during pipeline execution.

Managing credentials like these must be done securely and in compliance with best practices in the field of secrets management. In particular this means vaulting the required secrets using an approved in-boundary vault provider, such as Hashicorp or using IBM provided tools like Secrets Manager and then linking your toolchain secrets to those resources.

The Secrets Management capabilities provided in the Toolchain setup and Pipeline user interfaces enable easy selection of vaulted secrets by using Secrets Integrations for 
- HashiCorp Vault
- IBM Key Protect
- IBM Secrets Manager
    
By using the Secrets Picker dialog a toolchain or pipeline editor can easily select named secrets from a bound secrets integration that will then be resolved by reference within the toolchain and pipeline. **It is recommended that you create these secrets before toolchain creation.** This helps to inject these secrets in their respective tool integrations during the toolchain setup phase while giving toolchain author a single place to manage the secrets with the Secrets Integrations of their choice.

The secrets used in CI are outlined as follows:

| Secret | Information |
|--|--|
| IBM Cloud API Key | **Required:** Used to authenticate with IBM Public Cloud and perform a wide range of operations|
| Image Signature | **Required:**  This is the GPG Private Key used to sign images built by the CI pipeline |
| IBM COS Writer API Key | **Required:** Used to authenticate with IBM Cloud Object Storage service - This key must have writer permission |
| Artifactory API token | **Required:** Used to access images used by pipeline tasks |
| Slack Web Hook | 	**Optional:** This webhook is required if you choose to use the Slack tool integration to post toolchain status notifications |
| Github Access Token |	**Optional:** CI & CD Used to authenticate with Github and provide access to the repositories |