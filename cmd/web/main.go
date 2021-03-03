package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/micro/go-micro/v2/registry"
	"github.com/micro/go-micro/v2/registry/etcd"
	"github.com/micro/go-micro/v2/web"

	"dingdong/pkg/config"
)

func main() {
	reg := etcd.NewRegistry(func(op *registry.Options) {
		op.Addrs = config.Cfg.WebOpts.EtcdOps.Addrs
	})

	service := web.NewService(
		web.Name("go.micro.api.hello"),
		web.Registry(reg),
		web.Version("latest"),
		web.Address(":3000"),
	)
	if err := service.Init(); err != nil {
		log.Fatalln("web service init failed: ", err)
	}

	router := gin.Default()
	router.GET("/hello/:id", nil)

	service.Handle("/", router)

	if err := service.Run(); err != nil {
		log.Fatalln("web service run failed: ", err)
	}
}
