package com.massivedisaster.kickoff.util

import org.apache.commons.cli.*
import java.awt.Desktop
import java.io.IOException
import java.net.URI
import java.net.URISyntaxException
import java.util.logging.Level
import java.util.logging.Logger
import kotlin.system.exitProcess

class Cli(private val args: Array<String>) {
    private val options = Options()

    init {
        options.addOption(Option("h", "help", false, "Show Help."))
        val optGenerate = Option("g", "generate", true, "Generate a new project based on a configuration file.")
        optGenerate.argName = "configuration file"
        options.addOption(optGenerate)
        options.addOption(Option("o", "open", false, "Open the GitHub repository."))
    }

    fun parse() {
        val parser: CommandLineParser = BasicParser()
        val cmd: CommandLine?
        try {
            cmd = parser.parse(options, args, true)
            when {
                cmd.hasOption("h") -> help()
                cmd.hasOption("o") -> open()
                !cmd.hasOption("g") -> {
                    log.log(Level.SEVERE, "Missing g option")
                    help()
                }
            }
        } catch (e: ParseException) {
            help()
        }
    }

    fun getOptions(): CommandLine? {
        val parser: CommandLineParser = BasicParser()
        return try {
            parser.parse(options, args, true)
        } catch (e: ParseException) {
            help()
            null
        }
    }

    private fun help() {
        // This prints out some help
        val formatter = HelpFormatter()
        formatter.printHelp("kickoff", options)
        exitProcess(0)
    }

    private fun open() {
        try {
            println("Opening an online platform to create a configuration file...")
            Desktop.getDesktop().browse(URI(Const.LIBRARY_REPOSITORY_URL))
        } catch (e: IOException) {
            e.printStackTrace()
        } catch (e: URISyntaxException) {
            e.printStackTrace()
        }
        exitProcess(0)
    }

    companion object {
        private val log = Logger.getLogger(Cli::class.java.name)
    }
}