import scala.tools.nsc.interpreter._
import scala.tools.nsc.Settings


object Repl extends App {
  def repl = new ILoop {
    override def loop(): Unit = {
      intp.bind("e", "Double", 2.71828)
      super.loop()
    }
  }

  val settings = new Settings
  settings.Yreplsync.value = true


  //use when launching normally outside SBT
  settings.usejavacp.value = true      

  //an alternative to 'usejavacp' setting, when launching from within SBT
  //settings.embeddedDefaults[Repl.type]

  repl.process(settings)
}


/**
from stackoverflow question:

http://stackoverflow.com/questions/18628516/embedded-scala-repl-interpreter-example-for-2-10

*/