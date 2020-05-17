# Terraform modules

This repository contains generic Terraform modules for cloud providers (mainly AWS) to simplify infrastructure deployments

Example of how to access resources

```hcl
module "my_module" {
  source = "github.com/ben-bourdin451/terraform-modules//path/to/module?ref=tag"
}
```

You should normally target a tag to select a revision. Any valid git `ref` can [specify a branch, tag, or commit](https://www.terraform.io/docs/modules/sources.html#selecting-a-revision).

:warning: __You should always specify a tag or commit hash to prevent diffs or breaking changes__

Modules should run in any account with minimal configuration, but should also be fully configurable.  
These modules aim to be small & composable to remain flexible.

[Writing Terraform modules](https://www.terraform.io/docs/modules/create.html)
