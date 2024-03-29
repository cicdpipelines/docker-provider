package main

import (
	"github.com/NoUseFreak/cicd/pkg/server"
	"github.com/cicdpipelines/docker-provider/internal/docker"
)

func main() {
	server.Serve("docker", docker.Provider())
}
