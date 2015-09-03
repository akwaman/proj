
object HelloWorld {
  /* my first Scala program */

  def foo(a: Int, b: Int): Int = {a+b}

  def main(args: Array[String]) {
    println("Hello Scala!");  // print message

    println(args(0), args(1))

    val a1: Int = args(0).toInt
    val a2: Int = args(1).toInt

    printf("%d %d %d\n",a1, a2, foo(a1,a2))

  }
}   