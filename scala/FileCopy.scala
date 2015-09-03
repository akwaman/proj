/*
ASCII text file read and write out to a copy file

*/

import scala.io.Source   
import java.io._  // Scala does not offer text writing facilities

object FileCopy {
  def main(args: Array[String]) {

    val srcFile = args(0);
    printf("Source file %s stats\n",srcFile)

    val dstFile = new File("out.txt")
    val bufDst = new BufferedWriter(new FileWriter(dstFile))

    val bufSrc = Source.fromFile(srcFile)

    for (line <- bufSrc.getLines) {
        print(line)
        bufDst.write(line)
    }

    bufSrc.close
    bufDst.close



  }
}   
