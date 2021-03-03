package user

import (
	"context"

	pb "dingdong/pkg/pb/user"
)

func (UserService) Login(context.Context, *pb.LoginRequest, *pb.LoginResponse) error {
	return nil
}

func (UserService) Register(context.Context, *pb.RegisterRequest, *pb.RegisterResponse) error {
	return nil
}

func (UserService) ForgetPassword(context.Context, *pb.ForgetPasswordRequest, *pb.ForgetPasswordResponse) error {
	return nil
}
