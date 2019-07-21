package docker

import (
	cicd "github.com/NoUseFreak/cicd/pkg/helper"
)

func Provider() *cicd.Provider {
	return &cicd.Provider{
		StepMap: map[string]*cicd.Step{
			"docker_build": stepBuild(),
			"docker_push":  stepPush(),
		},
	}
}
