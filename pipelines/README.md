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

### Pipeline Resources
The bootstrap pipeline is also able to run `terraform`, if a pipeline requires any resources. If there is a directory alongside the pipeline configuration, using the same name, it will attempt to create these resources.

For instance, a pipeline configured in `pipelines/<cluster-name>/<team-name>/foobar.yaml` can also specify terraform-managed resources in `pipelines/<cluster-name>/<team-name>/foobar/`.
