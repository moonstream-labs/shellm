package main

import (
	"fmt"
	"io"
	"net"
	"strings"
)

func main() {
	listener, err := net.Listen("tcp", "0.0.0.0:8888")
	if err != nil {
		fmt.Printf("Error creating listener: %v\n", err)
		return
	}
	defer listener.Close()

	fmt.Println("Listening on :8888")

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Printf("Error accepting connection: %v\n", err)
			continue
		}

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
