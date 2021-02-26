package hellohandler

import (
	"context"
	"github.com/micro/go-micro/v2/client"
	proto "greeter/handler/hello/pb"
	user "greeter/handler/user/pb"
)

// GreeterHandler 是一个问候服务 demo
type GreeterHandler struct {
	UserClient user.UserService
}

// NewGreeterHandler Get a new GreeterHandler
func NewGreeterHandler(c client.Client) *GreeterHandler {
	return &GreeterHandler{
		UserClient: user.NewUserService("go.micro.srv.user", c),
	}
}

func (h *GreeterHandler) Hello(ctx context.Context, req *proto.HelloRequest, rsp *proto.HelloResponse) error {
	r, err := h.UserClient.GetUser(ctx, &user.GetUserRequest{Id: req.Id})
	if err != nil {
		return err
	}

	if r.User == nil {
		rsp.Msg = "User not found"
		return nil
	}

	rsp.Msg = "Hello " + r.User.Name
	return nil
}
