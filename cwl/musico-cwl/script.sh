echo $1 | tr "/" "\n"
put=(`echo $1 | tr "/" "\n"`)
fajl=${put[-1]}
req="curl -d '{\"calcs\":[\"$fajl\"], \"apiUser\": true}' -H \"Content-Type: application/json\" -X POST http://medflow.bioirc.ac.rs:3000/api/calcs/create"
echo $req
res=`eval $req`
echo $res
if [ `echo $res | jq -r '.success'` ]
    then
        guid=`echo $res | jq -r '.calcIds[0]'`
        echo $guid
        f=$(dirname $(readlink -e ${1}))

        req="curl -F \"zipFile[]=@$f/$fajl\" http://medflow.bioirc.ac.rs:3000/api/calcs/upload"
        echo $req
        res=`eval $req`
        if [ `echo ${res} | jq -r '.success'` ]
            then
                req="curl -d '{\"calcIds\":[\"$guid\"], \"apiUser\": true}' -H \"Content-Type: application/json\" -X POST http://medflow.bioirc.ac.rs:3000/api/calcs/run"
                echo $req
                res=`eval $req`
                echo $res
                if [ `echo $res | jq -r '.success'`=="blabla" ]
                    then
                        req="curl -d '{\"calcId\":\"$guid\", \"apiUser\": true}' -H \"Content-Type: application/json\" -X POST http://medflow.bioirc.ac.rs:3000/api/calcs/get-units"
                        res=`eval $req`
                        echo $res
                        ind=0
                        while [ $ind -eq 0 ]
                        do
                            units=`echo $res | jq -r '.units[].endTime'`
                            
                            ind=1
                            for unit in $units
                            do
                                if [ $unit == "null" ]
                                    then
                                        ind=0
                                fi
                            done
                            if [ $ind -eq 0 ]
                                then
                                    sleep 10
                            fi
                            res=`eval $req`
                        done

                        req="curl -d '{\"calcId\":\"5d769a3505f42c050e8c9581\", \"apiUser\": true}' -H \"Content-Type: application/json\" -X POST http://medflow.bioirc.ac.rs:3000/api/calcs/download-calc --output results.zip"
                        `eval $req`
                    else
                        echo "nije pokrenuto"
                fi
            else
                echo "nije upload"
        fi
    else
        echo "netacno"
fi
