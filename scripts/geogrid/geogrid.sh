#!/bin/bash

. /etc/profile.d/modules.sh

# Module stuff
module load netcdf
module load szip
module load sge
module load openmpi
module add ncl
module add nco
module switch ncl/opendap ncl/nodap

#
# Active comments for SGE 
#
#$ -S /bin/bash
#$ -N geogrid
#$ -v MPI_HOME
#$ -v LD_LIBRARY_PATH
#$ -cwd
#$ -q all.q
#$ -pe ompi 1
#$ -j yes



CMD="$MPI_HOME/bin/mpirun geogrid.exe"
 
echo $CMD
 
$CMD

