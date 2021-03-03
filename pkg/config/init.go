package config

import (
	"github.com/micro/go-micro/v2/config"
	"github.com/micro/go-micro/v2/config/source/file"
)

var Cfg = &Config{
	UserOpts: &UserOptions{
		Name:    "user",
		Version: "latest",
		EtcdOps: Etcd{
			Addrs: []string{
				"127.0.0.1.1234",
			},
		},
	},
}

func LoadConfig(filepath string) error {
	if err := config.Load(file.NewSource(
		file.WithPath(filepath)),
	); err != nil {
		return err
	}

	if err := config.Get().Scan(Cfg); err != nil {
		return err
	}

	return nil
}
