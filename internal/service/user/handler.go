package user

type UserService struct{}

func NewUserServiceHandler() *UserService {
	return &UserService{}
}
