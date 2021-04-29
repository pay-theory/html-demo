# html-demo
a demonstration of Pay Theory JavaScript SDK

## Initial Deployment

From the cloned repository with your branch checked out

Copy the following bash into a temp file

Replace *YourBranchName* with the capitalized, camelcase version of your branch name
Replace *your-branch-name* with the lower case, dashed version of your branch name

edit the file created as *shell/formation.your-branch-name.sh*
enter values for each environment variable set at top of file

```bash
sh shell/formation.sh your-branch-name
sh shell/build_env.sh your-branch-name
sh shell/deploy.sh
```

## Manual update deployment of project code

```bash
sh shell/deploy.sh
```
_make sure you remove your build files after deploying_

_everything below public/html_