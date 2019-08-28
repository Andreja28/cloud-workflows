files = Channel.fromPath("*.txt")
nums = Channel.from(1,2,3)

process setExample{
    input:
    file f from files
    each x from nums

    output:
    stdout result

    """
    echo Processing $f - $x
    """
}

result.println{it}