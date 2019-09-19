#!/bin/bash
#
#PBS -N math9880hw1process
#PBS -l select=1:ncpus=8:mem=64gb
#PBS -l walltime=72:00:00
#PBS -m abe
#PBS -M tsquire@g.clemson.edu
#PBS -j oe
#PBS -o process.error

module add matlab/2018b

cd $PBS_O_WORKDIR

taskset -c 0-$(($OMP_NUM_THREADS-1)) matlab -nodisplay -nodesktop -nosplash -r imgPreprocess


