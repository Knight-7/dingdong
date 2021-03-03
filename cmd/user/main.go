package main

import (
	"dingdong/pkg/config"
	"github.com/sirupsen/logrus"
	"log"
)

func main() {
	err := config.LoadConfig("./../../config.yaml")
	if err != nil {
		log.Fatalln(err)
	}

	engine := newEngine(config.Cfg.UserOpts)

	if err := engine.Run(); err != nil {
		logrus.Fatalln(err)
	}
}
