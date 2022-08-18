# html-demo
A demonstration page of Pay Theory JavaScript SDK

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/814cedb86cdb4ead94e04b02f0efc60f)](https://www.codacy.com/gh/pay-theory/html-demo/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pay-theory/html-demo&amp;utm_campaign=Badge_Grade)

## Initial Deployment

From the cloned repository with your branch checked out

Copy the following bash into a temp file

Replace *YourBranchName* with the capitalized, camelcase version of your branch name
Replace *your-branch-name* with the lower case, dashed version of your branch name

edit the file created as *shell/formation.your-branch-name.sh*
enter values for each environment variable set at top of file

```bash
sh shell/formation.init.sh your-branch-name your-stage
sh shell/build_env.sh your-branch-name your-stage
sh shell/deploy.sh
sh shell/formation.post.init.sh your-branch-name your-stage
```

## Manual update deployment of project code

```bash
sh shell/deploy.sh
```
_make sure you remove your build files after deploying_

_everything below public/html_