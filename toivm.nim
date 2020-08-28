import strutils
import os
import tables
import strformat
import toivmruntime
import toivmtypes

const strToOpcode = {
    "psh": Opcode.PSH,
    "add": Opcode.ADD,
    "mul": Opcode.MUL,
    "ech": Opcode.ECH,
    "prt": Opcode.PRT
}.toTable

proc lineToBytes(line: string): seq[uint8] =
    let currentLine: seq[string] = splitWhitespace(line); 
    var outBytes: seq[uint8] = @[]

    if len(currentLine) == 0:
        return outBytes

    let opcodeByte: uint8 = uint8(strToOpcode[currentLine[0]])
    outBytes.add(opcodeByte)

    if currentLine.len > 1:
        let operand: uint8 = uint8(parseInt(currentLine[1]))
        outBytes.add(operand)

    return outBytes

proc fileToBytes(inputFile: string): seq[uint8] =
    var outBytes: seq[uint8] = @[]
    for line in lines(inputFile):
        outBytes &= lineToBytes(line)

    return outBytes

var command: string = ""
if paramCount() > 0:
    command = paramStr(1)

case command:
of "bin", "b":
    if paramCount() < 3:
        echo "You must specify IN and OUT file paths"
        quit(-1)

    let inputFile: string = paramStr(2)
    let outputFile: string = paramStr(3)

    let outBytes = fileToBytes(inputFile)

    let outFile = open(outputFile, fmWrite)
    let writtenBytes = writeBytes(outfile, outBytes, 0, len(outBytes))
    if writtenBytes < len(outBytes):
        echo "Error writing file"
    else:
        echo fmt"Wrote {outputFile} successfully!"
of "run", "r":
    if paramCount() < 2:
        echo "You must specify the .toi file to run!"
        quit(-1)
    
    let inputFile: string = paramStr(2)
    let outBytes = fileToBytes(inputFile)

    let runtime = ToiVMRuntime()

    runtime.load(outBytes)
    runtime.run()
else: 
    echo "ToiVM (Toy Virtual Machine) by Digaly"
    echo ""
    echo "  toivm run IN.toi             Run a toi file with ToiVM"
    echo "  toivm bin IN.toi OUT.btoi    Compile a toi file to its bytecode representation"
    echo ""