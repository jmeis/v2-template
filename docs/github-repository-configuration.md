# GitHub Repository Configuration

### Add the required Branch Protection Rules
![Branch Protection](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/branch-protection-rules-screenshot.png)

On the settings tab in your repository, you can configure the Branch Protection rules.
Add the following rules to the `master` branch of your repository:

![Branch Protection Rules](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/rules-screenshot.png)

Pull Requests must be approved by the code owners before merging it to master.

![Branch Protection Rules 2](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/rules-2-screenshot.png)

The status checks shown on the screenshot must pass before merging a pull request on an up to date branch. In order to be able to set them as required status checks, you need to trigger a PR/CI pipeline beforehand (only existing status checks are listed on the UI).