#!/bin/bash
#SBATCH --job-name rattleSNP
#SBATCH --output slurm-%x_%j.log
#SBATCH --error slurm-%x_%j.log
#SBATCH --partition=long

profile=$HOME"/.config/snakemake/RattleSNP"
echo $profile
# module help
function help
{
    printf "\033[36m####################################################################\n";
    printf "#                     submit_rattleSNP                              #\n";
    printf "####################################################################\n";
    printf "
 Input:
    Configuration file for snakemake

 Exemple Usage: ./submit_rattleSNP.sh -c config.yaml -k cluster_config.yaml

 Usage: ./submit_rattleSNP.sh -c {file} -k {file}
    options:
        -c {file} = Configuration file for run rattleSNP
        -k {file} = Configuration file cluster for run rattleSNP

        -h = see help\n\n"
    exit 0
}

dag=false

##################################################
## Parse command line options.
while getopts :c:k:d:h: opt;
    do case $opt in
        c)    config=$OPTARG;;
        k)    cluster_config=$OPTARG;;
        d)    dag=true;;
        h)    help;;
        \?)    help;;
    esac
done

#if [ $# -eq 0 ]; then
#    help
#fi

##################################################
## Main code
##################################################

if [ ! -z "$config" ] && [ -e $config ]; then

    config=`readlink -m $config`
    echo "CONFIG FILE IS $config"

    if [ $dag == "true" ]; then
        snakemake -p -s $RATTLESNP/Snakefile \
        --configfile $config \
        --cluster-config $profile"/cluster_config.yaml" \
        --profile $profile --dag | dot -Tpdf > schema_pipeline_global.pdf

    elif [ ! -z "$cluster_config" ] && [ -e $cluster_config ]; then
        cluster_config=`readlink -m $cluster_config`
        echo "CLUSTER CONFIG FILE IS $cluster_config"
        snakemake -p -s $RATTLESNP/Snakefile \
        --configfile $config \
        --cluster-config $cluster_config \
        --profile $profile
    else
        snakemake -p -s $RATTLESNP/Snakefile \
        --configfile $config \
        --cluster-config $profile"/cluster_config.yaml" \
        --profile $profile

    fi


else
    echo "configfile = "$config
    echo "profile = "$profile
    printf "\033[31m \n\n You must add a valid config file !!!!!!!!!!!! \n\n"
    help
fi
