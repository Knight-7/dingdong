package userHandler

import (
	"context"
	proto "greeter/handler/user/pb"
)

type UserHandler struct{}

func NewUserHandler() *UserHandler {
	return &UserHandler{}
}

func (u *UserHandler) GetUser(ctx context.Context, req *proto.GetUserRequest, rsp *proto.GetUserResponse) error {
	if req.Id != 7 {
		rsp.User = nil
		return nil
	}

	rsp.User = &proto.User{
		Id:   7,
		Name: "Knight",
		Age:  24,
	}

	return nil
}
