package main

import (
	"github.com/micro/go-micro/v2"
	"github.com/micro/go-micro/v2/registry"
	"github.com/micro/go-micro/v2/registry/etcd"
	user "greeter/handler/user/pb"
	"greeter/handler/user/userHandler"
	"greeter/pkg/config"
	"log"
)

func main() {
	reg := etcd.NewRegistry(func(op *registry.Options) {
		op.Addrs = config.Addrs
	})

	service := micro.NewService(
		micro.Name("go.micro.srv.user"),
		micro.Registry(reg),
		micro.Version("latest"),
	)
	service.Init()

	err := user.RegisterUserServiceHandler(service.Server(), userHandler.NewUserHandler())
	if err != nil {
		log.Fatalln("regist userHandler failed: ", err)
	}

	if err := service.Run(); err != nil {
		log.Fatalln("run UserHandler failed: ", err)
	}
}
