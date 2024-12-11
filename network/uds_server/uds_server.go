package main

import (
	"fmt"
	"io"
	"net"
	"os"
	"strings"
)

const sockPath = "/tmp/test.sock"

func main() {
	// Cleanup any existing socket
	if err := os.RemoveAll(sockPath); err != nil {
		fmt.Printf("Error removing socket: %v\n", err)
		return
	}

	// Create Unix Domain Socket
	listener, err := net.Listen("unix", sockPath)
	if err != nil {
		fmt.Printf("Error creating socket: %v\n", err)
		return
	}
	defer listener.Close()

	fmt.Printf("Listening on %s\n", sockPath)

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Printf("Error accepting connection: %v\n", err)
			continue
		}

		// Handle connection in goroutine
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	defer conn.Close()

	fmt.Printf("New connection from: %s\n", conn.RemoteAddr())

	buf := make([]byte, 1024)
	for {
		n, err := conn.Read(buf)
		if err != nil {
			if err == io.EOF {
				fmt.Printf("Client closed connection: %s\n", conn.RemoteAddr())
				return
			}
			fmt.Printf("Error reading: %v\n", err)
			return
		}

		msg := string(buf[:n])
		fmt.Printf("Received: %s\n", msg)

		response := []byte(strings.ToUpper(msg))
		if _, err := conn.Write(response); err != nil {
			fmt.Printf("Error writing: %v\n", err)
			return
		}
	}
}
