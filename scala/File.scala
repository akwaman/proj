import scala.io.Source    // for file reading
import java.io._


object HelloWorld {
  def foo(a: Int, b: Int): Int = {a+b}

  def main(args: Array[String]) {
    println("Hello Scala!");  // print message
    println("your args were" + args(0) + args(1))

    print("Please enter your input : " )
//    val line = Console.readLine()
    val lines = io.Source.stdin.getLines  
    
    println("Thanks, you just typed: " + lines)

/*
    println("Write to file: test.txt")
    val writer = new PrintWriter(new File("test.txt" ))
    writer.write("Hello test.txt file")
    writer.close()

    println("Read from file: test.txt")

    Source.fromFile("test.txt" ).foreach { 
         print 
    }
*/
  }
}   

/*

 main(args: Array[String]) = {
    val lines = io.Source.stdin.getLines
    val t = lines.next.toInt
    // 1 to t because of ++i
    // 0 until t for i++
    for (i <- 1 to t) {
      // assuming n,m and p are all on the same line
      val Array(n,m,p) = lines.next.split(' ').map(_.toInt)
      // or (0 until n).toList if you prefer
      // not sure about the difference performance-wise
      val players = List.range(0,n).map { j =>
        val Array(name,pct,height) = lines.next.split(' ')
        Player(name, pct.toInt, height.toInt)
      }
      val ret = solve(players,n,m,p)
      print(s"Case #${i+1} : ")
      ret.foreach(player => print(player.name+" "))
      println

*/