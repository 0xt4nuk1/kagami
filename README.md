# Kagami: Mirror Git Repository

This GitHub Action is designed to push the contents of a repository to a mirror repository. It ensures that your primary repository is mirrored to a secondary location, providing redundancy and backup.

## Usage

To use this GitHub Action in your workflow, include it as a step in your GitHub Actions workflow file.

### Example Workflow

```yaml
name: Git Mirror

on: [push]

jobs:
  mirror:
    runs-on: ubuntu-latest
    name: Reflect
    steps:
      - uses: actions/checkout@v1
      - name: Kagami
        uses: javierparadadev/kagami@v1.0.0
        env:
          MIRROR_GIT_USERNAME: your-mirror-git-username
          MIRROR_GIT_EMAIL: your-mirror-git-email@mail.com
          MIRROR_GIT_HOSTNAME: git-system-url.com  # For example: "gitlab.com"
          MIRROR_GIT_PROJECT: your-repository-project-name
          MIRROR_GIT_TOKEN: ${{ secrets.MIRROR_GIT_TOKEN }} # Your access token with write permissions
```

### Required Environment Variables

The following environment variables need to be set in your GitHub repository secrets:

- `MIRROR_GIT_USERNAME`: The username for the mirror Git repository.
- `MIRROR_GIT_EMAIL`: The email for the mirror Git repository.
- `MIRROR_GIT_TOKEN`: The personal access token for the mirror Git repository.
- `MIRROR_GIT_HOSTNAME`: The hostname of the mirror Git repository.
- `MIRROR_GIT_PROJECT`: The name of the mirror Git project.

### Script Details

The script (`entrypoint.sh`) performs the following steps:

1. **Set Shell Options**:
   - The script starts with `set -e` to ensure it exits immediately if any command exits with a non-zero status.

2. **Check Required Environment Variables**:
   - It verifies that the required environment variables (`MIRROR_GIT_USERNAME`, `MIRROR_GIT_EMAIL`, `MIRROR_GIT_TOKEN`, `MIRROR_GIT_HOSTNAME`, `MIRROR_GIT_PROJECT`) are set. If any of these variables are missing, the script exits with an error.

3. **Configure Safe Directory**:
   - Adds `/github/workspace` to the list of safe directories in Git to avoid warnings or errors when running Git commands.

4. **Configure Git User Information**:
   - Configures the global Git username and email with the values provided by the environment variables `MIRROR_GIT_USERNAME` and `MIRROR_GIT_EMAIL`.

5. **Setup Git Credential Cache**:
   - Configures Git to use the credential cache helper, which stores credentials in memory temporarily.

6. **Insert Credentials into Cache**:
   - Manually inserts the provided credentials (`MIRROR_GIT_USERNAME` and `MIRROR_GIT_TOKEN`) into the credential cache.

7. **Checkout the Current Branch**:
   - Checks out the branch specified by the `GITHUB_REF_NAME` environment variable.

8. **Add Mirror Git Remote**:
   - Adds a new remote called `mirror_git` with the provided repository URL (excluding credentials).

9. **Push to Mirror Remote**:
   - Forces a push of all branches and tags to the `mirror_git` remote to mirror the repository.

10. **Cleanup Credentials from Cache**:
    - Removes the stored credentials from the credential cache to ensure they are not left in memory.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.