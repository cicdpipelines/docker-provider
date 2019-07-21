package docker

import (
	"fmt"

	cicd "github.com/NoUseFreak/cicd/pkg/helper"
)

func stepBuild() *cicd.Step {
	return &cicd.Step{
		Schema: map[string]*cicd.Schema{
			"name": {
				Type:     cicd.TypeString,
				Required: true,
			},
			"tag": {
				Type:     cicd.TypeString,
				Required: true,
			},
			"repo": {
				Type:     cicd.TypeString,
				Required: true,
			},
			"path": {
				Type:     cicd.TypeString,
				Required: true,
			},
		},
		Run: func(data *cicd.RunArguments, ctx *cicd.Context) (*cicd.StepResponse, error) {
			imageName := fmt.Sprintf(
				"%s:%s",
				data.GetString("name"),
				data.GetStringOrDefault("tag", "latest"),
			)
			args := []string{
				"build",
				"-t", imageName,
				data.GetStringOrDefault("path", "."),
			}

			return &cicd.StepResponse{}, ctx.RunCommand("docker", args...)
		},
	}
}
