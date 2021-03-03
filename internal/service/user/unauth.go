package user

import (
	"context"

	pb "dingdong/pkg/pb/user"
)

func (UserService) GetUser(context.Context, *pb.GetUserRequest, *pb.GetUserResponse) error {
	return nil
}

func (UserService) UpdateUser(context.Context, *pb.UpdateUserRequest, *pb.UpdateUserResponse) error {
	return nil
}

func (UserService) DeleteUser(context.Context, *pb.DeleteUserRequest, *pb.DeleteUserResponse) error {
	return nil
}
