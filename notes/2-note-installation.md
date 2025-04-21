# Installation 

First, we need to install the terraform, then install aws-cli. In my MacBook I use brew install both of those tools. 

- **Install Terraform & Verify Installation Success** 

```shell 
% brew install terraform 
```

```shell 
% terraform
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  metadata      Metadata related commands
  modules       Show all declared modules in a working directory
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Execute integration tests for Terraform modules
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.
```


- **Install AWS Cli & Verify Installiation Success**

```shell 
% brew install awscli
```

```shell 
% aws help 
AWS()                                                                    AWS()

NAME
       aws -

DESCRIPTION
       The AWS Command Line Interface is a unified tool to manage your AWS
       services.

SYNOPSIS

          aws [options] <command> <subcommand> [parameters]

       Use aws command help for information on a specific command. Use aws
       help topics to view a list of available help topics. The synopsis for
       each command shows its parameters and their usage. Optional parameters
       are shown in square brackets.

GLOBAL OPTIONS
       --debug (boolean)

       Turn on debug logging.

       --endpoint-url (string)

       Override command's default URL with the given URL.

       --no-verify-ssl (boolean)

       By default, the AWS CLI uses SSL when communicating with AWS services.
       For each SSL connection, the AWS CLI will verify SSL certificates. This
       option overrides the default behavior of verifying SSL certificates.

       --no-paginate (boolean)

       Disable automatic pagination. If automatic pagination is disabled, the
       AWS CLI will only make one call, for the first page of results.

       --output (string)

       The formatting style for command output.

       o json

       o text

       o table

       o yaml

       o yaml-stream

       --query (string)

       A JMESPath query to use in filtering the response data.

       --profile (string)

       Use a specific profile from your credential file.

       --region (string)

       The region to use. Overrides config/env settings.

       --version (string)
```

# Configuration 
- **Configure AWS CLI**
First, we go to the AWS Web page as IAM user, then generate an access key pair of AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. 
Then, we export the key pair to environment variables, or create a .env file on local scripts folder, and make sure this .env file should not be committed to the github repo. 



## References 
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Install AWS CLI](https://formulae.brew.sh/formula/awscli)



