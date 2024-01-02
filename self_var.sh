# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias smk='/data/software/miniconda/envs/snakemake/bin/snakemake --unlock'
alias smtqd='/data/software/miniconda/envs/snakemake/bin/snakemake -npr -s Snakefile'
#alias smq='/data/software/miniconda/envs/snakemake/bin/python /data/software/automation/snakemake_deliver.py'
alias qdqstat="kubectl get pods -n k8s-dna"
alias les='less -SN'
alias getlogs="kubectl logs -n k8s-dna $1"
alias ll="ls -lhrt"
#alias
complete -d cd
#export PS1="\[\e[33;1m\]zhengfx@MixCloud: \[\e[36;1m\]\w\[\e[0m\] $ "
#export PS1="\[\e[33;1m\]zhengfx@MixCloud: \[\e[36;1m\]\w\[\e[0m\] \$ "
export PS1="\[\033[33;1m\]zhengfx@MixCloud: \[\033[36;1m\]\w\[\033[0m\] \$ "
# env
alias path="readlink -f"
#alias smt="/data/software/miniconda/envs/snakemake/bin/snakemake -npr --rerun-triggers mtime"
alias smqqd="nohup /data/software/miniconda/envs/snakemake/bin/snakemake --cluster "ksub" --cluster-config cluster.yaml --rerun-triggers mtime  -j 100 --latency-wait 200 -pr > nohup.log 2>&1 &"
alias obsutil="/data/software/obsutil/5.3.4/obsutil"
export PATH="/home/liujiang/pbtbin:/home/zhengfuxing/my_script:/home/liujiang/scripts/2bM:/home/liujiang/bin:$PATH"

export DRMAA_LIBRARY_PATH=/software/gridengine/lib/lx-amd64/libdrmaa.so
# 操作 docker
rundocker() {
    if [ -z "$1" ]; then
        dockerid=$(kubectl get pods -n k8s-dna|awk '{if($3=="Running"){print$1}}'|tail -n 1)
    else
        dockerid=$1
    fi
    kubectl exec -it ${dockerid} -n k8s-dna sh;
}

open_container="https://github.com/JokerX6696/Open_Container.git"

###################
mic='http://gitlab.oebiotech.cn/Jiang/2bRAD-M_pipe.git'
get_abd='https://github.com/JokerX6696/get_abd.git'
sc='http://gitlab.oebiotech.cn/SingleCell/singlecell-snakemake-pipeline/scrna_pipeline.git'
wd='/oeK8S/public/automation/projects/qingdao/DNA/dna/'
md='/storge1/USER/zhengfuxing'

export LD_LIBRARY_PATH=/data/software/gcc/gcc-v6.4.0/lib:/data/software/gcc/gcc-v6.4.0/lib64:$LD_LIBRARY_PATH



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/storge1/USER/zhengfuxing/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/storge1/USER/zhengfuxing/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/storge1/USER/zhengfuxing/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/storge1/USER/zhengfuxing/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
source /data/software/modules/modules-v4.2.1/init/bash
# <<< conda initialize <<<
R_LIBS_SITE=/data/software/R_package/DNA/3.5/
