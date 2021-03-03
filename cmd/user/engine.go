package main

import (
	"github.com/micro/go-micro/v2"
	"github.com/micro/go-micro/v2/registry"
	"github.com/micro/go-micro/v2/registry/etcd"
	"github.com/sirupsen/logrus"

	"dingdong/internal/service/user"
	"dingdong/pkg/config"
	pb "dingdong/pkg/pb/user"
)

type Engine struct {
	Log     logrus.Logger
	Service micro.Service
}

func newEngine(userOpts *config.UserOptions) *Engine {
	engine := new(Engine)

	reg := etcd.NewRegistry(func(op *registry.Options) {
		op.Addrs = userOpts.EtcdOps.Addrs
	})

	service := micro.NewService(
		micro.Name(userOpts.Name),
		micro.Registry(reg),
		micro.Version(userOpts.Version),
	)
	service.Init()

	err := pb.RegisterUserServiceHandler(service.Server(), user.NewUserServiceHandler())
	if err != nil {
		logrus.Fatalln("registry userHandler failed: ", err)
	}
	engine.Service = service

	return engine
}

func (e *Engine) Run() error {
	if err := e.Service.Run(); err != nil {
		return err
	}

	return nil
}
