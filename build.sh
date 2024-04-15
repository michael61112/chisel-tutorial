#!/bin/bash
# Helper script to elaborate a Chisel module that has no parameters.

set -e

package="$1"
module="$2"
if [ -z "$module" ]; then
	echo "Usage: ./build.sh <package> <module>"
	echo "For example, gcd.GCD can be elaborated using ./build.sh gcd GCD"
	exit 1
fi

cat <<EOF > _temphelper.scala
package _temphelper
import ${package}._

object Elaborate extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(
    new ${package}.${module}(args),
    Array("-td","generated/${package}")
  )
}
EOF

echo "Elaborating module ${module}..."
sbt "runMain _temphelper.Elaborate"
echo "Elaborated Verilog available at ${module}.v"
