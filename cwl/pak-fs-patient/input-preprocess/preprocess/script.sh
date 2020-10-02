data=`cat ${2} | tr '\n' "@"`
new="s:_INPUT_DATA_:$data:g"
`sed -e "$new" $1 > pak-new.dat`
`sed 's/@/\n/g' pak-new.dat > pak.dat`

`rm pak-new.dat`
`cp /preprocess/solver_version.txt .`