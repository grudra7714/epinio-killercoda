# Epinio on Killercoda

Interactive [Killercoda](https://killercoda.com/) scenario: **Epinio - From App to URL in One Step**.

Learners install [Epinio](https://epinio.io/) on Kubernetes, deploy a sample app with `epinio push`, manage it (logs, scaling, env vars), and work with Epinio namespaces - without needing deep Kubernetes knowledge.

For a deploy-only scenario with Epinio pre-installed in the background, see [epinio-deploy-app](../epinio-deploy-app/).

## Scenario overview

| Step | Title | What learners do |
|------|--------|------------------|
| Intro | - | Overview; cert-manager, local-path storage, and nginx ingress install in the background |
| 1 | Install Epinio | Verify prerequisites, Helm install Epinio (devcontainer chart values), CLI login |
| 2 | Deploy a Sample Application | `epinio push` with Paketo buildpacks |
| 3 | Manage Your Application | Logs, scale to 3 instances, set env vars |
| 4 | Namespaces and Cleanup | Create/target namespaces, delete apps |

**Environment:** single-node Kubernetes (`kubernetes-kubeadm-1node`) with `kubectl` and `helm` pre-installed.

**Background setup:** `intro/background.sh` installs cluster prerequisites from the [Epinio devcontainer setup](https://github.com/epinio/epinio/blob/main/.devcontainer/setup.sh): cert-manager v1.18.1, local-path-provisioner, and nginx ingress with `hostNetwork` so the controller listens on node ports 80/443 (required on bare-metal / Killercoda kubeadm).

## Repository structure

```
.
├── index.json              # Scenario metadata and step definitions
├── intro/
│   ├── text.md             # Intro content
│   └── background.sh       # cert-manager, storage, ingress (runs on start)
├── step1/ … step4/
│   ├── text.md             # Step instructions (Killercoda {{exec}} blocks)
│   └── verify.sh           # Step completion checks
└── finish/
    └── text.md             # Wrap-up and next steps
```

### `index.json`

Defines the scenario title, description, step paths, and backend image. See [Killercoda creators docs](https://killercoda.com/creators) for the full schema.

### Verification scripts

Each `verify.sh` exits `0` when the learner has completed the step:

- **step1:** Epinio namespace exists, nginx ingress is running, and `epinio settings show` succeeds
- **step2:** `sample` app is running (`1/1`)
- **step3:** Environment variable `MY_VAR` is set on `sample`
- **step4:** `production` namespace has been removed (cleanup done)

## Publish on Killercoda

1. Push this repository to GitHub.
2. Add the repo on [Killercoda Creator Repository](https://killercoda.com/creators) (repo name + branch).
3. Add the Killercoda **deploy key** under GitHub → Settings → Deploy keys.
4. Add the **webhook** (payload URL + secret) under GitHub → Settings → Webhooks so pushes sync scenarios automatically.
5. Open [Creator Scenarios](https://killercoda.com/creators) to confirm the scenario appears.

Details: [Get started as a creator](https://killercoda.com/creators/get-started).

## Local development

- Edit step content in `*/text.md`. Command blocks use `{{exec}}` so Killercoda runs them in the learner terminal.
- Adjust checks in `*/verify.sh`; scripts must exit `0` on success, non-zero otherwise.
- Change the environment in `index.json` → `backend.imageid` if you need a different cluster image.

After pushing to the connected branch, Killercoda picks up changes via the webhook.

## Related links

- [Epinio documentation](https://docs.epinio.io/)
- [Epinio Helm charts](https://github.com/epinio/helm-charts)
- [Epinio on GitHub](https://github.com/epinio/epinio)
