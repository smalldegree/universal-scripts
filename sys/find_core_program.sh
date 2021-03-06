#!/bin/bash


function usage()
{
cat <<-END >&2
usage  :  ${0##*/} coreFilesDir [coreProduceProgramPath]
example:  ${0##*/} /work/core /tmp/coreProduceProgram.dat
suggest:  ${0##*/} . /tmp/coreProduceProgram.dat

END
}

[[ $# -eq 0 ]] && usage && echo -e "error  :  Please specify the core files dir first.\n" && exit

coreFileName=$(ls $1/core.*)
coreProduceProgram=""
coreProduceSignal=""

j=1

[[ -z $2 ]] && coreProduceProgramPath="/tmp/coreProduceProgram.dat" || coreProduceProgramPath=$2

rm -rf $coreProduceProgramPath
for i in $coreFileName
do
   coreProduceProgram=$(gdb --quiet -batch -nx core-file $coreFileName quit 2>&1 | grep "Core was generated by")
   coreProduceSignal=$(gdb --quiet -batch -nx core-file $coreFileName quit 2>&1 | grep "Program terminated with signal" | awk -F 'with' '{print $2}' | awk -F ',' '{print $1}')

   echo -e "$j  $i \"$coreProduceProgram\"  Recived ${coreProduceSignal}." | column -t | tee -a $coreProduceProgramPath

   let j=j+1
done
