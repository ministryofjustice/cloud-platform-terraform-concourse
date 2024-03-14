# pipelines

## Structure

The top level directories separate the configured pipelines for the different Concourse installations. They use the cluster name as it appears in the terraform workspaces (see the [top level README.md file](README.md))

The subdirectories within each cluster directory are then used to separate pipelines per Concourse team.

## Bootstrap

There is a bootstrap pipeline (see [`bootstrap.yaml`](live-1/main/bootstrap.yaml)) which can be used in any installation to manage pipeline configuration using this git repository as the source of truth. It uses the filename to deduce the pipeline's name (eg. `somejob.yaml` will result in a pipeline named `somejob`).

### Setup

To enable it for a Concourse team, copy it inside the appropriate directory (`pipelines/<cluster-name>/<team-name>/`). Make sure to adjust any values such as `CONCOURSE_CLUSTER` and `CONCOURSE_TEAM` and merge it into the main branch.

The bootstrap pipeline uses basic authentication for `fly`. This is automatically configured for team `main` by the `helm` chart, however, the chart does not support configuring additional teams. If you are setting up the bootstrap pipeline for a different team, you need to also setup basic authentication for that team and create a kubernetes secret in the [secrets namespace](https://github.com/kubernetes/charts/tree/master/stable/concourse/#kubernetes-secrets) of your team. Refer to the pipeline configuration for the expected structure of the kubernetes secret.

Finally, manually create and unpause the pipeline:
```sh
fly -t <target> set-pipeline -p bootstrap -c pipelines/<cluster>/<team-name>/bootstrap.yaml
fly -t <target> unpause-pipeline -p bootstrap
```

It should take over from here on.

Please do not deploy the bootstrap pipeline in your test cluster. It is for production level deployment and may trigger false alarms to our Slack Channel.
If you are looking for deploying a test pipeline in your test cluster, please create a new folder on your local machine and start with a simple pipeline. You may use [this link](https://concourse-ci.org/tutorial-hello-world.html) as reference to deploy the pipeline into your test cluster and not the one under `manager/main`.

## Custom cluster pipeline

If you'd like to execute a Concourse cluster build based on a WIP infrastructure branch for testing purposes, you can use `fly` CLI to prepare a job for this task:

- login to Concourse:

`fly -t manager login -c https://concourse.cloud-platform.service.justice.gov.uk/`

- set the `custom-cluster` pipeline with your `cloud-platform-infrastructure` branch name:

`fly -t manager set-pipeline -p custom-cluster -c pipelines/manager/main/custom-cluster.yaml -v branch_name=<YOUR-INFRA-BRANCH>`

And then trigger a new build of the `create` job in the Concourse view or `fly`

You can also use the `custom-integration-tests` job within the `custom-cluster` pipeline to execute the go integration test suite against a cluster of your choice:

`fly -t manager set-pipeline -p custom-cluster -c pipelines/manager/main/custom-cluster.yaml -v branch_name main/<SOME-OTHER-BRANCH> <-v cluster_name=<YOUR-TEST-CLUSTER-NAME>`

And then trigger a new build in `custom-integration-tests` job view.
