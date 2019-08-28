num = Channel.fromPath("*.txt").buffer(size:3, remainder:true)

process example{
    input:
    file x from num

    output:
    stdout result

    """
    echo $x
    """

}


result.println{it}