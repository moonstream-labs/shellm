package main

import (
	"fmt"
	"net"
)

func main() {
	// Connect to the server using the .orb.local domain
	conn, err := net.Dial("tcp", "tester.orb.local:8888")
	if err != nil {
		fmt.Printf("Error connecting: %v\n", err)
		return
	}
	defer conn.Close()

	message := "hello from go tcp client"
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
