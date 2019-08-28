files = Channel.fromPath("*.txt")
nums = Channel.from(1,2,3)

process setExample{
    echo true

    input:
    file f from files
    val x from nums

    output:
    set val(x), file(f) into setOut
    val x into xOut


    """
    echo first process Processing $f - $x
    """
}

process numExample{
    echo true

    input:
    val x from xOut

    """
    echo Only numbers $x
    """
}

process  example{
    echo true

    input:
    val x from setOut

    """
        echo second process Processing ${x[0]} - ${x[1]}   
    """
}