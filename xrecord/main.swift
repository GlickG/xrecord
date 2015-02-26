//
//  main.swift
//  xrecord
//
//  Created by Patrick Meenan on 12/10/15.
//  Copyright (c) 2015 WPO Foundation. All rights reserved.
//

import Foundation
import AVFoundation

let cli = CommandLine()

let list = BoolOption(shortFlag: "l", longFlag: "list",
    helpMessage: "List available capture devices.")
let name = StringOption(shortFlag: "n", longFlag: "name", required: false,
    helpMessage: "Device Name.")
let id = StringOption(shortFlag: "i", longFlag: "id", required: false,
    helpMessage: "Device ID.")
let outFile = StringOption(shortFlag: "o", longFlag: "out", required: false,
    helpMessage: "Output File.")
let help = BoolOption(shortFlag: "h", longFlag: "help",
    helpMessage: "Prints a help message.")
let verbosity = CounterOption(shortFlag: "v", longFlag: "verbose",
    helpMessage: "Print verbose messages. Specify multiple times to increase verbosity.")

cli.addOptions(list, name, id, outFile, help, verbosity)
let (success, error) = cli.parse()
if !success {
    println(error!)
    cli.printUsage()
    exit(EX_USAGE)
}

// Check to make sure a sane combination of options were specified
var ok = true
if !list.value {
    if name.value == nil && id.value == nil {
        ok = false
    }
    if outFile.value == nil {
        ok = false
    }
}
if !ok {
    cli.printUsage()
    exit(EX_USAGE)
}

let capture = Capture()
if list.value {
    println("Available capture devices:")
    capture.listDevices()
    exit(0)
}

// Set up the input device
if id.value != nil {
    if !capture.setDeviceById(id.value) {
        println("Device not found")
        exit(1)
    }
}
if name.value != nil {
    if !capture.setDeviceByName(name.value) {
        println("Device not found")
        exit(1)
    }
}

capture.start(outFile.value)
println("Capture Started")
sleep(10)
capture.stop()
println("Done")