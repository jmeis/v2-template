# GitHub Repository Configuration

On the settings tab in your repository, you can configure the Branch Protection rules.
### Add the required Branch Protection Rules
![Branch Protection](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/branch-protection-rules-screenshot.png)

Then you should add the following rules to the `master` branch of your repository:

![Branch Protection Rules](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/rules-screenshot.png)

Pull Requests _must_ be approved by the code owners before merging it to `master`.

![Branch Protection Rules 2](https://github.ibm.com/one-pipeline/docs/blob/master/assets/compliance-ci-toolchain/rules-2-screenshot.png)

The status checks shown on the screenshot above must pass before merging a pull request on an up-to-date branch. In order to be able to set them as required status checks, first you need to trigger a PR/CI pipeline beforehand (only existing status checks are listed on the UI).

Branch protection rules could also be set by the following `curl` command, after replacing the `$GH_TOKEN`, `$OWNER`, `$REPO` variables. In our sample `hello-compliance-app`, this command sets the branch protection settings by default through the `one-pipeline.yaml` setup stage.

```bash
curl -u ":$GH_TOKEN" https://github.ibm.com/api/v3/repos/$OWNER/$REPO/branches/master/protection -XPUT -d '{"required_pull_request_reviews":{"dismiss_stale_reviews":true},"required_status_checks":{"strict":true,"contexts":["tekton/code-branch-protection","tekton/code-unit-tests","tekton/code-cis-check","tekton/code-vulnerability-scan","tekton/code-detect-secrets"]},"enforce_admins":null,"restrictions":null}'
```
