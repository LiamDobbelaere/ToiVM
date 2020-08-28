import strutils
import os
import tables
import strformat

type Opcode = enum 
    PSH = 1,
    ADD = 2

const strToOpcode = {
    "psh": Opcode.PSH,
    "add": Opcode.ADD
}.toTable

var inputFile: string = paramStr(1)
var outputFile: string = paramStr(2)

var outBytes: seq[uint8] = @[]
for line in lines(inputFile):
    let currentLine: seq[string] = splitWhitespace(line); 
    let opcodeByte: uint8 = uint8(strToOpcode[currentLine[0]])
    
    outBytes.add(opcodeByte)

    if currentLine.len > 1:
        let operand: uint8 = uint8(parseInt(currentLine[1]))
        outBytes.add(operand)

let outFile = open(outputFile, fmWrite)
let writtenBytes = writeBytes(outfile, outBytes, 0, len(outBytes))
if writtenBytes < len(outBytes):
    echo "Error writing file"
else:
    echo fmt"Wrote {outputFile} successfully!"
