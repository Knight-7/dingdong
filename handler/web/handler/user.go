package handler

import (
	"context"
	"github.com/gin-gonic/gin"
	"github.com/micro/go-micro/v2/service/grpc"
	hello "greeter/handler/hello/pb"
	"log"
	"net/http"
	"strconv"
)

func GetUserHandler(c *gin.Context) {
	id := c.Param("id")
	log.Println("id: ", id)

	service := grpc.NewService()
	service.Init()

	helloClient := hello.NewGreeterService("go.micro.srv.hello", service.Client())

	reqID, _ := strconv.Atoi(id)
	rsp, err := helloClient.Hello(context.TODO(), &hello.HelloRequest{Id: int32(reqID)})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"errMsg": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Msg": rsp.Msg,
	})
}
