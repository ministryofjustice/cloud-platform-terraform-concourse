/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */
module "example_team_concourse" {
  #source = "github.com/ministryofjustice/cloud-platform-terraform-concourse?ref=v1.0"
  source = "../"

  team_name              = "cloudplatform"


  providers = {
    # Can be either "aws.london" or "aws.ireland"
    aws = aws.london
    /*

  }
}



