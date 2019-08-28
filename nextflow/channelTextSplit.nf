Channel
    .fromPath("*.txt")
    .splitText()
    .subscribe{print it}