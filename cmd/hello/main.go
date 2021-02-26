package main

import (
	"github.com/micro/go-micro/v2"

	"github.com/micro/go-micro/v2/registry/etcd"
	"greeter/handler/hello/hellohandler"
	hello "greeter/handler/hello/pb"
	"greeter/pkg/config"
	"log"

	"github.com/micro/go-micro/v2/registry"
)

func main() {
	reg := etcd.NewRegistry(func(op *registry.Options) {
		op.Addrs = config.Addrs
	})

	service := micro.NewService(
		micro.Name("go.micro.srv.hello"),
		micro.Registry(reg),
		micro.Version("latest"),
	)
	service.Init()

	err := hello.RegisterGreeterHandler(service.Server(), hellohandler.NewGreeterHandler(service.Client()))
	if err != nil {
		log.Fatalln("Regist GreeterHandler failed: ", err)
	}

	if err := service.Run(); err != nil {
		log.Fatalln("Run GreeterService failed: ", err)
	}
}
