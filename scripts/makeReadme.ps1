param (
    [Path]$setupYaml
)

# depends on yq, install with scoop

yq $setupYaml -o j