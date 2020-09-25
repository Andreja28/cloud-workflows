cp -r /pak/* .

cp $1 pak.dat


i=0
while IFS= read -r line
do
    if [ $i -eq 1 ]
    then
        version=${line:0:1}
        if [[ $version == 1 ]]
        then
            wine PAKFS.exe < /pak/files
        else
            wine PAKFIS.exe < /pak/files
        fi
    fi
    i=$((i+1))
done < $2