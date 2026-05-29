# Epinio Deploy App (Killercoda)

Interactive [Killercoda](https://killercoda.com/) scenario: **Epinio - Deploy Your First Application**.

Epinio is fully installed in the background. Learners focus on deploying and managing apps with the Epinio CLI.

For the installation-focused scenario, see [epinio-get-started](../epinio-get-started/).

## Scenario overview

| Step | Title | What learners do |
|------|--------|------------------|
| Intro | - | Overview; full Epinio stack installs in the background; kubectl explore-while-you-wait activities |
| 1 | Deploy a Sample Application | Verify Epinio, `epinio push`, curl the app URL |
| 2 | Manage Your Application | Logs, scale, environment variables |
| 3 | Namespaces and Cleanup | Create/target namespaces, deploy, delete resources |

**Environment:** single-node Kubernetes (`kubernetes-kubeadm-1node`).

**Background setup:** `intro/background.sh` installs cert-manager, local-path storage, nginx ingress (with `hostNetwork` for ports 80/443 on the node), Epinio (Helm), the CLI, and logs in as `admin` (password `password`). Writes `/etc/profile.d/epinio-env.sh` and `/var/run/epinio-ready` when complete.

## Repository structure

```
epinio-deploy-app/
├── index.json
├── intro/
│   ├── text.md
│   └── background.sh       # Full cluster + Epinio install
├── step1/ … step3/
│   ├── text.md
│   └── verify.sh
└── finish/
    └── text.md
```

### Verification scripts

- **step1:** `/var/run/epinio-ready` exists and `sample` app is `1/1`
- **step2:** Environment variable `MY_VAR` is set on `sample`
- **step3:** `production` namespace has been removed

## Publish on Killercoda

Same workflow as [epinio-get-started](../epinio-get-started/README.md#publish-on-killercoda): connect the repo, deploy key, and webhook on [Killercoda creators](https://killercoda.com/creators).

## Related links

- [Epinio documentation](https://docs.epinio.io/)
- [Epinio authorization (default users)](https://docs.epinio.io/references/authorization)
- [Epinio on GitHub](https://github.com/epinio/epinio)
