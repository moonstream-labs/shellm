package main

import (
	"fmt"
	"net"
)

func main() {
	conn, err := net.Dial("unix", "/tmp/test.sock")
	if err != nil {
		fmt.Printf("Error connecting: %v\n", err)
		return
	}
	defer conn.Close()

	message := "hello from go uds client"
	if _, err := conn.Write([]byte(message)); err != nil {
		fmt.Printf("Error writing: %v\n", err)
		return
	}

	buf := make([]byte, 1024)
	n, err := conn.Read(buf)
	if err != nil {
		fmt.Printf("Error reading: %v\n", err)
		return
	}

	fmt.Printf("Response: %s\n", string(buf[:n]))
}
